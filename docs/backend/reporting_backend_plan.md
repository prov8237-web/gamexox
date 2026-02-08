# Reporting Backend Implementation Plan (for `/Backend`)

## Current backend architecture map

### Extension entry points and routing
- **SmartFox extension entry point:** `MainExtension` registers all request handlers (e.g., `complaintlist`, `complaintaction`, `report`, `prereport`) and forwards requests to `BaseClientRequestHandler` implementations. It also logs requests and optionally falls back to a default handler when strict protocol is disabled.【F:Backend/MainExtension.java†L20-L213】
- **Request dispatch flow:** `MainExtension.handleClientRequest()` records `lastRequestId`, validates requests via `RequestValidator`, and then invokes the registered handler. Unknown commands can be rejected or routed to a fallback response based on `ProtocolConfig` flags.【F:Backend/MainExtension.java†L172-L213】
- **Handler utilities:** `OsBaseHandler` provides common response methods (`reply`, `sendValidated`, `sendResponseWithRid`), extracts request `rid`, and provides store/zone access for handlers.【F:Backend/OsBaseHandler.java†L15-L133】

### Existing reporting-related handlers
- **`report`, `prereport`, `ingamereport`** are currently routed to `PreReportHandler` which records a complaint and pushes a complaint list to security users.【F:Backend/MainExtension.java†L40-L44】【F:Backend/PreReportHandler.java†L16-L83】
- **Complaint inbox**:
  - List: `ComplaintListHandler` returns `complaintlist` with `ok` + `list` of complaint records and enforces security roles.【F:Backend/ComplaintListHandler.java†L14-L53】
  - Action: `ComplaintActionHandler` consumes `complaintaction` (resolve/warn/kick/ban/loginban), updates complaint status, and pushes updated list to security users.【F:Backend/ComplaintActionHandler.java†L18-L140】

### Data storage
- **Complaints** are stored in `InMemoryStore.ComplaintRecord` with fields: `id`, `reporterId`, `reporterName`, `targetId`, `targetName`, `roomName`, `text`, `reason`, `createdAtEpochSec`, `status`. The `toSFSObject` method currently maps them into `reporterId/targetId` etc. and uses `text/reason/time/status` keys.【F:Backend/InMemoryStore.java†L1496-L1536】
- **Ban records** are tracked in `InMemoryStore.BanRecord` keyed by IP, with `type`, `startEpochSec`, `endEpochSec`, and helper methods for `timeLeft` and active bans.【F:Backend/InMemoryStore.java†L625-L705】

### Protocol validation
- `ProtocolValidator` currently enforces minimal schemas for `report`/`prereport`/`complaintlist` and leaves them permissive (only `ok` required for report-like responses).【F:Backend/ProtocolValidator.java†L278-L306】

---

## Identify if `baninfo` / `report` exist

### Report
- **Exists**: `report` is routed to `PreReportHandler` and returns `{ ok, id }`, but **does not** match the client `ReportPanel` contract (which expects report-specific error codes and does not use `ok`).【F:Backend/MainExtension.java†L40-L44】【F:Backend/PreReportHandler.java†L36-L46】

### Baninfo
- **Missing**: There is **no** `baninfo` handler registered in `MainExtension`. This prevents the create-report panel from initializing properly.【F:Backend/MainExtension.java†L26-L152】

---

## Proposed data model

### Report entity (new)
Add a report entity to `InMemoryStore` (MVP in-memory), aligned with client expectations:

**Fields**
- `id` (long)
- `reporterAvatarID` (String)
- `reporterAvatarName` (String)
- `reportedAvatarID` (String)
- `reportedAvatarName` (String, optional)
- `message` (String) → reported chat message
- `comment` (String) → reporter text input
- `isPervert` (int, 0/1)
- `createdAtEpochSec` (long)
- `status` (OPEN/RESOLVED)
- `banCountSnapshot` (int) → for `baninfo` display
- `nextBanMinSnapshot` (int) → for UI in inbox

**Storage**
- In-memory list/map similar to `complaintsById` and `complaintOrder` with a separate `reportOrder` to avoid mixing “report” with legacy `complaint` entries (or reuse complaint entity but adapt fields to client schema).

**Optional persistence**
- Add a hook interface (e.g., `ReportStore`) to allow drop-in persistence later; MVP stays in-memory.

---

## Rate limit design (nextRequest + flood)

Client `ServiceModel` expects `errorCode="FLOOD"` with `nextRequest` in responses to throttle. The report UI doesn’t handle `nextRequest` directly, but the client does globally.

**Plan**
- Add an in-memory throttler keyed by `(reporterAvatarID, command)`:
  - `report`: e.g., 10 seconds
  - `baninfo`: e.g., 5 seconds
  - `complaintlist`: use current polling interval (20s) or 10s
- On throttle violation, return:
  - `errorCode="FLOOD"`
  - `nextRequest=<ms>`
- Otherwise include a `nextRequest` in success responses for `baninfo` and `report` to mirror official behavior.

---

## Security model

### Inbox access
- Keep security role checks in `ComplaintListHandler` and `ComplaintActionHandler` (`SECURITY`, `EDITOR_SECURITY`, `CARD_SECURITY`). This is already in place and should remain the gating mechanism for inbox access.【F:Backend/ComplaintListHandler.java†L19-L53】【F:Backend/ComplaintActionHandler.java†L143-L151】

### Anti-spam
- Add per-user rate limits to `report` and `baninfo`.
- For guests, optionally reject report creation with `errorCode="GUEST_NOT_ALLOWED"` (client supports this error pattern globally).

---

## Contract spec (client expectations)

### `baninfo` response (ReportPanel)
Client expects:
- `banCount` (int)
- `nextBanMin` (int)
- `banStatus` (truthy when already banned)
- `expireSecond` (ms; client divides by 1000)
See ReportPanel behavior in the create-report SWF (already documented).

### `report` response
Client expects:
- `errorCode`:
  - `"ALREADY_REPORTED"` → report already submitted
  - any other errorCode → shows generic error
- No specific success fields required, but response should **not** include `errorCode`.

### `complaintlist` response (inbox panel)
Client expects `complaints` array with items that include:
- `id`
- `message`
- `comment`
- `reporterAvatarID`
- `reportedAvatarID`
- `isPervert`
- `banCount`
- `nextBanMin`

**Current backend mismatch:** it returns `{ ok: true, list: [reporterId/targetId/text/reason/time/status] }`, which the inbox UI does not use. This must be adapted.

---

## Identity mismatch handling

Clients may send `avatarID` in different forms (numeric ID or `Guest#X`). Current backend often uses `User.getName()` or `avatarID` string.

**Plan**
- Add a shared normalization helper (e.g., `HandlerUtils.normalizeAvatarId(...)`) that:
  - Accepts incoming `avatarID` or `avatarName`
  - Resolves a `User` if possible (by name, avatarName user var, or `playerID` user var)
  - Returns a stable “avatarID” string for storage
- Use this in `ReportHandler`, `BanInfoHandler`, and `ComplaintActionHandler`.

---

## Implementation steps (file-by-file, no code changes yet)

1. **Add `BanInfoHandler`**
   - New file: `Backend/BanInfoHandler.java`
   - Inputs: `{ avatarID }`
   - Outputs: `{ banCount, nextBanMin, banStatus?, expireSecond?, nextRequest }`
   - Use `InMemoryStore` ban count + active ban status from IP ban records.
2. **Replace `report` handling**
   - New file: `Backend/ReportHandler.java`
   - Register in `MainExtension` for `report` (instead of `PreReportHandler`).【F:Backend/MainExtension.java†L40-L44】
   - Validate payload: `reportedAvatarID`, `message`, `comment`, `isPervert`
   - Store report record
   - Return either `errorCode` or success
3. **Adapt complaint list payload**
   - Update `ComplaintListHandler` (and push list in `PreReportHandler`) to emit `complaints` array with client keys instead of `list` + legacy keys.【F:Backend/ComplaintListHandler.java†L27-L40】【F:Backend/PreReportHandler.java†L61-L81】
   - Option: create a translation layer when converting `ComplaintRecord` to client shape.
4. **Extend `InMemoryStore`**
   - Add `ReportRecord` (new) or update `ComplaintRecord` to include fields used by the inbox panel.
   - Provide helpers: `addReport`, `listReports`.
5. **Update ProtocolValidator**
   - Add schema for `baninfo`.
   - Update `complaintlist` and `report` schemas to allow new field shapes (or keep permissive).
6. **Update RequestValidator**
   - Add optional schema for `baninfo` request (expects `avatarID`).
7. **Identity normalization**
   - Add `HandlerUtils.normalizeAvatarId(...)` and use in report/baninfo/complaint action.

---

## Test plan (manual + logs)

### Manual steps
1. Start server with reporting handlers enabled.
2. From client:
   - Open ReportPanel (create-report).
   - Submit report with comment + pervert checkbox.
3. Confirm:
   - `baninfo` response populates panel correctly.
   - `report` response success (no errorCode).
4. Open complaints inbox:
   - Verify `complaints` list populates.
   - Process a report (True/False) and verify list refresh.
5. Validate moderation actions:
   - Kick / warn / notice via Profile panel.

### Expected logs
- `📥 CLIENT REQUEST: baninfo`
- `📥 CLIENT REQUEST: report`
- `📤 SENDING: baninfo` with expected keys
- `📤 SENDING: report` with `ok` or `errorCode`
- `complaintlist` push after report creation

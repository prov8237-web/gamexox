# Moderation gap analysis (reports inbox actions)

## Scope
This analysis is based on the current backend handlers and the client panel documentation for the reports inbox and moderation panels. It focuses on the `complaintaction` flow and related moderation endpoints.

## Inputs and server-side flow (current behavior)

### Inbox action payloads (client → server)
The reports inbox panel sends `complaintaction` with the following payload keys:
- `id`
- `reportedAvatarID`
- `isPervert` (0/1)
- `isAbuse` (0/1)
- `isCorrect` (0/1)
- Handler: `moveNext` to advance the UI after the response.

These keys come from the reports inbox panel implementation documented in `panel_report_inbox_PNCMP923.2.md`. The panel also opens `BanPanel` for warn/notice actions instead of sending a direct `requestData` in that SWF.

### ComplaintActionHandler entry point
`Backend/ComplaintActionHandler.handleClientRequest()` parses:
- `id` from `id/complaintId/cid`
- `action` from `action/type/cmd`
- `duration` from `duration/time/seconds`
- `reason` from `reason/note/message`
- `isCorrect`, `isPervert`, `isAbuse`

It then:
- Resolves a `ReportRecord` by `id` (or falls back to `ComplaintRecord`).
- If inbox flags are present, it updates `isPervert/isAbuse` and resolves the report when `isCorrect` is present.
- Otherwise, it routes to `warnTarget`, `kickTarget`, or `banTarget` based on `action`.

### Target resolution
`resolveTargetUser()` tries:
- `Zone.getUserByName(avatarIdOrName)`
- User variables `avatarName`, `avatarID`, `avatarId`, or `playerID`.

**Important:** this lookup is a raw string comparison; it does not normalize IDs (numeric string vs `Guest#`). The report store records `reportedId` in normalized form, which may not match live user variables.

### Outbound moderation actions (current backend)
- **Warning**: `warnTarget` sends a `cmd2user` payload:
  - `{ from: "SYSTEM", type: "WARN", message: <reason or WARNING> }`
- **Ban**: `banTarget` creates a `BanRecord` and sends:
  - `banned` payload via `BanRecord.toSFSObject(now)` and adds `type`.
- **Kick**: `kickTarget` calls `getApi().disconnectUser(target)`.

## Complaint list broadcast (current behavior)
The complaint list is **not** broadcast to all users:
- `ComplaintActionHandler.pushComplaintListToSecurityUsers()` builds the list and sends it only to security users.
- The same security-only push is used by `ReportHandler` and `PreReportHandler` after reports are created/updated.

This matches the observed behavior where only admins receive `complaintlist` updates.

## Expected vs Actual behavior

| Action | Expected (official) | Actual (current backend) | Gap / Stop point |
| --- | --- | --- | --- |
| WARNING | Target receives `adminMessage` extension response (warning popup). | Target receives `cmd2user` with `type="WARN"`, not `adminMessage`. | `ComplaintActionHandler.warnTarget` sends `cmd2user` only; no `adminMessage` dispatch. |
| BAN | Target receives `banned` payload `{startDate, endDate?, timeLeft, type}` and often an `adminMessage`. | Backend sends `banned` from `ComplaintActionHandler.banTarget`, but **only if target resolves**. No `adminMessage` sent. | `resolveTargetUser` may fail due to normalized IDs; no `adminMessage` in handler. |
| KICK | Target is disconnected (connectionLost). | Backend calls `disconnectUser` only if target resolves. | `resolveTargetUser` may fail; no fallback or normalization. |

## Missing enforcement actions (gaps)
1. **No `adminMessage` event** is sent for WARN or BAN actions.
   - The client expects `adminMessage` to show warnings. `AdminMessageModel` listens to the `adminMessage` extension and turns payload into alerts.
   - The backend currently uses `cmd2user` for warnings, which the client does not map to the same UX.

2. **Target resolution mismatch** likely prevents enforcement.
   - `ReportRecord.reportedId` is normalized (e.g., `guest#3`), while `resolveTargetUser` compares raw strings to user variables without normalization.
   - This causes `target == null`, and all actions become no-ops (no `adminMessage`, no `banned`, no disconnect).

3. **Kick/Ban success depends on target resolution**, not on stored report IDs.
   - When `target == null`, enforcement is skipped without any fallback, so no kick/ban reaches the victim.

## Client payload schema expectations

### `adminMessage` (warning popup)
The client listens to `adminMessage` and uses:
- `title` (string)
- `message` (string)

If `title == "Ban Info"`, the client expects extra keys:
- `swear`
- `swearTime`
- `endDate`

For general warnings, the minimal schema is:
- `{ "title": "Municipalty Message", "message": "<warning text>" }`

### `banned` (ban model)
The ban model expects:
- `type` (e.g., `CHAT` or `LOGIN`)
- `timeLeft` (int seconds; `-1` for unlimited)
- `startDate` (string)
- `endDate` (string or null)

This matches `BanRecord.toSFSObject()` output used in `BanUserHandler` and `ComplaintActionHandler`.

## Recommended minimal code changes (plan only)

### 1) Normalize target resolution for moderation actions
**Files:**
- `Backend/ComplaintActionHandler.java`

**Changes:**
- Normalize `avatarIdOrName` and compare normalized strings (similar to `HandlerUtils.normalizeAvatarId`).
- Consider matching against `User.getName()` and user vars after normalization.

**Why:**
- Ensures `report.reportedId` matches live users so WARN/BAN/KICK can execute.

### 2) Send `adminMessage` on WARN and BAN
**Files:**
- `Backend/ComplaintActionHandler.java`
- (Optional) `Backend/WarnUserHandler.java` for consistency

**Changes:**
- Add `adminMessage` payload dispatch to the target user:
  - `{ title: "Municipalty Message", message: "<warning text>" }`
  - For ban events, optionally send `title: "Ban Info"` and include `endDate`.

**Why:**
- Matches official behavior where warnings show as admin popups.

### 3) Ensure BAN/KICK enforcement occurs
**Files:**
- `Backend/ComplaintActionHandler.java`

**Changes:**
- After successful resolution, call `disconnectUser` for KICK (already in place when target resolves).
- For LOGIN bans, keep disconnect (already present), but ensure target resolution succeeds.

**Why:**
- Aligns with official behavior (kick triggers connection lost).

## References (code + docs)
- `Backend/ComplaintActionHandler.java` for current action handling and outbound moderation messages.
- `Backend/BanUserHandler.java` and `Backend/WarnUserHandler.java` for existing moderation payloads and patterns.
- `Backend/KickAvatarFromRoomHandler.java` for the kick pattern used elsewhere.
- `Backend/ReportHandler.java` and `Backend/PreReportHandler.java` for complaint list pushes.
- Client docs: `docs/client/panel_report_inbox_PNCMP923.2.md` for inbox request payloads, `docs/client/panel_profile_PRFP57.md` for moderation entry points, and `docs/client/core_snal_official_analysis.md` for command registry context.

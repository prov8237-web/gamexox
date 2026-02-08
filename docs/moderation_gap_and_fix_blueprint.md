# Moderation gap & fix blueprint (client vs backend)

> **Note on missing inputs**: The task references `docs/client/moderation_client_contract.md`, `docs/client/moderation_event_handlers_map.md`, and `docs/client/panels_moderation_io.md`, but those files are not present in this repo. This blueprint therefore reconciles the available client moderation docs (report panel, complaint inbox, profile moderation) with the backend moderation docs. Missing sources should be added to tighten the contract mapping.

## 1) Executive Summary (Top 5 mismatches by impact)

1) **WARN uses `adminMessage` on backend but client WARN UI likely expects a different event path.** Backend warns via `adminMessage` in complaint actions, while other handlers use `cmd2user` with `type=WARN`. That mismatch likely explains missing warning popups in some flows. (Client inbox uses complaint actions; backend emits `adminMessage` there.)
2) **KICK flows rely on `disconnectUser` without consistent client-visible eventing.** Some handlers send `cmd2user` KICK before disconnect, others only disconnect; if the client expects a specific event (e.g., `cmd2user` or connectionLost) the sequence can fail depending on handler or race timing.
3) **BAN payload schema/type divergence (`startDate/endDate` ms long vs string) and missing `trace`.** Backend emits `banned` from multiple places with different date formats, which can break client parsing or UI rendering.
4) **Target resolution is inconsistent across handlers.** Complaint actions use a normalized scan of user vars and `Guest#` formats, while direct warn/ban/kick handlers use narrower matching. This mismatch can produce “target not found” or actions landing on the wrong avatar.
5) **Policy gates do not block admin→admin or protect privileged targets.** Complaint moderation is gated by security roles, but there is no hierarchy or target-role check, so admins can be punished like normal users (or actions can be refused client-side while server still applies them).

## 2) Contract Diff Table (WARN/KICK/BAN)

**Legend**: Status = MATCH / PARTIAL / FAIL

### WARN
| Item | Client expects | Backend emits | Status | Minimal fix |
| --- | --- | --- | --- | --- |
| WARN delivery | Complaint inbox `complaintaction` is used for moderation actions; warn likely expects a user-facing warning popup / notice channel. (Inbox panel uses `complaintaction`.) | `ComplaintActionHandler` sends `adminMessage` with `{title,message,ts,trace}` on WARN. (`adminMessage` is not `cmd2user`.) | **PARTIAL** | Emit **both** `adminMessage` and `cmd2user` with `type=WARN` when action=warn, to cover both UI listeners. |
| WARN target ID | Client passes raw `reportedAvatarID` from inbox list. | Backend uses `resolveTarget` for complaint flow (normalized + user vars). | **MATCH** (complaint flow) | Standardize resolution logic across all WARN endpoints (including `warnUser`). |

### KICK
| Item | Client expects | Backend emits | Status | Minimal fix |
| --- | --- | --- | --- | --- |
| KICK from profile | Profile panel sends `kickAvatarFromRoom` with `{avatarID,duration}`. | `KickAvatarFromRoomHandler` sends `cmd2user` `{type:"KICK", message}` then `disconnectUser`. | **MATCH** | Ensure disconnect is enforced (confirm session close) and log outcome. |
| KICK from complaint action | Complaint inbox sends `complaintaction` with action=kick. | `ComplaintActionHandler.kickUserHard` disconnects + retry, no `cmd2user`. | **PARTIAL** | Send `cmd2user` with `type=KICK` before `disconnectUser` in complaint-based kick. |

### BAN (chat/login)
| Item | Client expects | Backend emits | Status | Minimal fix |
| --- | --- | --- | --- | --- |
| BAN notification | Report panel expects `baninfo` with `banStatus/banCount/expireSecond/nextBanMin` and uses `report` responses for UI. | `BanInfoHandler` returns `banCount/totalMins/nextBanMin/banStatus?/expireSecond?`; `ReportHandler` returns `report` with `nextRequest` and optional `errorCode`. | **PARTIAL** | Ensure `baninfo` always includes fields used by panel (`banStatus`, `expireSecond`, `nextBanMin`) and align types. |
| BAN enforcement on login | Client expects to be disconnected / see `banned` for active bans. | `ServerEventHandler.onUserLogin` sends `banned` then disconnects. | **MATCH** | Use consistent `banned` payload schema (date formats) across sources. |
| BAN enforcement on chat | Client expects chat to be muted or blocked when chat-banned. | `ServerEventHandler.onPublicMessage` blocks chat and sends `banned`. | **PARTIAL** | Apply CHAT ban checks to private/whisper channels (if used) and make `banned` schema consistent. |

## 3) Root Cause Analysis (most likely stop points)

A) **Target resolution mismatch**
- Complaint actions resolve targets via normalized ID + user vars, while `warnUser` / `kickAvatarFromRoom` / `kickUserFromBusiness` use minimal matching. This can yield “target not found” or wrong target in direct moderation paths.

B) **Wrong cmd name / channel**
- WARN from complaint actions uses `adminMessage`, but other paths use `cmd2user` (type WARN). If the client WARN popup listens only for `cmd2user` or a specific alert in another handler, warnings never display.

C) **Payload type mismatch**
- `banned` payloads have two competing date formats (ms long vs formatted string). If the client expects a single format, a parse error can prevent ban UI or timers.

D) **Disconnect semantics**
- Complaint-based kicks rely on `disconnectUser` + retry; in some sessions the disconnect may not propagate or the WS session may remain alive, resulting in no visible “kick”.

E) **Policy gate / admin immunity**
- No backend role hierarchy prevents admin→admin actions; if client UI blocks actions but backend still applies (or vice versa), results diverge and appear inconsistent.

## 4) Fix Plan (Two Tracks)

### Track A: Minimal Patch (fast ROI)

1. **WARN dual-channel emit**
   - **Touch**: `Backend/ComplaintActionHandler.warnTarget` / `sendAdminMessage`.
   - **Change**: send `cmd2user` `{type:"WARN", message}` alongside `adminMessage` to cover both listeners.

2. **KICK consistency**
   - **Touch**: `Backend/ComplaintActionHandler.kickUserHard`.
   - **Change**: send `cmd2user` `{type:"KICK", message}` before `disconnectUser` for complaint-based kicks.

3. **Standardize `banned` payload schema**
   - **Touch**: `Backend/ComplaintActionHandler.banTarget`, `Backend/ServerEventHandler`, `Backend/InMemoryStore.BanRecord.toSFSObject`.
   - **Change**: choose a single date format (prefer ms longs or formatted strings) and apply across all senders; always include `type`, `startDate`, `endDate`, `timeLeft`, `trace`.

4. **Align `baninfo` fields**
   - **Touch**: `Backend/BanInfoHandler`.
   - **Change**: ensure `banStatus`, `expireSecond`, `nextBanMin`, and `banCount` are always present when expected by the report panel.

5. **Target resolution upgrade in direct handlers**
   - **Touch**: `WarnUserHandler`, `KickAvatarFromRoomHandler`, `KickUserFromBusinessHandler`, `BanUserHandler`.
   - **Change**: reuse the richer resolution logic (normalized IDs + user vars) from `ComplaintActionHandler.resolveTarget`.

### Track B: Hardening / Enterprise-grade moderation

1. **Deterministic target resolution**
   - Centralize a shared resolver (avatarId → user) with explicit match priority: direct name → normalized `Guest#` → user vars (`avatarID`, `avatarName`, `playerID`) → offline store lookup.

2. **Hard disconnect + session kill**
   - Implement a robust disconnect path that ensures session termination and removes the user from the zone; include retries + error logging.

3. **Consistent ban persistence/enforcement**
   - Move bans to persistent storage (DB/Redis) and enforce on login, join-room, and chat/whisper paths.

4. **Role hierarchy + super-admin override**
   - Introduce a role priority matrix (e.g., SUPER_ADMIN > ADMIN > MODERATOR > SECURITY). Enforce “cannot punish higher/equal role” unless override flag present.

5. **Audit trail + moderation trace**
   - Append structured moderation records (action, actor, target, resolvedBy, payload snapshot, timestamps) and emit them to logs/metrics.

## 5) Acceptance Tests (Must Pass)

> For each test, verify client event(s) **and** backend log lines. Use a known moderation trace id when available.

1. **WARN → guest**
   - Action: Security user warns a Guest#N from complaint inbox.
   - Expected client events: `cmd2user` {type:"WARN"} **and/or** `adminMessage` popup.
   - Expected server logs: `[MOD_WARN] trace=... sent=1` (complaint action) and/or send logs for `adminMessage`.

2. **WARN → user**
   - Action: Security user warns a normal user from complaint inbox.
   - Expected client events: `cmd2user` WARN or `adminMessage` popup; warning visible.
   - Expected server logs: `[MOD_TGT]` resolution + `[MOD_WARN]` send log.

3. **WARN → admin**
   - Action: Security user warns an admin user.
   - Expected client events: warn popup delivered (unless role hierarchy blocks).
   - Expected server logs: resolution log showing target roles + warn send log.

4. **KICK → guest/user/admin**
   - Action: Use profile panel `kickAvatarFromRoom` against guest/user/admin.
   - Expected client events: `cmd2user` {type:"KICK"}, connection lost / disconnect.
   - Expected server logs: `[KICK_AVATAR] ...` plus disconnect logs.

5. **BAN 60s → guest/user/admin (chat ban)**
   - Action: complaint action `ban` with duration=60 seconds.
   - Expected client events: `banned` payload with `type=CHAT`, valid `timeLeft`, plus disconnect.
   - Expected server logs: `[MOD_BAN_SEND] trace=... type=CHAT` and `[MOD_BAN_ENFORCE]` on subsequent login attempts.

6. **BAN 60s → guest/user/admin (login ban)**
   - Action: complaint action `loginban` with duration=60 seconds.
   - Expected client events: `banned` payload with `type=LOGIN` and disconnect; re-login blocked with `banned` on login.
   - Expected server logs: `[MOD_BAN_SEND] ... type=LOGIN` and `[MOD_BAN_ENFORCE] trace=... type=LOGIN` on login.

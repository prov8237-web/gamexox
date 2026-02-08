# Moderation enforcement patch notes

## Changed files
- `Backend/ComplaintActionHandler.java`
- `Backend/InGameReportHandler.java`
- `Backend/ServerEventHandler.java`
- `Backend/MainExtension.java`
- `Backend/PreReportHandler.java`
- `Backend/ReportHandler.java`
- `docs/backend/moderation_patch_notes.md`

## Summary
- Warn/kick/ban notifications now emit `adminMessage` (title `Municipalty Message`) so the client displays visible alerts without relying on `cmd2user`.
- `banned` payloads are standardized to string dates (`startDate`/`endDate`) + `timeLeft` (int) + `trace`, matching the client `BanModel` contract.
- Complaint actions and report creation reject `reportedAvatarID`=`0` and log `[RPT_WARN_ZERO]` instead of storing zero IDs.
- Kick actions issue an `adminMessage` before disconnect, with `[MOD_KICK]` logging and retry behavior preserved.
- Added `ingamereport` handling to send in-game notice/kick admin messages, resolve targets by avatar identifiers, and respond with traceable OK/error payloads.

## Manual test steps
1. **In-game notice**
   - Send `ingamereport` with `command=notice` and a target avatar id.
   - Expected client: `adminMessage` popup with title `Municipalty Message`.
   - Expected logs: `[MOD_TGT]`, `[MOD_SEND]`, `[INGAME_REPORT] ok=true`.
2. **In-game kick**
   - Send `ingamereport` with `command=kick` and a target avatar id.
   - Expected client: `adminMessage` popup, then disconnect.
   - Expected logs: `[MOD_TGT]`, `[MOD_SEND]`, `[MOD_KICK]`, `[INGAME_REPORT] ok=true`.
3. **Warning**
   - From the reports inbox, trigger a warning.
   - Expected client: `adminMessage` popup with title `Municipalty Message`.
   - Expected logs: `[MOD_REQ]`, `[MOD_TGT]`, `[MOD_SEND_ADMINMSG]`, `[MOD_WARN_SEND]`.
4. **Kick**
   - Trigger a kick action.
   - Expected client: `adminMessage` popup, then `connectionLost`.
   - Expected logs: `[MOD_REQ]`, `[MOD_TGT]`, `[MOD_KICK]` (and optional `[MOD_KICK_RETRY]`).
5. **CHAT ban (60s)**
   - Trigger a 60-second chat ban.
   - Expected client: `banned` event with `type=CHAT`, `timeLeft=60`, `startDate`/`endDate` strings, then disconnect.
   - Expected logs: `[MOD_BAN_SEND]` and `[MOD_BAN_ENFORCE]` on re-login/chat attempt.
6. **LOGIN ban (60s)**
   - Trigger a 60-second login ban.
   - Expected client: `banned` event with `type=LOGIN`, `timeLeft=60`, `startDate`/`endDate` strings, then disconnect.
   - Expected logs: `[MOD_BAN_SEND]` and `[MOD_BAN_ENFORCE]` on re-login.

## Expected logs
- `[MOD_REQ]`, `[MOD_TGT]`, `[MOD_SEND_ADMINMSG]`, `[MOD_FAIL]`
- `[MOD_WARN_SEND]`, `[MOD_BAN_SEND]`, `[MOD_BAN_ENFORCE]`
- `[MOD_KICK]`, `[MOD_KICK_RETRY]`
- `[REPORT_CREATE_IN]`, `[REPORT_CREATE_STORE]`
- `[COMPLAINTLIST_BUILD]`
- `[COMPLAINT_ACTION_IN]`
- `[INGAME_REPORT]`

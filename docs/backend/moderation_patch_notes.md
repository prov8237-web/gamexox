# Moderation enforcement patch notes

## Changed files
- `Backend/ComplaintActionHandler.java`
- `Backend/ServerEventHandler.java`
- `docs/backend/moderation_patch_notes.md`

## Summary
- Warn/kick/ban notifications now emit `adminMessage` (title `Municipalty Message`) so the client displays visible alerts without relying on `cmd2user`.
- `banned` payloads are standardized to string dates (`startDate`/`endDate`) + `timeLeft` (int) + `trace`, matching the client `BanModel` contract.
- Complaint actions and report creation reject `reportedAvatarID`=`0` and log `[RPT_WARN_ZERO]` instead of storing zero IDs.
- Kick actions issue an `adminMessage` before disconnect, with `[MOD_KICK]` logging and retry behavior preserved.

## Manual test steps
1. **Warning**
   - From the reports inbox, trigger a warning.
   - Expected client: `adminMessage` popup with title `Municipalty Message`.
   - Expected logs: `[MOD_REQ]`, `[MOD_TGT]`, `[MOD_SEND_ADMINMSG]`, `[MOD_WARN_SEND]`.
2. **Kick**
   - Trigger a kick action.
   - Expected client: `adminMessage` popup, then `connectionLost`.
   - Expected logs: `[MOD_REQ]`, `[MOD_TGT]`, `[MOD_KICK]` (and optional `[MOD_KICK_RETRY]`).
3. **CHAT ban (60s)**
   - Trigger a 60-second chat ban.
   - Expected client: `banned` event with `type=CHAT`, `timeLeft=60`, `startDate`/`endDate` strings, then disconnect.
   - Expected logs: `[MOD_BAN_SEND]` and `[MOD_BAN_ENFORCE]` on re-login/chat attempt.
4. **LOGIN ban (60s)**
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

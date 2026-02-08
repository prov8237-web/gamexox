# Moderation enforcement patch notes

## Changed files
- `Backend/ComplaintActionHandler.java`
- `Backend/ServerEventHandler.java`
- `docs/backend/moderation_patch_notes.md`

## Summary
- Added admin warning delivery via `adminMessage` (with `title`, `message`, `ts`) alongside existing `cmd2user` warnings.
- Added ban enforcement logs and admin ban notifications, and disconnect enforcement for active CHAT/LOGIN bans.
- Normalized target resolution during moderation actions to support numeric IDs and `Guest#` identifiers.
- Added login-time ban enforcement for CHAT bans with `[MOD_BAN_ENFORCE]` logging.

## Manual test steps
1. **Warning**
   - From the reports inbox, trigger a warning.
   - Expected: victim receives `adminMessage` popup; logs include `[MOD_IN]`, `[MOD_RESOLVE]`, `[MOD_SEND_ADMINMSG]`, `[MOD_WARN_REQ]`.
2. **Ban**
   - Trigger a 60-second ban.
   - Expected: victim receives `banned` event (`startDate`, `endDate`, `timeLeft`, `type`, `trace`) and `adminMessage`; logs include `[MOD_IN]`, `[MOD_RESOLVE]`, `[MOD_BAN_SEND]`, and `[MOD_BAN_ENFORCE]` on re-login.
3. **Kick**
   - Trigger a kick action.
   - Expected: victim disconnects (client `connectionLost`); logs include `[MOD_IN]`, `[MOD_RESOLVE]`, and `[MOD_KICK]`.

## Expected logs
- `[MOD_IN]`, `[MOD_RESOLVE]`, `[MOD_SEND_ADMINMSG]`
- `[MOD_BAN_SEND]`, `[MOD_BAN_ENFORCE]`
- `[MOD_KICK]`
- `[REPORT_CREATE_IN]`, `[REPORT_CREATE_STORE]`
- `[COMPLAINTLIST_BUILD]`
- `[COMPLAINT_ACTION_IN]`, `[COMPLAINT_ACTION_RESOLVE]`

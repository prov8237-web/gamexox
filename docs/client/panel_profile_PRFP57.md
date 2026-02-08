# Profile moderation panel (PRFP.57)

Scope: `Client/Panel/PRFP.57/scripts/org/oyunstudyosu/sanalika/panels/profile/*`.

## Moderation actions and commands

### Profile load (context for moderation)
- **Command**: `RequestDataKey.PROFILE` (`"profile"`).
- **Call site**: `ProfilePanel.init()` and `ProfilePanel.updateProfile()` → `requestData(RequestDataKey.PROFILE, { "avatarID": avatarId }, profileResponse)`.

### Kick from room (home)
- **Command**: `RequestDataKey.KICK_AVATAR_FROM_ROOM` (`"kickAvatarFromRoom"`).
- **Call site**: `ProfileMenu.kickResponse()` sends `{ avatarID, duration }` and handles response in `kickAvatarResponse`.
- **UI flow**: `kickUserFromHomeButton` opens a `KICK_SELECT_TIME` alert with a duration selector; on OK, sends the command.

### Ban/notice actions (via BanPanel)
- **Action**: `ProfileMenu.banButtonClicked()` and `noticeButtonClicked()` open `BanPanel` with `action="kick"` or `action="notice"`, and pass `avatarID`, `banCount`, `duration`. This does **not** directly send a service command in this SWF; the actual enforcement happens inside the BanPanel implementation (outside this SWF).
- **Duration logic**: `banDuration()` maps `banCount` to durations (warning, minute/hour/day/week/month) used for the BanPanel tooltip and payload duration string.

### Improper content flags (moderation marks)
- **Command**: `RequestDataKey.PROFILE_IMPROPER` (`"profileimproper"`).
- **Call sites**:
  - `btnImproperClicked` → `{ avatarID, action: "nick" }`
  - `btnImproperStatusClicked` → `{ avatarID, action: "status" }`
  - `btnImproperCityClicked` → `{ avatarID, action: "city" }`
- **Handlers**: `onImproperResponse`, `onImproperStatusResponse`, `onImproperCityResponse` mutate the UI (name/status/city label updates).

### Like/dislike (not strictly moderation, but profile feedback)
- **Command**: `RequestDataKey.PROFILE_LIKE` (`"profilelike"`).
- **Call sites**: `onLike` → `{ avatarID, avatarLike: 1 }`, `onDislike` → `{ avatarID, avatarLike: 0 }`. Response updates `likeCount`/`dislikeCount` UI.

## Permission gating
- **Moderation controls**: “improper” buttons only appear if the viewer has `AvatarPermission.SECURITY` and is not viewing their own profile. This is a client-side role gate for moderation actions.
- **Kick/ban/notice buttons** in `ProfileMenu` appear only when the viewer has `AvatarPermission.CARD_SECURITY` (and the target is not self).
- **Kick from home** button only appears when the viewer is at home (`avatarModel.atHome`).

## Avatar identifier representation
- **Avatar ID** is treated as a **string** throughout profile and menu code: passed via `data.params.avatarId` and used directly in requests and UI labels (`txtAvatarID`). No normalization is applied before use.
- **Player ID** is derived from the SmartFox user variable `CharacterVariable.PLAYER_ID` and converted to a string (numeric in source). This is separate from `avatarID` and is only used for display/copy actions (`txtPlayerID`).

**Normalization considerations**: The code does not attempt to parse or sanitize avatar IDs (e.g., for “Guest#X” strings). All moderation actions pass the raw `avatarID` string to `requestData` or `BanPanel`. If server endpoints require numeric IDs, normalization would need to happen upstream of this panel (caller or server side).

## How this connects to the reporting system
- Profile moderation provides the **post-report enforcement tools** (kick, notice, ban) used by security roles. These are triggered either via direct service commands (`kickAvatarFromRoom`) or via opening the `BanPanel` with action parameters. Combined with the reports inbox (`complaintlist`/`complaintaction`), this panel supplies the in-profile actions for moderators to act on reported users.

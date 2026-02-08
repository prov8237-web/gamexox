# Moderation panels I/O (client)

This document lists what each moderation-related panel **sends** and where the payload values originate. Each claim cites the class/method in the scanned scripts.

## ReportPanel (create report)
- **File**: `Client/Panel/1449237199236-23.4.swf/scripts/org/oyunstudyosu/sanalika/panels/report/ReportPanel.as`.
- **Sends**:
  - `baninfo` via `ServiceModel.requestData` with `{ avatarID }`. (Source: `ReportPanel.init`.)
  - `report` via `ServiceModel.requestData` with `reportData`:
    - `reportedAvatarID` (string) — from `data.params.avatarId`.
    - `message` (string) — from `data.params.lastMessage`.
    - `isPervert` (int 0/1) — from checkbox.
    - `comment` (string) — from user input (`lastComment`).
    (Source: `ReportPanel.init`, `ReportPanel.onReportUser`.)

## ComplaintPanel (reports inbox)
- **File**: `Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as`.
- **Sends**:
  - `complaintlist` with `{}` to fetch inbox. (Source: `ComplaintPanel.getList`.)
  - `complaintaction` with:
    - `id` (number)
    - `reportedAvatarID` (string)
    - `isPervert` (int)
    - `isAbuse` (int)
    - `isCorrect` (int)
    (Source: `ComplaintPanel.reportAction`.)
  - `buddylocate` with `{ avatarID }` for locate action. (Source: `ComplaintPanel.locationAction`.)
- **Ban/notice actions**:
  - Opens `BanPanel` with `action="notice"`, `avatarID`, `banCount`, `duration` instead of sending a direct request. (Source: `ComplaintPanel.warnAction`, `ComplaintPanel.warnReporter`.)

## Profile menu (moderation controls in profile panel)
- **File**: `Client/Panel/PRFP.57/scripts/org/oyunstudyosu/sanalika/panels/profile/ProfileMenu.as`.
- **Sends**:
  - `kickAvatarFromRoom` with `{ avatarID, duration }` when kicking from home. (Source: `ProfileMenu.kickResponse`.)
- **Ban/notice actions**:
  - Opens `BanPanel` with:
    - `action="kick"` (ban button)
    - `action="notice"` (notice button)
    - `avatarID`, `banCount`, `duration` from profile state
    (Source: `ProfileMenu.banButtonClicked`, `ProfileMenu.noticeButtonClicked`.)

## Report entry points (how `reportedAvatarID` is computed)

These UI entry points create the `ReportPanel` parameters consumed by `ReportPanel.init`.

- **Speech balloon report**: `SpeechBalloon.reportClicked` sets `params.avatarId = char.id` and `params.lastMessage = lastMessage`. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/chat/SpeechBalloon.as` — `reportClicked`.)
- **Room message tip report**: `UserRoomMessage.clickReport` sets `params.avatarId = character.id` and `params.lastMessage = data.message`. (Source: `Client/snal.official.swf/scripts/extensions/notification/UserRoomMessage.as` — `clickReport`.)
- **Business message report**: `BusinessMessage.reportButtonClicked` sets `params.avatarId = senderID` and `params.lastMessage = message`. (Source: `Client/snal.official.swf/scripts/org/oyunstudyosu/business/BusinessMessage.as` — `reportButtonClicked`.)

### Why `reportedAvatarID` can become `0`
- The panel relies on the **raw IDs** assigned in the entry points (`char.id`, `character.id`, `senderID`). If those values are `0`/empty from their source objects, the report panel sends `reportedAvatarID` as `0` without normalization. (Sources: `SpeechBalloon.reportClicked`, `UserRoomMessage.clickReport`, `BusinessMessage.reportButtonClicked`, and `ReportPanel.init`.)
- The complaint inbox uses `reportedAvatarID` from the server-provided `complaints` list; if the server stores `reportedAvatarID` as `0`, the panel sends that value back in `complaintaction`. (Source: `ComplaintPanel.complaintListResponse` → `ComplaintPanel.reportAction`.)

# Moderation event handlers map (client)

This map lists moderation-related event listeners and callbacks found in the scanned ActionScript sources. Each entry includes the class, method, trigger, required payload keys, and UI/state impact.

## ExtensionResponse / listenExtension handlers

| Cmd/event | Class → method | Trigger | Required payload keys (as used) | UI/state impact |
| --- | --- | --- | --- | --- |
| `adminMessage` | `com.oyunstudyosu.model.AdminMessageModel` → `onAdminMessage` | `ServiceModel.listenExtension("adminMessage", ...)` | `title` (optional), `message` (string), plus `swear`, `swearTime`, `endDate` when `title == "Ban Info"` | Shows an alert for non-`Ban Info` titles; `Ban Info` path rewrites message text but does not dispatch an alert. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/model/AdminMessageModel.as` — `AdminMessageModel.onAdminMessage`) |
| `banned` | `com.oyunstudyosu.ban.BanModel` → `banned` | `ServiceModel.listenExtension("banned", ...)` | `type` (string), `timeLeft` (int), `startDate` (string), `endDate` (string or null) | Adds a ban record, triggers `BanEvent.CHAT_BANNED` or a login-ban alert. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/ban/BanModel.as` — `BanModel.banned`) |
| `unbanned` | `com.oyunstudyosu.ban.BanModel` → `onBanExpired` | `ServiceModel.listenExtension("unbanned", ...)` | none used | Clears ban list and dispatches `BanEvent.CHAT_BANNED_COMPLETE`. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/ban/BanModel.as` — `BanModel.onBanExpired`) |
| `baninfo` | `org.oyunstudyosu.sanalika.panels.report.ReportPanel` → `onResponse` | `ServiceModel.requestData(RequestDataKey.AVATAR_BANINFO, ..., onResponse)` | `banCount` (int), `banStatus` (flag), `expireSecond` (ms), `nextBanMin` (minutes) | Renders ban info copy or shows “already banned” alert + closes panel. (Source: `Client/Panel/1449237199236-23.4.swf/scripts/org/oyunstudyosu/sanalika/panels/report/ReportPanel.as` — `ReportPanel.onResponse`) |
| `complaintlist` | `org.oyunstudyosu.sanalika.panels.complaint.ComplaintPanel` → `complaintListResponse` | `ServiceModel.requestData(RequestDataKey.COMPLAINT_LIST, ..., complaintListResponse)` | `complaints` array, each item uses `id`, `message`, `comment`, `reporterAvatarID`, `reportedAvatarID`, `isPervert`, `banCount`, `nextBanMin` | Builds complaint list UI; shows “No report...” or error text when list is missing/empty. (Source: `Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as` — `ComplaintPanel.complaintListResponse`) |
| `complaintaction` | `org.oyunstudyosu.sanalika.panels.complaint.ComplaintPanel` → `moveNext` | `ServiceModel.requestData(RequestDataKey.COMPLAINT_ACTION, ..., moveNext)` | `errorCode` (optional) | Advances to next complaint; if `errorCode` is set, it refreshes the list. (Source: `Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as` — `ComplaintPanel.moveNext`) |

> **Note**: `cmd2user` is defined in `GameRequest`/`GameResponse` constants, but no `listenExtension("cmd2user", ...)` or explicit handler method was found in the scanned client scripts. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/enums/GameRequest.as` — `GameRequest.MESSAGE`; `Client/snal.official.swf/scripts/com/oyunstudyosu/enums/GameResponse.as` — `GameResponse.MESSAGE`.)

## System events (SmartFox)

| Event | Class → method | Trigger | Required payload keys | UI/state impact |
| --- | --- | --- | --- | --- |
| `connectionLost` | `com.oyunstudyosu.service.ServiceController` → `onConnectionLost` | `sfs.addEventListener("connectionLost", ...)` | `reason` (string) | Shows reconnect/other-device alerts and terminates game state. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceController.as` — `ServiceController.onConnectionLost`) |
| `userEnterRoom` | `com.oyunstudyosu.room.RoomController` → `onUserEnterRoom` | `sfs.addEventListener("userEnterRoom", ...)` | `user`, `room` | Queues and spawns character entities when someone joins. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/room/RoomController.as` — `RoomController.onUserEnterRoom`) |
| `userExitRoom` | `com.oyunstudyosu.room.RoomController` → `onUserExitRoom` | `sfs.addEventListener("userExitRoom", ...)` | `user`, `room` | Removes character entities and dispatches `USER_LEAVE_ROOM` event. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/room/RoomController.as` — `RoomController.onUserExitRoom`) |

## Extension response dispatch mechanism (shared)
- `ServiceModel.onExtensionResponse` converts the payload to an object and dispatches callbacks for `requestData` and `listenExtension` registrations. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as` — `ServiceModel.onExtensionResponse`.)

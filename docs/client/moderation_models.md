# Moderation models + parsing logic (client)

This document extracts the parsing logic for moderation payloads and highlights guardrails that can silently drop events.

## `banned` parsing + ban timers
- **Handler**: `BanModel.banned` creates a `BanData` record and copies fields from the payload. It expects `type`, `timeLeft`, `startDate`, and `endDate` and treats `timeLeft == -1` as unlimited. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/ban/BanModel.as` — `BanModel.banned`.)
- **Ban timer tick**: `BanModel.updateBanTime` runs every second via `updateModel.getGroup(1000)` and decrements `banEndTime` for limited bans; when it reaches 0, it dispatches `BanEvent.CHAT_BANNED_COMPLETE`. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/ban/BanModel.as` — `BanModel.updateBanTime`.)
- **Data model**: `BanData.startDate` and `BanData.endDate` are typed as `String` and stored without parsing. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/ban/BanData.as` — setters/getters.)

## `adminMessage` parsing
- **Handler**: `AdminMessageModel.onAdminMessage` renders an alert for non-"Ban Info" titles and defaults missing titles to “Municipalty Message”. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/model/AdminMessageModel.as` — `AdminMessageModel.onAdminMessage`.)
- **Ban Info path**: when `title == "Ban Info"`, it mutates `param1.message` to append `swear`, `swearTime`, and `endDate` but **does not dispatch an alert**. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/model/AdminMessageModel.as` — `AdminMessageModel.onAdminMessage`.)

## `cmd2user` parsing
- **No handler found**: in the scanned scripts, `cmd2user` appears only as constants (`GameRequest.MESSAGE`, `GameResponse.MESSAGE`) with no explicit `listenExtension("cmd2user")` handler. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/enums/GameRequest.as`; `Client/snal.official.swf/scripts/com/oyunstudyosu/enums/GameResponse.as`.)

## ExtensionResponse dispatch (shared)
- **Routing**: `ServiceModel.onExtensionResponse` converts payloads to objects and dispatches callbacks for both `requestData` and `listenExtension` registrations; errors are wrapped in `try/catch` blocks and logged only via `trace`. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as` — `ServiceModel.onExtensionResponse`.)

## Top 10 reasons moderation UI can fail silently (with code references)

1. **`adminMessage` with title `Ban Info` never triggers an alert** — the method only rewrites message text for Ban Info and does not dispatch UI. (Source: `AdminMessageModel.onAdminMessage`.)
2. **`cmd2user` has no handler** — if the server emits WARN/KICK via `cmd2user`, the client has no listener to display it. (Source: `GameRequest.MESSAGE` / `GameResponse.MESSAGE` constants only.)
3. **`baninfo` payload controls panel close + copy** — `ReportPanel.onResponse` closes the panel when `banStatus` is present and uses `banCount`/`nextBanMin` to render warning text; wrong or missing values produce incorrect UI state. (Source: `ReportPanel.onResponse`.)
4. **`report`/`baninfo` callbacks can be swallowed** — `ServiceModel.onExtensionResponse` wraps callback dispatch in `try/catch` and only traces errors, so handler exceptions fail silently. (Source: `ServiceModel.onExtensionResponse`.)
5. **Rate limiting short-circuits requests** — `ServiceModel.requestData` returns early with `FLOOD`/`EXTENSION_IDLE`, which can look like “no response” if UI does not surface tooltips. (Source: `ServiceModel.requestData`.)
6. **Complaint inbox drops missing `complaints` key** — `ComplaintPanel.complaintListResponse` treats missing `complaints` as error and retries later without surfacing a hard failure. (Source: `ComplaintPanel.complaintListResponse`.)
7. **Report panel disables send buttons after submit** — `ReportPanel.onReportUser` removes click listeners after sending; if the response fails, the user cannot re-submit without reopening. (Source: `ReportPanel.onReportUser`.)
8. **Ban timer decrement bug** — `BanModel.updateBanTime` uses `banData == banList[_loc3_]` (comparison instead of assignment), so `banData` may not update, breaking timer countdown. (Source: `BanModel.updateBanTime`.)
9. **User variable update callbacks swallow errors** — `ServiceModel.onUserVariableUpdate` catches exceptions and does nothing, potentially hiding downstream failures tied to moderation state. (Source: `ServiceModel.onUserVariableUpdate`.)
10. **Room enter/exit events gated by room flags** — `RoomController.onUserEnterRoom`/`onUserExitRoom` return early if `isInteractiveRoom` is false, so presence changes (and any moderation tracking tied to them) can be skipped. (Source: `RoomController.onUserEnterRoom`, `RoomController.onUserExitRoom`.)

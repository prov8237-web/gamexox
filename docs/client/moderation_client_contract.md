# Moderation client contract (commands + payloads)

This contract is derived from the scanned ActionScript handlers and panels. Each entry lists expected keys, types, required vs optional, and example payloads. Each expectation references the consuming class/method.

## `adminMessage`
- **Consumer**: `AdminMessageModel.onAdminMessage` (`Client/snal.official.swf/scripts/com/oyunstudyosu/model/AdminMessageModel.as`).
- **Required keys**:
  - `message` (string) — used in alerts and Ban Info formatting.
- **Optional keys**:
  - `title` (string) — if missing, defaults to “Municipalty Message”.
  - `swear` (string), `swearTime` (string), `endDate` (string) — used only when `title == "Ban Info"`.
- **Example (standard info)**:
  ```json
  {"title":"Municipalty Message","message":"Stop flooding"}
  ```
- **Example (Ban Info)**:
  ```json
  {"title":"Ban Info","message":"You have been banned by the moderator.","swear":"CHAT","swearTime":"1700000000","endDate":"2024-01-01 10:00:00.0"}
  ```

## `banned`
- **Consumer**: `BanModel.banned` (`Client/snal.official.swf/scripts/com/oyunstudyosu/ban/BanModel.as`).
- **Required keys**:
  - `type` (string; expects values like `CHAT` or `LOGIN`).
  - `timeLeft` (int; seconds). `-1` is treated as unlimited.
- **Optional keys**:
  - `startDate` (string) — stored directly, not parsed.
  - `endDate` (string or null) — stored directly and used for login ban messaging.
- **Date format expectation**:
  - **Strings**. `BanData.startDate` and `BanData.endDate` are typed as `String` and used for display; no millisecond parsing occurs. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/ban/BanData.as` — getters/setters; `BanModel.banned` assigns `startDate`/`endDate`.)
- **Example**:
  ```json
  {"type":"CHAT","timeLeft":60,"startDate":"2024-01-01 10:00:00.0","endDate":"2024-01-01 10:01:00.0"}
  ```

## `unbanned`
- **Consumer**: `BanModel.onBanExpired` (`Client/snal.official.swf/scripts/com/oyunstudyosu/ban/BanModel.as`).
- **Required keys**: none (payload is ignored).
- **Example**:
  ```json
  {"type":"CHAT"}
  ```

## `cmd2user`
- **Consumer**: **No explicit handler found in scanned client scripts.** Only constants exist in `GameRequest.MESSAGE` / `GameResponse.MESSAGE`. (Source: `Client/snal.official.swf/scripts/com/oyunstudyosu/enums/GameRequest.as`, `Client/snal.official.swf/scripts/com/oyunstudyosu/enums/GameResponse.as`.)
- **Contract status**: **Undefined on client** in this repo; any server payload may be ignored if no listener is registered.

## `baninfo`
- **Consumer**: `ReportPanel.onResponse` (`Client/Panel/1449237199236-23.4.swf/scripts/org/oyunstudyosu/sanalika/panels/report/ReportPanel.as`).
- **Required keys**:
  - `banCount` (int)
  - `nextBanMin` (int, minutes)
- **Optional keys**:
  - `banStatus` (bool/flag) — if present, panel shows “already banned” alert and closes.
  - `expireSecond` (ms, number) — divided by 1000 to render remaining time.
- **Example**:
  ```json
  {"banCount":1,"nextBanMin":10,"banStatus":false}
  ```

## `complaintlist`
- **Consumer**: `ComplaintPanel.complaintListResponse` (`Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as`).
- **Required keys**:
  - `complaints` (array) — if missing, UI shows error + retries.
- **Each complaint item uses**:
  - `id` (number)
  - `message` (string)
  - `comment` (string)
  - `reporterAvatarID` (string)
  - `reportedAvatarID` (string)
  - `isPervert` (int)
  - `banCount` (int)
  - `nextBanMin` (int)
- **Example**:
  ```json
  {"complaints":[{"id":123,"message":"msg","comment":"comment","reporterAvatarID":"42","reportedAvatarID":"17","isPervert":0,"banCount":0,"nextBanMin":0}]}
  ```

## `complaintaction`
- **Consumer**: `ComplaintPanel.moveNext` (`Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as`).
- **Required keys**: none; handler only checks `errorCode`.
- **Optional keys**:
  - `errorCode` (string) — if present, the panel refreshes the list instead of advancing.
- **Example**:
  ```json
  {"ok":true}
  ```

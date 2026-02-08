# ReportPanel (1449237199236-23.4.swf) analysis

Scope: `Client/Panel/1449237199236-23.4.swf/scripts/org/oyunstudyosu/sanalika/panels/report/ReportPanel.as`.

## UI flow

### Fields + labels
- **Chat context display**: `lblChat` (`sChat`) renders the last chat message (HTML text) provided via `data.params.lastMessage`.
- **Report description/labels**:
  - `lbl_reportTitle` → `reportPanelTitle`.
  - `lbl_reportDescription` → `reportInpDefaultText`.
  - `lbl_reportContext` → `reportKeyTitle`.
  - `lbl_describeReport` → `reportDescribeTitle`.
  - `txtIsPervert` → `reportPervert` (checkbox label).
- **Comment/message input**: `inpFrm` is converted to a non-language text field and populated with default text (`"Write your message!"`). Focus-in clears it; focus-out caches the value in `lastComment`. No explicit length or emptiness validation is performed in this class.
- **Ban info text**: `infoBan` shows either `avatarWarning` (first-time warning) or `avatarNextBan` + `nextBanMin` (minutes). Toggling the pervert checkbox changes this copy to `reportPervertWarning` or `reportOneMonthMute` depending on `banCount`.

### Buttons and actions
- **Send report** (`btnSend`, RedButton):
  - Label is `avatarBan` when the viewer has `AvatarPermission.CARD_SECURITY`; otherwise `avatarReport`.
  - On click, sanitizes `lastComment`, appends it to `reportData`, and sends `RequestDataKey.REPORT`.
  - Removes click listeners for both `btnSend` and `btnBlockUser` after sending (no re-enable logic shown).
- **Block user** (`btnBlockUser`, YellowButton): calls `avatarModel.blockUser(avatarId)` and closes the panel.
- **Close** (`btnClose`): closes panel via `closeClicked` → `close()`.

### Validation / error states
- **Client-side sanitization**: before sending, the comment string strips HTML-like tags and single quotes. There is no minimum/maximum length check and no empty-string guard in `onReportUser`.
- **Baninfo error state**: if `banStatus` is present, the panel shows an info alert (`reportAlreadyBanned` + remaining time) and closes immediately without rendering the report UI.
- **Report response error states**:
  - `ALREADY_REPORTED` → show `reportAlreadyReported` and close.
  - Any other `errorCode` → show `preReportError` + `reportProblemDescription` and close.

## EXACT command usage

### `baninfo`
- **Where it is requested**: `ReportPanel.init()` sends `RequestDataKey.AVATAR_BANINFO` with parameter key `avatarID` from `data.params.avatarId`.
- **Exact call**: `requestData(RequestDataKey.AVATAR_BANINFO, { "avatarID": this.avatarId }, this.onResponse)`.
- **Handler**: `onResponse` is the callback registered for the `baninfo` request; it interprets `banStatus`, `banCount`, `expireSecond`, and `nextBanMin`.

### `report`
- **Where it is sent**: `ReportPanel.onReportUser()` calls `requestData(RequestDataKey.REPORT, this.reportData, this.onReportResponse)`.
- **Exact param keys (reportData)**:
  - `reportedAvatarID` (from `data.params.avatarId`)
  - `message` (from `data.params.lastMessage`)
  - `isPervert` (0/1; checkbox)
  - `comment` (sanitized `lastComment`)
- **Handler**: `onReportResponse` processes the report response and shows success/failure alerts before closing the panel.

## Server response expectations + `nextRequest`

### `baninfo` response expectations
`onResponse` expects:
- `banStatus` (presence means already banned → close panel)
- `banCount` (0 → show warning, >0 → show next ban timer)
- `expireSecond` (used to compute remaining ban time when `banStatus` exists)
- `nextBanMin` (used to compute `avatarNextBan` message)

### `report` response expectations
`onReportResponse` checks:
- `errorCode == "ALREADY_REPORTED"` → show `reportAlreadyReported` and close.
- Any other `errorCode` → show `preReportError` + `reportProblemDescription` and close.
- Otherwise success messaging differs based on `CARD_SECURITY` permission (`reportCompleteKnight` vs `reportReceived/reportReceivedDescription`).

### `nextRequest` usage
- This panel does **not** read `nextRequest` or manage cooldown timers itself.
- Any rate-limiting or `nextRequest` throttling is expected to be handled globally by `ServiceModel` in the core client (outside this panel SWF). There are no UI timers or disabled state toggles within `ReportPanel` beyond removing click handlers after submission.

## Dependencies + required init steps
- **Panel data contract**: `init()` requires `data.params.avatarId` and `data.params.lastMessage` to be populated before the panel is opened.
- **Global singletons via `Connectr`**:
  - `Connectr.instance.serviceModel` for `baninfo` and `report` requests.
  - `Connectr.instance.avatarModel` for permissions and blocking.
  - `Connectr.instance.gameModel.language` for Arabic input handling.
- **Localization**: UI labels and descriptions are pulled via `$(...)` keys; `TextFieldManager`/`ArabicInputManager` is used to configure text fields for Arabic locales.
- **Dragger**: `mcDragger` is assigned to `dragHandler`, enabling the panel’s drag-to-move behavior through the base `Panel` class implementation.

## Room/sourceRoom assumptions
- There is **no** explicit `roomKey`, `roomId`, or `sourceRoom` usage in this panel. The report is bound only to the provided `avatarId` + `lastMessage` and the current user’s permissions. The panel does not attach room metadata to the request payload on its own.

## Backend requirements (minimal responses)

### `baninfo` response (minimum viable for panel render)
To render and proceed:
- `banCount` (number) → determines initial `infoBan` copy.
- `nextBanMin` (number) → required when `banCount > 0` to show time until next ban.
Optional fields:
- `banStatus` (truthy value) → triggers “already banned” alert and immediate close.
- `expireSecond` (ms) → used with `banStatus` to show remaining time.

### `report` response (minimum viable for success/close)
To resolve the send flow:
- `errorCode` absent/falsey → treated as success.
- If error occurs, the UI expects either:
  - `errorCode == "ALREADY_REPORTED"` to show `reportAlreadyReported`, or
  - Any other `errorCode` to show `preReportError` + `reportProblemDescription`.

The panel does not require additional payload fields beyond these checks to complete the flow.

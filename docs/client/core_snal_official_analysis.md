# Core snal.official.swf ActionScript analysis (Client/snal.official.swf/scripts)

This document is a documentation-only review of **all** ActionScript sources under `Client/snal.official.swf/scripts`. It focuses on architecture, SmartFox integration, panel/asset loading, permission controls, and the reporting workflow required by the task.

## Architecture map (modules + responsibilities)

### Core application container
- **`Sanalika` (root Sprite)** centralizes the core models and controllers (asset, game, room, avatar, layer, panel, service, module, domain, etc.). It exposes these as public fields for the rest of the client to use, acting as the app-wide service locator. (Class: `Sanalika`, fields: `assetModel`, `serviceModel`, `panelModel`, `moduleModel`, etc.)

### ServiceModel + SmartFox integration
- **`ServiceModel`** owns the SmartFox client (`SmartFox`), listens to SmartFox extension responses, and routes request/response traffic to callbacks and extension listeners. It sends `ExtensionRequest` packets through `requestData` (and `requestExtension` alias), and it centrally handles error codes and rate limiting (`FLOOD` → `nextRequest` throttle) before dispatching callbacks.
- **`ConnectCommand`** sets up the SmartFox connection and chooses chat server endpoints (`serverName` → `<server>-sfs.sanalika.com`) and ports, then dispatches progress events on connect success/failure.
- **`LoginCommand`** sends the SmartFox login request (token-based or guest) and activates `ServiceModel` on successful login.
- **`ServiceController`** listens to global SmartFox lifecycle events (logout, connection lost/retry/resume, moderator messages) and subscribes to core extension events like `restartServer`, `requestTimeout`, `reloadStart`, etc.

### PanelModel (UI panels)
- **`PanelModel.openPanel`** is the primary panel loader. It resolves a panel name to a SWF module via `ModuleModel.getPath(...)`, creates an `AssetRequest`, and asks `AssetModel` to load it; once loaded, the panel class is instantiated and `init()` is called.
- **`ModuleModel`** converts panel names into module paths using a version map loaded at runtime (from `VersionModel`). For panels, it uses the `/dynamic/panels{qs}/{key}.swf` pattern (where `{key}` comes from the version map).
- **`VersionModel`** loads the Base64-encoded version file and initializes `ModuleModel` with the runtime map; this is where specific SWF filenames (such as `1449237199236-23.4.swf`) would be resolved, but those filenames are not embedded in this repository’s ActionScript sources.

### AssetModel (SWF/PNG loader)
- **`AssetModel`** manages queueing and loading of SWF/PNG assets, with an allowlist of module types (including panels and extensions). It loads via `Loader`/`BinaryDataLoader` and uses a `LoaderContext` with `allowCodeImport=false` for safety.

### Permission model
- **Permissions/roles** are modeled by numeric permissions (e.g., moderator) in `AvatarPermission` and are checked at runtime via `permission.check(...)` (example: walkable admin-only cells).
- **Role/user variables** are communicated via user variables (e.g., `CharacterVariable.ROLE`) and room variables in `RoomVariable`.

## Networking contract inventory

### ExtensionRequest command inventory
The table below lists **every command** invoked through `ServiceModel.requestData` / `requestExtension` across the ActionScript sources under `Client/snal.official.swf/scripts`. For each command, the parameter keys shown are those present in the local call site. (Dynamic payloads are labeled as such.)

| Command | Params (keys) | Source (class → method) |
| --- | --- | --- |
| `init` | *(none)* | `Sanalika.initialize` |
| `teleport` | `roomKey` | `Sanalika.testStreet`, `TeleportProperty.execute`, `Teleportation.onTeleport` |
| `roommessage` (`RequestDataKey.ROOM_MESSAGE`) | `message` | `BusinessMessage.sendOrOkClicked` |
| `orderlist` | *(none)* | `BusinessMenu.init` |
| `securitykey` (`RequestDataKey.SECURITY_KEY`) | `key`, `id` | `SecurityKeyView.sendKey` |
| *(dynamic)* | `param1.sn`, `param1.requestData` | `SecurityKeyView.securityKeyResponse` (passes server-provided `sn` + `requestData`) |
| `flatsettings` (`RequestDataKey.ROOM_SETTINGS`) | *(none)* | `RoomChangePasswordView.added` |
| `flatpassword` (`RequestDataKey.ROOM_CHANGE_PASSWORD`) | `password`, `vip`, `plus18`, `notVisitor` | `RoomChangePasswordView.sendKey` |
| `flatpassword` (`RequestDataKey.ROOM_CHANGE_PASSWORD`) | `password` ("-1" reset) | `RoomChangePasswordView.resetClicked` |
| `usechatballoon` (`RequestDataKey.USE_CHAT_BALLOON`) | `id` | `Hud.setWhisperMode` (reset to default) |
| `messagedetails` | `groupID` | `PrivateChatController.groupMessagesRequest` |
| `privatechatlist` | *(none)* | `PrivateChatController.groupListRequest` |
| `privatechatdeletegroup` | `groupID` | `PrivateChatModel.removeGroup` |
| `config` | *(none)* | `ConfigCommand.execute` |
| `barterresponse` | `barterID`, `response` | `BarterController.barterRequestAnswer` |
| `barterrequest` | `avatarID` | `BarterController.startBarterRequest` |
| `bartercancel` | `barterID` | `BarterController.cancelBarterRequest` |
| `drop` | `type` | `DropController.collect` ("COLLECT") |
| `usehanditem` | `id` | `TransferController.transferResult` (reset) |
| `transferresponse` | *(dynamic object)* | `TransferController.transferConfirmResponse` (reuses `lastTransferReceiveData`) |
| `giftcheckexchange` | `id` | `TransferController.checkResponse` |
| `transferrequest` | `clip`, `id`, `quantity`, `avatarID` | `TransferController.transferQuantityResponse` |
| `usehousedoor` | `flatID`, `password`, `avatarID` | `DoorModel.useHouseDoor` |
| `removeavatarrestriction` | `cmd`, `avatarID` | `RestrictedController.removeRestrictedRequest` |
| `questaction` | `id` | `QuestController.checkQuestItems` (collect step) |
| `questlist` | `showDetail` | `QuestController.getQuestList` |
| `debugcommand` | `params` | `DebugCommand.onDebugCommand`, `DebugModel.onDebugCommand` |
| `whisper` | `message`, `receiver` | `ChatController.send` |
| `buddylist` | *(none)* | `BuddyController` constructor |
| `buddyrespondinvitelocation` | `avatarID`, `response` | `BuddyController.buddyInviteResponse` (confirm callback) |
| `buddyacceptinvitegame` | `avatarID`, `game`, `key` | `BuddyController.buddyInviteGameResponse` (confirm callback) |
| `buddyinvitelocation` | `avatarID` | `BuddyController.buddyInviteLocationRequest` |
| `buddylocate` | `avatarID` | `BuddyController.buddyLocateRequest` |
| `diamondtransferresponse` | `diamondTransferID`, `response` | `BuddyController.transferConfirmResponse` |
| `diamondtransferrequest` | `avatarID`, `quantity` | `BuddyController.sendDiamondQuantityResponse` |
| `addbuddy` | `avatarID` | `BuddyController.addFriendRequest` |
| `changemood` | `mood` | `BuddyController.moodChangeRequest` |
| `changestatusmessage` | `message` | `BuddyController.statusMessageChangeRequest` |
| `changebuddyrating` | `avatarID`, `rating` | `BuddyController.changeRelationRequest` |
| `addbuddyresponse` | `avatarID`, `response` | `BuddyController.friendRequestAccept/Rejected` |
| `removebuddy` | `avatarID` | `BuddyController.removeBuddyConfirm/Request` |
| `farmimplantation` | `id`, `itemID` | `FarmModel.farmImplant` |
| `walkfinalrequest` | *(none)* | `WalkModel.walkTimerComplete` |
| `matchmakingCancel` | *(none)* | `MatchmakingModel.cancel` |
| `usechatballoon` | `id` | `HudModel.changeChatColorRequest` |
| `walkrequest` | `x`, `y`, `door` | `Character.walkRequest` |
| `partyIsland.leave` | *(none)* | `IslandServiceComponent.leaveGame` |
| `partyIsland.rollDice` | *(none)* | `IslandSceneHudComponent.onDiceButtonClick` |
| `dropthrowaction` | `type`, `xTarget`, `yTarget` | `JoystickController.on_mouseUp` |
| `roomjoincomplete` | *(none)* | `SceneProcessDataComponent` (after scene ready) |
| `avatarsalescollect` | `id` | `SolariumPanelProperty`, `ShopPanelProperty`, `FlatSponsorPanelProperty`, `NickChangePanelProperty` |
| `useobjectdoor` | `id` | `FlatEnterProperty.execute` |
| `farmgather` | `id` | `FarmProperty.execute` (harvest) |
| `farmclean` | `id` | `FarmProperty.execute` (clean) |
| `campaignquest` | `command`, `id` | `GiftOnceProperty.execute` ("botGift") |
| `usedoor` | `key`, `type` | `PassageProperty.execute`, `FlatExitProperty.execute` |
| `exchangediamond` | `diamondQuantity` | `ExchangeProperty.exhangeQuantityResponse` |
| `gatheritemsearch` | `id` | `GatheringProperty.execute` |
| `gatheritemcollect` | *(none)* | `GatheringProperty.itemCollect` |
| `changeobjectframe` | `id` | `FrameProperty.execute`, `GridSealingProperty.execute` |
| `ping` | *(none)* | `AvatarController.ping` |
| `changeobjectlock` | `id` | `EntryVo.lockChange` |
| `startroomvideo` | `videoUrl` | `YoutubeScreenProperty` (watch click) |
| `randomwheel` | `command`, `id` | `AdAirship.adClicked` ("play", 405) |
| `flatpurchase` | `shopID`, `objectID`, `items` | `PurchaseController` (flat purchase) |
| `purchase` | `shopID`, `objectID`, `items` | `PurchaseController` (standard purchase) |

### Event handlers (extensionResponse + SFSEvent)
- **Extension responses**: `ServiceModel` listens for the SmartFox `extensionResponse` event and routes payloads by `cmd` and callback list (including error handling and rate-limit updates).
- **SmartFox event handlers**:
  - Connection events: `ConnectCommand` (`connection`, `connectionResume`).
  - Login events: `LoginCommand` (`login`, `loginError`).
  - Connection lifecycle / moderator messages: `ServiceController` (`logout`, `connectionLost`, `connectionRetry`, `connectionResume`, `moderatorMessage`).
  - Public chat messages: `ChatController` listens for `publicMessage`.
  - Room join lifecycle: `RoomController` listens for `roomJoin`, `roomJoinError`, `userEnterRoom`, `userExitRoom`.
  - Concert user exit: `ConcertModel` listens for `userExitRoom` while media is active.

### Constants/enums for command names + room/user variables
- **Request/response command strings** for extensions are consolidated in `RequestDataKey` (e.g., `REPORT`, `AVATAR_BANINFO`) and `GameRequest`/`GameResponse` (e.g., `PREREPORT`, `cmd2user`).
- **Room variables**: `RoomVariable` defines room metadata like `roomKey`, `title`, `width`, `height`, etc.
- **User variables**: `CharacterVariable` defines user variable keys like `roles`, `position`, `avatarName`, `smiley`, and more.

## Security/permissions
- **Role/permission gating**: Core movement and interaction checks are gated by permissions (e.g., admin-only cells require `AvatarPermission.MODERATOR`).
- **Guest restrictions**: Server responses can reject guests (`GUEST_NOT_ALLOWED`), and the client opens a `GuestPanel` in that case.
- **Explicit client-side guest checks in reporting entry points**: Report buttons only open the report panel when `guest` is false (e.g., chat balloons and room message tips).
- **Owner/moderator-only interactions**: Object lock/frame changes and certain room interactions are gated by moderator permissions (permission 20) or room ownership.

## Reporting system focus (required)

### End-to-end call chain (current repository scope)
- **ChatHistoryPanel** is opened from the HUD model via `PanelModel.openPanel` (panel name `ChatHistoryPanel`).
- **ReportPanel** is opened by multiple in-world UI entry points, each passing `avatarId` and `lastMessage` as panel parameters:
  - Speech bubble report button (`SpeechBalloon.reportClicked`).
  - Business message panel report button (`BusinessMessage.reportButtonClicked`).
  - User room message tip report button (`UserRoomMessage.clickReport`).
- **Panel creation & SWF load**: All report panel requests flow through `PanelModel.openPanel`, which loads a SWF module using `ModuleModel.getPath(name, ModuleType.PANEL)` and then instantiates the `ReportPanel` class when it is present in the loaded SWF.

> **Call chain requirement mapping:** the local code confirms that report actions open `ReportPanel` via `PanelModel.openPanel`, but the `ChatHistoryPanel.repportButtonClicked` method and `ReportPanel.init` method are not present in this repository’s ActionScript sources. Those are expected to live in external panel SWFs loaded at runtime.

### Command strings, parameter keys, and validation (reporting-specific)
- **Command strings**:
  - `baninfo` (RequestDataKey.AVATAR_BANINFO).
  - `report` (RequestDataKey.REPORT).
- **Panel parameters used to build report requests**: `avatarId`, `lastMessage` (passed into `ReportPanel` by the entry points above).
- **Guest validation**: report entry points refuse to open `ReportPanel` for guests (`!Sanalika.instance.avatarModel.guest`).

### Report panel SWF resolution (1449237199236-23.4.swf)
- Report panel SWFs are resolved via **`ModuleModel.getPath(name, ModuleType.PANEL)`** and are sourced from the runtime version map loaded by `VersionModel`. That is where an entry like `ReportPanel=1449237199236-23.4` would map to `/dynamic/panels.../1449237199236-23.4.swf`, but the actual key/value mapping lives in the version file, not in this repo.
- **Trigger class** for report panel loading: `PanelModel.openPanel` is the class that initiates the SWF load whenever a `PanelVO` with `name="ReportPanel"` is opened.

### References to report-related panel SWFs
No references to the following SWF script paths exist in the ActionScript sources under `Client/snal.official.swf/scripts`:
- `/Client/Panel/PNCMP923.2.swf/scripts` (reports inbox)
- `/Client/Panel/1449237199236-23.4.swf/scripts` (create report)
- `/Client/Panel/PRFP.57/scripts` (profile moderation actions)

Given the architecture, these panels are expected to be loaded dynamically via `PanelModel` + `ModuleModel` mappings rather than referenced directly in the core ActionScript bundle.

## Notes / verification scope
- This analysis is based on a scan of all `.as` files under `Client/snal.official.swf/scripts`. All `requestData` / `requestExtension` call sites found there are enumerated above.

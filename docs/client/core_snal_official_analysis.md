# Core snal.official.swf ActionScript analysis (Client/snal.official.swf/scripts)

This document is a documentation-only review of **all** ActionScript sources under `Client/snal.official.swf/scripts`. It focuses on architecture, SmartFox integration, panel/asset loading, permission controls, and the reporting workflow required by the task.

## Architecture map (modules + responsibilities)

### Core application container
- **`Sanalika` (root Sprite)** centralizes the core models and controllers (asset, game, room, avatar, layer, panel, service, module, domain, etc.). It exposes these as public fields for the rest of the client to use, acting as the app-wide service locator. (Class: `Sanalika`, fields: `assetModel`, `serviceModel`, `panelModel`, `moduleModel`, etc.)【F:Sanalika.as†L149-L199】

### ServiceModel + SmartFox integration
- **`ServiceModel`** owns the SmartFox client (`SmartFox`), listens to SmartFox extension responses, and routes request/response traffic to callbacks and extension listeners. It sends `ExtensionRequest` packets through `requestData` (and `requestExtension` alias), and it centrally handles error codes and rate limiting (`FLOOD` → `nextRequest` throttle) before dispatching callbacks.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L200-L299】
- **`ConnectCommand`** sets up the SmartFox connection and chooses chat server endpoints (`serverName` → `<server>-sfs.sanalika.com`) and ports, then dispatches progress events on connect success/failure.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/commands/ConnectCommand.as†L14-L64】
- **`LoginCommand`** sends the SmartFox login request (token-based or guest) and activates `ServiceModel` on successful login.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/commands/LoginCommand.as†L19-L120】
- **`ServiceController`** listens to global SmartFox lifecycle events (logout, connection lost/retry/resume, moderator messages) and subscribes to core extension events like `restartServer`, `requestTimeout`, `reloadStart`, etc.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceController.as†L20-L69】

### PanelModel (UI panels)
- **`PanelModel.openPanel`** is the primary panel loader. It resolves a panel name to a SWF module via `ModuleModel.getPath(...)`, creates an `AssetRequest`, and asks `AssetModel` to load it; once loaded, the panel class is instantiated and `init()` is called.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/PanelModel.as†L199-L279】
- **`ModuleModel`** converts panel names into module paths using a version map loaded at runtime (from `VersionModel`). For panels, it uses the `/dynamic/panels{qs}/{key}.swf` pattern (where `{key}` comes from the version map).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/ModuleModel.as†L27-L81】
- **`VersionModel`** loads the Base64-encoded version file and initializes `ModuleModel` with the runtime map; this is where specific SWF filenames (such as `1449237199236-23.4.swf`) would be resolved, but those filenames are not embedded in this repository’s ActionScript sources.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/VersionModel.as†L17-L68】

### AssetModel (SWF/PNG loader)
- **`AssetModel`** manages queueing and loading of SWF/PNG assets, with an allowlist of module types (including panels and extensions). It loads via `Loader`/`BinaryDataLoader` and uses a `LoaderContext` with `allowCodeImport=false` for safety.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/assets/AssetModel.as†L43-L93】

### Permission model
- **Permissions/roles** are modeled by numeric permissions (e.g., moderator) in `AvatarPermission` and are checked at runtime via `permission.check(...)` (example: walkable admin-only cells).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/AvatarPermission.as†L1-L56】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/engine/core/Cell.as†L157-L173】
- **Role/user variables** are communicated via user variables (e.g., `CharacterVariable.ROLE`) and room variables in `RoomVariable`.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/CharacterVariable.as†L1-L33】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/RoomVariable.as†L1-L23】

## Networking contract inventory

### ExtensionRequest command inventory
The table below lists **every command** invoked through `ServiceModel.requestData` / `requestExtension` across the ActionScript sources under `Client/snal.official.swf/scripts`. For each command, the parameter keys shown are those present in the local call site. (Dynamic payloads are labeled as such.)

| Command | Params (keys) | Source (class → method) |
| --- | --- | --- |
| `init` | *(none)* | `Sanalika.initialize`【F:Sanalika.as†L552-L555】 |
| `teleport` | `roomKey` | `Sanalika.testStreet`, `TeleportProperty.execute`, `Teleportation.onTeleport`【F:Sanalika.as†L547-L550】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/TeleportProperty.as†L12-L17】【F:Client/snal.official.swf/scripts/extensions/admin/Teleportation.as†L28-L35】 |
| `roommessage` (`RequestDataKey.ROOM_MESSAGE`) | `message` | `BusinessMessage.sendOrOkClicked`【F:Client/snal.official.swf/scripts/org/oyunstudyosu/business/BusinessMessage.as†L190-L208】 |
| `orderlist` | *(none)* | `BusinessMenu.init`【F:Client/snal.official.swf/scripts/org/oyunstudyosu/business/BusinessMenu.as†L88-L99】 |
| `securitykey` (`RequestDataKey.SECURITY_KEY`) | `key`, `id` | `SecurityKeyView.sendKey`【F:Client/snal.official.swf/scripts/org/oyunstudyosu/alert/views/SecurityKeyView.as†L174-L181】 |
| *(dynamic)* | `param1.sn`, `param1.requestData` | `SecurityKeyView.securityKeyResponse` (passes server-provided `sn` + `requestData`)【F:Client/snal.official.swf/scripts/org/oyunstudyosu/alert/views/SecurityKeyView.as†L183-L189】 |
| `flatsettings` (`RequestDataKey.ROOM_SETTINGS`) | *(none)* | `RoomChangePasswordView.added`【F:Client/snal.official.swf/scripts/org/oyunstudyosu/alert/views/RoomChangePasswordView.as†L120-L133】 |
| `flatpassword` (`RequestDataKey.ROOM_CHANGE_PASSWORD`) | `password`, `vip`, `plus18`, `notVisitor` | `RoomChangePasswordView.sendKey`【F:Client/snal.official.swf/scripts/org/oyunstudyosu/alert/views/RoomChangePasswordView.as†L293-L300】 |
| `flatpassword` (`RequestDataKey.ROOM_CHANGE_PASSWORD`) | `password` ("-1" reset) | `RoomChangePasswordView.resetClicked`【F:Client/snal.official.swf/scripts/org/oyunstudyosu/alert/views/RoomChangePasswordView.as†L303-L306】 |
| `usechatballoon` (`RequestDataKey.USE_CHAT_BALLOON`) | `id` | `Hud.setWhisperMode` (reset to default)【F:Client/snal.official.swf/scripts/org/oyunstudyosu/components/hud/Hud.as†L318-L324】 |
| `messagedetails` | `groupID` | `PrivateChatController.groupMessagesRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/privatechat/PrivateChatController.as†L115-L119】 |
| `privatechatlist` | *(none)* | `PrivateChatController.groupListRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/privatechat/PrivateChatController.as†L147-L151】 |
| `privatechatdeletegroup` | `groupID` | `PrivateChatModel.removeGroup`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/privatechat/PrivateChatModel.as†L45-L52】 |
| `config` | *(none)* | `ConfigCommand.execute`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/commands/ConfigCommand.as†L21-L24】 |
| `barterresponse` | `barterID`, `response` | `BarterController.barterRequestAnswer`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/barter/BarterController.as†L66-L80】 |
| `barterrequest` | `avatarID` | `BarterController.startBarterRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/barter/BarterController.as†L85-L88】 |
| `bartercancel` | `barterID` | `BarterController.cancelBarterRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/barter/BarterController.as†L90-L95】 |
| `drop` | `type` | `DropController.collect` ("COLLECT")【F:Client/snal.official.swf/scripts/com/oyunstudyosu/drop/DropController.as†L70-L91】 |
| `usehanditem` | `id` | `TransferController.transferResult` (reset)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/transfer/TransferController.as†L83-L101】 |
| `transferresponse` | *(dynamic object)* | `TransferController.transferConfirmResponse` (reuses `lastTransferReceiveData`)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/transfer/TransferController.as†L167-L189】 |
| `giftcheckexchange` | `id` | `TransferController.checkResponse`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/transfer/TransferController.as†L314-L320】 |
| `transferrequest` | `clip`, `id`, `quantity`, `avatarID` | `TransferController.transferQuantityResponse`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/transfer/TransferController.as†L405-L414】 |
| `usehousedoor` | `flatID`, `password`, `avatarID` | `DoorModel.useHouseDoor`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/door/DoorModel.as†L82-L91】 |
| `removeavatarrestriction` | `cmd`, `avatarID` | `RestrictedController.removeRestrictedRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/restricted/RestrictedController.as†L25-L30】 |
| `questaction` | `id` | `QuestController.checkQuestItems` (collect step)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/quest/QuestController.as†L96-L113】 |
| `questlist` | `showDetail` | `QuestController.getQuestList`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/quest/QuestController.as†L228-L233】 |
| `debugcommand` | `params` | `DebugCommand.onDebugCommand`, `DebugModel.onDebugCommand`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/debug/DebugCommand.as†L21-L24】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/debug/DebugModel.as†L50-L53】 |
| `whisper` | `message`, `receiver` | `ChatController.send`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/chat/ChatController.as†L320-L329】 |
| `buddylist` | *(none)* | `BuddyController` constructor【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L50-L67】 |
| `buddyrespondinvitelocation` | `avatarID`, `response` | `BuddyController.buddyInviteResponse` (confirm callback)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L76-L91】 |
| `buddyacceptinvitegame` | `avatarID`, `game`, `key` | `BuddyController.buddyInviteGameResponse` (confirm callback)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L127-L145】 |
| `buddyinvitelocation` | `avatarID` | `BuddyController.buddyInviteLocationRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L153-L165】 |
| `buddylocate` | `avatarID` | `BuddyController.buddyLocateRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L169-L177】 |
| `diamondtransferresponse` | `diamondTransferID`, `response` | `BuddyController.transferConfirmResponse`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L320-L339】 |
| `diamondtransferrequest` | `avatarID`, `quantity` | `BuddyController.sendDiamondQuantityResponse`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L343-L351】 |
| `addbuddy` | `avatarID` | `BuddyController.addFriendRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L406-L409】 |
| `changemood` | `mood` | `BuddyController.moodChangeRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L411-L414】 |
| `changestatusmessage` | `message` | `BuddyController.statusMessageChangeRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L416-L419】 |
| `changebuddyrating` | `avatarID`, `rating` | `BuddyController.changeRelationRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L421-L430】 |
| `addbuddyresponse` | `avatarID`, `response` | `BuddyController.friendRequestAccept/Rejected`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L433-L448】 |
| `removebuddy` | `avatarID` | `BuddyController.removeBuddyConfirm/Request`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/buddy/BuddyController.as†L460-L481】 |
| `farmimplantation` | `id`, `itemID` | `FarmModel.farmImplant`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/FarmModel.as†L21-L29】 |
| `walkfinalrequest` | *(none)* | `WalkModel.walkTimerComplete`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/WalkModel.as†L27-L30】 |
| `matchmakingCancel` | *(none)* | `MatchmakingModel.cancel`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/MatchmakingModel.as†L24-L27】 |
| `usechatballoon` | `id` | `HudModel.changeChatColorRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/HudModel.as†L1286-L1291】 |
| `walkrequest` | `x`, `y`, `door` | `Character.walkRequest`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/engine/character/Character.as†L1393-L1410】 |
| `partyIsland.leave` | *(none)* | `IslandServiceComponent.leaveGame`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/game/partyisland/components/IslandServiceComponent.as†L227-L230】 |
| `partyIsland.rollDice` | *(none)* | `IslandSceneHudComponent.onDiceButtonClick`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/game/partyisland/components/IslandSceneHudComponent.as†L220-L224】 |
| `dropthrowaction` | `type`, `xTarget`, `yTarget` | `JoystickController.on_mouseUp`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/game/JoystickController.as†L80-L94】 |
| `roomjoincomplete` | *(none)* | `SceneProcessDataComponent` (after scene ready)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/engine/scene/components/SceneProcessDataComponent.as†L253-L255】 |
| `avatarsalescollect` | `id` | `SolariumPanelProperty`, `ShopPanelProperty`, `FlatSponsorPanelProperty`, `NickChangePanelProperty`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/SolariumPanelProperty.as†L21-L31】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/ShopPanelProperty.as†L21-L30】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/FlatSponsorPanelProperty.as†L21-L31】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/NickChangePanelProperty.as†L21-L31】 |
| `useobjectdoor` | `id` | `FlatEnterProperty.execute`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/FlatEnterProperty.as†L27-L36】 |
| `farmgather` | `id` | `FarmProperty.execute` (harvest)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/FarmProperty.as†L103-L121】 |
| `farmclean` | `id` | `FarmProperty.execute` (clean)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/FarmProperty.as†L122-L125】 |
| `campaignquest` | `command`, `id` | `GiftOnceProperty.execute` ("botGift")【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/GiftOnceProperty.as†L25-L34】 |
| `usedoor` | `key`, `type` | `PassageProperty.execute`, `FlatExitProperty.execute`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/PassageProperty.as†L12-L24】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/FlatExitProperty.as†L12-L20】 |
| `exchangediamond` | `diamondQuantity` | `ExchangeProperty.exhangeQuantityResponse`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/ExchangeProperty.as†L35-L40】 |
| `gatheritemsearch` | `id` | `GatheringProperty.execute`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/GatheringProperty.as†L40-L60】 |
| `gatheritemcollect` | *(none)* | `GatheringProperty.itemCollect`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/GatheringProperty.as†L110-L115】 |
| `changeobjectframe` | `id` | `FrameProperty.execute`, `GridSealingProperty.execute`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/FrameProperty.as†L25-L33】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/GridSealingProperty.as†L28-L34】 |
| `ping` | *(none)* | `AvatarController.ping`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/avatar/AvatarController.as†L78-L81】 |
| `changeobjectlock` | `id` | `EntryVo.lockChange`【F:Client/snal.official.swf/scripts/com/oyunstudyosu/interactive/EntryVo.as†L375-L379】 |
| `startroomvideo` | `videoUrl` | `YoutubeScreenProperty` (watch click)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/map/property/YoutubeScreenProperty.as†L103-L109】 |
| `randomwheel` | `command`, `id` | `AdAirship.adClicked` ("play", 405)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/displayAd/AdAirship.as†L143-L152】 |
| `flatpurchase` | `shopID`, `objectID`, `items` | `PurchaseController` (flat purchase)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/controller/PurchaseController.as†L119-L125】 |
| `purchase` | `shopID`, `objectID`, `items` | `PurchaseController` (standard purchase)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/controller/PurchaseController.as†L127-L134】 |

### Event handlers (extensionResponse + SFSEvent)
- **Extension responses**: `ServiceModel` listens for the SmartFox `extensionResponse` event and routes payloads by `cmd` and callback list (including error handling and rate-limit updates).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L281-L357】
- **SmartFox event handlers**:
  - Connection events: `ConnectCommand` (`connection`, `connectionResume`).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/commands/ConnectCommand.as†L32-L56】
  - Login events: `LoginCommand` (`login`, `loginError`).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/commands/LoginCommand.as†L33-L47】
  - Connection lifecycle / moderator messages: `ServiceController` (`logout`, `connectionLost`, `connectionRetry`, `connectionResume`, `moderatorMessage`).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceController.as†L20-L46】
  - Public chat messages: `ChatController` listens for `publicMessage`.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/chat/ChatController.as†L45-L58】
  - Room join lifecycle: `RoomController` listens for `roomJoin`, `roomJoinError`, `userEnterRoom`, `userExitRoom`.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/room/RoomController.as†L46-L56】
  - Concert user exit: `ConcertModel` listens for `userExitRoom` while media is active.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/concert/ConcertModel.as†L147-L163】

### Constants/enums for command names + room/user variables
- **Request/response command strings** for extensions are consolidated in `RequestDataKey` (e.g., `REPORT`, `AVATAR_BANINFO`) and `GameRequest`/`GameResponse` (e.g., `PREREPORT`, `cmd2user`).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/RequestDataKey.as†L70-L84】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/RequestDataKey.as†L314-L361】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/GameRequest.as†L1-L40】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/GameResponse.as†L1-L40】
- **Room variables**: `RoomVariable` defines room metadata like `roomKey`, `title`, `width`, `height`, etc.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/RoomVariable.as†L1-L23】
- **User variables**: `CharacterVariable` defines user variable keys like `roles`, `position`, `avatarName`, `smiley`, and more.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/CharacterVariable.as†L1-L33】

## Security/permissions
- **Role/permission gating**: Core movement and interaction checks are gated by permissions (e.g., admin-only cells require `AvatarPermission.MODERATOR`).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/engine/core/Cell.as†L157-L173】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/AvatarPermission.as†L1-L56】
- **Guest restrictions**: Server responses can reject guests (`GUEST_NOT_ALLOWED`), and the client opens a `GuestPanel` in that case.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L318-L322】
- **Explicit client-side guest checks in reporting entry points**: Report buttons only open the report panel when `guest` is false (e.g., chat balloons and room message tips).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/chat/SpeechBalloon.as†L189-L208】【F:Client/snal.official.swf/scripts/extensions/notification/UserRoomMessage.as†L148-L163】
- **Owner/moderator-only interactions**: Object lock/frame changes and certain room interactions are gated by moderator permissions (permission 20) or room ownership.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/interactive/EntryVo.as†L386-L395】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/property/FrameProperty.as†L25-L33】

## Reporting system focus (required)

### End-to-end call chain (current repository scope)
- **ChatHistoryPanel** is opened from the HUD model via `PanelModel.openPanel` (panel name `ChatHistoryPanel`).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/HudModel.as†L1273-L1281】
- **ReportPanel** is opened by multiple in-world UI entry points, each passing `avatarId` and `lastMessage` as panel parameters:
  - Speech bubble report button (`SpeechBalloon.reportClicked`).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/chat/SpeechBalloon.as†L189-L208】
  - Business message panel report button (`BusinessMessage.reportButtonClicked`).【F:Client/snal.official.swf/scripts/org/oyunstudyosu/business/BusinessMessage.as†L173-L184】
  - User room message tip report button (`UserRoomMessage.clickReport`).【F:Client/snal.official.swf/scripts/extensions/notification/UserRoomMessage.as†L148-L163】
- **Panel creation & SWF load**: All report panel requests flow through `PanelModel.openPanel`, which loads a SWF module using `ModuleModel.getPath(name, ModuleType.PANEL)` and then instantiates the `ReportPanel` class when it is present in the loaded SWF.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/PanelModel.as†L199-L279】

> **Call chain requirement mapping:** the local code confirms that report actions open `ReportPanel` via `PanelModel.openPanel`, but the `ChatHistoryPanel.repportButtonClicked` method and `ReportPanel.init` method are not present in this repository’s ActionScript sources. Those are expected to live in external panel SWFs loaded at runtime.

### Command strings, parameter keys, and validation (reporting-specific)
- **Command strings**:
  - `baninfo` (RequestDataKey.AVATAR_BANINFO).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/RequestDataKey.as†L350-L361】
  - `report` (RequestDataKey.REPORT).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/enums/RequestDataKey.as†L74-L83】
- **Panel parameters used to build report requests**: `avatarId`, `lastMessage` (passed into `ReportPanel` by the entry points above).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/chat/SpeechBalloon.as†L189-L208】【F:Client/snal.official.swf/scripts/org/oyunstudyosu/business/BusinessMessage.as†L173-L184】【F:Client/snal.official.swf/scripts/extensions/notification/UserRoomMessage.as†L148-L163】
- **Guest validation**: report entry points refuse to open `ReportPanel` for guests (`!Sanalika.instance.avatarModel.guest`).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/chat/SpeechBalloon.as†L189-L205】【F:Client/snal.official.swf/scripts/extensions/notification/UserRoomMessage.as†L148-L162】

### Report panel SWF resolution (1449237199236-23.4.swf)
- Report panel SWFs are resolved via **`ModuleModel.getPath(name, ModuleType.PANEL)`** and are sourced from the runtime version map loaded by `VersionModel`. That is where an entry like `ReportPanel=1449237199236-23.4` would map to `/dynamic/panels.../1449237199236-23.4.swf`, but the actual key/value mapping lives in the version file, not in this repo.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/ModuleModel.as†L27-L81】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/VersionModel.as†L17-L68】
- **Trigger class** for report panel loading: `PanelModel.openPanel` is the class that initiates the SWF load whenever a `PanelVO` with `name="ReportPanel"` is opened.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/PanelModel.as†L199-L279】

### References to report-related panel SWFs
No references to the following SWF script paths exist in the ActionScript sources under `Client/snal.official.swf/scripts`:
- `/Client/Panel/PNCMP923.2.swf/scripts` (reports inbox)
- `/Client/Panel/1449237199236-23.4.swf/scripts` (create report)
- `/Client/Panel/PRFP.57/scripts` (profile moderation actions)

Given the architecture, these panels are expected to be loaded dynamically via `PanelModel` + `ModuleModel` mappings rather than referenced directly in the core ActionScript bundle.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/PanelModel.as†L199-L279】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/model/ModuleModel.as†L27-L81】

## Notes / verification scope
- This analysis is based on a scan of all `.as` files under `Client/snal.official.swf/scripts`. All `requestData` / `requestExtension` call sites found there are enumerated above.

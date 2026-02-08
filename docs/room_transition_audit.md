# Room Transition Audit

## Executive Summary
The backend currently builds door rendering data (`doors` room variable) from `RoomConfigRegistry` via `MapBuilder.buildRoomData`, but the registry resolves configs by exact room key (trim + lowercase) and only returns configured rooms; all other room keys fall back to an empty config. This means any runtime room name that does not exactly match a registered key will receive an empty `doors` list even if a config exists elsewhere. Room join handlers inject the `doors` room variable only if a `RoomState` is built (which itself is seeded from `MapBuilder`), so missing/incorrect config resolution leads to missing arrows in the client. (RoomConfigRegistry.java:18-36; InMemoryStore.java:554-575; OsBaseHandler.java:143-197; ServerEventHandler.java:105-132)

## Room Entry Flow (join → handlers → MapBuilder → room vars)
1. **Init path (street01 only)**: `InitHandler` hardcodes room payload and join to `street01`. It uses `MapBuilder.buildMapBase64()` and then joins the room by name, invoking `ensureMandatoryRoomVars`. (InitHandler.java:327-390)
2. **Room join event**: `ServerEventHandler.onUserJoinRoom` creates/gets `RoomState` and sets room variables (`doors`, `bots`, `grid`, `isInteractiveRoom`, etc.). (ServerEventHandler.java:105-132)
3. **RoomState construction**: `InMemoryStore.RoomState` calls `MapBuilder.buildRoomData(roomName)` to produce `doorsJson`, `botsJson`, map, and scene items. (InMemoryStore.java:564-575)
4. **Room vars injection**: `OsBaseHandler.ensureMandatoryRoomVars` adds `doors`/`bots`/`grid` room variables if missing, using the `RoomState` values. (OsBaseHandler.java:143-197)

## Door Rendering Contract
- **Rendering source**: The client’s arrow overlay is driven by the room variable `doors` (JSON string) inserted by `ServerEventHandler` and `ensureMandatoryRoomVars`. (ServerEventHandler.java:122-129; OsBaseHandler.java:170-177)
- **Schema**: `MapBuilder.buildDoorsResult` serializes each `DoorSpawn` as `{"key":"<id>","targetX":<int>,"targetY":<int>,"targetDir":<int>,"property":{"cn":"FlatExitProperty"}}`. (MapBuilder.java:158-201)
- **Implication**: If `doors` is empty/missing, the arrow is not rendered even if a door object exists in the SWF art.

## Door Routing Contract
- **Client command**: `UseDoorHandler` handles the `usedoor` request. It reads `data.key` as the door key and determines routing based on the current room’s `RoomConfig` and matching `DoorSpawn`. (UseDoorHandler.java:9-39)
- **Destination resolution**: Routing uses `DoorSpawn.getDestinationRoomKey()` when present; otherwise it logs `missing_destination` or `unknown_door`. (UseDoorHandler.java:31-57)
- **Room transition**: The backend attempts `getRoomByName(destKey)` and joins that room if present. (UseDoorHandler.java:43-52)
- **Room existence**: There is no dynamic room creation in this handler; if the destination room is not present in the SFS zone, the join fails (`room_not_found`). (UseDoorHandler.java:44-57)

## RoomConfigRegistry Wiring (explicit evidence)
- **Registered rooms**: The static block registers `street01`, `street05`, and `street02` only. (RoomConfigRegistry.java:18-22)
- **Config lookup**: `resolve(roomKey)` trims whitespace, defaults to `street01` if empty, lowercases the key, and performs an exact map lookup. (RoomConfigRegistry.java:26-35)
- **Normalization gaps**: There is no handling for instance suffixes or naming patterns (e.g., `street05#1`, `street05_2`, or group/zone prefixes). Any mismatch results in fallback config with empty `doors`. (RoomConfigRegistry.java:26-35)
- **Single source of truth**: `MapBuilder` uses `RoomConfigRegistry.resolve(...)` for map/bots/doors building, so this registry is the only config source for rendering data. (MapBuilder.java:48-88)

## Explaining street02: “door object exists but no arrow/routing”
- **Visual door vs. interactive door**: The SWF can contain a door object (art) independent of the backend `doors` room variable. If the backend supplies an empty `doors` list, the arrow overlay will not appear and clicking will not route. (ServerEventHandler.java:122-129; MapBuilder.java:158-201)
- **Likely cause**: If the room key used at runtime does not resolve to a registered config (e.g., instance suffix), `RoomConfigRegistry.resolve` returns fallback with `doors=[]`, so the arrow never appears. (RoomConfigRegistry.java:26-35)

## Explaining street05: “doors did not render”
- **Registry mismatch**: Rendering depends on `RoomConfigRegistry.resolve(roomKey)` producing a config. Any mismatch between runtime room key and registered key yields fallback with empty `doors`. (RoomConfigRegistry.java:26-35)
- **Injection path**: `doors` are only injected via `RoomState` → `ServerEventHandler`/`ensureMandatoryRoomVars`, so if the `RoomState` is constructed with a mismatched `roomName`, its `doorsJson` will be empty. (InMemoryStore.java:564-575; ServerEventHandler.java:122-129)
- **Implication**: Even if `buildStreet05()` exists, doors will not render unless the runtime room key exactly matches `street05` (lowercase). (RoomConfigRegistry.java:26-35)

## Correct Operating Model (requirements for consistent arrows + routing)
1. **Room key normalization** must map runtime room names (including instance suffixes) to the canonical config key before config lookup.
2. **Every room** that should render doors must be registered or generated by a config provider.
3. **Room join flow** must always inject the `doors` variable for that room (no default-only behavior), which requires a non-empty config resolve.
4. **Routing** should use the same normalized room key and per-room config to resolve destination keys; destination rooms must exist in the SFS zone or be created on demand.


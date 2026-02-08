# Backend MapBuilder Audit

## Executive Summary
The backend now resolves **room-specific configurations** via `RoomConfigRegistry` and `MapBuilder.buildRoomData`, which produces map XML, scene items, bots JSON, and doors JSON per room. This replaces the earlier single global layout by indexing configs on `roomKey`/room name, ensuring room layouts can diverge. A legacy fallback path is still present (but disabled by default) to preserve the old hardcoded layout if needed. (MapBuilder.java:39-67, 234-377; RoomConfigRegistry.java:16-133)

## Architecture Map
**Key classes and responsibilities**
- **`RoomConfigRegistry`**: Owns per-room configuration for furniture/bots/doors and resolves a `RoomConfig` for a given room key, defaulting to a safe empty config when missing. (RoomConfigRegistry.java:9-35, 44-133)
- **`RoomConfig` + spawn POJOs**: Define the shape of room configuration (`RoomConfig`, `FurnitureSpawn`, `BotSpawn`, `DoorSpawn`). (RoomConfig.java, FurnitureSpawn.java, BotSpawn.java, DoorSpawn.java)
- **`MapBuilder`**: Converts a `RoomConfig` into map XML, scene items, bots JSON, and doors JSON. Also logs `[ROOM_BUILD]` with counts. (MapBuilder.java:39-179, 379-445)
- **`InMemoryStore.RoomState`**: Caches per-room data; now uses `MapBuilder.buildRoomData(roomName)` to populate map/bots/doors/scene items. (InMemoryStore.java:564-575)
- **`UseDoorHandler` / `TeleportHandler`**: Resolve target rooms from request payloads and join SFS rooms by name. `UseDoorHandler` also logs `[ROOM_DOOR]`. (UseDoorHandler.java:10-32, TeleportHandler.java:10-42)
- **`OsBaseHandler.ensureMandatoryRoomVars`**: Sets room variables (roomKey, doors, bots, grid) from the room state. (OsBaseHandler.java:143-197)

## Room Identity Flow
1. **Room key source**: For door transitions, `UseDoorHandler` reads `roomKey` and `key` from the request, falling back to `MapBuilder.DEFAULT_ROOM_KEY`/`DEFAULT_DOOR_KEY` if absent. (UseDoorHandler.java:10-12)
2. **Room lookup + join**: The server joins the SFS room whose name equals the `roomKey`. (UseDoorHandler.java:19-26, TeleportHandler.java:18-24)
3. **Room variables**: Room variables such as `roomKey`, `doors`, `bots`, and `grid` are set using the per-room `RoomState`. (OsBaseHandler.java:143-197)
4. **Room payload**: Client payloads are built from the `RoomState` or, if needed, `MapBuilder.buildRoomPayload`. (UseDoorHandler.java:34-47, MapBuilder.java:25-28)

## Current Data Flow (Bots / Furniture / Doors)
- **Room config selection**: `RoomConfigRegistry.resolve(roomKey)` returns a `RoomConfig` or a safe empty config if missing. (RoomConfigRegistry.java:25-35)
- **Furniture / map**: `MapBuilder` iterates `RoomConfig.getFurniture()` to build map XML and scene items. (MapBuilder.java:81-109)
- **Bots**: `MapBuilder` builds bots JSON from `RoomConfig.getBots()`. (MapBuilder.java:156-179)
- **Doors**: `MapBuilder` builds doors JSON from `RoomConfig.getDoors()`. (MapBuilder.java:127-154)

## Root Causes (Legacy / Historical)
The previous issue of room layouts being identical stemmed from a single global map builder and room state seeding from those global lists. That old layout is still visible in the **legacy builder path**, which holds the hardcoded map/bot/door data. (MapBuilder.java:234-377)

## Risk / Edge Cases
- **Unknown room keys**: `RoomConfigRegistry` returns a safe empty config for unknown room keys. This is logged as `[ROOM_BUILD] ... source=fallback`. (RoomConfigRegistry.java:25-35, MapBuilder.java:39-67, 379-390)
- **Legacy fallback**: If `USE_LEGACY_FALLBACK` is toggled on, the old hardcoded layout will be used for missing configs. (MapBuilder.java:21, 39-54)
- **Room variable timing**: `ensureMandatoryRoomVars` only sets vars if missing, so stale variables can persist until a room is recreated or vars are explicitly updated. (OsBaseHandler.java:143-197)

## Logging / Observability
- **Room build logs**: `[ROOM_BUILD] roomKey=... furniture=... bots=... doors=... source=...` emitted during room state creation. (MapBuilder.java:39-67, 379-390)
- **Door transition logs**: `[ROOM_DOOR] from=... to=... doorId=... ok=... reason=...` emitted on door usage. (UseDoorHandler.java:31-32)

## Proposed Solution Overview (Implemented)
- Introduced `RoomConfigRegistry` and room-specific configs for `street01` and `street02`, decoupling rooms from a single static layout. (RoomConfigRegistry.java:18-133)
- Refactored `MapBuilder` and `RoomState` to use room-specific configs for map/bots/doors/scene items. (MapBuilder.java:39-179; InMemoryStore.java:564-575)
- Added structured logs to verify per-room separation. (MapBuilder.java:379-390; UseDoorHandler.java:31-32)

## Acceptance Criteria
- Room joins to `street01` and `street02` produce different coordinates for bots/furniture/doors (visible in logs and room variables).
- Unknown room keys default to a safe empty config with a warning log.
- Logs include room key and counts for bots, furniture, and doors.

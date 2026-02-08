# Room Configuration Design (Backend)

## Proposed Layout
```
Backend/
  RoomConfig.java
  FurnitureSpawn.java
  BotSpawn.java
  DoorSpawn.java
  RoomConfigRegistry.java
  MapBuilder.java (refactored to use RoomConfigRegistry)
  (optional future) roomconfigs/
    street01.json
    street02.json
```
**Notes**
- Initial implementation can keep configs in Java (static registry) for safety and quick iteration.
- Future: move configs to JSON under `Backend/roomconfigs/` and parse them in `RoomConfigRegistry`.

## Data Model (POJOs)
```java
class RoomConfig {
  String roomKey;
  String theme;        // map themes attribute
  int xOrigin;
  int yOrigin;
  List<FurnitureSpawn> furniture;
  List<BotSpawn> bots;
  List<DoorSpawn> doors;
}

class FurnitureSpawn {
  String type;   // "box" | "floor"
  String def;    // furniture id
  int x;
  int y;
  int z;
  int rotation;  // maps to scene item "dir"
}

class BotSpawn {
  String key;
  String name;
  int x;
  int y;
  int width;
  int height;
  int length;    // default 1
  String propertyCn; // "SimpleBotMessageProperty"
}

class DoorSpawn {
  String key;
  int targetX;
  int targetY;
  int targetDir;
  String propertyCn; // "FlatExitProperty"
  String destinationRoomKey;  // used for logging/validation
  String destinationDoorKey;  // optional
}
```

## MapBuilder Selection Flow
1. **Resolve room key**: from `room.getName()` or request `roomKey`.
2. **Fetch config**: `RoomConfigRegistry.get(roomKey)` returns a `RoomConfig` or a safe fallback.
3. **Build outputs**:
   - `buildMapXml(RoomConfig)` generates the `<map>` XML by iterating furniture list.
   - `buildSceneItems(RoomConfig)` generates `SFSArray` from furniture list.
   - `buildBotsJson(RoomConfig)` generates bot JSON from bots list.
   - `buildDoorsJson(RoomConfig)` generates doors JSON from doors list.
4. **Fallback**:
   - If the roomKey is unknown, return a minimal empty config and log a warning.
   - Keep a **legacy fallback** path that uses current MapBuilder hardcoded values if needed for transition.

## Logging Strategy
- **Room build** (MapBuilder / registry):
  - `[ROOM_BUILD] roomKey=... furniture=... bots=... doors=... source=config|fallback|legacy`
- **Door usage** (UseDoorHandler):
  - `[ROOM_DOOR] from=... to=... doorId=... ok=... reason=...`

These logs should be emitted with deterministic counts so that room separation is visible in server logs.

## Migration Plan
1. **Introduce new data model classes + registry** with static configs for `street01` and `street02`.
2. **Refactor MapBuilder** to use the registry for all build methods.
3. **Update RoomState initialization** to use MapBuilder room-specific builders with roomKey.
4. **Keep legacy fallback** for unconfigured rooms (existing hardcoded map/bots/doors).
5. **Iterate**: move static config data into JSON files once stable and validated.

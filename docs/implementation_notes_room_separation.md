# Implementation Notes: Room Separation

## Files Changed
- `Backend/MapBuilder.java`
- `Backend/InMemoryStore.java`
- `Backend/UseDoorHandler.java`

## Files Added
- `Backend/RoomConfigRegistry.java`
- `Backend/RoomConfig.java`
- `Backend/FurnitureSpawn.java`
- `Backend/BotSpawn.java`
- `Backend/DoorSpawn.java`

## How to Extend for `street03`
1. Add a new `RoomConfig` in `RoomConfigRegistry.buildStreet03()` with:
   - `List<FurnitureSpawn>` items and coordinates.
   - `List<BotSpawn>` items and coordinates.
   - `List<DoorSpawn>` entries (including destination room keys).
2. Register it in the static initializer:
   ```java
   register(buildStreet03());
   ```
3. Ensure the SFS room name matches `street03` or update mapping logic if different.

## How to Test (Backend-only)
1. Start the backend and observe logs.
2. Join `street01` and verify `[ROOM_BUILD]` log shows non-zero furniture/bots/doors and `source=config`.
3. Use a door to `street02` and verify `[ROOM_BUILD]` logs show **different counts/placements** (and `source=config`).
4. Use a door back to `street01` and confirm consistent logs.
5. Join an unknown roomKey and verify `[ROOM_BUILD]` logs `source=fallback` with zero counts.

## Verification Checklist (Phase 4)
- Join `street01` → logs show correct counts and `roomKey=street01`.
- Use door to `street02` → logs show different placements/counts, `roomKey=street02`.
- Go back to `street01` → consistent results.
- Unknown `roomKey` → fallback with warning in logs.

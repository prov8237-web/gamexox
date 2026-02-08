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

## Street01 Doors
Street01: Added 9 doors (`d1`..`d9`) mapping to `street02`..`street10`; coords are placeholders to be refined.

## Street01 Door Routing
- `d1` → `street02`
- `d2` → `street03`
- `d3` → `street04`
- `d4` → `street05`
- `d5` → `street06` (legacy coords preserved)
- `d6` → `street07`
- `d7` → `street08`
- `d8` → `street09`
- `d9` → `street10`

## Room Key Normalization & Aliases
- Room keys are normalized by trimming, lowercasing, and stripping instance suffixes (`#1`, `_2`, `-3`) before config lookup.
- Known aliases map runtime names to canonical keys (e.g., `1450281337501-10.5` → `street02`, `st01.1` → `street01`).

## Street05 Doors
Street05: Added 9 doors (`d1`..`d9`) mapping to `street01`..`street10`; coords are placeholders to be refined.

## Street05 Door Routing
- `d1` → `street01`
- `d2` → `street02`
- `d3` → `street03`
- `d4` → `street04`
- `d5` → `street06`
- `d6` → `street07`
- `d7` → `street08`
- `d8` → `street09`
- `d9` → `street10`

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

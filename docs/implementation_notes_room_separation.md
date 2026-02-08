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

## Additional Rooms with Doors (d1..d9)
- street02, street03, street04, street05, street07, street08, street09, street10, street11, street12, street13

## Door Mapping Rule (Default)
- `d1` → `street01`
- `d2` → `street02`
- `d3` → `street03`
- `d4` → `street04`
- `d5` → `street05` (street02 overrides to `street01`)
- `d6` → `street07`
- `d7` → `street08`
- `d8` → `street09`
- `d9` → `street10`

## Street05 Example Content
- Bots: florist01, ramadanSt1_5, ramadanPurpleLamp, ramadanPurpleLamp2, tribun, eylul, ramadanSt1_3, ramadanStars_5, securityBot3, ramadanPurpleLamp3
- Furniture: bayrak, bayrak_yari, cadde_agac_dilek, cadde_agac1, cadde_bank_3, cadde_bank_5, cadde_bank1_3, cadde_bank1_5, cadde_bank2_3, cadde_bank2_5, cadde_bebek_heykeli, cadde_cim_kisa, cadde_cim_kisa_5, cadde_cim_uzun, cadde_direk, cadde_durak_tabela, cadde_girilmez_tabela_5, cadde_kahvehane_kose, cadde_kisa_duvar_3, cadde_kisa_duvar_5, cadde_metro_tabela, cadde_reklam_tabela, cadde_uzun_duvar_3, cadde_uzun_duvar_5, cadde_yuvarlak_agac, cafe_market_cicek, cafe_market_cicek_yuvarlak01, cafe_market_cicek_yuvarlak02, Cd5Tabela1, Cd5Tabela3, Cd5Tabela4, cit_park_3, Clock, koltuk_1, koltuk_1_m, koltuk_3, koltuk_5, koltuk_7, koltuk_7_m, masa_1, masa_7, SaatKulesi, semsiye

## Verification Checklist
1) Join each listed room and confirm `[ROOM_CONFIG_RESOLVE] ... found=true source=config`, `[ROOM_BUILD] roomKey=<room> doors=9 source=config`, and `[DOORS_LIST] roomKey=<room> keys=d1..d9`.
2) In street05 confirm `[ROOM_BUILD]` shows increased `bots` and `furniture` counts.
3) Click at least 3 doors in street05 (`d1`, `d5`, `d9`) and confirm `[ROOM_DOOR]` logs + room transitions.

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

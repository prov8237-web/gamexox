# Room Transition Test Matrix

## Core Scenarios
1. **street01 → street02 → street01 return arrow**
   - Expect `[ROOM_BUILD] roomKey=street01 doors=9 source=config` and `[DOORS_LIST]` with `d1..d9`.
   - After routing to street02, expect `doors` room var to be set (arrow present) and a return door route to street01.

2. **street01 → street05 → street01 return arrow**
   - Validate `RoomConfigRegistry.resolve` for `street05` (normalized key matched).
   - Expect `[ROOM_BUILD] roomKey=street05 doors=9 source=config` and `[DOORS_LIST]` with `d1..d9`.

3. **street02 door art vs backend `doors` var**
   - Confirm the SWF may show a door object even if `doors` room var is empty.
   - Expect no arrow unless backend injects `doors`.

4. **Unknown room keys fallback**
   - Use a room key that is not registered or mismatched (e.g., `street05#1`).
   - Expect `[ROOM_CONFIG_RESOLVE] ... found=false source=fallback` and `doors=[]` with no arrow.

## Logs to Verify
- `[ROOM_CONFIG_RESOLVE] requestedKey=... normalizedKey=... found=true/false source=config|fallback`
- `[ROOM_BUILD] roomKey=... doors=... source=config|fallback`
- `[DOORS_LIST] roomKey=... keys=...`
- `[ROOM_VARS_SET] roomKey=... hasDoorsVar=true doorsCount=...`
- `[ROOM_DOOR] from=... doorKey=... to=... ok=... reason=...`


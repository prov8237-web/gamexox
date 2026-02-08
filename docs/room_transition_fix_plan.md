# Room Transition Fix Plan (No Code Yet)

## Step-by-step Plan
1. **Room key normalization in `RoomConfigRegistry.resolve`**
   - Strip common instance suffixes (e.g., `#1`, `_2`, `-3`) and whitespace.
   - Add alias mapping (e.g., `street05#1` → `street05`).
   - Log normalization decisions:
     - `[ROOM_CONFIG_RESOLVE] requestedKey=... normalizedKey=... found=true/false source=config|fallback`
   - Location to implement: `RoomConfigRegistry.resolve(...)`. (RoomConfigRegistry.java:26-35)

2. **Ensure every room config is registered**
   - Add explicit `register(buildStreetXX())` for all supported rooms, or a template generator for numbered streets.
   - Make registration and resolution consistent with the normalized keys.

3. **Guarantee door variable injection for all rooms**
   - Verify `ServerEventHandler.onUserJoinRoom` and `OsBaseHandler.ensureMandatoryRoomVars` run for every room join and always set `doors` from `RoomState` when missing. (ServerEventHandler.java:105-132; OsBaseHandler.java:143-197)
   - Add instrumentation:
     - `[ROOM_VARS_SET] roomKey=... hasDoorsVar=true doorsCount=...`

4. **Destination room existence strategy**
   - Decide whether to pre-create all rooms in the SFS zone or dynamically create on-demand before `joinRoom`.
   - Add logs around room creation/join attempts:
     - `[ROOM_JOIN_FLOW] roomKey=... stage=resolve|create|join ok=... reason=...`
   - Location: `UseDoorHandler.handleClientRequest` and any room creation utilities. (UseDoorHandler.java:43-57)

5. **Observability improvements**
   - Add structured logs in `MapBuilder.buildRoomData` and `RoomConfigRegistry.resolve`:
     - `[ROOM_CONFIG_RESOLVE] requestedKey=... normalizedKey=... found=true/false source=config|fallback`
     - `[ROOM_BUILD] roomKey=... doors=... source=...`
     - `[DOORS_LIST] roomKey=... keys=...`
   - These logs will support verifying that doors are built and injected per room.


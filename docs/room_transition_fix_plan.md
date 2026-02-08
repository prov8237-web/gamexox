# Room Transition Fix Plan (Implemented)

## Implemented Steps
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

## Implementation Notes
- Normalization and alias mapping are now handled by `RoomConfigRegistry.normalizeRoomKey`, with alias logs emitted on use and resolve logs emitted on every lookup. (RoomConfigRegistry.java:18-72)
- `MapBuilder.buildRoomData` uses the normalized room key for config selection and logging, ensuring consistent `ROOM_BUILD`/`DOORS_LIST` across rooms. (MapBuilder.java:48-83)
- `UseDoorHandler` resolves routing based on the normalized room key and logs routing using that normalized value. (UseDoorHandler.java:14-57)
- `street02` includes a return door (`d5`) back to `street01`. (RoomConfigRegistry.java:127-140)

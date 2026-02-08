# Door Arrow Orientation Audit

## Executive Summary
Door arrow orientation is controlled entirely by the `targetDir` field in the backend-provided `doors` JSON. The client parses `targetDir` into `DoorVO.direction`, and the door hover handler sets the mouse cursor to `"doorarrow" + direction`. This means orientation is selected by the cursor asset named `doorarrow<direction>` rather than any `property.cn` or door key. (DoorModel.as:122-150; SceneDoorComponent.as:115-123)

## Parsing Path (doors JSON → arrow)
1. **Doors JSON parsing**: `DoorModel.load` iterates each door object, copies `targetX`, `targetY`, and `targetDir` into `DoorVO.x/y/direction`. (Client/snal.official.swf/scripts/com/oyunstudyosu/door/DoorModel.as:122-150)
2. **Door hover behavior**: `SceneDoorComponent.mouseOverDoor` looks up the `DoorVO` by id and sets `Mouse.cursor = "doorarrow" + door.direction`. (Client/snal.official.swf/scripts/com/oyunstudyosu/engine/scene/components/SceneDoorComponent.as:115-123)
3. **Property not used for orientation**: `DoorVO.setProperty` only instantiates the property class; it does not affect `direction` or cursor selection. (Client/snal.official.swf/scripts/com/oyunstudyosu/door/DoorVO.as:79-132)

## Mapping Logic (targetDir → orientation)
- **Direct mapping**: `targetDir` is used verbatim as the suffix for the cursor name: `doorarrow<targetDir>`. (SceneDoorComponent.as:115-123)
- **Orientation source**: The actual arrow orientation depends on how the cursor assets `doorarrow0`, `doorarrow1`, etc. are drawn in the client asset library (not in code). There is no numeric mapping table in AS code.
- **Evidence of non-0..3 values**: `EditPanelMock` includes `targetDir:7`, indicating the client can accept values beyond 0–3 (likely 1–8 directions). (Client/Panel/INVPNL.25.swf/scripts/org/oyunstudyosu/sanalika/panels/edit/EditPanelMock.as:20-35)

### Observed/Implied Direction Range
- **At least 0..7 (or 1..8)**: The `targetDir:7` example suggests values beyond 0–3 are supported. (EditPanelMock.as:20-35)
- **No explicit clamping**: `DoorModel` and `DoorVO` do not clamp or normalize `direction`; they store the integer as provided. (DoorModel.as:122-150; DoorVO.as:39-110)

## Do other fields affect orientation?
- **`property.cn`**: Used only to instantiate door behavior (e.g., `FlatExitProperty`) and does not affect cursor orientation. (DoorVO.as:79-132)
- **`key`**: Only used to look up the door by id and match a ceiling clip with the same name; it does not affect orientation. (SceneDoorComponent.as:49-83; DoorModel.as:122-150)

## Coordinate Semantics (targetX/targetY)
- `targetX` and `targetY` are **grid/tile coordinates**, not pixels. They are compared to the player’s current tile coordinates when deciding whether to use the door immediately or walk to it. (SceneDoorComponent.as:176-210; DoorModel.as:122-150)

## Backend Control Surface (what to change)
- **Orientation field**: Set `DoorSpawn.targetDir` (serialized as `targetDir` in doors JSON) to control cursor orientation. This is the only field that affects arrow orientation. (Backend/MapBuilder.java:184-189; DoorModel.as:122-150)
- **No schema changes**: Keep JSON schema as-is; only adjust `targetDir` values per door.

## Recommended Backend Guidance
- Use `DoorSpawn.targetDir` to control arrow orientation.
- If you need standard 4-way directions, define a team convention (e.g., 0–3) and verify which `doorarrow<dir>` asset matches each orientation by testing.

## Optional Runtime Experiment (no code changes requested)
1. In the backend, temporarily set a door’s `targetDir` to 0/1/2/3/7 for a test room.
2. Join the room and hover the door; observe the cursor arrow orientation.
3. Record which `targetDir` values map to which visual arrow direction and lock the team’s convention.


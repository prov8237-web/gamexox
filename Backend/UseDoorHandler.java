package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.*;
public class UseDoorHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        String doorKey = data.containsKey("key") ? data.getUtfString("key") : MapBuilder.DEFAULT_DOOR_KEY;
        InMemoryStore store = getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);
        String fromRoom = state.getCurrentRoom();
        if (fromRoom == null || fromRoom.trim().isEmpty()) {
            Room lastRoom = user.getLastJoinedRoom();
            fromRoom = lastRoom != null ? lastRoom.getName() : MapBuilder.DEFAULT_ROOM_KEY;
        }
        String normalizedFromRoom = RoomConfigRegistry.normalizeRoomKey(fromRoom);
        String targetRoom = data.containsKey("roomKey") ? data.getUtfString("roomKey") : MapBuilder.DEFAULT_ROOM_KEY;
        boolean routed = false;
        String reason = "requested";
        RoomConfigRegistry.Resolution resolution = RoomConfigRegistry.resolve(normalizedFromRoom);
        DoorSpawn matchedDoor = null;
        for (DoorSpawn door : resolution.getConfig().getDoors()) {
            if (door != null && doorKey.equals(door.getKey())) {
                matchedDoor = door;
                break;
            }
        }
        if (matchedDoor == null) {
            reason = "unknown_door";
        } else if (matchedDoor.getDestinationRoomKey() == null
            || matchedDoor.getDestinationRoomKey().trim().isEmpty()) {
            reason = "missing_destination";
        } else {
            targetRoom = matchedDoor.getDestinationRoomKey();
            routed = true;
            reason = "route_ok";
        }

        trace("[USEDOOR] " + user.getName() + " -> " + targetRoom + " via " + doorKey);

        // Server-side room join
        Room targetRoomObj = getParentExtension().getParentZone().getRoomByName(targetRoom);
        if (routed && targetRoomObj != null) {
            try {
                InMemoryStore.RoomState roomState = store.getOrCreateRoom(targetRoomObj);
                ensureMandatoryRoomVars(targetRoomObj, roomState, "USEDOOR");
                getApi().joinRoom(user, targetRoomObj);
                state.setCurrentRoom(targetRoom);
            } catch (Exception e) {
                trace("[USEDOOR] Error: " + e.getMessage());
            }
        }
        trace("[ROOM_DOOR] from=" + normalizedFromRoom + " doorKey=" + doorKey + " to=" + targetRoom
            + " ok=" + (routed && targetRoomObj != null) + " reason="
            + (routed ? (targetRoomObj != null ? "join_ok" : "room_not_found") : reason));

        // Client-side room data
        SFSObject res = new SFSObject();
        Room roomRef = routed && targetRoomObj != null ? targetRoomObj : user.getLastJoinedRoom();
        SFSObject room = new SFSObject();
        if (roomRef != null) {
            InMemoryStore.RoomState roomState = store.getOrCreateRoom(roomRef);
            room = roomState.buildRoomPayload(doorKey);
        } else {
            RoomPayload payload = MapBuilder.buildRoomPayload(fromRoom, doorKey);
            room.putUtfString("key", payload.getKey());
            room.putUtfString("doorKey", payload.getDoorKey());
            room.putInt("pv", payload.getPv());
            room.putInt("dv", payload.getDv());
            room.putUtfString("map", payload.getMapBase64());
        }
        res.putSFSObject("room", room);
        reply(user, "usedoor", res);
        
        trace("[USEDOOR] ✅ Done");
    }
}

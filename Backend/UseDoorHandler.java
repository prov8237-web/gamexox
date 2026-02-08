package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.*;
public class UseDoorHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        String doorKey = data.containsKey("key") ? data.getUtfString("key") : MapBuilder.DEFAULT_DOOR_KEY;
        String targetRoom = data.containsKey("roomKey") ? data.getUtfString("roomKey") : MapBuilder.DEFAULT_ROOM_KEY;
        InMemoryStore store = getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);

        trace("[USEDOOR] " + user.getName() + " -> " + targetRoom + " via " + doorKey);

        // Server-side room join
        Room targetRoomObj = getParentExtension().getParentZone().getRoomByName(targetRoom);
        if (targetRoomObj != null) {
            try {
                InMemoryStore.RoomState roomState = store.getOrCreateRoom(targetRoomObj);
                ensureMandatoryRoomVars(targetRoomObj, roomState, "USEDOOR");
                getApi().joinRoom(user, targetRoomObj);
                state.setCurrentRoom(targetRoom);
            } catch (Exception e) {
                trace("[USEDOOR] Error: " + e.getMessage());
            }
        }

        // Client-side room data
        SFSObject res = new SFSObject();
        Room roomRef = targetRoomObj != null ? targetRoomObj : user.getLastJoinedRoom();
        SFSObject room = new SFSObject();
        if (roomRef != null) {
            InMemoryStore.RoomState roomState = store.getOrCreateRoom(roomRef);
            room = roomState.buildRoomPayload(doorKey);
        } else {
            RoomPayload payload = MapBuilder.buildRoomPayload(targetRoom, doorKey);
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

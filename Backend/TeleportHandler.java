package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.*;

public class TeleportHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        String roomKey = data.containsKey("roomKey") ? data.getUtfString("roomKey") : MapBuilder.DEFAULT_ROOM_KEY;
        InMemoryStore store = getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);
        
        trace("[TELEPORT] " + user.getName() + " -> " + roomKey);

        Room targetRoom = getParentExtension().getParentZone().getRoomByName(roomKey);
        if (targetRoom != null) {
            try {
                InMemoryStore.RoomState roomState = store.getOrCreateRoom(targetRoom);
                ensureMandatoryRoomVars(targetRoom, roomState, "TELEPORT");
                getApi().joinRoom(user, targetRoom);
                state.setCurrentRoom(roomKey);
            } catch (Exception e) {
                trace("[TELEPORT] Error: " + e.getMessage());
            }
        }

        SFSObject res = new SFSObject();
        SFSObject room = new SFSObject();
        if (targetRoom != null) {
            InMemoryStore.RoomState roomState = store.getOrCreateRoom(targetRoom);
            room = roomState.buildRoomPayload(MapBuilder.DEFAULT_DOOR_KEY);
        } else {
            RoomPayload payload = MapBuilder.buildRoomPayload(roomKey, MapBuilder.DEFAULT_DOOR_KEY);
            room.putUtfString("key", payload.getKey());
            room.putUtfString("doorKey", payload.getDoorKey());
            room.putInt("pv", payload.getPv());
            room.putInt("dv", payload.getDv());
            room.putUtfString("map", payload.getMapBase64());
        }

        res.putSFSObject("room", room);
        reply(user, "teleport", res);
        
        trace("[TELEPORT] ✅ Done");
    }
}

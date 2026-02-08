package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.*;
public class UseHouseDoorHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        trace("[USEHOUSEDOOR] " + user.getName() + " entering house");
        InMemoryStore store = getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);

        String targetRoom = data.containsKey("flatID") ? "st01" : "st01";
        Room targetRoomObj = getParentExtension().getParentZone().getRoomByName(targetRoom);
        if (targetRoomObj != null) {
            try {
                InMemoryStore.RoomState roomState = store.getOrCreateRoom(targetRoomObj);
                ensureMandatoryRoomVars(targetRoomObj, roomState, "USEHOUSEDOOR");
                getApi().joinRoom(user, targetRoomObj);
                state.setCurrentRoom(targetRoom);
            } catch (Exception e) {
                trace("[USEHOUSEDOOR] Error: " + e.getMessage());
            }
        }

        SFSObject res = new SFSObject();
        SFSObject room = new SFSObject();
        if (targetRoomObj != null) {
            InMemoryStore.RoomState roomState = store.getOrCreateRoom(targetRoomObj);
            room = roomState.buildRoomPayload(MapBuilder.DEFAULT_DOOR_KEY);
        } else {
            RoomPayload payload = MapBuilder.buildRoomPayload(targetRoom, MapBuilder.DEFAULT_DOOR_KEY);
            room.putUtfString("key", payload.getKey());
            room.putUtfString("doorKey", payload.getDoorKey());
            room.putInt("pv", payload.getPv());
            room.putInt("dv", payload.getDv());
            room.putUtfString("map", payload.getMapBase64());
        }

        res.putSFSObject("room", room);
        reply(user, "usehousedoor", res);
        
        trace("[USEHOUSEDOOR] ✅ Done");
    }
}

package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class SceneItemsHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, com.smartfoxserver.v2.entities.data.ISFSObject params) {
        Room room = user.getLastJoinedRoom();
        ISFSArray items = new SFSArray();
        if (room != null) {
            InMemoryStore.RoomState roomState = getStore().getOrCreateRoom(room);
            items = roomState.getSceneItems();
        }
        SFSObject res = new SFSObject();
        res.putSFSArray("items", items);
        reply(user, "sceneitems", res);
    }
}

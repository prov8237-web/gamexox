package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class SaveSceneItemsHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        ISFSArray items = data != null && data.containsKey("items") ? data.getSFSArray("items") : new SFSArray();
        Room room = user.getLastJoinedRoom();
        if (room != null) {
            InMemoryStore.RoomState roomState = getStore().getOrCreateRoom(room);
            roomState.setSceneItems(items);
        }

        SFSObject res = new SFSObject();
        res.putBool("ok", true);
        res.putInt("count", items.size());
        reply(user, "savesceneitems", res);
    }
}

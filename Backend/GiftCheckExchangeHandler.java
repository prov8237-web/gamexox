package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class GiftCheckExchangeHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        long id = 0L;
        if (data != null && data.containsKey("id")) {
            try {
                id = data.getLong("id");
            } catch (Exception e) {
                id = data.getInt("id");
            }
        }

        InMemoryStore store = getStore();
        InMemoryStore.StoreItem item = store.getHandItemById(user.getId(), id);

        SFSObject response = new SFSObject();
        response.putLong("id", id);
        response.putBool("ok", item != null);
        response.putBool("exchangeable", item != null && item.transferrable);
        response.putUtfString("message", item != null ? "OK" : "ITEM_NOT_FOUND");
        response.putSFSObject("item", item != null ? item.toSFSObject() : new SFSObject());
        response.putInt("nextRequest", 1000);

        reply(user, "giftcheckexchange", response);
    }
}

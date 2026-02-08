
package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.*;
import java.util.List;

/**
 * Player requests a guide ("guiderequest"). Stored and pushed to all guides.
 */
public class GuideRequestHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ISFSObject data = data(params);
        int rid = extractRid(params);

        String message = readStringAny(data, new String[]{"message","msg","text","body"}, null);

        Room room = sender.getLastJoinedRoom();
        String roomName = room != null ? room.getName() : readStringAny(data, new String[]{"room","roomName"}, "");

        InMemoryStore store = getStore();
        InMemoryStore.UserState st = store.getOrCreateUser(sender);

        long id = store.addGuideRequest(String.valueOf(st.getUserId()),
                st.getAvatarName() != null ? st.getAvatarName() : sender.getName(),
                roomName, message);

        SFSObject res = new SFSObject();
        res.putBool("ok", true);
        res.putLong("id", id);
        sendResponseWithRid("guiderequest", res, sender, rid);

        pushGuideListToGuides(store);
    }

    private void pushGuideListToGuides(InMemoryStore store) {
        List<InMemoryStore.GuideRequestRecord> list = store.listGuideRequests("OPEN", 50);
        ISFSArray arr = new SFSArray();
        for (InMemoryStore.GuideRequestRecord r : list) arr.addSFSObject(r.toSFSObject());
        SFSObject payload = new SFSObject();
        payload.putSFSArray("list", arr);

        try {
            Zone z = getZone();
            if (z == null) return;
            for (User u : z.getUserList()) {
                if (u == null) continue;
                if (isGuideUser(u, store)) {
                    sendValidated(u, "guidelist", payload);
                }
            }
        } catch (Exception ignored) {}
    }

    private boolean isGuideUser(User u, InMemoryStore store) {
        try {
            InMemoryStore.UserState st = store.getOrCreateUser(u);
            String roles = st.getRoles();
            return PermissionCodec.hasPermission(roles, AvatarPermissionIds.CARD_GUIDE)
                    || PermissionCodec.hasPermission(roles, AvatarPermissionIds.MODERATOR)
                    || PermissionCodec.hasPermission(roles, AvatarPermissionIds.SECURITY);
        } catch (Exception e) { return false; }
    }

    private static String readStringAny(ISFSObject obj, String[] keys, String def) {
        if (obj == null) return def;
        for (String k : keys) {
            try {
                if (obj.containsKey(k)) {
                    String v = obj.getUtfString(k);
                    if (v != null && !v.trim().isEmpty()) return v;
                }
            } catch (Exception ignored) {}
        }
        return def;
    }
}

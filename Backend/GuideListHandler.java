
package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import java.util.List;

/**
 * Guide panel list.
 * Returns { list: [ {id, requesterId, requesterName, room, message, time, status, guideId, guideName}, ... ] }
 */
public class GuideListHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        int rid = extractRid(params);
        InMemoryStore store = getStore();

        if (!isGuideUser(user, store)) {
            SFSObject denied = new SFSObject();
            denied.putBool("ok", false);
            denied.putUtfString("error", "NO_PERMISSION");
            sendResponseWithRid("guidelist", denied, user, rid);
            return;
        }

        ISFSObject data = data(params);
        String status = readString(data, "status", "OPEN");
        int limit = readInt(data, "limit", 50);

        List<InMemoryStore.GuideRequestRecord> list = store.listGuideRequests(status, limit);
        ISFSArray arr = new SFSArray();
        for (InMemoryStore.GuideRequestRecord r : list) arr.addSFSObject(r.toSFSObject());

        SFSObject res = new SFSObject();
        res.putBool("ok", true);
        res.putSFSArray("list", arr);
        sendResponseWithRid("guidelist", res, user, rid);
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

    private static String readString(ISFSObject obj, String key, String def) {
        try {
            if (obj != null && obj.containsKey(key)) {
                String v = obj.getUtfString(key);
                if (v != null) return v;
            }
        } catch (Exception ignored) {}
        return def;
    }

    private static int readInt(ISFSObject obj, String key, int def) {
        try {
            if (obj != null && obj.containsKey(key)) {
                try { return obj.getInt(key); } catch (Exception ignored) {}
                try { Double d = obj.getDouble(key); return d == null ? def : d.intValue(); } catch (Exception ignored2) {}
            }
        } catch (Exception ignored) {}
        return def;
    }
}

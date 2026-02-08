
package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.*;
import java.util.List;

/**
 * Guide actions:
 * - action: "take" | "close"
 * - id: guide request id
 */
public class GuideActionHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        int rid = extractRid(params);
        InMemoryStore store = getStore();

        if (!isGuideUser(sender, store)) {
            SFSObject denied = new SFSObject();
            denied.putBool("ok", false);
            denied.putUtfString("error", "NO_PERMISSION");
            sendResponseWithRid("guideaction", denied, sender, rid);
            return;
        }

        ISFSObject data = data(params);
        long id = readLongAny(data, new String[]{"id","gid","requestId"}, -1);
        String action = readStringAny(data, new String[]{"action","type","cmd"}, "").toLowerCase();

        boolean ok = false;

        InMemoryStore.UserState st = store.getOrCreateUser(sender);
        String gid = String.valueOf(st.getUserId());
        String gname = st.getAvatarName() != null ? st.getAvatarName() : sender.getName();

        if ("take".equals(action) || "accept".equals(action)) {
            ok = store.takeGuideRequest(id, gid, gname);
        } else if ("close".equals(action) || "done".equals(action)) {
            ok = store.closeGuideRequest(id);
        }

        SFSObject res = new SFSObject();
        res.putBool("ok", ok);
        res.putLong("id", id);
        res.putUtfString("action", action);
        sendResponseWithRid("guideaction", res, sender, rid);

        // push updated list
        pushGuideListToGuides(store);
    }

    private void pushGuideListToGuides(InMemoryStore store) {
        List<InMemoryStore.GuideRequestRecord> list = store.listGuideRequests(null, 50);
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

    private static long readLongAny(ISFSObject obj, String[] keys, long def) {
        if (obj == null) return def;
        for (String k : keys) {
            try {
                if (obj.containsKey(k)) {
                    try { return obj.getLong(k); } catch (Exception ignored) {}
                    try { return (long) obj.getInt(k); } catch (Exception ignored2) {}
                    try { Double d = obj.getDouble(k); return d == null ? def : d.longValue(); } catch (Exception ignored3) {}
                }
            } catch (Exception ignored) {}
        }
        return def;
    }
}

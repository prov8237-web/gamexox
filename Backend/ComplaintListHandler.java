
package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import java.util.List;

/**
 * Knights/Security panel list.
 * Returns { complaints: [ {id, message, comment, reporterAvatarID, reportedAvatarID, isPervert, banCount, nextBanMin}, ... ] }
 */
public class ComplaintListHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        int rid = extractRid(params);
        InMemoryStore store = getStore();

        if (!isSecurityUser(user, store)) {
            SFSObject denied = new SFSObject();
            denied.putBool("ok", false);
            denied.putUtfString("error", "NO_PERMISSION");
            sendResponseWithRid("complaintlist", denied, user, rid);
            return;
        }

        ISFSObject data = data(params);
        String status = readString(data, "status", "OPEN");
        int limit = readInt(data, "limit", 50);

        trace("[REPORT_INBOX_FETCH] requester=" + user.getName() + " status=" + status + " limit=" + limit);

        SFSObject res = buildComplaintPayload(store, status, limit);
        sendResponseWithRid("complaintlist", res, user, rid);
    }

    public static boolean isSecurityUser(User u, InMemoryStore store) {
        try {
            InMemoryStore.UserState st = store.getOrCreateUser(u);
            String roles = st.getRoles();
            return PermissionCodec.hasPermission(roles, AvatarPermissionIds.SECURITY)
                    || PermissionCodec.hasPermission(roles, AvatarPermissionIds.EDITOR_SECURITY)
                    || PermissionCodec.hasPermission(roles, AvatarPermissionIds.CARD_SECURITY);
        } catch (Exception e) {
            return false;
        }
    }

    public static SFSObject buildComplaintPayload(InMemoryStore store, String status, int limit) {
        List<InMemoryStore.ReportRecord> list = store.listReports(status, limit);
        ISFSArray arr = new SFSArray();
        for (InMemoryStore.ReportRecord r : list) {
            SFSObject item = new SFSObject();
            item.putLong("id", r.reportId);
            item.putUtfString("message", r.message == null ? "" : r.message);
            item.putUtfString("comment", r.comment == null ? "" : r.comment);
            item.putUtfString("reporterAvatarID", r.reporterId == null ? "" : r.reporterId);
            item.putUtfString("reportedAvatarID", r.reportedId == null ? "" : r.reportedId);
            item.putInt("isPervert", r.isPervert);
            item.putInt("banCount", r.banCount);
            item.putInt("nextBanMin", r.nextBanMin);
            arr.addSFSObject(item);
        }

        SFSObject res = new SFSObject();
        res.putBool("ok", true);
        res.putSFSArray("complaints", arr);
        return res;
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

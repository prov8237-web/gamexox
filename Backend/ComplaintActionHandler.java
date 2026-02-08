
package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.*;
import java.util.List;

/**
 * Knights/Security panel actions on a complaint:
 * - action: "warn" | "kick" | "ban" | "loginban" | "resolve"
 * - id: complaint id
 * Additional keys for ban: duration (sec) and reason (optional)
 */
public class ComplaintActionHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        int rid = extractRid(params);
        InMemoryStore store = getStore();

        if (!isSecurityUser(sender, store)) {
            SFSObject denied = new SFSObject();
            denied.putBool("ok", false);
            denied.putUtfString("error", "NO_PERMISSION");
            sendResponseWithRid("complaintaction", denied, sender, rid);
            return;
        }

        ISFSObject data = data(params);

        long id = readLongAny(data, new String[]{"id","complaintId","cid"}, -1);
        String action = readStringAny(data, new String[]{"action","type","cmd"}, "").toLowerCase();
        int duration = readInt(data, "duration", readInt(data, "time", readInt(data, "seconds", 3600)));
        String reason = readStringAny(data, new String[]{"reason","note","message"}, null);

        InMemoryStore.ComplaintRecord complaint = store.getComplaint(id);

        if (complaint == null) {
            SFSObject res = new SFSObject();
            res.putBool("ok", false);
            res.putUtfString("error", "NOT_FOUND");
            sendResponseWithRid("complaintaction", res, sender, rid);
            return;
        }

        boolean ok = true;

        if ("resolve".equals(action) || "done".equals(action) || "close".equals(action)) {
            ok = store.resolveComplaint(id);
        } else if ("warn".equals(action)) {
            ok = warnTarget(complaint, reason);
        } else if ("kick".equals(action)) {
            ok = kickTarget(complaint);
        } else if ("ban".equals(action) || "chatban".equals(action)) {
            ok = banTarget(complaint, "CHAT", duration);
        } else if ("loginban".equals(action) || "banlogin".equals(action)) {
            ok = banTarget(complaint, "LOGIN", duration);
        } else {
            ok = false;
        }

        SFSObject res = new SFSObject();
        res.putBool("ok", ok);
        res.putLong("id", id);
        res.putUtfString("action", action);
        sendResponseWithRid("complaintaction", res, sender, rid);

        // push updated list
        pushComplaintListToSecurityUsers();
    }

    private boolean warnTarget(InMemoryStore.ComplaintRecord complaint, String reason) {
        User target = resolveTargetUser(complaint.targetId, complaint.targetName);
        if (target == null) return false;

        SFSObject payload = new SFSObject();
        payload.putUtfString("from", "SYSTEM");
        payload.putUtfString("type", "WARN");
        payload.putUtfString("message", reason != null ? reason : "WARNING");
        try {
            getParentExtension().send("cmd2user", payload, target);
        } catch (Exception ignored) {}
        return true;
    }

    private boolean kickTarget(InMemoryStore.ComplaintRecord complaint) {
        User target = resolveTargetUser(complaint.targetId, complaint.targetName);
        if (target == null) return false;
        try {
            getApi().disconnectUser(target);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean banTarget(InMemoryStore.ComplaintRecord complaint, String banType, int duration) {
        User target = resolveTargetUser(complaint.targetId, complaint.targetName);
        if (target == null) return false;

        String ip = target.getSession().getAddress();
        InMemoryStore store = getStore();
        InMemoryStore.BanRecord rec = store.addBanForIp(ip, banType, duration);
        if (rec == null) return false;
        store.incrementBanCount(complaint.targetId);

        SFSObject payload = rec.toSFSObject(System.currentTimeMillis() / 1000);
        payload.putUtfString("type", banType);
        try {
            getParentExtension().send("banned", payload, target);
        } catch (Exception ignored) {}

        if ("LOGIN".equalsIgnoreCase(banType)) {
            try { getApi().disconnectUser(target); } catch (Exception ignored) {}
        }
        return true;
    }

    private void pushComplaintListToSecurityUsers() {
        InMemoryStore store = getStore();
        List<InMemoryStore.ComplaintRecord> list = store.listComplaints("OPEN", 50);

        ISFSArray arr = new SFSArray();
        for (InMemoryStore.ComplaintRecord r : list) arr.addSFSObject(r.toSFSObject());

        SFSObject payload = new SFSObject();
        payload.putBool("ok", true);
        payload.putSFSArray("list", arr);

        try {
            Zone z = getZone();
            if (z == null) return;
            for (User u : z.getUserList()) {
                if (u == null) continue;
                if (isSecurityUser(u, store)) {
                    sendValidated(u, "complaintlist", payload);
                }
            }
        } catch (Exception ignored) {}
    }

    private boolean isSecurityUser(User u, InMemoryStore store) {
        try {
            InMemoryStore.UserState st = store.getOrCreateUser(u);
            String roles = st.getRoles();
            return PermissionCodec.hasPermission(roles, AvatarPermissionIds.SECURITY)
                    || PermissionCodec.hasPermission(roles, AvatarPermissionIds.EDITOR_SECURITY)
                    || PermissionCodec.hasPermission(roles, AvatarPermissionIds.CARD_SECURITY);
        } catch (Exception e) { return false; }
    }

    private User resolveTargetUser(String avatarIdOrName, String avatarNameFallback) {
        try {
            Zone z = getZone();
            if (z == null) return null;
            if (avatarIdOrName != null && !avatarIdOrName.trim().isEmpty()) {
                User u = z.getUserByName(avatarIdOrName);
                if (u != null) return u;
                for (User cand : z.getUserList()) {
                    try {
                        if (cand == null) continue;
                        if (avatarIdOrName.equals(readUserVarAsString(cand, "avatarName", "avatarID", "avatarId"))) return cand;
                        String playerIdVar = readUserVarAsString(cand, "playerID", "playerId");
                        if (avatarIdOrName.equals(playerIdVar)) return cand;
                        Object playerIdProp = cand.getProperty("playerID");
                        if (playerIdProp != null && avatarIdOrName.equals(playerIdProp.toString())) return cand;
                    } catch (Exception ignored) {}
                }
            }
            if (avatarNameFallback != null && !avatarNameFallback.trim().isEmpty()) {
                User u2 = z.getUserByName(avatarNameFallback);
                if (u2 != null) return u2;
                for (User cand : z.getUserList()) {
                    try {
                        if (cand == null) continue;
                        if (avatarNameFallback.equals(readUserVarAsString(cand, "avatarName", "avatarID", "avatarId"))) return cand;
                        String playerIdVar = readUserVarAsString(cand, "playerID", "playerId");
                        if (avatarNameFallback.equals(playerIdVar)) return cand;
                        Object playerIdProp = cand.getProperty("playerID");
                        if (playerIdProp != null && avatarNameFallback.equals(playerIdProp.toString())) return cand;
                    } catch (Exception ignored) {}
                }
            }
        } catch (Exception ignored) {}
        return null;
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


package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.*;

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

        if (!ComplaintListHandler.isSecurityUser(sender, store)) {
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
        Integer isCorrect = readOptionalInt(data, "isCorrect");
        Integer isPervert = readOptionalInt(data, "isPervert");
        Integer isAbuse = readOptionalInt(data, "isAbuse");

        InMemoryStore.ReportRecord report = store.getReport(id);
        InMemoryStore.ComplaintRecord complaint = report == null ? store.getComplaint(id) : null;

        if (report == null && complaint == null) {
            SFSObject res = new SFSObject();
            res.putBool("ok", false);
            res.putUtfString("error", "NOT_FOUND");
            sendResponseWithRid("complaintaction", res, sender, rid);
            return;
        }

        boolean ok = true;

        boolean usesInboxFlags = isCorrect != null || isPervert != null || isAbuse != null;
        String targetIdForLog = report != null ? report.reportedId : complaint != null ? complaint.targetId : "unknown";

        if (report != null && usesInboxFlags) {
            if (isPervert != null) {
                report.isPervert = Math.max(0, isPervert);
            }
            if (isAbuse != null) {
                report.isAbuse = Math.max(0, isAbuse);
            }
            if (isCorrect != null) {
                ok = store.resolveReport(id);
            }
        } else if ("resolve".equals(action) || "done".equals(action) || "close".equals(action)) {
            ok = report != null ? store.resolveReport(id) : store.resolveComplaint(id);
        } else if ("warn".equals(action)) {
            trace("[MOD_WARN_REQ] actor=" + sender.getName() + " target=" + targetIdForLog + " reportId=" + id);
            ok = report != null ? warnTarget(report, reason) : warnTarget(complaint, reason);
        } else if ("kick".equals(action)) {
            trace("[MOD_KICK_REQ] actor=" + sender.getName() + " target=" + targetIdForLog + " reportId=" + id);
            ok = report != null ? kickTarget(report) : kickTarget(complaint);
        } else if ("ban".equals(action) || "chatban".equals(action)) {
            trace("[MOD_BAN_REQ] actor=" + sender.getName() + " target=" + targetIdForLog + " reportId=" + id + " type=CHAT duration=" + duration);
            ok = report != null ? banTarget(report, "CHAT", duration, id) : banTarget(complaint, "CHAT", duration, id);
        } else if ("loginban".equals(action) || "banlogin".equals(action)) {
            trace("[MOD_BAN_REQ] actor=" + sender.getName() + " target=" + targetIdForLog + " reportId=" + id + " type=LOGIN duration=" + duration);
            ok = report != null ? banTarget(report, "LOGIN", duration, id) : banTarget(complaint, "LOGIN", duration, id);
        } else if (usesInboxFlags && report != null) {
            ok = true;
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

    private boolean warnTarget(InMemoryStore.ReportRecord report, String reason) {
        User target = resolveTargetUser(report.reportedId, null);
        if (target == null) return false;

        String msg = reason != null ? reason : "WARNING";
        SFSObject payload = new SFSObject();
        payload.putUtfString("from", "SYSTEM");
        payload.putUtfString("type", "WARN");
        payload.putUtfString("message", msg);
        try {
            getParentExtension().send("cmd2user", payload, target);
            sendAdminMessage(target, "Municipalty Message", msg, null);
            trace("[MOD_WARN_SENT] target=" + target.getName());
        } catch (Exception ignored) {}
        return true;
    }

    private boolean warnTarget(InMemoryStore.ComplaintRecord complaint, String reason) {
        User target = resolveTargetUser(complaint.targetId, complaint.targetName);
        if (target == null) return false;

        String msg = reason != null ? reason : "WARNING";
        SFSObject payload = new SFSObject();
        payload.putUtfString("from", "SYSTEM");
        payload.putUtfString("type", "WARN");
        payload.putUtfString("message", msg);
        try {
            getParentExtension().send("cmd2user", payload, target);
            sendAdminMessage(target, "Municipalty Message", msg, null);
            trace("[MOD_WARN_SENT] target=" + target.getName());
        } catch (Exception ignored) {}
        return true;
    }

    private boolean kickTarget(InMemoryStore.ComplaintRecord complaint) {
        User target = resolveTargetUser(complaint.targetId, complaint.targetName);
        if (target == null) return false;
        try {
            getApi().disconnectUser(target);
            trace("[MOD_KICK_APPLIED] target=" + target.getName());
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean kickTarget(InMemoryStore.ReportRecord report) {
        User target = resolveTargetUser(report.reportedId, null);
        if (target == null) return false;
        try {
            getApi().disconnectUser(target);
            trace("[MOD_KICK_APPLIED] target=" + target.getName());
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean banTarget(InMemoryStore.ComplaintRecord complaint, String banType, int duration, long reportId) {
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
            sendBanAdminMessage(target, banType, rec.endDate, reportId);
            trace("[MOD_BAN_APPLY] target=" + target.getName() + " type=" + banType + " endDate=" + rec.endDate);
        } catch (Exception ignored) {}

        if ("LOGIN".equalsIgnoreCase(banType) || "CHAT".equalsIgnoreCase(banType)) {
            try { getApi().disconnectUser(target); } catch (Exception ignored) {}
        }
        return true;
    }

    private boolean banTarget(InMemoryStore.ReportRecord report, String banType, int duration, long reportId) {
        User target = resolveTargetUser(report.reportedId, null);
        if (target == null) return false;

        String ip = target.getSession().getAddress();
        InMemoryStore store = getStore();
        InMemoryStore.BanRecord rec = store.addBanForIp(ip, banType, duration);
        if (rec == null) return false;
        store.incrementBanCount(report.reportedId);

        SFSObject payload = rec.toSFSObject(System.currentTimeMillis() / 1000);
        payload.putUtfString("type", banType);
        try {
            getParentExtension().send("banned", payload, target);
            sendBanAdminMessage(target, banType, rec.endDate, reportId);
            trace("[MOD_BAN_APPLY] target=" + target.getName() + " type=" + banType + " endDate=" + rec.endDate);
        } catch (Exception ignored) {}

        if ("LOGIN".equalsIgnoreCase(banType) || "CHAT".equalsIgnoreCase(banType)) {
            try { getApi().disconnectUser(target); } catch (Exception ignored) {}
        }
        return true;
    }

    private void sendAdminMessage(User target, String title, String message, String endDate) {
        if (target == null) return;
        SFSObject payload = new SFSObject();
        payload.putUtfString("title", title);
        payload.putUtfString("message", message);
        payload.putInt("ts", (int) (System.currentTimeMillis() / 1000));
        if (endDate != null) {
            payload.putUtfString("endDate", endDate);
        }
        try {
            getParentExtension().send("adminMessage", payload, target);
        } catch (Exception ignored) {}
    }

    private void sendBanAdminMessage(User target, String banType, String endDate, long reportId) {
        if (target == null) return;
        SFSObject payload = new SFSObject();
        payload.putUtfString("title", "Ban Info");
        payload.putUtfString("message", "You have been banned by the moderator.");
        payload.putUtfString("swear", banType);
        payload.putUtfString("swearTime", String.valueOf(System.currentTimeMillis() / 1000));
        if (endDate != null) {
            payload.putUtfString("endDate", endDate);
        }
        payload.putLong("reportID", reportId);
        payload.putInt("ts", (int) (System.currentTimeMillis() / 1000));
        try {
            getParentExtension().send("adminMessage", payload, target);
        } catch (Exception ignored) {}
    }

    private void pushComplaintListToSecurityUsers() {
        InMemoryStore store = getStore();
        SFSObject payload = ComplaintListHandler.buildComplaintPayload(store, "OPEN", 50);

        try {
            Zone z = getZone();
            if (z == null) return;
            for (User u : z.getUserList()) {
                if (u == null) continue;
                if (ComplaintListHandler.isSecurityUser(u, store)) {
                    sendValidated(u, "complaintlist", payload);
                }
            }
        } catch (Exception ignored) {}
    }

    private User resolveTargetUser(String avatarIdOrName, String avatarNameFallback) {
        try {
            Zone z = getZone();
            if (z == null) return null;
            if (avatarIdOrName != null && !avatarIdOrName.trim().isEmpty()) {
                String normalized = HandlerUtils.normalizeAvatarId(avatarIdOrName);
                User u = z.getUserByName(avatarIdOrName);
                if (u != null) return u;
                for (User cand : z.getUserList()) {
                    try {
                        if (cand == null) continue;
                        if (matchesNormalized(avatarIdOrName, readUserVarAsString(cand, "avatarName", "avatarID", "avatarId"), normalized)) return cand;
                        String playerIdVar = readUserVarAsString(cand, "playerID", "playerId");
                        if (matchesNormalized(avatarIdOrName, playerIdVar, normalized)) return cand;
                        Object playerIdProp = cand.getProperty("playerID");
                        if (playerIdProp != null && matchesNormalized(avatarIdOrName, playerIdProp.toString(), normalized)) return cand;
                    } catch (Exception ignored) {}
                }
            }
            if (avatarNameFallback != null && !avatarNameFallback.trim().isEmpty()) {
                String normalizedFallback = HandlerUtils.normalizeAvatarId(avatarNameFallback);
                User u2 = z.getUserByName(avatarNameFallback);
                if (u2 != null) return u2;
                for (User cand : z.getUserList()) {
                    try {
                        if (cand == null) continue;
                        if (matchesNormalized(avatarNameFallback, readUserVarAsString(cand, "avatarName", "avatarID", "avatarId"), normalizedFallback)) return cand;
                        String playerIdVar = readUserVarAsString(cand, "playerID", "playerId");
                        if (matchesNormalized(avatarNameFallback, playerIdVar, normalizedFallback)) return cand;
                        Object playerIdProp = cand.getProperty("playerID");
                        if (playerIdProp != null && matchesNormalized(avatarNameFallback, playerIdProp.toString(), normalizedFallback)) return cand;
                    } catch (Exception ignored) {}
                }
            }
        } catch (Exception ignored) {}
        return null;
    }

    private boolean matchesNormalized(String rawInput, String candidate, String normalizedInput) {
        if (candidate == null || rawInput == null) return false;
        String normalizedCandidate = HandlerUtils.normalizeAvatarId(candidate);
        if (normalizedInput != null && normalizedInput.equals(normalizedCandidate)) return true;
        return rawInput.equals(candidate);
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

    private static Integer readOptionalInt(ISFSObject obj, String key) {
        try {
            if (obj != null && obj.containsKey(key)) {
                try { return obj.getInt(key); } catch (Exception ignored) {}
                try { Double d = obj.getDouble(key); return d == null ? null : d.intValue(); } catch (Exception ignored2) {}
            }
        } catch (Exception ignored) {}
        return null;
    }
}

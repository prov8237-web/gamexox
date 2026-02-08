
package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.*;
import java.util.List;

/**
 * Client sends "prereport" (and sometimes "ingamereport") when reporting a user's chat/behavior.
 * This handler stores the complaint and pushes it to SECURITY/KNIGHTS panel (complaintlist).
 */
public class PreReportHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ISFSObject data = data(params);
        int rid = extractRid(params);
        String command = resolveCommand(sender);

        String targetId = HandlerUtils.readStringAny(data, "reportedAvatarID", "avatarID", "avatarId", "targetId", "toId", "id", "uid");
        String targetName = HandlerUtils.readStringAny(data, "reportedAvatarName", "avatarName", "targetName", "toName", "name");
        if (isBlank(targetId) || "0".equals(targetId)) {
            String fallbackId = readPropertyString(sender, "lastProfileAvatarId");
            if (!isBlank(fallbackId)) {
                targetId = fallbackId;
            }
        }
        if (isBlank(targetName)) {
            String fallbackName = readPropertyString(sender, "lastProfileAvatarName");
            if (!isBlank(fallbackName)) {
                targetName = fallbackName;
            }
        }
        String text = HandlerUtils.readStringAny(data, "text", "msg", "message", "chat", "body");
        String reason = HandlerUtils.readStringAny(data, "comment", "reason", "type", "category");
        int isPervert = readInt(data, "isPervert", 0);

        Room room = sender.getLastJoinedRoom();
        String roomName = room != null ? room.getName() : readStringAny(data, new String[]{"room","roomName"}, "");
        if ((isBlank(targetId) || "0".equals(targetId)) && !isBlank(targetName) && room != null) {
            String resolved = resolveTargetIdFromRoom(room, targetName);
            if (!isBlank(resolved)) {
                targetId = resolved;
            }
        }
        if ((isBlank(targetId) || "0".equals(targetId)) && !isBlank(targetName)) {
            targetId = targetName;
        }

        InMemoryStore store = getStore();
        InMemoryStore.UserState st = store.getOrCreateUser(sender);

        String reporterRaw = resolveReporterId(sender);
        String reporterNorm = HandlerUtils.normalizeAvatarId(reporterRaw);
        String reporterId = reporterNorm.isEmpty() ? reporterRaw : reporterNorm;
        String reporterName = HandlerUtils.readUserVarAsString(sender, "avatarName");
        if (isBlank(reporterName)) {
            reporterName = st.getAvatarName() != null ? st.getAvatarName() : sender.getName();
        }

        String normalizedTargetId = HandlerUtils.normalizeAvatarId(targetId);
        int banCount = store.getBanCount(normalizedTargetId);
        trace("[REPORT_CREATE_IN] reporterRaw=" + reporterRaw + " reportedRaw=" + targetId + " messageRaw=" + text + " commentRaw=" + reason + " isPervert=" + isPervert);
        if (isBlank(targetId) || "0".equals(targetId)) {
            trace("[REPORT_CREATE_WARN] source=request reportedRaw=" + targetId);
        }
        if (isBlank(text) || "0".equals(text)) {
            trace("[REPORT_CREATE_WARN] source=request messageRaw=" + text);
        }
        if (isBlank(reason) || "0".equals(reason)) {
            trace("[REPORT_CREATE_WARN] source=request commentRaw=" + reason);
        }
        long complaintId = store.addComplaint(reporterId, reporterName, targetId, targetName, roomName, text, reason);
        store.addReport(reporterRaw, reporterNorm, targetId, normalizedTargetId, text, reason, isPervert, banCount, 0);
        trace("[REPORT_CREATE_STORE] id=" + complaintId + " reporterId=" + reporterNorm + " reportedId=" + normalizedTargetId + " message=" + text + " comment=" + reason);
        if (isBlank(reporterNorm) || isBlank(normalizedTargetId)) {
            trace("[REPORT_CREATE_WARN] source=store reporterId=" + reporterNorm + " reportedId=" + normalizedTargetId);
        }

        // ACK to reporter
        SFSObject res = new SFSObject();
        res.putBool("ok", true);
        res.putLong("id", complaintId);
        sendResponseWithRid(command, res, sender, rid);

        // Push updated complaint list to all security users (including current sender if they are security)
        pushComplaintListToSecurityUsers();
    }

    private String resolveCommand(User sender) {
        try {
            Object last = sender.getProperty("lastRequestId");
            if (last != null) {
                String cmd = last.toString();
                if ("ingamereport".equals(cmd) || "report".equals(cmd)) {
                    return cmd;
                }
            }
        } catch (Exception ignored) {}
        return "prereport";
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String resolveReporterId(User sender) {
        String raw = HandlerUtils.readUserVarAsString(sender, "avatarID", "avatarId", "avatarName");
        if (raw == null || raw.trim().isEmpty()) {
            raw = sender != null ? sender.getName() : "";
        }
        return raw;
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

    private String resolveTargetIdFromRoom(Room room, String targetName) {
        if (room == null || isBlank(targetName)) {
            return "";
        }
        try {
            List<User> users = room.getUserList();
            if (users == null) return "";
            for (User u : users) {
                if (u == null) continue;
                String avatarName = HandlerUtils.readUserVarAsString(u, "avatarName");
                if (targetName.equals(avatarName) || targetName.equals(u.getName())) {
                    String avatarId = HandlerUtils.readUserVarAsString(u, "avatarID", "avatarId");
                    if (!isBlank(avatarId)) {
                        return avatarId;
                    }
                }
            }
        } catch (Exception ignored) {}
        return "";
    }

    private String readPropertyString(User user, String key) {
        if (user == null || key == null) return "";
        try {
            Object value = user.getProperty(key);
            if (value != null) {
                String asString = value.toString();
                if (asString != null && !asString.trim().isEmpty()) {
                    return asString;
                }
            }
        } catch (Exception ignored) {}
        return "";
    }
}

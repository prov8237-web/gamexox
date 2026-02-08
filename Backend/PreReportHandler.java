
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

        String targetId = HandlerUtils.readStringAny(data, "avatarID", "avatarId", "targetId", "toId", "id", "uid");
        String targetName = HandlerUtils.readStringAny(data, "avatarName", "targetName", "toName", "name");
        String text = HandlerUtils.readStringAny(data, "text", "msg", "message", "chat", "body");
        String reason = HandlerUtils.readStringAny(data, "reason", "type", "category");

        Room room = sender.getLastJoinedRoom();
        String roomName = room != null ? room.getName() : readStringAny(data, new String[]{"room","roomName"}, "");

        InMemoryStore store = getStore();
        InMemoryStore.UserState st = store.getOrCreateUser(sender);

        String reporterRaw = sender.getName();
        String reporterNorm = HandlerUtils.normalizeAvatarId(reporterRaw);
        String reporterId = reporterNorm.isEmpty() ? reporterRaw : reporterNorm;
        String reporterName = st.getAvatarName() != null ? st.getAvatarName() : sender.getName();

        if (isBlank(targetId) || "0".equals(targetId)) {
            targetId = resolveTargetIdFallback(targetName);
        }
        String normalizedTargetId = HandlerUtils.normalizeAvatarId(targetId);
        int banCount = store.getBanCount(normalizedTargetId);
        trace("[REPORT_CREATE_IN] reporterRaw=" + reporterRaw + " reportedRaw=" + targetId + " messageRaw=" + text + " commentRaw=" + reason + " isPervert=0");
        if (isBlank(targetId) || "0".equals(targetId)) {
            trace("[RPT_WARN_ZERO] trace=prereport-" + sender.getName() + "-" + System.currentTimeMillis() + " reportedRaw=" + targetId);
        }
        if (isBlank(text) || "0".equals(text)) {
            trace("[REPORT_CREATE_WARN] source=request messageRaw=" + text);
        }
        if (isBlank(reason) || "0".equals(reason)) {
            trace("[REPORT_CREATE_WARN] source=request commentRaw=" + reason);
        }
        if (isBlank(targetId) || "0".equals(targetId)) {
            SFSObject res = new SFSObject();
            res.putBool("ok", false);
            res.putUtfString("errorCode", "MISSING_ITEM");
            sendResponseWithRid(command, res, sender, rid);
            return;
        }

        long complaintId = store.addComplaint(reporterId, reporterName, targetId, targetName, roomName, text, reason);
        store.addReport(reporterRaw, reporterNorm, targetId, normalizedTargetId, text, reason, 0, banCount, 0);
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

    private String resolveTargetIdFallback(String targetName) {
        if (isBlank(targetName)) {
            return "";
        }
        try {
            Zone z = getZone();
            if (z != null) {
                User byName = z.getUserByName(targetName);
                if (byName != null) {
                    String avatarIdVar = HandlerUtils.readUserVarAsString(byName, "avatarID", "avatarId", "avatarName");
                    return avatarIdVar != null ? avatarIdVar : byName.getName();
                }
            }
        } catch (Exception ignored) {}
        return targetName;
    }
}

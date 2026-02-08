package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.List;

public class ReportHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ISFSObject data = data(params);
        int rid = extractRid(params);

        String reportedRaw = HandlerUtils.readStringAny(data, "reportedAvatarID", "avatarID", "avatarId");
        String reportedName = HandlerUtils.readStringAny(data, "reportedAvatarName", "avatarName", "targetName", "name");
        if (isBlank(reportedRaw) || "0".equals(reportedRaw)) {
            String fallbackId = readPropertyString(sender, "lastProfileAvatarId");
            if (!isBlank(fallbackId)) {
                reportedRaw = fallbackId;
            }
        }
        if (isBlank(reportedName)) {
            String fallbackName = readPropertyString(sender, "lastProfileAvatarName");
            if (!isBlank(fallbackName)) {
                reportedName = fallbackName;
            }
        }
        if ((isBlank(reportedRaw) || "0".equals(reportedRaw)) && !isBlank(reportedName)) {
            Room room = sender.getLastJoinedRoom();
            String resolved = resolveTargetIdFromRoom(room, reportedName);
            if (!isBlank(resolved)) {
                reportedRaw = resolved;
            }
        }
        if ((isBlank(reportedRaw) || "0".equals(reportedRaw)) && !isBlank(reportedName)) {
            reportedRaw = reportedName;
        }
        String reportedNorm = HandlerUtils.normalizeAvatarId(reportedRaw);
        String reporterRaw = resolveReporterId(sender);
        String reporterNorm = HandlerUtils.normalizeAvatarId(reporterRaw);
        String message = HandlerUtils.readStringAny(data, "message");
        String comment = HandlerUtils.readStringAny(data, "comment");
        int isPervert = readInt(data, "isPervert", 0);

        trace("[REPORT_CREATE_IN] reporterRaw=" + reporterRaw + " reportedRaw=" + reportedRaw + " messageRaw=" + message + " commentRaw=" + comment + " isPervert=" + isPervert);
        if (isBlank(reportedRaw) || "0".equals(reportedRaw)) {
            trace("[REPORT_CREATE_WARN] source=request reportedRaw=" + reportedRaw);
        }
        if (isBlank(message) || "0".equals(message)) {
            trace("[REPORT_CREATE_WARN] source=request messageRaw=" + message);
        }
        if (isBlank(comment) || "0".equals(comment)) {
            trace("[REPORT_CREATE_WARN] source=request commentRaw=" + comment);
        }

        InMemoryStore store = getStore();
        int banCount = store.getBanCount(reportedNorm);
        int nextBanMin = 0;

        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 0);

        if (reportedNorm == null || reportedNorm.trim().isEmpty() || "unknown".equalsIgnoreCase(reportedNorm)) {
            res.putUtfString("errorCode", "MISSING_ITEM");
            sendResponseWithRid("report", res, sender, rid);
            trace("[REPORT_SUBMIT_RES] reporter=" + reporterRaw + " errorCode=MISSING_ITEM");
            return;
        }

        long reportId = store.addReport(reporterRaw, reporterNorm, reportedRaw, reportedNorm, message, comment, isPervert, banCount, nextBanMin);
        res.putLong("reportId", reportId);

        sendResponseWithRid("report", res, sender, rid);
        trace("[REPORT_CREATE_STORE] id=" + reportId + " reporterId=" + reporterNorm + " reportedId=" + reportedNorm + " message=" + message + " comment=" + comment);
        if (isBlank(reporterNorm) || isBlank(reportedNorm)) {
            trace("[REPORT_CREATE_WARN] source=store reporterId=" + reporterNorm + " reportedId=" + reportedNorm);
        }

        pushComplaintListToSecurityUsers();
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
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

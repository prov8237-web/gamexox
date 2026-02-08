package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class ReportHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ISFSObject data = data(params);
        int rid = extractRid(params);

        String reportedRaw = readString(data, "reportedAvatarID", readString(data, "avatarID", readString(data, "avatarId", "")));
        String reportedId = HandlerUtils.normalizeAvatarId(reportedRaw);
        String reporterId = resolveReporterId(sender);
        String message = readString(data, "message", "");
        String comment = readString(data, "comment", "");
        int isPervert = readInt(data, "isPervert", 0);

        trace("[REPORT_SUBMIT_REQ] reporter=" + reporterId + " reported=" + reportedId + " isPervert=" + isPervert);

        InMemoryStore store = getStore();
        int banCount = store.getBanCount(reportedId);
        int nextBanMin = 0;

        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 0);

        if (reportedId == null || reportedId.trim().isEmpty() || "unknown".equalsIgnoreCase(reportedId)) {
            res.putUtfString("errorCode", "MISSING_ITEM");
            sendResponseWithRid("report", res, sender, rid);
            trace("[REPORT_SUBMIT_RES] reporter=" + reporterId + " errorCode=MISSING_ITEM");
            return;
        }

        long reportId = store.addReport(reporterId, reportedId, message, comment, isPervert, banCount, nextBanMin);
        res.putLong("reportId", reportId);

        sendResponseWithRid("report", res, sender, rid);
        trace("[REPORT_SUBMIT_RES] reporter=" + reporterId + " reportId=" + reportId);

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
        return HandlerUtils.normalizeAvatarId(raw);
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

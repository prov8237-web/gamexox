
package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.entities.variables.UserVariable;

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
        String reportedParam = HandlerUtils.readStringAny(data, "reportedAvatarID", "reportedId", "avatarID", "avatarId");

        trace("[COMPLAINT_ACTION_IN] action=" + action + " id=" + id + " reportedAvatarID=" + reportedParam + " duration=" + duration + " reason=" + reason);

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
        String storedReporter = report != null ? preferredReporterId(report) : complaint != null ? complaint.reporterId : "unknown";
        String storedReported = report != null ? preferredReportedId(report) : complaint != null ? complaint.targetId : "unknown";
        String modTraceId = buildTraceId(action, id);
        trace("[MOD_IN] trace=" + modTraceId + " action=" + action + " admin=" + sender.getName()
                + " reportId=" + id + " reportedRaw=" + reportedParam + " storedReportedId=" + storedReported);

        ResolveResult resolveResult = null;
        if (isModerationAction(action)) {
            resolveResult = resolveTargetUserStrong(storedReported, reportedParam);
            String resolvedName = resolveResult.user != null ? resolveResult.user.getName() : "null";
            String resolvedSessionId = resolveResult.user != null && resolveResult.user.getSession() != null
                    ? String.valueOf(resolveResult.user.getSession().getId()) : "null";
            trace("[MOD_RESOLVE] trace=" + modTraceId + " targetResolved=" + (resolveResult.user != null)
                    + " targetName=" + resolvedName
                    + " targetSessionId=" + resolvedSessionId
                    + " matchedBy=" + resolveResult.matchedBy);
            if (resolveResult.user == null) {
                SFSObject res = new SFSObject();
                res.putBool("ok", false);
                res.putUtfString("error", "TARGET_NOT_FOUND");
                res.putLong("id", id);
                res.putUtfString("action", action);
                sendResponseWithRid("complaintaction", res, sender, rid);
                return;
            }
        }
        if (isBlank(storedReported) || "0".equals(storedReported)) {
            trace("[COMPLAINT_ACTION_WARN] source=store stored.reportedId=" + storedReported);
        }

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
            trace("[MOD_WARN_REQ] trace=" + modTraceId + " actor=" + sender.getName() + " target=" + storedReported + " reportId=" + id);
            ok = warnTarget(resolveResult.user, reason, modTraceId);
        } else if ("kick".equals(action)) {
            trace("[MOD_KICK_REQ] trace=" + modTraceId + " actor=" + sender.getName() + " target=" + storedReported + " reportId=" + id);
            ok = kickTarget(resolveResult.user, modTraceId);
        } else if ("ban".equals(action) || "chatban".equals(action)) {
            trace("[MOD_BAN_REQ] trace=" + modTraceId + " actor=" + sender.getName() + " target=" + storedReported + " reportId=" + id + " type=CHAT duration=" + duration);
            ok = banTarget(resolveResult.user, "CHAT", duration, id, modTraceId, storedReported);
        } else if ("loginban".equals(action) || "banlogin".equals(action)) {
            trace("[MOD_BAN_REQ] trace=" + modTraceId + " actor=" + sender.getName() + " target=" + storedReported + " reportId=" + id + " type=LOGIN duration=" + duration);
            ok = banTarget(resolveResult.user, "LOGIN", duration, id, modTraceId, storedReported);
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

        if (ok) {
            // push updated list
            pushComplaintListToSecurityUsers();
        }
    }

    private boolean warnTarget(User target, String reason, String traceId) {
        if (target == null) return false;
        String msg = reason != null ? reason : "WARNING";
        return sendAdminMessage(target, "Municipalty Message", msg, null, traceId);
    }

    private boolean kickTarget(User target, String traceId) {
        if (target == null) return false;
        boolean ok = false;
        String methodUsed = "disconnectUser";
        try {
            getApi().disconnectUser(target);
            ok = true;
        } catch (Exception ignored) {}
        trace("[MOD_KICK] trace=" + traceId + " methodUsed=" + methodUsed + " ok=" + ok);
        return ok;
    }

    private boolean banTarget(User target, String banType, int duration, long reportId, String traceId, String storedReportedId) {
        if (target == null) return false;

        String ip = target.getSession().getAddress();
        InMemoryStore store = getStore();
        InMemoryStore.BanRecord rec = store.addBanForIp(ip, banType, duration);
        if (rec == null) return false;
        store.incrementBanCount(HandlerUtils.normalizeAvatarId(storedReportedId));

        long endMs = rec.endEpochSec < 0 ? -1 : rec.endEpochSec * 1000L;
        SFSObject payload = rec.toSFSObject(System.currentTimeMillis() / 1000);
        payload.putUtfString("type", banType);
        payload.putUtfString("trace", traceId);
        boolean sent = false;
        try {
            getParentExtension().send("banned", payload, target);
            sent = true;
        } catch (Exception ignored) {}
        trace("[MOD_BAN_SEND] trace=" + traceId + " type=" + banType + " durationSec=" + duration + " endMs=" + endMs + " ok=" + sent);
        sendBanAdminMessage(target, banType, rec.endDate, reportId, traceId);

        if ("LOGIN".equalsIgnoreCase(banType) || "CHAT".equalsIgnoreCase(banType)) {
            try { getApi().disconnectUser(target); } catch (Exception ignored) {}
        }
        return true;
    }

    private boolean sendAdminMessage(User target, String title, String message, String endDate, String traceId) {
        if (target == null) return false;
        SFSObject payload = new SFSObject();
        payload.putUtfString("title", title);
        payload.putUtfString("message", message);
        payload.putInt("ts", (int) (System.currentTimeMillis() / 1000));
        payload.putUtfString("trace", traceId);
        if (endDate != null) {
            payload.putUtfString("endDate", endDate);
        }
        boolean ok = false;
        try {
            getParentExtension().send("adminMessage", payload, target);
            ok = true;
        } catch (Exception ignored) {}
        trace("[MOD_SEND_ADMINMSG] trace=" + traceId + " ok=" + ok + " payloadKeys=" + payload.getKeys());
        return ok;
    }

    private void sendBanAdminMessage(User target, String banType, String endDate, long reportId, String traceId) {
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
        payload.putUtfString("trace", traceId);
        try {
            getParentExtension().send("adminMessage", payload, target);
        } catch (Exception ignored) {}
        trace("[MOD_SEND_ADMINMSG] trace=" + traceId + " ok=true payloadKeys=" + payload.getKeys());
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

    private String preferredReporterId(InMemoryStore.ReportRecord report) {
        if (report == null) return "";
        if (report.reporterIdRaw != null && !report.reporterIdRaw.isEmpty()) return report.reporterIdRaw;
        if (report.reporterIdNorm != null && !report.reporterIdNorm.isEmpty()) return report.reporterIdNorm;
        return report.reporterId;
    }

    private String preferredReportedId(InMemoryStore.ReportRecord report) {
        if (report == null) return "";
        if (report.reportedIdRaw != null && !report.reportedIdRaw.isEmpty()) return report.reportedIdRaw;
        if (report.reportedIdNorm != null && !report.reportedIdNorm.isEmpty()) return report.reportedIdNorm;
        return report.reportedId;
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private boolean isModerationAction(String action) {
        if (action == null) return false;
        return "warn".equals(action)
                || "kick".equals(action)
                || "ban".equals(action)
                || "chatban".equals(action)
                || "loginban".equals(action)
                || "banlogin".equals(action);
    }

    private String buildTraceId(String action, long reportId) {
        String act = action == null ? "unknown" : action;
        return act + "-" + reportId + "-" + System.currentTimeMillis();
    }

    private ResolveResult resolveTargetUserStrong(String storedReportedId, String reportedRaw) {
        String raw = coalesce(storedReportedId, reportedRaw);
        String normalized = HandlerUtils.normalizeAvatarId(raw);
        Zone z = getZone();
        if (z == null) return new ResolveResult(null, "zone:null");

        String[] nameCandidates = buildNameCandidates(raw, normalized);
        for (String candidate : nameCandidates) {
            if (isBlank(candidate)) continue;
            User u = z.getUserByName(candidate);
            if (u != null) return new ResolveResult(u, "name");
        }

        String numeric = extractNumeric(raw);
        for (User cand : z.getUserList()) {
            if (cand == null) continue;
            String userName = cand.getName();
            if (matchesNormalized(raw, userName, normalized)) return new ResolveResult(cand, "scan:name");
            if (!isBlank(numeric) && matchesNormalized(numeric, userName, HandlerUtils.normalizeAvatarId(numeric))) {
                return new ResolveResult(cand, "scan:name:numeric");
            }
            String avatarIdVar = readUserVarAsString(cand, "avatarID", "avatarId");
            if (matchesNormalized(raw, avatarIdVar, normalized)) return new ResolveResult(cand, "var:avatarID");
            String playerIdVar = readUserVarAsString(cand, "playerID", "playerId");
            if (matchesNormalized(raw, playerIdVar, normalized)) return new ResolveResult(cand, "var:playerID");
            String avatarNameVar = readUserVarAsString(cand, "avatarName");
            if (matchesNormalized(raw, avatarNameVar, normalized)) return new ResolveResult(cand, "var:avatarName");
        }

        return new ResolveResult(null, "not-found");
    }

    private String[] buildNameCandidates(String raw, String normalized) {
        String guestNumeric = extractNumeric(raw);
        String guestName = isBlank(guestNumeric) ? "" : "Guest#" + guestNumeric;
        String guestLower = isBlank(guestNumeric) ? "" : "guest#" + guestNumeric;
        return new String[]{
                raw,
                normalized,
                guestName,
                guestLower,
                raw != null ? raw.toLowerCase() : ""
        };
    }

    private String extractNumeric(String value) {
        if (isBlank(value)) return "";
        String trimmed = value.trim();
        if (trimmed.matches("\\d+")) return trimmed;
        String lower = trimmed.toLowerCase();
        if (lower.startsWith("guest#")) {
            return lower.substring("guest#".length()).trim();
        }
        return "";
    }

    private String coalesce(String primary, String fallback) {
        if (!isBlank(primary)) return primary;
        return fallback == null ? "" : fallback;
    }

    private static final class ResolveResult {
        private final User user;
        private final String matchedBy;

        private ResolveResult(User user, String matchedBy) {
            this.user = user;
            this.matchedBy = matchedBy;
        }
    }

    private String collectUserVarKeys(User user) {
        if (user == null) {
            return "[]";
        }
        java.util.List<String> keys = new java.util.ArrayList<>();
        try {
            for (UserVariable var : user.getVariables()) {
                if (var != null) {
                    keys.add(var.getName());
                }
            }
        } catch (Exception ignored) {
            return "[]";
        }
        return keys.toString();
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

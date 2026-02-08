
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
        String actorId = HandlerUtils.readStringAny(data, "actorId", "adminId", "avatarID", "avatarId");
        trace("[MOD_REQ] trace=" + modTraceId + " action=" + action + " actorName=" + sender.getName()
                + " actorId=" + actorId + " targetInput=" + reportedParam + " reportId=" + id
                + " duration=" + duration + " reason=" + reason);

        ResolveResult resolveResult = null;
        if (isModerationAction(action)) {
            resolveResult = resolveTarget(modTraceId, reportedParam, report);
            if (resolveResult.user == null) {
                SFSObject res = new SFSObject();
                res.putBool("ok", false);
                res.putUtfString("reason", "TARGET_NOT_FOUND");
                res.putUtfString("trace", modTraceId);
                res.putLong("id", id);
                res.putUtfString("action", action);
                sendResponseWithRid("complaintaction", res, sender, rid);
                trace("[MOD_FAIL] trace=" + modTraceId + " reason=TARGET_NOT_FOUND");
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
            ok = warnTarget(resolveResult.user, reason, modTraceId);
        } else if ("kick".equals(action)) {
            ok = kickUserHard(resolveResult.user, modTraceId);
        } else if ("ban".equals(action) || "chatban".equals(action)) {
            ok = banTarget(resolveResult.user, "CHAT", duration, id, modTraceId, storedReported);
        } else if ("loginban".equals(action) || "banlogin".equals(action)) {
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
        boolean ok = sendAdminMessage(target, "Municipalty Message", msg, null, traceId);
        trace("[MOD_WARN] trace=" + traceId + " sent=" + (ok ? 1 : 0));
        return ok;
    }

    private boolean banTarget(User target, String banType, int duration, long reportId, String traceId, String storedReportedId) {
        if (target == null) return false;

        String ip = target.getSession().getAddress();
        InMemoryStore store = getStore();
        InMemoryStore.BanRecord rec = store.addBanForIp(ip, banType, duration);
        if (rec == null) return false;
        store.incrementBanCount(HandlerUtils.normalizeAvatarId(storedReportedId));

        long startMs = rec.startEpochSec * 1000L;
        long endMs = rec.endEpochSec < 0 ? -1 : rec.endEpochSec * 1000L;
        int timeLeft = rec.timeLeftSec(System.currentTimeMillis() / 1000);
        SFSObject payload = new SFSObject();
        payload.putUtfString("type", banType);
        payload.putLong("startDate", startMs);
        payload.putLong("endDate", endMs);
        payload.putInt("timeLeft", timeLeft);
        payload.putUtfString("trace", traceId);
        boolean sent = false;
        try {
            getParentExtension().send("banned", payload, target);
            sent = true;
        } catch (Exception ignored) {}
        trace("[MOD_BAN_SEND] trace=" + traceId + " type=" + banType + " durationSec=" + duration + " endMs=" + endMs + " ok=" + sent);
        sendBanAdminMessage(target, banType, rec.endDate, reportId, traceId);

        if ("LOGIN".equalsIgnoreCase(banType) || "CHAT".equalsIgnoreCase(banType)) {
            kickUserHard(target, traceId);
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

    private boolean kickUserHard(User target, String traceId) {
        if (target == null) return false;
        boolean ok = false;
        String method = "disconnect";
        int[] retries = new int[]{0};
        try {
            getApi().disconnectUser(target);
            ok = true;
        } catch (Exception ignored) {}
        if (target.getSession() != null) {
            if (tryLogout(target)) {
                method = "disconnect+logout";
            }
        }
        scheduleKickRetry(target, traceId, retries);
        trace("[MOD_KICK] trace=" + traceId + " method=" + method + " ok=" + ok + " retry=" + retries[0]);
        return ok;
    }

    private void scheduleKickRetry(User target, String traceId, int[] retries) {
        if (target == null) return;
        Zone z = getZone();
        if (z == null) return;
        String name = target.getName();
        new Thread(() -> {
            try {
                Thread.sleep(150);
            } catch (InterruptedException ignored) {}
            User stillThere = z.getUserByName(name);
            if (stillThere != null) {
                retries[0] = retries[0] + 1;
                try {
                    getApi().disconnectUser(stillThere);
                } catch (Exception ignored) {}
                trace("[MOD_KICK_RETRY] trace=" + traceId + " count=" + retries[0]);
            }
        }).start();
    }

    private boolean tryLogout(User target) {
        try {
            java.lang.reflect.Method logout = getApi().getClass().getMethod("logout", User.class);
            logout.invoke(getApi(), target);
            return true;
        } catch (Exception ignored) {}
        try {
            java.lang.reflect.Method logoutUser = getApi().getClass().getMethod("logoutUser", User.class);
            logoutUser.invoke(getApi(), target);
            return true;
        } catch (Exception ignored) {}
        return false;
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

    private ResolveResult resolveTarget(String traceId, String reportedParam, InMemoryStore.ReportRecord report) {
        Zone z = getZone();
        if (z == null) return new ResolveResult(null, "zone:null", 0);
        String raw = coalesce(reportedParam, report != null ? report.reportedIdRaw : null);
        String normalized = HandlerUtils.normalizeAvatarId(raw);
        int candidatesChecked = 0;

        String[] nameCandidates = buildNameCandidates(raw, normalized);
        for (String candidate : nameCandidates) {
            if (isBlank(candidate)) continue;
            candidatesChecked++;
            User u = z.getUserByName(candidate);
            if (u != null) {
                logTarget(traceId, u, "name", candidatesChecked);
                return new ResolveResult(u, "name", candidatesChecked);
            }
        }

        String numeric = extractNumeric(raw);
        for (User cand : z.getUserList()) {
            if (cand == null) continue;
            candidatesChecked++;
            String userName = cand.getName();
            if (matchesNormalized(raw, userName, normalized)) {
                logTarget(traceId, cand, "scan:name", candidatesChecked);
                return new ResolveResult(cand, "scan:name", candidatesChecked);
            }
            if (!isBlank(numeric) && matchesNormalized(numeric, userName, HandlerUtils.normalizeAvatarId(numeric))) {
                logTarget(traceId, cand, "scan:name:numeric", candidatesChecked);
                return new ResolveResult(cand, "scan:name:numeric", candidatesChecked);
            }
            String avatarIdVar = readUserVarAsString(cand, "avatarID", "avatarId");
            if (matchesNormalized(raw, avatarIdVar, normalized)) {
                logTarget(traceId, cand, "var:avatarID", candidatesChecked);
                return new ResolveResult(cand, "var:avatarID", candidatesChecked);
            }
            String playerIdVar = readUserVarAsString(cand, "playerID", "playerId");
            if (matchesNormalized(raw, playerIdVar, normalized)) {
                logTarget(traceId, cand, "var:playerID", candidatesChecked);
                return new ResolveResult(cand, "var:playerID", candidatesChecked);
            }
            String avatarNameVar = readUserVarAsString(cand, "avatarName");
            if (matchesNormalized(raw, avatarNameVar, normalized)) {
                logTarget(traceId, cand, "var:avatarName", candidatesChecked);
                return new ResolveResult(cand, "var:avatarName", candidatesChecked);
            }
        }

        trace("[MOD_TGT] trace=" + traceId + " found=false matchMode=not-found targetName=null targetVars={} candidates=" + candidatesChecked);
        return new ResolveResult(null, "not-found", candidatesChecked);
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
        private final int candidatesChecked;

        private ResolveResult(User user, String matchedBy, int candidatesChecked) {
            this.user = user;
            this.matchedBy = matchedBy;
            this.candidatesChecked = candidatesChecked;
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

    private void logTarget(String traceId, User user, String matchMode, int candidatesChecked) {
        String name = user != null ? user.getName() : "null";
        String avatarId = readUserVarAsString(user, "avatarID", "avatarId");
        String avatarName = readUserVarAsString(user, "avatarName");
        String playerId = readUserVarAsString(user, "playerID", "playerId");
        String roles = readUserVarAsString(user, "roles");
        trace("[MOD_TGT] trace=" + traceId
                + " found=" + (user != null)
                + " matchMode=" + matchMode
                + " targetName=" + name
                + " targetVars={avatarID:" + avatarId + ",avatarName:" + avatarName + ",playerID:" + playerId + ",roles:" + roles + "}"
                + " candidates=" + candidatesChecked);
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

package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.UserVariable;

/**
 * Handles in-game moderation actions (notice/kick) via cmd="ingamereport".
 */
public class InGameReportHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ISFSObject data = data(params);
        int rid = extractRid(params);

        String command = HandlerUtils.readStringAny(data, "command", "cmd", "action");
        String reason = HandlerUtils.readStringAny(data, "reason", "message", "note");
        String avatarId = HandlerUtils.readStringAny(data, "avatarID", "avatarId", "targetId", "toId", "id");
        int isPervert = readInt(data, "isPervert", 0);
        String traceId = "ingamereport-" + sender.getName() + "-" + System.currentTimeMillis();

        boolean ok = true;
        String errorCode = null;

        ResolveResult result = resolveTarget(traceId, avatarId);
        if (result.user == null) {
            ok = false;
            errorCode = "TARGET_NOT_FOUND";
        } else if ("notice".equalsIgnoreCase(command)) {
            String msg = safeAdminMessage(reason, "Warning.");
            SFSObject payload = buildAdminMessagePayload(msg, traceId);
            trace(buildSendLog("adminMessage", traceId, result.user, payload));
            sendAdminMessage(result.user, payload);
        } else if ("kick".equalsIgnoreCase(command)) {
            String msg = safeAdminMessage(reason, "You were kicked.");
            SFSObject payload = buildAdminMessagePayload(msg, traceId);
            trace(buildSendLog("adminMessage", traceId, result.user, payload));
            sendAdminMessage(result.user, payload);
            kickUserHard(result.user, traceId);
        } else {
            ok = false;
            errorCode = "UNKNOWN_COMMAND";
        }

        SFSObject res = new SFSObject();
        res.putBool("ok", ok);
        res.putUtfString("command", command == null ? "" : command);
        res.putInt("isPervert", isPervert);
        res.putUtfString("trace", traceId);
        if (!ok) {
            res.putUtfString("errorCode", errorCode == null ? "FAILED" : errorCode);
            res.putUtfString("message", "moderation_target");
        }
        sendResponseWithRid("ingamereport", res, sender, rid);

        trace("[INGAME_REPORT] cmd=" + command
                + " sender=" + sender.getName()
                + " avatarID=" + avatarId
                + " reason=" + reason
                + " ok=" + ok
                + " errorCode=" + (errorCode == null ? "" : errorCode)
                + " trace=" + traceId);
    }

    private ResolveResult resolveTarget(String traceId, String rawId) {
        Zone z = getZone();
        if (z == null) return new ResolveResult(null, "zone:null", 0);
        String raw = rawId == null ? "" : rawId;
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

        trace("[MOD_TGT_FAIL] trace=" + traceId + " reason=TARGET_NOT_FOUND");
        return new ResolveResult(null, "not-found", candidatesChecked);
    }

    private boolean matchesNormalized(String rawInput, String candidate, String normalizedInput) {
        if (candidate == null || rawInput == null) return false;
        String normalizedCandidate = HandlerUtils.normalizeAvatarId(candidate);
        if (normalizedInput != null && normalizedInput.equals(normalizedCandidate)) return true;
        return rawInput.equals(candidate);
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

    private boolean kickUserHard(User target, String traceId) {
        if (target == null) return false;
        boolean ok = false;
        int[] retries = new int[]{0};
        try {
            getApi().disconnectUser(target);
            ok = true;
        } catch (Exception ignored) {}
        scheduleKickRetry(target, traceId, retries);
        trace("[MOD_KICK] trace=" + traceId + " target=" + target.getName() + " disconnected=" + ok + " retry=" + retries[0]);
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

    private SFSObject buildAdminMessagePayload(String message, String traceId) {
        SFSObject payload = new SFSObject();
        payload.putUtfString("title", "Municipalty Message");
        payload.putUtfString("message", safeAdminMessage(message, "Warning."));
        payload.putInt("ts", (int) (System.currentTimeMillis() / 1000));
        payload.putUtfString("trace", traceId == null ? "" : traceId);
        return payload;
    }

    private boolean sendAdminMessage(User target, SFSObject payload) {
        if (target == null || payload == null) return false;
        try {
            getParentExtension().send("adminMessage", payload, target);
            return true;
        } catch (Exception ignored) {
            return false;
        }
    }

    private String safeAdminMessage(String message, String fallback) {
        if (message == null) return fallback;
        String trimmed = message.trim();
        if (trimmed.isEmpty()) return fallback;
        return trimmed;
    }

    private String buildSendLog(String cmd, String traceId, User target, SFSObject payload) {
        String targetName = target != null ? target.getName() : "null";
        String targetId = target != null ? HandlerUtils.readUserVarAsString(target, "avatarID", "avatarId", "avatarName") : "null";
        return "[MOD_SEND] cmd=" + cmd
                + " trace=" + traceId
                + " to=" + targetName
                + " avatarID=" + targetId
                + " payload=" + formatPayloadTypes(payload);
    }

    private String formatPayloadTypes(SFSObject payload) {
        if (payload == null) return "{}";
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (String key : payload.getKeys()) {
            if (!first) sb.append(", ");
            first = false;
            String type = "unknown";
            try {
                if (payload.getUtfString(key) != null) {
                    type = "str";
                }
            } catch (Exception ignored) {}
            try {
                payload.getInt(key);
                type = "int";
            } catch (Exception ignored) {}
            sb.append(key).append("(").append(type).append(")=").append(String.valueOf(payload.get(key)));
        }
        sb.append("}");
        return sb.toString();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
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

    private void logTarget(String traceId, User user, String matchMode, int candidatesChecked) {
        String name = user != null ? user.getName() : "null";
        String avatarId = HandlerUtils.readUserVarAsString(user, "avatarID", "avatarId");
        String avatarName = HandlerUtils.readUserVarAsString(user, "avatarName");
        String playerId = HandlerUtils.readUserVarAsString(user, "playerID", "playerId");
        trace("[MOD_TGT] trace=" + traceId
                + " found=" + (user != null)
                + " matchMode=" + matchMode
                + " targetName=" + name
                + " targetVars={avatarID:" + avatarId + ",avatarName:" + avatarName + ",playerID:" + playerId + "}"
                + " candidates=" + candidatesChecked);
    }
}

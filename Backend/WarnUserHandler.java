package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.Zone;

/**
 * Matches client GameRequest.WARN_USER / GameResponse.WARN_USER ("warnUser").
 * Client-side implementation varies; we deliver both a response and a direct message to target.
 */
public class WarnUserHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ISFSObject data = data(params);
        String targetAvatarId = readString(data, "avatarID", readString(data, "avatarId", readString(data, "targetId", "")));
        String message = readString(data, "message", readString(data, "msg", "Warning"));
        int rid = extractRid(params);

        trace("[WARN_USER] sender=" + sender.getName() + " target=" + targetAvatarId + " msg=" + message);

        User target = resolveTargetUser(targetAvatarId);

        SFSObject res = new SFSObject();
        res.putUtfString("targetId", targetAvatarId);
        res.putUtfString("message", message);
        res.putBool("ok", target != null);

        // reply to sender
        sendResponseWithRid("warnUser", res, sender, rid);

        if (target != null) {
            String traceId = "warnUser-" + target.getName() + "-" + System.currentTimeMillis();
            String safeMessage = safeAdminMessage(message, "Warning.");
            SFSObject adminMessage = new SFSObject();
            adminMessage.putUtfString("title", "Municipalty Message");
            adminMessage.putUtfString("message", safeMessage);
            adminMessage.putInt("ts", (int) (System.currentTimeMillis() / 1000));
            adminMessage.putUtfString("trace", traceId);
            trace(buildSendLog("adminMessage", traceId, target, adminMessage));
            getParentExtension().send("adminMessage", adminMessage, target);
            trace("[MOD_WARN_SEND] trace=" + traceId + " target=" + target.getName());

            getParentExtension().send("warnUser", res, target);
        }
    }

    private User resolveTargetUser(String avatarIdOrName) {
        if (avatarIdOrName == null || avatarIdOrName.trim().isEmpty()) return null;
        try {
            Zone z = getParentExtension().getParentZone();
            User u = z.getUserByName(avatarIdOrName);
            if (u != null) return u;
            for (User cand : z.getUserList()) {
                if (cand == null) continue;
                if (avatarIdOrName.equals(readUserVarAsString(cand, "avatarName", "avatarID", "avatarId"))) return cand;
                String playerIdVar = readUserVarAsString(cand, "playerID", "playerId");
                if (avatarIdOrName.equals(playerIdVar)) return cand;
                Object playerIdProp = cand.getProperty("playerID");
                if (playerIdProp != null && avatarIdOrName.equals(playerIdProp.toString())) return cand;
            }
        } catch (Exception ignored) {}
        return null;
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

    private String safeAdminMessage(String message, String fallback) {
        if (message == null) return fallback;
        String trimmed = message.trim();
        if (trimmed.isEmpty()) return fallback;
        return trimmed;
    }

    private String buildSendLog(String cmd, String traceId, User target, SFSObject payload) {
        String targetName = target != null ? target.getName() : "null";
        String targetId = target != null ? readUserVarAsString(target, "avatarID", "avatarId", "avatarName") : "null";
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
}

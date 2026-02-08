package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

/**
 * Matches client GameRequest.KICK_USER_FROM_BUSINESS / GameResponse.KICK_USER_FROM_BUSINESS ("kickUserFromBusiness").
 * We treat it as a hard kick (disconnect) because the client UI expects the user to be removed immediately.
 */
public class KickUserFromBusinessHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ISFSObject data = data(params);
        String targetAvatarId = readString(data, "avatarID", readString(data, "avatarId", readString(data, "targetId", "")));
        int rid = extractRid(params);

        trace("[KICK_BUSINESS] sender=" + sender.getName() + " target=" + targetAvatarId);

        User target = resolveTargetUser(targetAvatarId);

        SFSObject res = new SFSObject();
        res.putUtfString("targetId", targetAvatarId);
        res.putBool("ok", target != null);

        String traceId = "kickUserFromBusiness-" + targetAvatarId + "-" + System.currentTimeMillis();
        int[] retries = new int[]{0};
        if (target != null) {
            SFSObject adminMessage = new SFSObject();
            adminMessage.putUtfString("title", "Municipalty Message");
            adminMessage.putUtfString("message", "You were kicked.");
            adminMessage.putInt("ts", (int) (System.currentTimeMillis() / 1000));
            adminMessage.putUtfString("trace", traceId);
            trace(buildSendLog("adminMessage", traceId, target, adminMessage));
            try {
                getParentExtension().send("adminMessage", adminMessage, target);
            } catch (Exception ignored) {}
            try { getApi().disconnectUser(target); } catch (Exception ignored) {}
            scheduleKickRetry(target, traceId, retries);
        }
        trace("[MOD_KICK] trace=" + traceId + " target=" + (target != null ? target.getName() : "null") + " disconnected=" + (target != null) + " retry=" + retries[0]);

        sendResponseWithRid("kickUserFromBusiness", res, sender, rid);
    }

    private User resolveTargetUser(String avatarIdOrName) {
        if (avatarIdOrName == null || avatarIdOrName.trim().isEmpty()) return null;
        try {
            Zone z = getParentExtension().getParentZone();
            User u = z.getUserByName(avatarIdOrName);
            if (u != null) return u;
            for (User cand : z.getUserList()) {
                if (cand == null) continue;
                if (avatarIdOrName.equals(readUserVarAsString(cand, "avatarName", ""))) return cand;
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

    private void scheduleKickRetry(User target, String traceId, int[] retries) {
        if (target == null) return;
        Zone z = getParentExtension().getParentZone();
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

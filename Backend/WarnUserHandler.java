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
            // try multiple client listeners:
            // 1) "cmd2user" channel is widely supported
            SFSObject cmd2user = new SFSObject();
            cmd2user.putUtfString("type", "WARN");
            cmd2user.putUtfString("message", message);
            getParentExtension().send("cmd2user", cmd2user, target);

            // 2) also send "warnUser" directly
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
}

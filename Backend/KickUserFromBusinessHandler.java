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

        if (target != null) {
            try {
                // notify target before kick (best-effort)
                SFSObject msg = new SFSObject();
                msg.putUtfString("type", "KICK");
                msg.putUtfString("message", "You were kicked.");
                getParentExtension().send("cmd2user", msg, target);
            } catch (Exception ignored) {}
            try { getApi().disconnectUser(target); } catch (Exception ignored) {}
        }

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
}


package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.*;

/**
 * Guide sends message to requester (or any user) via "guidemessage".
 * Keys accepted: targetId / avatarID / avatarId / toId, message/text.
 * Sends "guidemessage" to target + ACK to sender.
 */
public class GuideMessageHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        int rid = extractRid(params);
        InMemoryStore store = getStore();

        if (!isGuideUser(sender, store)) {
            SFSObject denied = new SFSObject();
            denied.putBool("ok", false);
            denied.putUtfString("error", "NO_PERMISSION");
            sendResponseWithRid("guidemessage", denied, sender, rid);
            return;
        }

        ISFSObject data = data(params);
        String targetId = readStringAny(data, new String[]{"targetId","avatarID","avatarId","toId","id","uid"}, "");
        String targetName = readStringAny(data, new String[]{"targetName","toName","avatarName","name"}, "");
        String message = readStringAny(data, new String[]{"message","msg","text","body"}, "");

        User target = resolveTargetUser(targetId, targetName);
        if (target == null) {
            SFSObject res = new SFSObject();
            res.putBool("ok", false);
            res.putUtfString("error", "PLAYER_NOT_FOUND");
            sendResponseWithRid("guidemessage", res, sender, rid);
            return;
        }

        InMemoryStore.UserState st = store.getOrCreateUser(sender);
        String fromName = st.getAvatarName() != null ? st.getAvatarName() : sender.getName();

        SFSObject payload = new SFSObject();
        payload.putUtfString("from", fromName);
        payload.putUtfString("message", message);

        try {
            getParentExtension().send("guidemessage", payload, target);
        } catch (Exception ignored) {}

        SFSObject ok = new SFSObject();
        ok.putBool("ok", true);
        sendResponseWithRid("guidemessage", ok, sender, rid);
    }

    private boolean isGuideUser(User u, InMemoryStore store) {
        try {
            InMemoryStore.UserState st = store.getOrCreateUser(u);
            String roles = st.getRoles();
            return PermissionCodec.hasPermission(roles, AvatarPermissionIds.CARD_GUIDE)
                    || PermissionCodec.hasPermission(roles, AvatarPermissionIds.MODERATOR)
                    || PermissionCodec.hasPermission(roles, AvatarPermissionIds.SECURITY);
        } catch (Exception e) { return false; }
    }

    private User resolveTargetUser(String avatarIdOrName, String avatarNameFallback) {
        try {
            Zone z = getZone();
            if (z == null) return null;
            if (avatarIdOrName != null && !avatarIdOrName.trim().isEmpty()) {
                User u = z.getUserByName(avatarIdOrName);
                if (u != null) return u;
                for (User cand : z.getUserList()) {
                    try {
                        if (cand == null) continue;
                        if (avatarIdOrName.equals(readUserVarAsString(cand, "avatarName", "avatarID", "avatarId"))) return cand;
                        String playerIdVar = readUserVarAsString(cand, "playerID", "playerId");
                        if (avatarIdOrName.equals(playerIdVar)) return cand;
                        Object playerIdProp = cand.getProperty("playerID");
                        if (playerIdProp != null && avatarIdOrName.equals(playerIdProp.toString())) return cand;
                    } catch (Exception ignored) {}
                }
            }
            if (avatarNameFallback != null && !avatarNameFallback.trim().isEmpty()) {
                User u2 = z.getUserByName(avatarNameFallback);
                if (u2 != null) return u2;
                for (User cand : z.getUserList()) {
                    try {
                        if (cand == null) continue;
                        if (avatarNameFallback.equals(readUserVarAsString(cand, "avatarName", "avatarID", "avatarId"))) return cand;
                        String playerIdVar = readUserVarAsString(cand, "playerID", "playerId");
                        if (avatarNameFallback.equals(playerIdVar)) return cand;
                        Object playerIdProp = cand.getProperty("playerID");
                        if (playerIdProp != null && avatarNameFallback.equals(playerIdProp.toString())) return cand;
                    } catch (Exception ignored) {}
                }
            }
        } catch (Exception ignored) {}
        return null;
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
}

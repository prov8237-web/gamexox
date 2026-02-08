package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.Zone;
import java.util.List;

/**
 * Matches client GameRequest.BAN_USER / GameResponse.BAN_USER ("banUser").
 * Also notifies the target client using extension message "banned" like BanModel expects.
 */
public class BanUserHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ISFSObject data = data(params);

        String targetAvatarId = readString(data, "avatarID", readString(data, "avatarId", readString(data, "targetId", "")));
        String banType = readString(data, "type", readString(data, "banType", "CHAT"));
        int duration = readInt(data, "duration", readInt(data, "time", readInt(data, "seconds", -1)));
        boolean unban = readBool(data, "unban", false) || readBool(data, "remove", false);

        int rid = extractRid(params);

        trace("[BAN_USER] sender=" + sender.getName() + " target=" + targetAvatarId + " type=" + banType + " duration=" + duration + " unban=" + unban);

        User target = resolveTargetUser(targetAvatarId);
        InMemoryStore store = getStore();

        SFSObject res = new SFSObject();
        res.putUtfString("targetId", targetAvatarId);
        res.putUtfString("type", banType);

        if (target == null) {
            res.putBool("ok", false);
            res.putUtfString("error", "PLAYER_NOT_FOUND");
            sendResponseWithRid("banUser", res, sender, rid);
            return;
        }

        String ip = target.getSession().getAddress();

        if (unban || duration == 0) {
            boolean removed = store.removeBanForIp(ip, banType);
            res.putBool("ok", removed);

            // notify target
            SFSObject payload = new SFSObject();
            payload.putUtfString("type", banType);
            getParentExtension().send("unbanned", payload, target);

            sendResponseWithRid("banUser", res, sender, rid);
            return;
        }

        InMemoryStore.BanRecord rec = store.addBanForIp(ip, banType, duration);
        res.putBool("ok", rec != null);
        if (rec != null) {
            store.incrementBanCount(targetAvatarId);
        }

        // notify target (client BanModel listens "banned")
        if (rec != null) {
            long now = System.currentTimeMillis() / 1000;
            String traceId = "banUser-" + target.getName() + "-" + System.currentTimeMillis();
            SFSObject payload = HandlerUtils.buildBannedPayload(banType, rec, now, traceId);
            getParentExtension().send("banned", payload, target);
            trace("[MOD_BAN_SEND] trace=" + traceId + " type=" + banType + " timeLeft=" + payload.getInt("timeLeft"));

            // if LOGIN ban: disconnect immediately
            if ("LOGIN".equalsIgnoreCase(banType)) {
                try {
                    getApi().disconnectUser(target);
                } catch (Exception ignored) {}
            }
        }

        sendResponseWithRid("banUser", res, sender, rid);
    }

    private User resolveTargetUser(String avatarIdOrName) {
        if (avatarIdOrName == null || avatarIdOrName.trim().isEmpty()) return null;
        try {
            Zone z = getZone();
            if (z == null) return null;
            User u = z.getUserByName(avatarIdOrName);
            if (u != null) return u;

            // fallback: match avatarName variable
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

    private static int readInt(ISFSObject obj, String key, int def) {
        try {
            if (obj != null && obj.containsKey(key)) {
                try { return obj.getInt(key); } catch (Exception ignored) {}
                try { Double d = obj.getDouble(key); return d == null ? def : d.intValue(); } catch (Exception ignored2) {}
            }
        } catch (Exception ignored) {}
        return def;
    }

    private static boolean readBool(ISFSObject obj, String key, boolean def) {
        try {
            if (obj != null && obj.containsKey(key)) return obj.getBool(key);
        } catch (Exception ignored) {}
        return def;
    }
}

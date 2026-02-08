package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class KickAvatarFromRoomHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ISFSObject data = data(params);
        String avatarId = readField(data, "avatarID", readField(data, "avatarId", "Unknown"));
        double duration = readDouble(data, "duration", 0.0);
        int rid = extractRid(params);

        trace("[KICK_AVATAR] handler=KickAvatarFromRoomHandler avatarID=" + avatarId + " duration=" + duration + " sender=" + sender.getName());

        User target = resolveTargetUser(avatarId);

        SFSObject res = new SFSObject();
        res.putUtfString("targetId", avatarId);
        res.putBool("ok", target != null);

        // best effort notify + kick
        if (target != null) {
            try {
                SFSObject msg = new SFSObject();
                msg.putUtfString("type", "KICK");
                msg.putUtfString("message", "You were kicked from the room.");
                getParentExtension().send("cmd2user", msg, target);
            } catch (Exception ignored) {}

            try {
                getApi().disconnectUser(target);
            } catch (Exception ignored) {}
        }

        trace("RID_CHECK cmd=kickAvatarFromRoom reqRid=" + rid + " resRid=" + rid + " avatarID=" + avatarId);
        sendResponseWithRid("kickAvatarFromRoom", res, sender, rid);
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

    private String readField(ISFSObject data, String key, String fallback) {
        if (data == null || key == null || !data.containsKey(key)) {
            return fallback;
        }
        try {
            String value = data.getUtfString(key);
            return value == null || value.trim().isEmpty() ? fallback : value;
        } catch (Exception ignored) {
            return fallback;
        }
    }

    private double readDouble(ISFSObject data, String key, double fallback) {
        if (data == null || key == null || !data.containsKey(key)) {
            return fallback;
        }
        try {
            return data.getDouble(key);
        } catch (Exception ignored) {
            try {
                return data.getInt(key);
            } catch (Exception ignored2) {
                return fallback;
            }
        }
    }
}

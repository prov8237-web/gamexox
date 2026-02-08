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

        String traceId = "kickAvatarFromRoom-" + avatarId + "-" + System.currentTimeMillis();
        // best effort notify + kick
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

            try {
                getApi().disconnectUser(target);
            } catch (Exception ignored) {}
            scheduleKickRetry(target, traceId, retries);
        }

        trace("[MOD_KICK] trace=" + traceId + " target=" + (target != null ? target.getName() : "null") + " disconnected=" + (target != null) + " retry=" + retries[0]);
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

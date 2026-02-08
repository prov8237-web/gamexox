package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.List;

public class BanInfoHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ISFSObject data = data(params);
        int rid = extractRid(params);

        String rawAvatarId = readString(data, "avatarID", readString(data, "avatarId", ""));
        String normalizedAvatarId = HandlerUtils.normalizeAvatarId(rawAvatarId);

        trace("[REPORT_BANINFO_REQ] sender=" + sender.getName() + " avatarID=" + rawAvatarId + " normalized=" + normalizedAvatarId);

        InMemoryStore store = getStore();
        int banCount = store.getBanCount(normalizedAvatarId);
        int nextBanMin = 0;
        int totalMins = 0;
        boolean banStatus = false;
        long expireSecond = 0;

        User target = resolveTargetUser(rawAvatarId, normalizedAvatarId);
        if (target != null) {
            try {
                String ip = target.getSession().getAddress();
                long now = System.currentTimeMillis() / 1000;
                List<InMemoryStore.BanRecord> active = store.getActiveBansForIp(ip);
                for (InMemoryStore.BanRecord br : active) {
                    if (br == null) continue;
                    if (!"CHAT".equalsIgnoreCase(br.type)) continue;
                    banStatus = true;
                    int timeLeftSec = br.timeLeftSec(now);
                    if (timeLeftSec >= 0) {
                        expireSecond = (long) timeLeftSec * 1000L;
                        totalMins = timeLeftSec / 60;
                    }
                    break;
                }
            } catch (Exception ignored) {}
        }

        SFSObject res = new SFSObject();
        res.putInt("banCount", banCount);
        res.putInt("totalMins", totalMins);
        res.putInt("nextBanMin", nextBanMin);
        res.putInt("nextRequest", 0);
        if (banStatus) {
            res.putBool("banStatus", true);
            res.putLong("expireSecond", expireSecond);
        }

        trace("[REPORT_BANINFO_RES] avatarID=" + normalizedAvatarId + " banCount=" + banCount + " totalMins=" + totalMins + " nextBanMin=" + nextBanMin + " banStatus=" + banStatus);

        sendResponseWithRid("baninfo", res, sender, rid);
    }

    private User resolveTargetUser(String avatarIdOrName, String normalizedId) {
        try {
            Zone z = getZone();
            if (z == null) return null;
            if (avatarIdOrName != null && !avatarIdOrName.trim().isEmpty()) {
                User u = z.getUserByName(avatarIdOrName);
                if (u != null) return u;
            }
            for (User cand : z.getUserList()) {
                if (cand == null) continue;
                String avatarNameVar = HandlerUtils.readUserVarAsString(cand, "avatarName", "avatarID", "avatarId");
                if (matchesNormalized(avatarNameVar, normalizedId)) return cand;
                String playerIdVar = HandlerUtils.readUserVarAsString(cand, "playerID", "playerId");
                if (matchesNormalized(playerIdVar, normalizedId)) return cand;
                Object playerIdProp = cand.getProperty("playerID");
                if (playerIdProp != null && matchesNormalized(playerIdProp.toString(), normalizedId)) return cand;
            }
        } catch (Exception ignored) {}
        return null;
    }

    private boolean matchesNormalized(String candidate, String normalizedTarget) {
        if (candidate == null || normalizedTarget == null) return false;
        return HandlerUtils.normalizeAvatarId(candidate).equals(HandlerUtils.normalizeAvatarId(normalizedTarget));
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

package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class ProfileImproperHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        String avatarId = readField(data, "avatarID", "Unknown");
        String action = readField(data, "action", "unknown");
        int rid = extractRid(params);

        trace("[PROFILEIMPROPER] avatarID=" + avatarId + " action=" + action + " user=" + user.getName());
        InMemoryStore store = getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);
        String normalized = action == null ? "" : action.toLowerCase();
        boolean changed = false;
        boolean blocked = state.isBlocked(avatarId);

        if ("block".equals(normalized) || "ban".equals(normalized) || "silence".equals(normalized)) {
            state.blockUser(avatarId);
            blocked = true;
            changed = true;
        } else if ("unblock".equals(normalized) || "unban".equals(normalized) || "unsilence".equals(normalized)) {
            state.unblockUser(avatarId);
            blocked = false;
            changed = true;
        }

        SFSObject res = new SFSObject();
        res.putBool("ok", true);
        res.putUtfString("action", normalized);
        res.putBool("blocked", blocked);
        res.putBool("changed", changed);
        trace("RID_CHECK cmd=profileimproper reqRid=" + rid + " resRid=" + rid + " avatarID=" + avatarId);
        sendResponseWithRid("profileimproper", res, user, rid);
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
}

package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class ProfileLikeHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        String avatarId = readField(data, "avatarID", "Unknown");
        int avatarLike = readInt(data, "avatarLike", 0);
        int rid = extractRid(params);

        trace("[PROFILELIKE] avatarID=" + avatarId + " like=" + avatarLike + " user=" + user.getName());

        InMemoryStore store = getStore();
        InMemoryStore.ProfileData profile = store.getOrCreateProfile(avatarId, avatarId);
        profile.applyLikeStatus(user.getName(), avatarLike);

        int likeCount = profile.getLikeCount();
        int dislikeCount = profile.getDislikeCount();
        int totalVotes = likeCount + dislikeCount;

        SFSObject res = new SFSObject();
        res.putInt("likeCount", likeCount);
        res.putInt("dislikeCount", dislikeCount);
        res.putDouble("rating", totalVotes > 0 ? 1.0 + (likeCount * 4.0 / totalVotes) : 0.0);
        res.putBool("success", true);
        res.putInt("userLikeStatus", profile.getUserLikeStatus(user.getName()));
        
        trace("RID_CHECK cmd=profilelike reqRid=" + rid + " resRid=" + rid + " avatarID=" + avatarId);
        sendResponseWithRid("profilelike", res, user, rid);
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

    private int readInt(ISFSObject data, String key, int fallback) {
        if (data == null || key == null || !data.containsKey(key)) {
            return fallback;
        }
        try {
            return data.getInt(key);
        } catch (Exception ignored) {
            return fallback;
        }
    }
}

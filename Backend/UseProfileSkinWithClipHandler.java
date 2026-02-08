package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class UseProfileSkinWithClipHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        String clip = readField(data, "clip", "0");
        int rid = extractRid(params);

        trace("[USE_PROFILE_SKIN] clip=" + clip + " user=" + user.getName());
        InMemoryStore store = getStore();
        InMemoryStore.ProfileData profile = store.getOrCreateProfile(user.getName(), user.getName());

        InMemoryStore.ProfileSkinDefinition def = store.findProfileSkinDefinition(clip);
        InMemoryStore.ProfileSkin skin;
        if (def != null) {
            skin = new InMemoryStore.ProfileSkin(def.getClip(), def.getBgColor(), def.getAlpha(), def.getTextColor(), def.getRoles());
        } else {
            skin = new InMemoryStore.ProfileSkin(clip, "FEFFF2", "1", "fdeed5", "");
        }
        profile.setSkin(skin);

        SFSObject res = new SFSObject();
        res.putBool("ok", true);
        res.putUtfString("clip", clip);
        res.putSFSObject("skin", skin.toSFSObject());
        trace("RID_CHECK cmd=useprofileskinwithclip reqRid=" + rid + " resRid=" + rid + " avatarID=unknown");
        sendResponseWithRid("useprofileskinwithclip", res, user, rid);
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

package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class ProfileSkinListHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        int page = readInt(data, "page", 1);
        String search = readField(data, "search", "");
        String sort = readField(data, "sort", "created_desc");
        int rid = extractRid(params);

        trace("[PROFILESKINLIST] page=" + page + " search=" + search + " sort=" + sort + " user=" + user.getName());

        SFSObject res = new SFSObject();
        
        InMemoryStore store = getStore();
        InMemoryStore.ProfileData profile = store.getOrCreateProfile(user.getName(), user.getName());
        String selectedClip = profile.getSkin() != null ? profile.getSkin().getClip() : "";

        // إنشاء قائمة السكنات
        SFSArray skinList = new SFSArray();
        int index = 0;

        for (InMemoryStore.ProfileSkinDefinition def : store.getProfileSkins()) {
            SFSObject skin = new SFSObject();
            skin.putUtfString("clip", def.getClip());

            SFSObject property = new SFSObject();
            property.putUtfString("bgColor", def.getBgColor());
            property.putUtfString("alpha", def.getAlpha());
            property.putUtfString("cn", "ProfileSkinProperty");
            property.putUtfString("textColor", def.getTextColor());
            skin.putSFSObject("property", property);

            skin.putUtfString("roles", def.getRoles());
            skin.putUtfString("name", def.getName());
            skin.putUtfString("author", def.getAuthor());
            skin.putInt("id", def.getId());
            skin.putInt("likes", 50 + (index * 10));
            skin.putInt("uses", 100 + (index * 20));
            skin.putBool("isPublic", true);
            skin.putLong("created", System.currentTimeMillis() - (index * 86400000L));
            skin.putBool("selected", def.getClip().equals(selectedClip));

            skinList.addSFSObject(skin);
            index++;
        }
        
        SFSObject items = new SFSObject();
        items.putSFSArray("list", skinList);
        items.putInt("total", skinList.size());
        items.putInt("pages", 1);
        
        res.putSFSObject("items", items);
        res.putInt("pageSelected", page);
        res.putInt("totalSkins", skinList.size());
        res.putBool("hasMore", false);
        
        trace("RID_CHECK cmd=profileskinlist reqRid=" + rid + " resRid=" + rid + " avatarID=unknown");
        sendResponseWithRid("profileskinlist", res, user, rid);
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

package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import java.util.ArrayList;
import java.util.List;

public class ChangeSettingsHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        int rid = extractRid(params);

        String newName = readStringAny(data, new String[]{"avatarName", "name", "nickname", "nick", "displayName"}, null);
        String status = readStringAny(data, new String[]{"status", "description", "bio", "about", "message"}, null);
        String city = readStringAny(data, new String[]{"city", "avatarCity"}, null);
        String age = readStringAny(data, new String[]{"age", "avatarAge"}, null);

        InMemoryStore store = getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);
        InMemoryStore.ProfileData profile = store.getOrCreateProfile(user.getName(), state.getAvatarName());

        List<UserVariable> vars = new ArrayList<>();

        if (newName != null && !newName.trim().isEmpty() && !newName.equals(state.getAvatarName())) {
            store.releaseDisplayName(state.getAvatarName());
            String uniqueName = store.ensureUniqueDisplayName(newName, user.getId());
            state.setAvatarName(uniqueName);
            profile.setAvatarName(uniqueName);
            vars.add(new SFSUserVariable("avatarName", uniqueName));
        }

        if (status != null) {
            state.setStatusMessage(status);
            profile.setStatusMessage(status);
        }

        if (city != null) {
            profile.setCity(city);
        }

        if (age != null) {
            profile.setAge(age);
        }

        if (!vars.isEmpty()) {
            getApi().setUserVariables(user, vars);
        }

        SFSObject res = new SFSObject();
        res.putBool("ok", true);
        res.putUtfString("avatarName", profile.getAvatarName());
        res.putUtfString("status", profile.getStatusMessage());
        res.putUtfString("avatarCity", profile.getCity());
        res.putUtfString("avatarAge", profile.getAge());

        sendResponseWithRid("changesettings", res, user, rid);
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

package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import java.util.ArrayList;
import java.util.List;

public class NickChangeHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        int rid = extractRid(params);

        String newName = readStringAny(data, new String[]{"name", "avatarName", "nickname", "nick"}, null);

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

        if (!vars.isEmpty()) {
            getApi().setUserVariables(user, vars);
        }

        SFSObject res = new SFSObject();
        res.putBool("ok", true);
        res.putUtfString("avatarName", profile.getAvatarName());

        sendResponseWithRid("nickChange", res, user, rid);
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

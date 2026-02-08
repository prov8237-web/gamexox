package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class QuestListHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[QUESTLIST] Request from: " + user.getName());
        InMemoryStore.UserState state = getStore().getOrCreateUser(user);
        SFSObject res = new SFSObject();
        res.putSFSArray("quests", state.getQuests());
        res.putInt("nextRequest", 1000);

        reply(user, "questlist", res);
        trace("[QUESTLIST] ✅ Response sent");
    }
}

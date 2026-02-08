package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class QuestActionHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String ip = user.getSession().getAddress();
        InMemoryStore.UserState state = getStore().getOrCreateUser(user);
        String questId = null;
        ISFSObject data = data(params);
        if (data != null && data.containsKey("id")) {
            questId = String.valueOf(data.getInt("id"));
        }

        if (questId == null) {
            trace("[QUESTACTION] Missing quest id");
            if (ProtocolConfig.strictProtocol()) {
                throw new IllegalStateException("Strict protocol: questaction missing id");
            }
            SFSObject error = new SFSObject();
            error.putUtfString("errorCode", "MISSING_ID");
            error.putUtfString("message", "Missing quest id");
            send("questaction", error, user);
            return;
        }

        String key = ip + "_quest_" + questId;
        Object saved = getParentExtension().getParentZone().getProperty(key);
        int curVal = saved instanceof Integer ? (Integer) saved : 0;
        int reqVal = 1;

        curVal = Math.min(curVal + 1, reqVal);
        getParentExtension().getParentZone().setProperty(key, curVal);

        SFSObject res = new SFSObject();
        res.putInt("curVal", curVal);
        res.putInt("reqVal", reqVal);
        res.putInt("id", Integer.parseInt(questId));
        reply(user, "questaction", res);

        if (state.getQuests().size() == 0) {
            ISFSArray quests = state.getQuests();
            SFSObject quest = new SFSObject();
            quest.putInt("id", Integer.parseInt(questId));
            quest.putInt("currentStep", curVal);
            quest.putInt("totalStep", reqVal);
            quest.putUtfString("status", curVal >= reqVal ? "COMPLETED" : "ONGOING");
            quests.addSFSObject(quest);
        }

        trace("[QUESTACTION] ✅ Quest " + questId + " progress " + curVal + "/" + reqVal);
    }
}

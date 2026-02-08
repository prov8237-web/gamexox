package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import java.util.ArrayList;
import java.util.List;

public class UseChatBalloonHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        InMemoryStore.UserState state = getStore().getOrCreateUser(user);

        if (data == null || !data.containsKey("id")) {
            trace("[USECHATBALLOON] Missing id");
            if (ProtocolConfig.strictProtocol()) {
                throw new IllegalStateException("Strict protocol: usechatballoon missing id");
            }
            SFSObject error = new SFSObject();
            error.putUtfString("errorCode", "MISSING_ID");
            error.putUtfString("message", "Missing id");
            send("usechatballoon", error, user);
            return;
        }

        int id = data.getInt("id");
        List<UserVariable> vars = new ArrayList<>();
        vars.add(new SFSUserVariable("chatBalloon", String.valueOf(id)));
        getApi().setUserVariables(user, vars);
        state.setChatBalloon(String.valueOf(id));

        SFSObject res = new SFSObject();
        res.putInt("id", id);
        reply(user, "usechatballoon", res);

        trace("[USECHATBALLOON] ✅ chatBalloon set to " + id);
    }
}

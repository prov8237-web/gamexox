package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class ChangeStatusMessageHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String message = params.getUtfString("message");
        
        trace("📝 ChangeStatusMessage - User: " + user.getName() + 
              " | Message: " + message);
        
        MainExtension ext = (MainExtension) getParentExtension();
        InMemoryStore store = ext.getStore();
        
        InMemoryStore.UserState userState = store.getOrCreateUser(user);
        userState.setStatusMessage(message);
        
        ext.markResponseSent("changestatusmessage", user);
        
        ISFSObject res = new SFSObject();
        res.putUtfString("status", "ok");
        res.putUtfString("message", "Status message updated");
        
        // Broadcast status change to buddies
        SFSObject broadcast = new SFSObject();
        broadcast.putUtfString("cmd", "buddy.changestatusmessage");
        String avatarId = HandlerUtils.readUserVarAsString(user, "avatarID", "avatarId", "playerID", "playerId");
        if (avatarId == null || avatarId.trim().isEmpty()) {
            avatarId = user.getName();
        }
        broadcast.putUtfString("avatarID", avatarId);
        broadcast.putUtfString("message", message);
        
        getParentExtension().send("buddy.changestatusmessage", broadcast, user);
        
        send("changestatusmessage", res, user);
    }
}

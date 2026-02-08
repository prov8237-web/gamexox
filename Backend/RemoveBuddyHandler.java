package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class RemoveBuddyHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = params.containsKey("data") ? params.getSFSObject("data") : params;
        String avatarID = data != null ? data.getUtfString("avatarID") : null;
        
        trace("🗑️ RemoveBuddy - User: " + user.getName() + 
              " | Removing buddy: " + avatarID);
        if (avatarID == null || avatarID.trim().isEmpty()) {
            return;
        }
        
        MainExtension ext = (MainExtension) getParentExtension();
        InMemoryStore store = ext.getStore();
        
        // Remove buddy relationship
        store.removeBuddy(user.getName(), avatarID);
        
        ext.markResponseSent("removebuddy", user);
        
        ISFSObject res = new SFSObject();
        res.putUtfString("status", "ok");
        res.putUtfString("avatarID", avatarID);
        res.putUtfString("message", "Buddy removed successfully");
        
        // Broadcast buddy removed
        SFSObject broadcast = new SFSObject();
        broadcast.putUtfString("cmd", "buddyRemoved");
        broadcast.putUtfString("avatarID", avatarID);
        
        getParentExtension().send("buddyRemoved", broadcast, user);
        User buddy = getApi().getUserByName(avatarID);
        if (buddy != null) {
            SFSObject back = new SFSObject();
            back.putUtfString("cmd", "buddyRemoved");
            back.putUtfString("avatarID", user.getName());
            getParentExtension().send("buddyRemoved", back, buddy);
        }
        
        send("removebuddy", res, user);
    }
}

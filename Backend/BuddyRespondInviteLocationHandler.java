package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class BuddyRespondInviteLocationHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String avatarID = params.getUtfString("avatarID");
        int response = params.getInt("response");
        
        trace("🎯 BuddyRespondInviteLocation - User: " + user.getName() + 
              " | Response: " + response + " | Target: " + avatarID);
        
        MainExtension ext = (MainExtension) getParentExtension();
        ext.markResponseSent("buddyrespondinvitelocation", user);
        
        ISFSObject res = new SFSObject();
        res.putUtfString("status", "ok");
        res.putUtfString("message", "Location invite response processed");
        
        send("buddyrespondinvitelocation", res, user);
    }
}
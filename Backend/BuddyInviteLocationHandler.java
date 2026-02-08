package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class BuddyInviteLocationHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String avatarID = params.getUtfString("avatarID");
        
        trace("📍 BuddyInviteLocation - User: " + user.getName() + 
              " | Inviting: " + avatarID);
        
        MainExtension ext = (MainExtension) getParentExtension();
        ext.markResponseSent("buddyinvitelocation", user);
        
        ISFSObject res = new SFSObject();
        res.putUtfString("status", "ok");
        res.putUtfString("avatarID", user.getName());
        res.putUtfString("universe", "w8");
        res.putUtfString("street", "3");
        res.putInt("flat", 0);
        
        send("buddyinvitelocation", res, user);
    }
}
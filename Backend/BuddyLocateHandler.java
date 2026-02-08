package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class BuddyLocateHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String avatarID = params.getUtfString("avatarID");
        
        trace("🔍 BuddyLocate - User: " + user.getName() + 
              " | Locating: " + avatarID);
        
        MainExtension ext = (MainExtension) getParentExtension();
        ext.markResponseSent("buddylocate", user);
        
        ISFSObject res = new SFSObject();
        res.putUtfString("universe", "w8");
        res.putUtfString("street", "3");
        res.putInt("flat", 0);
        res.putUtfString("avatarID", avatarID);
        
        send("buddylocate", res, user);
    }
}
package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class BuddyAcceptInviteGameHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String avatarID = params.getUtfString("avatarID");
        String game = params.getUtfString("game");
        String key = params.getUtfString("key");
        
        trace("🎮 BuddyAcceptInviteGame - User: " + user.getName() + 
              " | Game: " + game + " | Key: " + key + " | From: " + avatarID);
        
        MainExtension ext = (MainExtension) getParentExtension();
        ext.markResponseSent("buddyacceptinvitegame", user);
        
        ISFSObject res = new SFSObject();
        res.putUtfString("status", "ok");
        res.putUtfString("game", game);
        res.putUtfString("key", key);
        res.putUtfString("inviterID", avatarID);
        
        send("buddyacceptinvitegame", res, user);
    }
}
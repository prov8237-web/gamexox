package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class ChangeBuddyRatingHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String avatarID = params.getUtfString("avatarID");
        int rating = params.getInt("rating");
        
        trace("⭐ ChangeBuddyRating - User: " + user.getName() + 
              " | Rating: " + rating + " | For: " + avatarID);
        
        MainExtension ext = (MainExtension) getParentExtension();
        InMemoryStore store = ext.getStore();
        
        ext.markResponseSent("changebuddyrating", user);
        
        ISFSObject res = new SFSObject();
        res.putUtfString("status", "ok");
        res.putUtfString("avatarID", avatarID);
        res.putInt("myRating", rating);
        res.putUtfString("message", "Buddy rating updated");
        
        // Broadcast relation change
        SFSObject broadcast = new SFSObject();
        broadcast.putUtfString("cmd", "buddyRelationUpdated");
        broadcast.putUtfString("avatarID", user.getName());
        broadcast.putInt("buddyRating", rating);
        broadcast.putInt("myRating", rating);
        
        getParentExtension().send("buddyRelationUpdated", broadcast, user);
        
        send("changebuddyrating", res, user);
    }
}
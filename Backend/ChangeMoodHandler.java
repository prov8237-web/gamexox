package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class ChangeMoodHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        int mood = params.getInt("mood");
        
        trace("😊 ChangeMood - User: " + user.getName() + 
              " | Mood: " + mood);
        
        MainExtension ext = (MainExtension) getParentExtension();
        InMemoryStore store = ext.getStore();
        
        InMemoryStore.UserState userState = store.getOrCreateUser(user);
        userState.setMood(mood);
        
        ext.markResponseSent("changemood", user);
        
        ISFSObject res = new SFSObject();
        res.putUtfString("status", "ok");
        res.putInt("mood", mood);
        res.putUtfString("avatarID", user.getName());
        
        // Broadcast mood change to buddies
        SFSObject broadcast = new SFSObject();
        broadcast.putUtfString("cmd", "buddy.moodchanged");
        broadcast.putUtfString("avatarID", user.getName());
        broadcast.putInt("mood", mood);
        
        getParentExtension().send("buddy.moodchanged", broadcast, user);
        
        send("changemood", res, user);
    }
}
package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class BuddyListHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[BUDDYLIST] Request from: " + user.getName());
        InMemoryStore store = getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);
        
        SFSObject res = new SFSObject();
        
        // استخدام البيانات الفعلية من الـ store
        ISFSArray buddiesArray = store.buildBuddyListArray(user.getName());
        ISFSArray requestsArray = store.buildBuddyRequestsArray(user.getName());
        state.setBuddies(buddiesArray);
        
        res.putSFSArray("buddies", buddiesArray);
        res.putSFSArray("requests", requestsArray);
        res.putInt("nextRequest", 10000);  // Official uses 10000 for buddylist
        
        reply(user, "buddylist", res);
        trace("[BUDDYLIST] ✅ Sent " + buddiesArray.size() + " buddies and " + requestsArray.size() + " requests");
    }
}

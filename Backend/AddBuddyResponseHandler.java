package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class AddBuddyResponseHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = params.containsKey("data") ? params.getSFSObject("data") : params;
        String avatarID = data != null ? data.getUtfString("avatarID") : null;
        String response = data != null ? data.getUtfString("response") : null;
        
        trace("🤝 AddBuddyResponse - User: " + user.getName() + 
              " | Response: " + response + " | From: " + avatarID);
        
        MainExtension ext = (MainExtension) getParentExtension();
        InMemoryStore store = ext.getStore();
        
        // Find pending request between these users
        InMemoryStore.BuddyRequest pendingRequest = null;
        for (InMemoryStore.BuddyRequest req : store.getIncomingRequests(user.getName())) {
            if (req.getRequesterId().equals(avatarID) && 
                "PENDING".equals(req.getStatus())) {
                pendingRequest = req;
                break;
            }
        }
        
        if (pendingRequest != null) {
            if ("ACCEPTED".equals(response)) {
                store.acceptBuddyRequest(pendingRequest.getRequestId());
            } else if ("REJECTED".equals(response)) {
                store.rejectBuddyRequest(pendingRequest.getRequestId());
            }
        }
        
        ext.markResponseSent("addbuddyresponse", user);
        
        ISFSObject res = new SFSObject();
        res.putUtfString("status", "ok");
        res.putUtfString("response", response);
        res.putUtfString("avatarID", avatarID);
        res.putSFSArray("requests", store.buildBuddyRequestsArray(user.getName()));
        
        // Send response to requester
        User requester = avatarID != null ? getApi().getUserByName(avatarID) : null;
        if ("ACCEPTED".equals(response)) {
            if (requester != null) {
                SFSObject requesterAdded = store.buildBuddyEntry(user.getName());
                getParentExtension().send("buddyAdded", requesterAdded, requester);
            }
            if (avatarID != null) {
                SFSObject receiverAdded = store.buildBuddyEntry(avatarID);
                getParentExtension().send("buddyAdded", receiverAdded, user);
            }
        }
        
        send("addbuddyresponse", res, user);
    }
}

package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class AddBuddyHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = params.containsKey("data") ? params.getSFSObject("data") : params;
        String avatarID = data != null ? data.getUtfString("avatarID") : null;
        
        trace("➕ AddBuddy - User: " + user.getName() + 
              " | Adding buddy: " + avatarID);
        if (avatarID == null || avatarID.trim().isEmpty()) {
            return;
        }
        
        MainExtension ext = (MainExtension) getParentExtension();
        ext.markResponseSent("addbuddy", user);
        
        // ⭐⭐ RESPONSE FIRST - هذا أهم حاجة ⭐⭐
        ISFSObject res = new SFSObject();
        res.putInt("nextRequest", 2000);  // ⭐⭐ دي اللي الكلاينت بيستناها ⭐⭐
        send("addbuddy", res, user);
        trace("✅ AddBuddy response sent with nextRequest: 2000");
        
        // ⭐⭐ BACKGROUND PROCESSING ⭐⭐
        try {
            InMemoryStore store = ext.getStore();
            InMemoryStore.UserState userState = store.getOrCreateUser(user);
            String senderId = user.getName();
            String senderName = userState.getAvatarName();
            
            // 1. Check if this is a numeric ID (like official: "101279326")
            boolean isNumericID = avatarID.matches("\\d+");
            
            // 2. Find actual user by name or ID
            String actualReceiverName = avatarID;
            User receiver = null;
            
            // Try to find by name first (for Guest#4 cases)
            receiver = getApi().getUserByName(avatarID);
            
            // If not found and it's numeric, try to find by playerID property
            if (receiver == null && isNumericID) {
                for (User u : getParentExtension().getParentZone().getUserList()) {
                    Object playerIDProp = u.getProperty("playerID");
                    if (playerIDProp != null && playerIDProp.toString().equals(avatarID)) {
                        receiver = u;
                        actualReceiverName = u.getName();
                        break;
                    }
                }
            }
            
            if (store.areBuddies(senderId, actualReceiverName) || store.hasPendingRequest(senderId, actualReceiverName)) {
                trace("ℹ️ Buddy request ignored (already buddy/pending): " + senderId + " -> " + actualReceiverName);
                return;
            }

            // 3. Add to buddy requests (store-level)
            long requestId = store.createBuddyRequest(senderId, senderName, actualReceiverName, actualReceiverName);
            
            // 4. Send notification if receiver is online
            if (receiver != null) {
                SFSObject notification = new SFSObject();
                notification.putUtfString("cmd", "respondBuddyRequest");
                notification.putUtfString("avatarID", senderId);
                notification.putUtfString("avatarName", senderName);
                notification.putLong("date", System.currentTimeMillis());
                notification.putLong("requestId", requestId);
                
                send("respondBuddyRequest", notification, receiver);
                trace("📨 Buddy notification sent to online user: " + actualReceiverName);
            } else {
                trace("ℹ️ Receiver not online, request queued: " + actualReceiverName);
            }
            
        } catch (Exception e) {
            trace("⚠️ Background processing error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

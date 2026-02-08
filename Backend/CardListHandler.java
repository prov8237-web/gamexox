package src5;

import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class CardListHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        try {
            trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            trace("🎴 CARDLIST REQUEST from: " + user.getName());
            trace("User ID: " + user.getId());
            
            if (params != null && params.size() > 0) {
                trace("Params: " + params.getDump());
            }
            
            MainExtension extension = (MainExtension) getParentExtension();
            InMemoryStore store = extension.getStore();
            
            SFSObject response = store.getCardListResponse(user.getId());
            
            trace("📤 Sending cardlist response with " + 
                  response.getSFSArray("items").size() + " items");
            trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            
            send("cardlist", response, user);
            extension.markResponseSent("cardlist", user);
            
        } catch (Exception e) {
            trace("❌ Error in CardListHandler: " + e.getMessage());
            e.printStackTrace();
            
            SFSObject error = new SFSObject();
            error.putUtfString("errorCode", "CARD_LIST_ERROR");
            error.putUtfString("message", "Failed to retrieve card list");
            send("cardlist", error, user);
            
            MainExtension extension = (MainExtension) getParentExtension();
            extension.markResponseSent("cardlist", user);
        }
    }
}
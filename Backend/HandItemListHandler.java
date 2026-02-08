package src5;

import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class HandItemListHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        try {
            trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            trace("👜 HANDITEMLIST REQUEST from: " + user.getName());
            trace("User ID: " + user.getId());
            
            if (params != null && params.size() > 0) {
                trace("Params: " + params.getDump());
            }
            
            MainExtension extension = (MainExtension) getParentExtension();
            InMemoryStore store = extension.getStore();
            
            int page = 1;
            String sort = "created_desc";
            String search = "";
            
            if (params != null) {
                if (params.containsKey("page")) {
                    page = params.getInt("page");
                }
                if (params.containsKey("sort")) {
                    sort = params.getUtfString("sort");
                }
                if (params.containsKey("search")) {
                    search = params.getUtfString("search");
                }
            }
            
            SFSObject response = store.getHandItemListResponse(user.getId(), page, sort, search);
            
            trace("📤 Sending handitemlist response - Page: " + page + 
                  ", Total Pages: " + response.getInt("totalPages"));
            trace("Items in page: " + 
                  response.getSFSObject("items").getSFSArray("list").size());
            trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            
            send("handitemlist", response, user);
            extension.markResponseSent("handitemlist", user);
            
        } catch (Exception e) {
            trace("❌ Error in HandItemListHandler: " + e.getMessage());
            e.printStackTrace();
            
            SFSObject error = new SFSObject();
            error.putUtfString("errorCode", "HAND_ITEM_LIST_ERROR");
            error.putUtfString("message", "Failed to retrieve hand item list");
            send("handitemlist", error, user);
            
            MainExtension extension = (MainExtension) getParentExtension();
            extension.markResponseSent("handitemlist", user);
        }
    }
}
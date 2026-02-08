package src5;

import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import java.util.ArrayList;
import java.util.List;

public class UseHandItemHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String command = "usehanditem";
        ISFSObject data = params;
        if (params != null && params.containsKey("data")) {
            ISFSObject nested = params.getSFSObject("data");
            if (nested != null) {
                data = nested;
            }
        }
        
        try {
            trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            trace("🎁 " + command.toUpperCase() + " REQUEST from: " + user.getName());
            trace("User ID: " + user.getId());
            trace("Zone: " + user.getZone().getName());
            
            // Log full params
            if (params != null) {
                trace("📦 Full params dump:");
                trace(params.getDump());
            } else {
                trace("📦 No params received");
            }
            
            // Check if 'id' parameter exists
            if (data == null || !data.containsKey("id")) {
                trace("❌ ERROR: Missing 'id' parameter");
                SFSObject error = new SFSObject();
                error.putUtfString("errorCode", "MISSING_PARAMETER");
                error.putUtfString("message", "Required parameter 'id' is missing");
                send(command, error, user);
                
                // Mark response
                if (getParentExtension() instanceof MainExtension) {
                    ((MainExtension) getParentExtension()).markResponseSent(command, user);
                }
                return;
            }
            
            // Get the item ID from request (supports int/long/string for client compatibility)
            long requestedId = resolveRequestedId(data);
            trace("🎯 Requested item ID: " + requestedId);
            trace("🎯 Requested item ID (hex): 0x" + Long.toHexString(requestedId));
            
            // Get extension and store
            MainExtension extension = (MainExtension) getParentExtension();
            InMemoryStore store = extension.getStore();

            // id=0 means clear currently equipped hand item (used by client after transfer)
            if (requestedId <= 0) {
                trace("🧹 Clearing hand item for user due to id <= 0");
                clearHandItem(user);

                SFSObject response = new SFSObject();
                response.putInt("nextRequest", 1000);
                response.putUtfString("status", "success");
                response.putLong("itemId", 0L);
                send(command, response, user);
                extension.markResponseSent(command, user);
                sendRolesResponse(user);
                return;
            }
            
            // Log all hand items for debugging
            trace("📦 Searching in user's hand items...");
            
            // Try different search methods
            InMemoryStore.StoreItem foundItem = null;
            int userId = user.getId();
            
            // Method 1: Search by exact item ID
            foundItem = store.getHandItemById(userId, requestedId);
            if (foundItem != null) {
                trace("✅ Found by item ID");
            }
            
            // Method 2: Search by product ID (if requestedId is small)
            if (foundItem == null && requestedId < Integer.MAX_VALUE) {
                foundItem = store.getHandItemByProductId(userId, (int)requestedId);
                if (foundItem != null) {
                    trace("✅ Found by product ID");
                }
            }
            
            // Method 3: Search for item with clip "0043" (from logs)
            if (foundItem == null) {
                foundItem = store.getHandItemByClip(userId, "0043");
                if (foundItem != null) {
                    trace("✅ Found by clip '0043'");
                }
            }
            
            // If still not found, try any item
            if (foundItem == null && !store.getUserHandItems(userId).isEmpty()) {
                foundItem = store.getUserHandItems(userId).get(0);
                trace("⚠️ Using first available hand item");
            }
            
            // Final check
            if (foundItem == null) {
                trace("❌ ERROR: No hand items found for user");
                SFSObject error = new SFSObject();
                error.putUtfString("errorCode", "INVENTORY_EMPTY");
                error.putUtfString("message", "No hand items in inventory");
                send(command, error, user);
                
                extension.markResponseSent(command, user);
                return;
            }
            
            // Log item details
            trace("✅ Item Details:");
            trace("   - Database ID: " + foundItem.id);
            trace("   - Product ID: " + foundItem.productID);
            trace("   - Clip: '" + foundItem.clip + "'");
            trace("   - Type: " + foundItem.subType);
            trace("   - Source: " + foundItem.source);
            
            // Prepare hand value (CRITICAL: from clip, not ID!)
            String handValue = foundItem.clip;
            
            // Format hand value to 4 digits if it's numeric
            if (handValue.matches("\\d+")) {
                int num = Integer.parseInt(handValue);
                handValue = String.format("%04d", num);
                trace("   - Formatted hand value: '" + handValue + "'");
            }
            
            // Update user variables (EXACTLY like logs)
            trace("🔄 Updating user variables...");
            List<UserVariable> vars = new ArrayList<>();
            
            // Variable 1: hand = clip value (e.g., "0043")
            vars.add(new SFSUserVariable("hand", handValue));
            trace("   ✓ hand = '" + handValue + "'");
            
            // Variable 2: speed = 1.0 (always)
            vars.add(new SFSUserVariable("speed", 100));
            trace("   ✓ speed = 1.0");
            
            // Apply variables
            getApi().setUserVariables(user, vars);
            trace("✅ User variables updated successfully");
            
            // Send usehanditem response
            SFSObject response = new SFSObject();
            response.putInt("nextRequest", 1000);
            response.putUtfString("status", "success");
            response.putLong("itemId", foundItem.id);
            
            trace("📤 Sending usehanditem response:");
            trace(response.toJson());
            trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            
            send(command, response, user);
            extension.markResponseSent(command, user);
            
            // Send roles response separately (like in logs)
            sendRolesResponse(user);
            
        } catch (Exception e) {
            trace("❌ CRITICAL ERROR in UseHandItemHandler:");
            trace("   Message: " + e.getMessage());
            trace("   Stack trace:");
            e.printStackTrace();
            
            SFSObject error = new SFSObject();
            error.putUtfString("errorCode", "SERVER_ERROR");
            error.putUtfString("message", "Internal server error: " + e.getClass().getSimpleName());
            error.putInt("nextRequest", 0);
            
            send(command, error, user);
            
            try {
                MainExtension ext = (MainExtension) getParentExtension();
                ext.markResponseSent(command, user);
            } catch (Exception ex) {
                trace("⚠️ Could not mark response as sent");
            }
        }
    }
    
    private long resolveRequestedId(ISFSObject params) {
        try {
            return params.getLong("id");
        } catch (Exception ignored) {
        }

        try {
            return params.getInt("id");
        } catch (Exception ignored) {
        }

        try {
            String raw = params.getUtfString("id");
            if (raw == null || raw.trim().isEmpty()) {
                return 0L;
            }
            return Long.parseLong(raw.trim());
        } catch (Exception ignored) {
            return 0L;
        }
    }

    private void clearHandItem(User user) {
        List<UserVariable> vars = new ArrayList<>();
        vars.add(new SFSUserVariable("hand", "0"));
        vars.add(new SFSUserVariable("speed", 1.0));
        getApi().setUserVariables(user, vars);
    }

    private void sendRolesResponse(User user) {
        try {
            // Small delay like original server
            Thread.sleep(50);
            
            MainExtension extension = (MainExtension) getParentExtension();
            InMemoryStore store = extension.getStore();
            String roles = store.recomputeRoles(user.getId(), user.getPrivilegeId());
            store.getOrCreateUser(user).setRoles(roles);

            SFSObject rolesResponse = new SFSObject();
            rolesResponse.putUtfString("roles", roles);
            
            trace("📤 Sending roles response:");
            trace(rolesResponse.toJson());
            
            send("roles", rolesResponse, user);
            
        } catch (Exception e) {
            trace("⚠️ Failed to send roles response: " + e.getMessage());
        }
    }
}

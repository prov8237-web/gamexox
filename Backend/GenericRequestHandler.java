package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import java.util.ArrayList;
import java.util.List;

public class GenericRequestHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        Object cmdObj = user.getProperty("lastRequestId");
        String command = cmdObj instanceof String ? (String) cmdObj : "";
        ISFSObject data = data(params);
        InMemoryStore store = getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);

        switch (command) {
            case "randomwheel":
            case "transferresponse":
            case "giftcheckexchange":
            case "transferrequest":
            case "partyIsland.rollDice":
            case "partyIsland.leave":
            case "dropthrowaction":
            case "buddyrespondinvitelocation":
            case "buddyacceptinvitegame":
            case "buddyinvitelocation":
            case "diamondtransferresponse":
            case "diamondtransferrequest":
            case "barterresponse":
            case "barterrequest":
            case "bartercancel":
            case "farmimplantation":
            case "drop":
            case "changeobjectlock":
            case "changeobjectframe":
            case "campaignquest":
            case "exchangediamond":
            case "farmclean":
            case "farmgather":
            case "matchmakingCancel":
            case "removeavatarrestriction":
            case "privatechatdeletegroup":
            case "flatpassword":
            case "debugcommand":
            case "roommessage":
                reply(user, command, new SFSObject());
                return;
            case "avatarsalescollect":
                reply(user, command, buildAvatarSalesCollectResponse());
                return;
            case "addbuddy":
                handleAddBuddy(state, data);
                reply(user, command, new SFSObject());
                return;
            case "changemood":
                handleChangeMood(user, state, data);
                reply(user, command, new SFSObject());
                return;
            case "changestatusmessage":
                handleChangeStatusMessage(user, state, data);
                reply(user, command, new SFSObject());
                return;
            case "changebuddyrating":
                reply(user, command, new SFSObject());
                return;
            case "addbuddyresponse":
                reply(user, command, buildBuddyResponse(state, data));
                return;
            case "removebuddy":
                handleRemoveBuddy(state, data);
                reply(user, command, new SFSObject());
                return;
            case "whisper":
                trace("[WHISPER] from=" + user.getName() + " to=" + (data != null && data.containsKey("receiver") ? data.getUtfString("receiver") : "unknown") + " msg=" + (data != null && data.containsKey("message") ? data.getUtfString("message") : ""));
                reply(user, command, new SFSObject());
                return;
            case "usehanditem":
                handleUseHandItem(user, data);
                return;
            case "purchase":
            case "flatpurchase":
                reply(user, command, buildPurchaseResponse(data, state));
                return;
            case "startroomvideo":
                handleStartRoomVideo(user, data);
                return;
            case "gatheritemsearch":
                reply(user, command, new SFSObject());
                return;
            case "gatheritemcollect":
                reply(user, command, buildGatherCollectResponse(data));
                return;
            case "questlist":
                reply(user, command, buildQuestListResponse(state));
                return;
            case "privatechatlist":
                reply(user, command, buildPrivateChatListResponse());
                return;
            case "messagedetails":
                reply(user, command, buildMessageDetailsResponse(data));
                return;
            case "orderlist":
                reply(user, command, buildOrderListResponse(state));
                return;
            case "flatsettings":
                reply(user, command, buildRoomSettingsResponse());
                return;
            case "buddylocate":
                reply(user, command, buildBuddyLocateResponse(state));
                return;
            case "shopproductlist":
                reply(user, command, buildShopProductListResponse());
                return;
            case "pubContentList":
                reply(user, command, buildPubContentListResponse());
                return;
            default:
                reply(user, command, new SFSObject());
        }
    }

    private ISFSObject buildPurchaseResponse(ISFSObject data, InMemoryStore.UserState state) {
        SFSObject res = new SFSObject();
        SFSArray items = new SFSArray();
        if (data != null && data.containsKey("items")) {
            ISFSArray requested = data.getSFSArray("items");
            for (int i = 0; i < requested.size(); i++) {
                ISFSObject req = requested.getSFSObject(i);
                SFSObject bucket = new SFSObject();
                bucket.putUtfString("type", "CLOTH");
                SFSArray bucketItems = new SFSArray();
                SFSObject item = new SFSObject();
                item.putUtfString("clip", req.containsKey("shopProductID") ? String.valueOf(req.getInt("shopProductID")) : "item");
                item.putInt("color", req.containsKey("color") ? req.getInt("color") : 0);
                item.putUtfString("subType", "CLOTH");
                bucketItems.addSFSObject(item);
                bucket.putSFSArray("items", bucketItems);
                items.addSFSObject(bucket);
                state.getInventory().addSFSObject(item);
            }
        }
        res.putSFSArray("items", items);
        res.putInt("cost", 0);
        return res;
    }

    private ISFSObject buildGatherCollectResponse(ISFSObject data) {
        SFSObject res = new SFSObject();
        res.putUtfString("clip", data != null && data.containsKey("clip") ? data.getUtfString("clip") : "unknown");
        res.putInt("quantity", 1);
        return res;
    }

    private ISFSObject buildQuestListResponse(InMemoryStore.UserState state) {
        SFSObject res = new SFSObject();
        res.putSFSArray("quests", state.getQuests());
        res.putInt("nextRequest", 1000);
        return res;
    }

    private ISFSObject buildPrivateChatListResponse() {
        SFSObject res = new SFSObject();
        res.putSFSArray("groupList", new SFSArray());
        return res;
    }

    private ISFSObject buildMessageDetailsResponse(ISFSObject data) {
        SFSObject res = new SFSObject();
        if (data != null && data.containsKey("groupID")) {
            res.putUtfString("groupID", data.getUtfString("groupID"));
        } else {
            res.putUtfString("groupID", "0");
        }
        res.putSFSArray("contents", new SFSArray());
        return res;
    }

    private ISFSObject buildRoomSettingsResponse() {
        SFSObject res = new SFSObject();
        res.putBool("passwordSet", false);
        res.putBool("vip", false);
        res.putBool("plus18", false);
        res.putBool("notVisitor", false);
        return res;
    }

    private ISFSObject buildOrderListResponse(InMemoryStore.UserState state) {
        SFSObject res = new SFSObject();
        res.putSFSArray("orders", state.getOrders());
        return res;
    }

    private ISFSObject buildShopProductListResponse() {
        SFSObject res = new SFSObject();
        res.putSFSArray("products", new SFSArray());
        res.putInt("nextRequest", 1000);
        return res;
    }

    private ISFSObject buildPubContentListResponse() {
        SFSObject res = new SFSObject();
        SFSArray list = new SFSArray();
        SFSObject item = new SFSObject();
        item.putUtfString("metaType", "JOURNAL");
        item.putUtfString("title", "MenaC");
        item.putUtfString("image", "https://cdn.discordapp.com/attachments/1345899137211699321/1470030551934308498/menaC.png");
        item.putUtfString("imageUrl", "https://cdn.discordapp.com/attachments/1345899137211699321/1470030551934308498/menaC.png");
        item.putUtfString("thumb", "https://cdn.discordapp.com/attachments/1345899137211699321/1470030551934308498/menaC.png");
        list.addSFSObject(item);
        res.putSFSArray("list", list);
        res.putInt("nextRequest", 1000);
        return res;
    }

    private ISFSObject buildAvatarSalesCollectResponse() {
        SFSObject res = new SFSObject();
        SFSArray gains = new SFSArray();
        SFSObject gain = new SFSObject();
        gain.putInt("amount", 0);
        gain.putUtfString("currency", "SANIL");
        gains.addSFSObject(gain);
        res.putSFSArray("gains", gains);
        return res;
    }

    private void handleStartRoomVideo(User user, ISFSObject data) {
        Room room = user.getLastJoinedRoom();
        if (room == null) {
            reply(user, "startroomvideo", new SFSObject());
            return;
        }
        String videoUrl = data != null && data.containsKey("videoUrl") ? data.getUtfString("videoUrl") : "";
        SFSObject videoData = new SFSObject();
        videoData.putUtfString("videoId", videoUrl);
        videoData.putLong("videoStartTimestamp", System.currentTimeMillis() / 1000);

        List<RoomVariable> vars = new ArrayList<>();
        vars.add(new SFSRoomVariable("roomVideoData", videoData));
        getApi().setRoomVariables(null, room, vars, false, false, false);

        reply(user, "startroomvideo", new SFSObject());
    }

    private void handleUseHandItem(User user, ISFSObject data) {
        int id = data != null && data.containsKey("id") ? data.getInt("id") : 0;
        InMemoryStore.UserState state = getStore().getOrCreateUser(user);
        List<UserVariable> vars = new ArrayList<>();
        if (id == 0) {
            vars.add(new SFSUserVariable("hand", ""));
            state.setHand("");
        } else {
            String handValue = String.valueOf(id);
            vars.add(new SFSUserVariable("hand", handValue));
            state.setHand(handValue);
        }
        vars.add(new SFSUserVariable("speed", Double.valueOf(1.0)));
        if (!vars.isEmpty()) {
            getApi().setUserVariables(user, vars);
        }
        
        SFSObject response = new SFSObject();
        response.putInt("nextRequest", 1000);
        
        reply(user, "usehanditem", response);
    }

    private void handleChangeMood(User user, InMemoryStore.UserState state, ISFSObject data) {
        int mood = data != null && data.containsKey("mood") ? data.getInt("mood") : 0;
        state.setMood(mood);
        List<UserVariable> vars = new ArrayList<>();
        vars.add(new SFSUserVariable("mood", mood));
        getApi().setUserVariables(user, vars);
    }

    private void handleChangeStatusMessage(User user, InMemoryStore.UserState state, ISFSObject data) {
        String message = data != null && data.containsKey("message") ? data.getUtfString("message") : "";
        state.setStatusMessage(message);
        List<UserVariable> vars = new ArrayList<>();
        vars.add(new SFSUserVariable("statusMessage", message));
        getApi().setUserVariables(user, vars);
    }

    private void handleAddBuddy(InMemoryStore.UserState state, ISFSObject data) {
        if (data == null || !data.containsKey("avatarID")) {
            return;
        }
        String avatarId = data.getUtfString("avatarID");
        SFSObject request = new SFSObject();
        request.putUtfString("avatarID", avatarId);
        request.putUtfString("avatarName", avatarId);
        request.putLong("date", System.currentTimeMillis());
        
        state.getBuddyRequests().addSFSObject(request);
    }

    private ISFSObject buildBuddyResponse(InMemoryStore.UserState state, ISFSObject data) {
        if (data != null && data.containsKey("response") && "ACCEPTED".equalsIgnoreCase(data.getUtfString("response"))) {
            String avatarId = data.containsKey("avatarID") ? data.getUtfString("avatarID") : "";
            if (!avatarId.isEmpty()) {
                SFSObject buddy = new SFSObject();
                buddy.putUtfString("avatarID", avatarId);
                buddy.putUtfString("avatarName", avatarId);
                buddy.putBool("isOnline", true);
                buddy.putInt("mood", 1);
                buddy.putInt("buddyRating", 1);
                buddy.putInt("myRating", 1);
                buddy.putUtfString("imgPath", "");
                buddy.putUtfString("status", "");
                state.getBuddies().addSFSObject(buddy);
                
                // Remove from requests
                ISFSArray updatedRequests = new SFSArray();
                ISFSArray requests = state.getBuddyRequests();
                for (int i = 0; i < requests.size(); i++) {
                    ISFSObject req = requests.getSFSObject(i);
                    if (!avatarId.equals(req.getUtfString("avatarID"))) {
                        updatedRequests.addSFSObject(req);
                    }
                }
                state.setBuddies(state.getBuddies()); // Refresh buddy array
            }
        }
        SFSObject res = new SFSObject();
        res.putSFSArray("requests", state.getBuddyRequests());
        return res;
    }

    private void handleRemoveBuddy(InMemoryStore.UserState state, ISFSObject data) {
        if (data == null || !data.containsKey("avatarID")) {
            return;
        }
        String avatarId = data.getUtfString("avatarID");
        SFSArray updated = new SFSArray();
        ISFSArray buddies = state.getBuddies();
        for (int i = 0; i < buddies.size(); i++) {
            ISFSObject buddy = buddies.getSFSObject(i);
            if (buddy != null && avatarId.equals(buddy.getUtfString("avatarID"))) {
                continue;
            }
            updated.addSFSObject(buddy);
        }
        state.setBuddies(updated);
    }

    private ISFSObject buildBuddyLocateResponse(InMemoryStore.UserState state) {
        SFSObject res = new SFSObject();
        res.putUtfString("universe", state.getUniverseKey());
        String room = state.getCurrentRoom();
        res.putUtfString("street", InMemoryStore.isBlank(room) ? "street01" : room);
        return res;
    }
}

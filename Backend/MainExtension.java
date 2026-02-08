package src5;

import com.smartfoxserver.v2.extensions.SFSExtension;
import com.smartfoxserver.v2.core.SFSEventType;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.Room;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

public class MainExtension extends SFSExtension {
    
    private Set<String> registeredHandlers = new HashSet<>();
    private Map<String, Integer> commandStats = new ConcurrentHashMap<>();
    private final InMemoryStore store = new InMemoryStore();
    private final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
    private final Map<String, ScheduledFuture<?>> tahsinChatterTasks = new ConcurrentHashMap<>();
    private final List<String> tahsinChatterLines = Arrays.asList(
        "ياهلا!",
        "انا هنا لو احتجت حاجة.",
        "تابع اخر الاخبار من الجريدة.",
        "استمتع بوقتك!"
    );
    
    public void markResponseSent(String command, User user) {
        trace("✅ [RESPONSE-TRACKED] " + command + " for " + user.getName());
    }

    @Override
    public void init() {
        trace("════════════════════════════════════════════════════════");
        trace("🎮 MARHAB EXTENSION - OFFICIAL SERVER REPLICA v1.0");
        trace("════════════════════════════════════════════════════════");
        
        // Core handlers - matching official server
        registerHandler("config", ConfigHandler.class);
        registerHandler("init", InitHandler.class);
        registerHandler("baseclothes", BaseClothesHandler.class);
        registerHandler("clothlist", ClothListHandler.class);
        registerHandler("changeclothes", ChangeClothesHandler.class);
        registerHandler("savebaseclothes", SaveBaseClothesHandler.class);
        registerHandler("buddylist", BuddyListHandler.class);
        registerHandler("changesettings", ChangeSettingsHandler.class);
        registerHandler("nickChange", NickChangeHandler.class);
        registerHandler("roomjoincomplete", RoomJoinCompleteHandler.class);
        registerHandler("recommendeduniverse", GenericRequestHandler.class);
        registerHandler("questlist", QuestListHandler.class);
        registerHandler("questaccept", GenericRequestHandler.class);
        registerHandler("complaintlist", ComplaintListHandler.class);
        registerHandler("complaintaction", ComplaintActionHandler.class);
        registerHandler("baninfo", BanInfoHandler.class);
        registerHandler("prereport", PreReportHandler.class);
        registerHandler("ingamereport", PreReportHandler.class);
        registerHandler("report", ReportHandler.class);

        registerHandler("guidelist", GuideListHandler.class);
        registerHandler("guiderequest", GuideRequestHandler.class);
        registerHandler("guideaction", GuideActionHandler.class);
        registerHandler("guidemessage", GuideMessageHandler.class);
        registerHandler("globalchat.leave", GenericRequestHandler.class);
        registerHandler("questaction", QuestActionHandler.class);
        registerHandler("walkrequest", WalkRequestHandler.class);
        registerHandler("walkfinalrequest", WalkFinalRequestHandler.class);
        registerHandler("usechatballoon", UseChatBalloonHandler.class);
        registerHandler("sceneitems", SceneItemsHandler.class);
        registerHandler("savesceneitems", SaveSceneItemsHandler.class);
        registerHandler("cardlist", CardListHandler.class);
        registerHandler("handitemlist", HandItemListHandler.class);
        registerHandler("usehanditem", UseHandItemHandler.class);
        registerHandler("smileylist", SmileyListHandler.class);
        registerHandler("usesmiley", UseSmileyHandler.class);
        registerHandler("changesmiley", UseSmileyHandler.class);
        registerHandler("adminannouncement", AdminAnnouncementHandler.class);
        
        // Profile handlers
        registerHandler("profile", ProfileHandler.class);
        registerHandler("profilelike", ProfileLikeHandler.class);
        registerHandler("profileimproper", ProfileImproperHandler.class);
        registerHandler("profileskinlist", ProfileSkinListHandler.class);
        registerHandler("useprofileskinwithclip", UseProfileSkinWithClipHandler.class);
        registerHandler("kickAvatarFromRoom", KickAvatarFromRoomHandler.class);
        // Moderation / admin actions
        registerHandler("banUser", BanUserHandler.class);
        registerHandler("warnUser", WarnUserHandler.class);
        registerHandler("kickUserFromBusiness", KickUserFromBusinessHandler.class);

        
        // Ping/Pong - official server responds with "pong"
        registerHandler("ping", PingHandler.class);
        
        // Door handlers
        registerHandler("teleport", TeleportHandler.class);
        registerHandler("usedoor", UseDoorHandler.class);
        registerHandler("usehousedoor", UseHouseDoorHandler.class);
        registerHandler("useobjectdoor", UseObjectDoorHandler.class);
        
        // Empty handlers for requests that don't need response data
        registerHandler("roles", RolesHandler.class);
        registerHandler("trace", TraceHandler.class);

        // ✅✅✅ BOT MESSAGE HANDLERS - NEW ✅✅✅
        registerHandler("botmessage", BotMessageHandler.class);
        registerHandler("simplebotmessage", SimpleBotMessageHandler.class);
        // ✅✅✅ END BOT MESSAGE HANDLERS ✅✅✅

        // Additional client-used commands handled by GenericRequestHandler
        registerHandler("randomwheel", GenericRequestHandler.class);
        registerHandler("purchase", GenericRequestHandler.class);
        registerHandler("flatpurchase", GenericRequestHandler.class);
        registerHandler("transferresponse", GenericRequestHandler.class);
        registerHandler("giftcheckexchange", GiftCheckExchangeHandler.class);
        registerHandler("transferrequest", GenericRequestHandler.class);
        registerHandler("startroomvideo", GenericRequestHandler.class);
        registerHandler("partyIsland.rollDice", GenericRequestHandler.class);
        registerHandler("partyIsland.leave", GenericRequestHandler.class);
        registerHandler("dropthrowaction", GenericRequestHandler.class);
        registerHandler("buddyrespondinvitelocation", BuddyRespondInviteLocationHandler.class);
        registerHandler("buddyacceptinvitegame", BuddyAcceptInviteGameHandler.class);

        registerHandler("buddyinvitelocation", BuddyInviteLocationHandler.class);

        registerHandler("buddylocate", BuddyLocateHandler.class);

        registerHandler("diamondtransferresponse", GenericRequestHandler.class);
        registerHandler("diamondtransferrequest", GenericRequestHandler.class);
        registerHandler("addbuddy", AddBuddyHandler.class);                     // ✅

        registerHandler("changemood", ChangeMoodHandler.class);                 // ✅

        registerHandler("changestatusmessage", ChangeStatusMessageHandler.class); // ✅

        registerHandler("changebuddyrating", ChangeBuddyRatingHandler.class);   // ✅

        registerHandler("addbuddyresponse", AddBuddyResponseHandler.class);     // ✅
        registerHandler("removebuddy", RemoveBuddyHandler.class);               // ✅

        registerHandler("barterresponse", GenericRequestHandler.class);
        registerHandler("barterrequest", GenericRequestHandler.class);
        registerHandler("bartercancel", GenericRequestHandler.class);
        registerHandler("farmimplantation", GenericRequestHandler.class);
        registerHandler("drop", GenericRequestHandler.class);
        registerHandler("changeobjectlock", GenericRequestHandler.class);
        registerHandler("changeobjectframe", GenericRequestHandler.class);
        registerHandler("gatheritemsearch", GenericRequestHandler.class);
        registerHandler("gatheritemcollect", GenericRequestHandler.class);
        registerHandler("avatarsalescollect", GenericRequestHandler.class);
        registerHandler("campaignquest", GenericRequestHandler.class);
        registerHandler("farmclean", GenericRequestHandler.class);
        registerHandler("farmgather", GenericRequestHandler.class);
        registerHandler("matchmakingCancel", GenericRequestHandler.class);
        registerHandler("removeavatarrestriction", GenericRequestHandler.class);
        registerHandler("exchangediamond", GenericRequestHandler.class);
        registerHandler("whisper", WhisperHandler.class);
        registerHandler("privatechatlist", GenericRequestHandler.class);
        registerHandler("messagedetails", GenericRequestHandler.class);
        registerHandler("privatechatdeletegroup", GenericRequestHandler.class);
        registerHandler("flatsettings", GenericRequestHandler.class);
        registerHandler("flatpassword", GenericRequestHandler.class);
        registerHandler("debugcommand", GenericRequestHandler.class);
        registerHandler("roommessage", GenericRequestHandler.class);
        registerHandler("orderlist", GenericRequestHandler.class);

        trace("════════════════════════════════════════════════════════");
        trace("✅ Handlers Registered: " + registeredHandlers.size());
        trace("📋 Commands: " + registeredHandlers);
        trace("⚙ STRICT_PROTOCOL=" + ProtocolConfig.strictProtocol() + " DEV_FALLBACK=" + ProtocolConfig.devFallback() + " CHAT_ENABLED=" + ProtocolConfig.chatEnabled());
        trace("════════════════════════════════════════════════════════");

        addEventHandler(SFSEventType.USER_LOGIN, ServerEventHandler.class);
        addEventHandler(SFSEventType.USER_JOIN_ROOM, ServerEventHandler.class);
        addEventHandler(SFSEventType.USER_LEAVE_ROOM, ServerEventHandler.class);
        addEventHandler(SFSEventType.USER_DISCONNECT, ServerEventHandler.class);
        addEventHandler(SFSEventType.PUBLIC_MESSAGE, ServerEventHandler.class);
        
    }
    
    private void registerHandler(String command, Class<?> handlerClass) {
        addRequestHandler(command, handlerClass);
        registeredHandlers.add(command);
    }

    @Override
    public void handleClientRequest(String requestId, User user, ISFSObject params) {
        commandStats.merge(requestId, 1, Integer::sum);
        user.setProperty("lastRequestId", requestId);
        
        trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        trace("📥 CLIENT REQUEST: " + requestId);
        trace("User: " + user.getName() + " | IP: " + user.getSession().getAddress());
        
        if (!registeredHandlers.contains(requestId)) {
            trace("⚠️ UNREGISTERED COMMAND: " + requestId);
        }
        
        if (params != null && params.size() > 0) {
            trace("Params: " + params.getDump());
        }
        trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        
        if (!registeredHandlers.contains(requestId)) {
            if (ProtocolConfig.devFallback() && !ProtocolConfig.strictProtocol()) {
                trace("🧪 DEV_FALLBACK enabled. Using default handler for: " + requestId);
                ISFSObject res = DefaultResponseFactory.buildResponse(requestId, user, params, this);
                send(requestId, res, user);
                markResponseSent(requestId, user);
                return;
            }

            trace("❌ Unhandled command: " + requestId);
            if (ProtocolConfig.strictProtocol()) {
                throw new IllegalStateException("Strict protocol: unhandled command " + requestId);
            }
            ISFSObject error = new com.smartfoxserver.v2.entities.data.SFSObject();
            error.putUtfString("errorCode", "UNHANDLED_COMMAND");
            error.putUtfString("message", "No handler for command: " + requestId);
            send(requestId, error, user);
            markResponseSent(requestId, user);
            return;
        }

        RequestValidator.validateRequest(requestId, params);
        super.handleClientRequest(requestId, user, params);
    }

    public InMemoryStore getStore() {
        return store;
    }

    public void ensureTahsinChatter(String roomName) {
        if (roomName == null || roomName.isEmpty()) {
            return;
        }
        if (!RoomConfigRegistry.roomHasBot(roomName, "tahsin")) {
            return;
        }
        tahsinChatterTasks.computeIfAbsent(roomName, key -> scheduler.scheduleAtFixedRate(
            () -> sendTahsinChatter(key), 10, 10, TimeUnit.SECONDS));
    }

    public void stopTahsinChatterIfEmpty(String roomName) {
        if (roomName == null || roomName.isEmpty()) {
            return;
        }
        Room room = getParentZone() == null ? null : getParentZone().getRoomByName(roomName);
        if (room != null && !room.getUserList().isEmpty()) {
            return;
        }
        ScheduledFuture<?> task = tahsinChatterTasks.remove(roomName);
        if (task != null) {
            task.cancel(false);
        }
    }

    private void sendTahsinChatter(String roomName) {
        Room room = getParentZone() == null ? null : getParentZone().getRoomByName(roomName);
        if (room == null || room.getUserList().isEmpty()) {
            return;
        }
        String message = tahsinChatterLines.get(new Random().nextInt(tahsinChatterLines.size()));
        SFSObject payload = buildBotMessagePayload("tahsin", message);
        if (payload == null) {
            return;
        }
        send("botMessage", payload, room.getUserList());
    }

    private SFSObject buildBotMessagePayload(String botKey, String message) {
        BotMessageCatalog.BotDefinition definition = BotMessageCatalog.resolve(botKey);
        if (definition == null) {
            return null;
        }
        SFSObject botData = new SFSObject();
        botData.putUtfString("botKey", definition.getKey());
        botData.putUtfString("message", message);
        botData.putInt("duration", 20);
        botData.putInt("version", 1);
        SFSArray colors = definition.buildColors();
        botData.putSFSArray("colors", colors);
        SFSObject property = new SFSObject();
        property.putUtfString("cn", "SimpleBotMessageProperty");
        botData.putSFSObject("property", property);
        return botData;
    }
}

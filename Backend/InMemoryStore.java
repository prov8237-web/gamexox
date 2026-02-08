package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

public class InMemoryStore {
    // ========== USER STORAGE ==========
    private final Map<Integer, UserState> usersById = new ConcurrentHashMap<>();
    private final Map<String, UserState> usersByName = new ConcurrentHashMap<>();
    private final Set<String> reservedNames = ConcurrentHashMap.newKeySet();
    
    // ========== ROOM STORAGE ==========
    private final Map<String, RoomState> roomsByName = new ConcurrentHashMap<>();
    
    // ========== ITEM STORAGE ==========
    private final Map<Integer, StoreData> userStores = new ConcurrentHashMap<>();
    
    // ========== BUDDY SYSTEM ==========
    private final Map<Long, BuddyRequest> buddyRequests = new ConcurrentHashMap<>();
    private final Map<String, Set<Long>> userOutgoingRequests = new ConcurrentHashMap<>();
    private final Map<String, Set<Long>> userIncomingRequests = new ConcurrentHashMap<>();
    private final Map<String, Set<String>> userBuddies = new ConcurrentHashMap<>();

    // ========== PROFILE DATA ==========
    private final Map<String, ProfileData> profilesByAvatarId = new ConcurrentHashMap<>();
    private final List<ProfileSkinDefinition> profileSkins = new ArrayList<>();
    
    
    // ========== MODERATION (BANS / WARNS) ==========
    private final Map<String, List<BanRecord>> bansByIp = new ConcurrentHashMap<>();
    private final Map<Long, ComplaintRecord> complaintsById = new ConcurrentHashMap<>();
    private final List<Long> complaintOrder = Collections.synchronizedList(new ArrayList<Long>());
    private final Map<Long, ReportRecord> reportsById = new ConcurrentHashMap<>();
    private final List<Long> reportOrder = Collections.synchronizedList(new ArrayList<Long>());
    private final Map<Long, GuideRequestRecord> guideRequestsById = new ConcurrentHashMap<>();
    private final List<Long> guideRequestOrder = Collections.synchronizedList(new ArrayList<Long>());
// ========== SMILEY SYSTEM ==========
    private final List<SmileyItem> smileyItems = new ArrayList<>();
    private final Map<Integer, SmileyItem> smileyById = new ConcurrentHashMap<>();
    private final Map<String, SmileyItem> smileyByClip = new ConcurrentHashMap<>();

    // ========== CONSTRUCTOR ==========
    public InMemoryStore() {
        initializeSmileys();
        initializeProfileSkins();
        trace("✅ InMemoryStore initialized with buddy system");
    }

    // ========== BUDDY REQUEST CLASS ==========
    public static class BuddyRequest {
        private final long requestId;
        private final String requesterId;
        private final String requesterName;
        private final String receiverId;
        private final String receiverName;
        private final long requestDate;
        private String status; // PENDING, ACCEPTED, REJECTED
        
        public BuddyRequest(long requestId, String requesterId, String requesterName,
                          String receiverId, String receiverName) {
            this.requestId = requestId;
            this.requesterId = requesterId;
            this.requesterName = requesterName;
            this.receiverId = receiverId;
            this.receiverName = receiverName;
            this.requestDate = System.currentTimeMillis();
            this.status = "PENDING";
        }
        
        // Getters
        public long getRequestId() { return requestId; }
        public String getRequesterId() { return requesterId; }
        public String getRequesterName() { return requesterName; }
        public String getReceiverId() { return receiverId; }
        public String getReceiverName() { return receiverName; }
        public long getRequestDate() { return requestDate; }
        public String getStatus() { return status; }
        
        // Setters
        public void setStatus(String status) { this.status = status; }
        
        public SFSObject toSFSObject() {
            SFSObject obj = new SFSObject();
            obj.putLong("requestId", requestId);
            obj.putUtfString("requesterId", requesterId);
            obj.putUtfString("requesterName", requesterName);
            obj.putUtfString("receiverId", receiverId);
            obj.putUtfString("receiverName", receiverName);
            obj.putLong("date", requestDate);
            obj.putUtfString("status", status);
            return obj;
        }
    }

    // ========== BUDDY SYSTEM METHODS ==========
    public long createBuddyRequest(String requesterId, String requesterName,
                                  String receiverId, String receiverName) {
        long requestId = System.currentTimeMillis();
        BuddyRequest request = new BuddyRequest(requestId, requesterId, requesterName,
                                               receiverId, receiverName);
        buddyRequests.put(requestId, request);
        
        // Add to user maps
        userOutgoingRequests.computeIfAbsent(requesterId, k -> new HashSet<>()).add(requestId);
        userIncomingRequests.computeIfAbsent(receiverId, k -> new HashSet<>()).add(requestId);
        
        trace("📩 Buddy request created: " + requesterId + " -> " + receiverId);
        return requestId;
    }
    
    public BuddyRequest getBuddyRequest(long requestId) {
        return buddyRequests.get(requestId);
    }
    
    public List<BuddyRequest> getIncomingRequests(String userId) {
        List<BuddyRequest> requests = new ArrayList<>();
        Set<Long> requestIds = userIncomingRequests.get(userId);
        if (requestIds != null) {
            for (Long requestId : requestIds) {
                BuddyRequest request = buddyRequests.get(requestId);
                if (request != null && "PENDING".equals(request.getStatus())) {
                    requests.add(request);
                }
            }
        }
        return requests;
    }
    
    public List<BuddyRequest> getOutgoingRequests(String userId) {
        List<BuddyRequest> requests = new ArrayList<>();
        Set<Long> requestIds = userOutgoingRequests.get(userId);
        if (requestIds != null) {
            for (Long requestId : requestIds) {
                BuddyRequest request = buddyRequests.get(requestId);
                if (request != null && "PENDING".equals(request.getStatus())) {
                    requests.add(request);
                }
            }
        }
        return requests;
    }
    
    public boolean addBuddy(String userId1, String userName1, String userId2, String userName2) {
        // Add each other as buddies
        userBuddies.computeIfAbsent(userId1, k -> new HashSet<>()).add(userId2);
        userBuddies.computeIfAbsent(userId2, k -> new HashSet<>()).add(userId1);
        
        // Remove the request
        cleanupBuddyRequest(userId1, userId2);
        
        trace("🤝 Buddies added: " + userId1 + " <-> " + userId2);
        return true;
    }
    
    public boolean removeBuddy(String userId1, String userId2) {
        Set<String> buddies1 = userBuddies.get(userId1);
        Set<String> buddies2 = userBuddies.get(userId2);
        
        if (buddies1 != null) buddies1.remove(userId2);
        if (buddies2 != null) buddies2.remove(userId1);
        
        trace("🚫 Buddy removed: " + userId1 + " -X- " + userId2);
        return true;
    }
    
    public List<String> getBuddies(String userId) {
        Set<String> buddies = userBuddies.get(userId);
        return buddies != null ? new ArrayList<>(buddies) : new ArrayList<>();
    }
    
    public boolean areBuddies(String userId1, String userId2) {
        Set<String> buddies = userBuddies.get(userId1);
        return buddies != null && buddies.contains(userId2);
    }
    
    public boolean hasPendingRequest(String requesterId, String receiverId) {
        for (BuddyRequest request : buddyRequests.values()) {
            if (request.getRequesterId().equals(requesterId) &&
                request.getReceiverId().equals(receiverId) &&
                "PENDING".equals(request.getStatus())) {
                return true;
            }
        }
        return false;
    }
    
    public void acceptBuddyRequest(long requestId) {
        BuddyRequest request = buddyRequests.get(requestId);
        if (request != null && "PENDING".equals(request.getStatus())) {
            request.setStatus("ACCEPTED");
            addBuddy(request.getRequesterId(), request.getRequesterName(),
                    request.getReceiverId(), request.getReceiverName());
        }
    }
    
    public void rejectBuddyRequest(long requestId) {
        BuddyRequest request = buddyRequests.get(requestId);
        if (request != null && "PENDING".equals(request.getStatus())) {
            request.setStatus("REJECTED");
            cleanupBuddyRequest(request.getRequesterId(), request.getReceiverId());
        }
    }
    
    private void cleanupBuddyRequest(String requesterId, String receiverId) {
        // Find and remove the request
        BuddyRequest toRemove = null;
        for (BuddyRequest request : buddyRequests.values()) {
            if (request.getRequesterId().equals(requesterId) &&
                request.getReceiverId().equals(receiverId) &&
                "PENDING".equals(request.getStatus())) {
                toRemove = request;
                break;
            }
        }
        
        if (toRemove != null) {
            buddyRequests.remove(toRemove.getRequestId());
            
            // Clean up user maps
            cleanupFromSet(userOutgoingRequests.get(requesterId), toRemove.getRequestId());
            cleanupFromSet(userIncomingRequests.get(receiverId), toRemove.getRequestId());
        }
    }
    
    private void cleanupFromSet(Set<Long> set, Long value) {
        if (set != null) {
            set.remove(value);
            if (set.isEmpty()) {
                // Don't keep empty sets
            }
        }
    }

    // ========== USER STATE CLASS ==========
    public static final class UserState {
        private final int userId;
        private final String userName;
        private String avatarName;
        private boolean guest = true;
        private String gender = "m";
        private String clothesJson = "[]";
        private ISFSArray clothesItems = new SFSArray();
        private String position = "275,614";
        private int direction = 0;
        // Default to no special permissions; will be recomputed from cards/privilege.
        private String roles = PermissionCodec.empty();
        private double avatarSize = 1.0;
        private String smiley = "";
        private String hand = "";
        private double speed = 100;
        private String target = "";
        private String status = "idle";
        private String universeKey = "w8";
        private String fbPermissions = "";
        private String currentRoom = "";
        private int mood = 0;
        private String statusMessage = "";
        private String chatBalloon = "1";
        private String optimizedAssetKey = "";
        private int typing = 0;
        private ISFSArray wallet = new SFSArray();
        private ISFSArray inventory = new SFSArray();
        private ISFSArray quests = new SFSArray();
        private ISFSArray orders = new SFSArray();

        // Profile data
        private ProfileData profile;
        private final Set<String> blockedAvatarIds = new HashSet<>();
        
        // Buddy system - NEW SYSTEM
        private final Set<String> buddySet = new HashSet<>();
        private final List<BuddyRequest> incomingRequests = new ArrayList<>();
        
        // Buddy system - OLD SYSTEM COMPATIBILITY
        private ISFSArray buddyListArray = new SFSArray();
        private ISFSArray buddyRequestsArray = new SFSArray();

        public UserState(int userId, String userName) {
            this.userId = userId;
            this.userName = userName == null ? "" : userName;
            this.avatarName = isBlank(this.userName) ? "Guest" + userId : this.userName;
            this.quests = buildDefaultQuests();
            this.hand = "0";
            this.speed = 100;
        }

        // ========== BUDDY METHODS (NEW SYSTEM) ==========
        public boolean isBuddy(String avatarId) {
            return buddySet.contains(avatarId);
        }
        
        public void addBuddy(String avatarId) {
            buddySet.add(avatarId);
            updateBuddyListArray();
        }
        
        public void removeBuddy(String avatarId) {
            buddySet.remove(avatarId);
            updateBuddyListArray();
        }
        
        public List<String> getBuddyList() {
            return new ArrayList<>(buddySet);
        }
        
        public void addIncomingRequest(BuddyRequest request) {
            incomingRequests.add(request);
            updateBuddyRequestsArray();
        }
        
        public List<BuddyRequest> getIncomingRequests() {
            return new ArrayList<>(incomingRequests);
        }
        
        public void removeRequest(long requestId) {
            incomingRequests.removeIf(req -> req.getRequestId() == requestId);
            updateBuddyRequestsArray();
        }
        
        private void updateBuddyListArray() {
            buddyListArray = new SFSArray();
            for (String buddyId : buddySet) {
                SFSObject buddyObj = new SFSObject();
                buddyObj.putUtfString("avatarID", buddyId);
                buddyObj.putUtfString("avatarName", buddyId);
                buddyObj.putBool("isOnline", true);
                buddyObj.putInt("mood", 1);
                buddyObj.putInt("buddyRating", 1);
                buddyObj.putInt("myRating", 1);
                buddyObj.putUtfString("imgPath", "");
                buddyObj.putUtfString("status", "");
                buddyListArray.addSFSObject(buddyObj);
            }
        }
        
        private void updateBuddyRequestsArray() {
            buddyRequestsArray = new SFSArray();
            for (BuddyRequest request : incomingRequests) {
                if ("PENDING".equals(request.getStatus())) {
                    SFSObject reqObj = new SFSObject();
                    reqObj.putUtfString("avatarID", request.getRequesterId());
                    reqObj.putUtfString("avatarName", request.getRequesterName());
                    reqObj.putLong("date", request.getRequestDate());
                    buddyRequestsArray.addSFSObject(reqObj);
                }
            }
        }

        // ========== OLD COMPATIBILITY METHODS ==========
        public List<BuddyData> getBuddyDataList() {
            List<BuddyData> list = new ArrayList<>();
            for (String buddyId : buddySet) {
                list.add(new BuddyData(
                    buddyId, buddyId, true, 1, 1, 1, "", ""
                ));
            }
            return list;
        }
        
        public List<BuddyRequest> getBuddyRequestList() {
            return new ArrayList<>(incomingRequests);
        }
        
        public ISFSArray getBuddies() {
            return buddyListArray;
        }
        
        public ISFSArray getBuddyRequests() {
            return buddyRequestsArray;
        }
        
        public void setBuddies(ISFSArray buddies) {
            buddyListArray = buddies;
            buddySet.clear();
            for (int i = 0; i < buddies.size(); i++) {
                ISFSObject buddy = buddies.getSFSObject(i);
                if (buddy != null && buddy.containsKey("avatarID")) {
                    buddySet.add(buddy.getUtfString("avatarID"));
                }
            }
        }

        // ========== BUDDY DATA CLASS (للتوافق مع الكود القديم) ==========
        public static class BuddyData {
            private final String avatarId;
            private final String avatarName;
            private final boolean isOnline;
            private final int mood;
            private final int buddyRating;
            private final int myRating;
            private final String imgPath;
            private final String status;
            
            public BuddyData(String avatarId, String avatarName, boolean isOnline, 
                           int mood, int buddyRating, int myRating, String imgPath, String status) {
                this.avatarId = avatarId;
                this.avatarName = avatarName;
                this.isOnline = isOnline;
                this.mood = mood;
                this.buddyRating = buddyRating;
                this.myRating = myRating;
                this.imgPath = imgPath;
                this.status = status;
            }
            
            public String getAvatarId() { return avatarId; }
            public String getAvatarName() { return avatarName; }
            public boolean isOnline() { return isOnline; }
            public int getMood() { return mood; }
            public int getBuddyRating() { return buddyRating; }
            public int getMyRating() { return myRating; }
            public String getImgPath() { return imgPath; }
            public String getStatus() { return status; }
        }

        // ========== GETTERS & SETTERS ==========
        public int getUserId() { return userId; }
        public String getUserName() { return userName; }
        public String getAvatarName() { return avatarName; }
        public void setAvatarName(String avatarName) {
            this.avatarName = avatarName;
            if (profile != null) {
                profile.setAvatarName(avatarName);
            }
        }
        public boolean isGuest() { return guest; }
        public void setGuest(boolean guest) { this.guest = guest; }
        public String getGender() { return gender; }
        public void setGender(String gender) { this.gender = gender; }
        public String getClothesJson() { return clothesJson; }
        public void setClothesJson(String clothesJson) { this.clothesJson = clothesJson; }
        public ISFSArray getClothesItems() { return clothesItems; }
        
        public void setClothesItems(ISFSArray items) {
            if (items == null) {
                clothesItems = new SFSArray();
                clothesJson = "[]";
                return;
            }
            clothesItems = new SFSArray();
            for (int i = 0; i < items.size(); i++) {
                clothesItems.addSFSObject(items.getSFSObject(i));
            }
            clothesJson = items.toJson();
        }
        
        public String getPosition() { return position; }
        public void setPosition(String position) { this.position = position; }
        public int getDirection() { return direction; }
        public void setDirection(int direction) { this.direction = direction; }
        public String getRoles() { return roles; }
        public void setRoles(String roles) { this.roles = roles; }
        public String getOptimizedAssetKey() { return optimizedAssetKey; }
        public void setOptimizedAssetKey(String optimizedAssetKey) { this.optimizedAssetKey = optimizedAssetKey; }
        public double getAvatarSize() { return avatarSize; }
        public void setAvatarSize(double avatarSize) { this.avatarSize = avatarSize; }
        public String getSmiley() { return smiley; }
        public void setSmiley(String smiley) { this.smiley = smiley; }
        public String getHand() { return hand; }
        public void setHand(String hand) { this.hand = hand; }
        public double getSpeed() { return speed; }
        public void setSpeed(double speed) { this.speed = speed; }
        public String getTarget() { return target; }
        public void setTarget(String target) { this.target = target; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getUniverseKey() { return universeKey; }
        public void setUniverseKey(String universeKey) { this.universeKey = universeKey; }
        public String getFbPermissions() { return fbPermissions; }
        public void setFbPermissions(String fbPermissions) { this.fbPermissions = fbPermissions; }
        public String getCurrentRoom() { return currentRoom; }
        public void setCurrentRoom(String currentRoom) { this.currentRoom = currentRoom == null ? "" : currentRoom; }
        public int getMood() { return mood; }
        public void setMood(int mood) { this.mood = mood; }
        public String getStatusMessage() { return statusMessage; }
        public void setStatusMessage(String statusMessage) {
            this.statusMessage = statusMessage == null ? "" : statusMessage;
            if (profile != null) {
                profile.setStatusMessage(this.statusMessage);
            }
        }
        public String getChatBalloon() { return chatBalloon; }
        public void setChatBalloon(String chatBalloon) { this.chatBalloon = chatBalloon == null ? "1" : chatBalloon; }
        public int getTyping() { return typing; }
        public void setTyping(int typing) { this.typing = typing; }
        public ISFSArray getWallet() { return wallet; }
        
        public void setWallet(ISFSArray walletArray) {
            wallet = new SFSArray();
            if (walletArray != null) {
                for (int i = 0; i < walletArray.size(); i++) {
                    wallet.addSFSObject(walletArray.getSFSObject(i));
                }
            }
        }
        
        public ISFSArray getInventory() { return inventory; }
        public ISFSArray getQuests() { return quests; }
        public ISFSArray getOrders() { return orders; }

        public ProfileData getProfile() { return profile; }
        public void attachProfile(ProfileData profile) {
            this.profile = profile;
            if (this.profile != null) {
                this.profile.setAvatarName(avatarName);
                this.profile.setStatusMessage(statusMessage);
            }
        }

        public boolean isBlocked(String avatarId) {
            return avatarId != null && blockedAvatarIds.contains(avatarId);
        }

        public void blockUser(String avatarId) {
            if (avatarId != null) {
                blockedAvatarIds.add(avatarId);
            }
        }

        public void unblockUser(String avatarId) {
            if (avatarId != null) {
                blockedAvatarIds.remove(avatarId);
            }
        }

        private static ISFSArray buildDefaultQuests() {
            SFSArray quests = new SFSArray();
            quests.addSFSObject(buildPeriodicQuest(-154128, "cosmicStone", 4));
            quests.addSFSObject(buildPeriodicQuest(-154129, "sapling_task", 10));
            quests.addSFSObject(buildPeriodicQuest(-154130, "snowlyFlower", 5));
            quests.addSFSObject(buildPeriodicQuest(-154131, "snowman", 7));
            quests.addSFSObject(buildPeriodicQuest(-154132, "paperDelivery", 7));
            quests.addSFSObject(buildPeriodicQuest(-154133, "GuitarMakingTask", 7));
            quests.addSFSObject(buildPeriodicQuest(-154134, "trashQuest", 6));
            return quests;
        }

        private static SFSObject buildPeriodicQuest(int id, String metaKey, int totalStep) {
            SFSObject quest = new SFSObject();
            quest.putInt("totalStep", totalStep);
            quest.putUtfString("metaKey", metaKey);
            quest.putUtfString("type", "PERIODIC");
            quest.putInt("rewardMultiplier", 1);
            quest.putInt("currentStep", 1);
            quest.putInt("id", id);
            quest.putUtfString("status", "NEW");
            return quest;
        }
    }

    // ========== ROOM STATE CLASS ==========
    public static final class RoomState {
        private final String roomName;
        private String doorsJson = "[]";
        private String botsJson = "[]";
        private String mapBase64 = "";
        private String gridBase64 = "";
        private ISFSArray sceneItems = new SFSArray();
        private final SFSObject roomInfo = new SFSObject();

        public RoomState(String roomName) {
            this.roomName = roomName;
            roomInfo.putUtfString("key", roomName);
            roomInfo.putUtfString("doorKey", MapBuilder.DEFAULT_DOOR_KEY);
            roomInfo.putInt("pv", 0);
            roomInfo.putInt("dv", 0);
            mapBase64 = MapBuilder.buildMapBase64();
            doorsJson = MapBuilder.buildDoorsJson();
            gridBase64 = MapBuilder.buildGridBase64();
            botsJson = MapBuilder.buildBotsJson();
            sceneItems = MapBuilder.buildSceneItems();
        }

        public String getRoomName() { return roomName; }
        public String getDoorsJson() { return doorsJson; }
        public void setDoorsJson(String doorsJson) { this.doorsJson = doorsJson; }
        public String getBotsJson() { return botsJson; }
        public void setBotsJson(String botsJson) { this.botsJson = botsJson; }
        public SFSObject getRoomInfo() { return roomInfo; }
        public String getMapBase64() { return mapBase64; }
        public void setMapBase64(String mapBase64) { this.mapBase64 = mapBase64 == null ? "" : mapBase64; }
        public String getGridBase64() { return gridBase64; }
        public void setGridBase64(String gridBase64) { this.gridBase64 = gridBase64 == null ? "" : gridBase64; }

        public synchronized ISFSArray getSceneItems() {
            ISFSArray copy = new SFSArray();
            if (sceneItems != null) {
                for (int i = 0; i < sceneItems.size(); i++) {
                    copy.addSFSObject(sceneItems.getSFSObject(i));
                }
            }
            return copy;
        }

        public synchronized void setSceneItems(ISFSArray items) {
            sceneItems = new SFSArray();
            if (items != null) {
                for (int i = 0; i < items.size(); i++) {
                    sceneItems.addSFSObject(items.getSFSObject(i));
                }
            }
        }

        public SFSObject buildRoomPayload(String doorKey) {
            SFSObject room = new SFSObject();
            room.putUtfString("key", roomName);
            room.putUtfString("doorKey", doorKey == null ? MapBuilder.DEFAULT_DOOR_KEY : doorKey);
            room.putInt("pv", roomInfo.getInt("pv"));
            room.putInt("dv", roomInfo.getInt("dv"));
            room.putUtfString("map", mapBase64);
            return room;
        }
    }

    // ========== STORE DATA CLASS ==========
    private static class StoreData {
        List<StoreItem> cards = new ArrayList<>();
        List<StoreItem> handItems = new ArrayList<>();
        int lastCardUpdate = 0;
        int lastHandItemUpdate = 0;
    }

    
    // ========== BAN RECORD CLASS ==========
    public static class BanRecord {
        public final String type; // "CHAT" or "LOGIN"
        public final long startEpochSec;
        public final long endEpochSec; // -1 for eternal
        public final String startDate;
        public final String endDate; // null for eternal

        public BanRecord(String type, long startEpochSec, long endEpochSec) {
            this.type = type == null ? "CHAT" : type;
            this.startEpochSec = startEpochSec;
            this.endEpochSec = endEpochSec;
            this.startDate = formatEpoch(startEpochSec);
            this.endDate = endEpochSec < 0 ? null : formatEpoch(endEpochSec);
        }

        public boolean isLimited() { return endEpochSec >= 0; }

        public int timeLeftSec(long nowEpochSec) {
            if (endEpochSec < 0) return -1;
            long left = endEpochSec - nowEpochSec;
            if (left < 0) return 0;
            if (left > Integer.MAX_VALUE) return Integer.MAX_VALUE;
            return (int) left;
        }

        public boolean isExpired(long nowEpochSec) {
            return endEpochSec >= 0 && nowEpochSec >= endEpochSec;
        }

        public SFSObject toSFSObject(long nowEpochSec) {
            SFSObject obj = new SFSObject();
            obj.putUtfString("type", type);
            obj.putInt("timeLeft", timeLeftSec(nowEpochSec));
            obj.putUtfString("startDate", startDate);
            if (endDate != null) obj.putUtfString("endDate", endDate);
            return obj;
        }
    }

    private static String formatEpoch(long epochSec) {
        try {
            java.time.Instant inst = java.time.Instant.ofEpochSecond(epochSec);
            java.time.ZonedDateTime zdt = java.time.ZonedDateTime.ofInstant(inst, java.time.ZoneOffset.UTC);
            // Client expects "YYYY-MM-DD HH:mm:ss.0" style (as seen in logs)
            return String.format(java.util.Locale.ROOT, "%04d-%02d-%02d %02d:%02d:%02d.0",
                zdt.getYear(), zdt.getMonthValue(), zdt.getDayOfMonth(),
                zdt.getHour(), zdt.getMinute(), zdt.getSecond());
        } catch (Exception e) {
            return null;
        }
    }

    // ========== MODERATION HELPERS ==========
    public List<BanRecord> getActiveBansForIp(String ip) {
        if (ip == null) return new ArrayList<>();
        long now = System.currentTimeMillis() / 1000;
        List<BanRecord> list = bansByIp.getOrDefault(ip, Collections.emptyList());
        if (list.isEmpty()) return new ArrayList<>();
        // purge expired
        List<BanRecord> active = new ArrayList<>();
        for (BanRecord br : list) {
            if (br != null && !br.isExpired(now)) {
                active.add(br);
            }
        }
        if (active.size() != list.size()) {
            bansByIp.put(ip, active);
        }
        return active;
    }

    public boolean isIpBanned(String ip, String type) {
        if (ip == null) return false;
        String t = type == null ? "CHAT" : type;
        long now = System.currentTimeMillis() / 1000;
        for (BanRecord br : getActiveBansForIp(ip)) {
            if (t.equalsIgnoreCase(br.type) && !br.isExpired(now)) return true;
        }
        return false;
    }

    public BanRecord addBanForIp(String ip, String type, int durationSec) {
        if (ip == null) return null;
        long now = System.currentTimeMillis() / 1000;
        long end = durationSec < 0 ? -1 : now + Math.max(1, durationSec);
        BanRecord rec = new BanRecord(type, now, end);
        bansByIp.compute(ip, (k, v) -> {
            List<BanRecord> lst = v == null ? new ArrayList<>() : new ArrayList<>(v);
            // remove same type
            lst.removeIf(x -> x != null && rec.type.equalsIgnoreCase(x.type));
            lst.add(rec);
            return lst;
        });
        return rec;
    }

    public boolean removeBanForIp(String ip, String type) {
        if (ip == null) return false;
        String t = type == null ? "CHAT" : type;
        List<BanRecord> cur = bansByIp.get(ip);
        if (cur == null || cur.isEmpty()) return false;
        int before = cur.size();
        cur.removeIf(x -> x != null && t.equalsIgnoreCase(x.type));
        if (cur.isEmpty()) bansByIp.remove(ip);
        return cur.size() != before;
    }

    public SFSArray getActiveBansSFS(String ip) {
        SFSArray arr = new SFSArray();
        long now = System.currentTimeMillis() / 1000;
        for (BanRecord br : getActiveBansForIp(ip)) {
            arr.addSFSObject(br.toSFSObject(now));
        }
        return arr;
    }
// ========== SMILEY ITEM CLASS ==========
    public static class SmileyItem {
        public final int id;
        public final String clip;
        public final String requirements;
        public final int sorting;

        public SmileyItem(int id, String clip, String requirements, int sorting) {
            this.id = id;
            this.clip = clip;
            this.requirements = requirements;
            this.sorting = sorting;
        }

        public SFSObject toSFSObject() {
            SFSObject obj = new SFSObject();
            obj.putUtfString("requirements", requirements);
            obj.putInt("id", id);
            obj.putUtfString("metaKey", clip);
            obj.putInt("sorting", sorting);
            return obj;
        }
    }

    // ========== STORE ITEM CLASS ==========
    public static class StoreItem {
        int color;
        boolean transferrable;
        int productID;
        String source;
        long expire;
        int quantity;
        String subType;
        long lifeTime;
        int base;
        String createdAt;
        long timeLeft;
        long id;
        String roles;
        int active;
        String clip;

        public StoreItem(long id, int productID, String clip, String subType, String source, 
                        long lifeTime, int quantity, long expire, String createdAt,
                        boolean transferrable, int color, String roles) {
            this.id = id;
            this.productID = productID;
            this.clip = clip;
            this.subType = subType;
            this.source = source;
            this.lifeTime = lifeTime;
            this.quantity = quantity;
            this.expire = expire;
            this.createdAt = createdAt;
            this.transferrable = transferrable;
            this.color = color;
            this.roles = roles;
            this.base = 0;
            this.active = 0;
            
            if (expire > 0) {
                long now = System.currentTimeMillis() / 1000;
                this.timeLeft = Math.max(0, expire - now);
            } else {
                this.timeLeft = lifeTime;
            }
        }

        public SFSObject toSFSObject() {
            SFSObject obj = new SFSObject();
            obj.putInt("color", color);
            obj.putBool("transferrable", transferrable);
            obj.putInt("productID", productID);
            obj.putUtfString("source", source);
            obj.putLong("expire", expire);
            obj.putInt("quantity", quantity);
            obj.putUtfString("subType", subType);
            obj.putLong("lifeTime", lifeTime);
            obj.putInt("base", base);
            obj.putUtfString("createdAt", createdAt);
            obj.putLong("timeLeft", timeLeft);
            obj.putLong("id", id);
            obj.putUtfString("roles", roles);
            obj.putInt("active", active);
            obj.putUtfString("clip", clip);
            return obj;
        }
    }

    // ========== UTILITY METHODS ==========
    public static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private void trace(String message) {
        System.out.println("[STORE] " + message);
    }

    // ========== USER MANAGEMENT ==========
    public UserState getOrCreateUser(User user) {
        return usersById.computeIfAbsent(user.getId(), id -> {
            UserState state = new UserState(id, user.getName());
            usersByName.put(state.getUserName(), state);
            ProfileData profile = getOrCreateProfile(state.getUserName(), state.getAvatarName());
            state.attachProfile(profile);
            trace("👤 Created new UserState for: " + user.getName() + " (ID: " + id + ")");
            return state;
        });
    }

    public UserState findUserByName(String name) {
        return usersByName.get(name);
    }

    public RoomState getOrCreateRoom(Room room) {
        return roomsByName.computeIfAbsent(room.getName(), RoomState::new);
    }

    public String ensureUniqueDisplayName(String baseName, int userId) {
        String normalized = isBlank(baseName) ? "Guest" : baseName.trim();
        String candidate = normalized;
        int counter = 1;
        while (reservedNames.contains(candidate)) {
            candidate = normalized + "#" + userId + "_" + counter;
            counter++;
        }
        reservedNames.add(candidate);
        return candidate;
    }

    public void releaseDisplayName(String name) {
        if (name != null) {
            reservedNames.remove(name);
        }
    }

    // ========== HAND ITEM METHODS ==========
    public StoreItem getHandItemById(int userId, long itemId) {
        StoreData store = userStores.get(userId);
        if (store == null) {
            trace("⚠️ User " + userId + " has no store data");
            return null;
        }
        
        for (StoreItem item : store.handItems) {
            if (item.id == itemId) {
                trace("✅ Found hand item by ID " + itemId + ": " + item.clip);
                return item;
            }
        }
        
        trace("❌ No hand item found with ID " + itemId + " for user " + userId);
        return null;
    }
    
    public StoreItem getHandItemByProductId(int userId, int productId) {
        StoreData store = userStores.get(userId);
        if (store == null) {
            return null;
        }
        
        for (StoreItem item : store.handItems) {
            if (item.productID == productId) {
                trace("✅ Found hand item by productID " + productId + ": " + item.clip);
                return item;
            }
        }
        
        trace("❌ No hand item found with productID " + productId);
        return null;
    }
    
    public StoreItem getHandItemByClip(int userId, String clip) {
        StoreData store = userStores.get(userId);
        if (store == null) {
            return null;
        }
        
        for (StoreItem item : store.handItems) {
            if (clip.equals(item.clip)) {
                trace("✅ Found hand item by clip '" + clip + "'");
                return item;
            }
        }
        
        return null;
    }
    
    public List<StoreItem> getUserHandItems(int userId) {
        StoreData store = userStores.get(userId);
        if (store == null) {
            return new ArrayList<>();
        }
        return new ArrayList<>(store.handItems);
    }

    private StoreData getOrCreateStore(int userId) {
        return userStores.computeIfAbsent(userId, k -> {
            trace("📦 Creating new store for user: " + userId);
            StoreData store = new StoreData();
            initializeSampleStoreData(store);
            return store;
        });
    }

    private void initializeSampleStoreData(StoreData store) {
        if (store.cards.isEmpty()) {
            // Cards shown in profile MUST exist in cardlist too (client expects them there).
            // Card roles must represent the granted permissions (client reads them as a Permission bitset)
            String[] defaultCardClips = new String[] {
                "CARD_GOLD",
                "CARD_ACTOR",
                "CARD_CAFE",
                "CARD_CAPTAIN",
                "CARD_DIAMOND",
                "CARD_DIAMOND_CLUB",
                "CARD_DIRECTOR",
                "CARD_GUARD",
                "CARD_GUIDE",
                "CARD_JOURNALIST",
                "CARD_MODERATOR",
                "CARD_MUSIC",
                "CARD_PAINTER",
                "CARD_PHOTOGRAPHER",
                "CARD_SANALIKAX",
                "CARD_SILVER"
            };

            long baseId = 234300000L;
            int baseProduct = 4000;

            for (int i = 0; i < defaultCardClips.length; i++) {
                String clip = defaultCardClips[i];
                store.cards.add(new StoreItem(
                    baseId + i,
                    baseProduct + i,
                    clip,
                    "VIP",
                    "PAYMENT",
                    2592000, // 30 days
                    1,
                    1771983256L,
                    "2025-12-27 04:34:17.0",
                    false,
                    0,
                    rolesForCardClip(clip)
                ));
            }

            store.lastCardUpdate = (int)(System.currentTimeMillis() / 1000);
            trace("✅ Added default profile cards to cardlist: " + store.cards.size());
        }

        if (store.handItems.isEmpty()) {

            
 
  store.handItems.add(new StoreItem(
                234964833L, 226666, "bbFs32eQ", "TOY", "TRADE_BARTER",
                1296001, 1, 100L, "2025-10-14 22:04:58.0", true, 100, rolesForSource("TRADE_BARTER")
            ));
  store.handItems.add(new StoreItem(
                234964834L, 226667, "Add20se9", "TOY", "TRADE_BARTER",
                1296001, 1, 100L, "2025-10-14 22:04:58.0", true, 100, rolesForSource("TRADE_BARTER")
            ));
  store.handItems.add(new StoreItem(
                234964835L, 226667, "uY3PMwUN", "TOY", "TRADE_BARTER",
                12960066, 1, 100L, "2025-10-14 22:04:58.0", true, 100, rolesForSource("TRADE_BARTER")
            ));
  store.handItems.add(new StoreItem(
                234964836L, 226668, "q7d2i6jg", "TOY", "TRADE_BARTER",
                12960067, 1, 100L, "2025-10-14 22:04:58.0", true, 100, rolesForSource("TRADE_BARTER")
            ));
  store.handItems.add(new StoreItem(
                234964837L, 226668, "28cV2CBR", "TOY", "TRADE_BARTER",
                12960068, 1, 100L, "2025-10-14 22:04:58.0", true, 100, rolesForSource("TRADE_BARTER")
            ));
            store.lastHandItemUpdate = (int)(System.currentTimeMillis() / 1000);
            trace("✅ Added " + store.handItems.size() + " sample hand items");
        }
    }

    /**
     * Card clips grant specific avatar permissions.
     * The returned value MUST be encoded exactly like the client Permission.as
     */
    private static String rolesForCardClip(String clip) {
        if (clip == null) {
            return PermissionCodec.empty();
        }
        String c = clip.trim().toUpperCase(Locale.ROOT);
        List<Integer> grants = new ArrayList<>();

        // VIP cards
        if (c.contains("CARD_GOLD")) {
            grants.add(AvatarPermissionIds.VIP);
            grants.add(AvatarPermissionIds.VIP_GOLD);
        } else if (c.contains("CARD_SILVER")) {
            grants.add(AvatarPermissionIds.VIP);
            grants.add(AvatarPermissionIds.VIP_SILVER);
        } else if (c.contains("CARD_DIAMOND") && !c.contains("DIAMOND_CLUB")) {
            grants.add(AvatarPermissionIds.VIP);
            grants.add(AvatarPermissionIds.VIP_DIAMOND);
        }

        // Special cards / roles
        if (c.contains("DIAMOND_CLUB")) grants.add(AvatarPermissionIds.DIAMOND_CLUB);
        if (c.contains("CARD_SECURITY")) grants.add(AvatarPermissionIds.CARD_SECURITY);
        if (c.contains("EDITOR_SECURITY")) grants.add(AvatarPermissionIds.EDITOR_SECURITY);
        if (c.contains("CARD_JOURNALIST")) grants.add(AvatarPermissionIds.CARD_JOURNALIST);
        if (c.contains("CARD_DIRECTOR")) grants.add(AvatarPermissionIds.CARD_DIRECTOR);
        if (c.contains("CARD_PHOTOGRAPHER")) grants.add(AvatarPermissionIds.CARD_PHOTOGRAPHER);
        if (c.contains("CARD_PAINTER")) grants.add(AvatarPermissionIds.CARD_PAINTER);
        if (c.contains("CARD_ACTOR")) grants.add(AvatarPermissionIds.CARD_ACTOR);
        if (c.contains("CARD_GUIDE")) grants.add(AvatarPermissionIds.CARD_GUIDE);
        if (c.contains("CARD_SANALIKAX")) grants.add(AvatarPermissionIds.CARD_SANALIKAX);
        if (c.contains("CARD_MUSIC")) grants.add(AvatarPermissionIds.CARD_MUSIC);
        if (c.contains("CARD_CAPITAN") || c.contains("CARD_CAPTAIN")) grants.add(AvatarPermissionIds.CARD_CAPITAN);
        if (c.contains("CARD_MODERATOR")) grants.add(AvatarPermissionIds.MODERATOR);
        if (c.contains("CARD_GUARD")) { grants.add(AvatarPermissionIds.CARD_SECURITY); grants.add(AvatarPermissionIds.SECURITY); }
        // CARD_CAFE affects cafe features on client (not a Permission bit). Keep roles empty for it.


        return PermissionCodec.fromGrantedIndexes(grants);
    }

    private static String rolesForSource(String source) {
        if (source == null) {
            return PermissionCodec.empty();
        }
        String s = source.trim().toUpperCase(Locale.ROOT);
        List<Integer> grants = new ArrayList<>();
        // Trade/buy flows in client often depend on TRANSFER/BARTER.
        if (s.contains("BARTER")) grants.add(AvatarPermissionIds.BARTER);
        if (s.contains("TRANSFER")) grants.add(AvatarPermissionIds.TRANSFER);
        return PermissionCodec.fromGrantedIndexes(grants);
    }

    /**
     * Recompute a user's roles as OR of:
     * 1) permissions granted by owned cards
     * 2) extra permissions implied by server privilege (moderator/admin)
     */
    public String recomputeRoles(int userId, short privilegeId) {
        StoreData store = getOrCreateStore(userId);
        String roles = PermissionCodec.empty();
        for (StoreItem card : store.cards) {
            roles = PermissionCodec.or(roles, card.roles);
        }
        if (privilegeId >= 2) {
            // SFS privilege 2 is commonly used as MODERATOR
            roles = PermissionCodec.or(roles, PermissionCodec.fromGrantedIndexes(Collections.singletonList(AvatarPermissionIds.MODERATOR)));
        }
        return roles;
    }

    // ========== STORE RESPONSE METHODS ==========
    public SFSObject getCardListResponse(int userId) {
        StoreData store = getOrCreateStore(userId);
        SFSObject response = new SFSObject();
        response.putUtfString("type", "CARD");
        
        SFSArray itemsArray = new SFSArray();
        for (StoreItem item : store.cards) {
            itemsArray.addSFSObject(item.toSFSObject());
        }
        response.putSFSArray("items", itemsArray);
        response.putInt("nextRequest", 1000);
        
        return response;
    }

    public SFSObject getHandItemListResponse(int userId, int page, String sort, String search) {
        StoreData store = getOrCreateStore(userId);
        SFSObject response = new SFSObject();
        
        int itemsPerPage = 15;
        int totalItems = store.handItems.size();
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
        
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;
        
        int startIndex = (page - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
        
        SFSArray listArray = new SFSArray();
        for (int i = startIndex; i < endIndex; i++) {
            listArray.addSFSObject(store.handItems.get(i).toSFSObject());
        }
        
        SFSObject itemsObj = new SFSObject();
        itemsObj.putInt("page", page);
        itemsObj.putSFSArray("list", listArray);
        
        response.putInt("totalPages", totalPages);
        response.putSFSObject("items", itemsObj);
        response.putInt("pageSelected", page);
        response.putInt("nextRequest", 500);
        
        return response;
    }

    // ========== SMILEY METHODS ==========
    private void initializeSmileys() {
        // Initialize all 68 smileys
        addSmiley(1, "empty", "AA==", 0);
        addSmiley(93, "disco", "AA==", 1);
        addSmiley(123, "kar_tanesi", "AA==", 1);
        addSmiley(154, "sanalika", "AA==", 1);
        addSmiley(245, "LedSnowflake", "AA==", 1);
        addSmiley(240, "Funwin", "AA==", 2);
        addSmiley(242, "lifebuoy", "AA==", 2);
        addSmiley(243, "captainhat", "AAAAAABA", 2);
        addSmiley(244, "anchor", "AAAAAABA", 2);
        addSmiley(264, "CafeSmiley", "AAAIAAAAEA==", 3);
        addSmiley(116, "mutlu", "AA==", 10);
        addSmiley(117, "lol", "AA==", 11);
        addSmiley(12, "cool", "AA==", 12);
        addSmiley(21, "peaceful", "AA==", 12);
        addSmiley(14, "flirty", "AA==", 13);
        addSmiley(16, "nervous", "AA==", 13);
        addSmiley(34, "mutsuz", "AA==", 13);
        addSmiley(39, "sabit", "AA==", 13);
        addSmiley(24, "kahraman", "AA==", 14);
        addSmiley(147, "winking", "AA==", 15);
        addSmiley(4, "mocking", "AA==", 16);
        addSmiley(42, "saskin", "AA==", 17);
        addSmiley(2, "cry", "AA==", 18);
        addSmiley(36, "olu", "AA==", 19);
        addSmiley(19, "ill", "AA==", 20);
        addSmiley(47, "uyku", "AA==", 21);
        addSmiley(163, "sun", "AA==", 22);
        addSmiley(13, "storm", "AA==", 23);
        addSmiley(162, "14subat2", "AA==", 23);
        addSmiley(27, "kirik_kalp", "AA==", 24);
        addSmiley(52, "yonca", "AA==", 24);
        addSmiley(122, "bubbleHeart", "AA==", 24);
        addSmiley(166, "simit", "CA==", 24);
        addSmiley(48, "vip", "CA==", 25);
        addSmiley(87, "diamond", "QA==", 25);
        addSmiley(91, "diamond1", "ACA=", 25);
        addSmiley(167, "kelebek", "iA==", 26);
        addSmiley(165, "alev", "AA==", 27);
        addSmiley(38, "peri", "AA==", 28);
        addSmiley(33, "melek", "AA==", 29);
        addSmiley(119, "yildiz_gokkusagi", "CA==", 29);
        addSmiley(41, "sapka", "AA==", 30);
        addSmiley(49, "yarasa", "AA==", 31);
        addSmiley(131, "on_milyon", "AA==", 32);
        addSmiley(7, "fish", "AA==", 33);
        addSmiley(31, "kurukafa", "AA==", 35);
        addSmiley(23, "kagit", "AA==", 36);
        addSmiley(32, "makas", "AA==", 36);
        addSmiley(44, "tas", "AA==", 36);
        addSmiley(199, "snake_1", "AA==", 37);
        addSmiley(200, "snake_2", "AA==", 38);
        addSmiley(201, "snake3", "AA==", 39);
        addSmiley(202, "train", "AA==", 40);
        addSmiley(203, "train2", "AA==", 41);
        addSmiley(159, "sanalikaX", "AAAAgA==", 53);
        addSmiley(5, "goldStar", "EA==", 54);
        addSmiley(17, "silverStar", "gA==", 55);
        addSmiley(40, "sanil", "CA==", 56);
        addSmiley(169, "knight1", "AIA=", 57);
        addSmiley(196, "guide3", "AAAAEA==", 57);
        addSmiley(218, "director", "AAAE", 57);
        addSmiley(220, "journalist1", "AAAC", 57);
        addSmiley(222, "artist2", "AABA", 57);
        addSmiley(239, "goldCamera", "AAAW", 57);
        addSmiley(170, "actor", "AAAABA==", 58);
        addSmiley(227, "music", "AAAAAAAE", 58);
        addSmiley(2270, "musa", "AAAAAAAE", 58);
        addSmiley(2271, "guard5", "AAAAAAAE", 58);
        addSmiley(104, "nota", "AA==", 110);
    }

    private void addSmiley(int id, String clip, String requirements, int sorting) {
        SmileyItem item = new SmileyItem(id, clip, requirements, sorting);
        smileyItems.add(item);
        smileyById.put(id, item);
        smileyByClip.put(clip, item);
    }

    public SFSObject getSmileyListResponse() {
        SFSObject response = new SFSObject();
        SFSArray smilies = new SFSArray();
        
        for (SmileyItem item : smileyItems) {
            smilies.addSFSObject(item.toSFSObject());
        }
        
        response.putSFSArray("smilies", smilies);
        response.putInt("nextRequest", 1000);
        
        return response;
    }

    public SmileyItem findSmileyById(int id) {
        return smileyById.get(id);
    }

    public SmileyItem findSmileyByClip(String clip) {
        return smileyByClip.get(clip);
    }

    // ========== PROFILE / SKIN DEFINITIONS ==========
    private void initializeProfileSkins() {
        profileSkins.add(new ProfileSkinDefinition(1000, "foprF3Ew", "3d050b", "0.3", "fdeed5", "AA==", "سكن أحمر داكن", "سـموكـر"));
        profileSkins.add(new ProfileSkinDefinition(1001, "p6yPb4aN", "4c758e", "0.4", "ffffff", "AA==", "سكن أزرق", "mohammad_adi"));
        profileSkins.add(new ProfileSkinDefinition(1002, "fx8M8nDf", "700b37", "0.3", "ffd5e2", "AA==", "سكن بنفسجي", "`Qi"));
        profileSkins.add(new ProfileSkinDefinition(1003, "foprF3Ew", "FEFFF2", "1", "fdeed5", "", "سكن افتراضي", "النظام"));
    }

    public List<ProfileSkinDefinition> getProfileSkins() {
        return profileSkins;
    }

    public ProfileSkinDefinition findProfileSkinDefinition(String clip) {
        if (clip == null) {
            return null;
        }
        for (ProfileSkinDefinition def : profileSkins) {
            if (clip.equals(def.getClip())) {
                return def;
            }
        }
        return null;
    }

    public ProfileData getOrCreateProfile(String avatarId, String avatarName) {
        if (isBlank(avatarId)) {
            avatarId = "unknown";
        }
        final String id = avatarId;
        ProfileData data = profilesByAvatarId.computeIfAbsent(id, key -> new ProfileData(key, avatarName));
        if (!isBlank(avatarName)) {
            data.setAvatarName(avatarName);
        }
        return data;
    }

    public ProfileData getProfileByAvatarId(String avatarId) {
        if (isBlank(avatarId)) {
            return null;
        }
        return profilesByAvatarId.get(avatarId);
    }

    public ProfileData resolveProfile(String avatarId, String avatarNameFallback) {
        UserState state = findUserByName(avatarId);
        if (state != null && state.getProfile() != null) {
            return state.getProfile();
        }
        return getOrCreateProfile(avatarId, avatarNameFallback);
    }

    public void incrementBanCount(String avatarId) {
        ProfileData data = getOrCreateProfile(avatarId, avatarId);
        data.incrementBanCount();
    }

    public int getBanCount(String avatarId) {
        ProfileData data = getProfileByAvatarId(avatarId);
        return data == null ? 0 : data.getBanCount();
    }

    public SFSArray buildBuddyListArray(String userId) {
        SFSArray list = new SFSArray();
        if (isBlank(userId)) {
            return list;
        }
        Set<String> buddies = userBuddies.get(userId);
        if (buddies == null) {
            return list;
        }
        for (String buddyId : buddies) {
            SFSObject buddyObj = new SFSObject();
            buddyObj.putUtfString("avatarID", buddyId);
            UserState buddyState = findUserByName(buddyId);
            ProfileData profile = resolveProfile(buddyId, buddyId);
            buddyObj.putUtfString("avatarName", profile != null ? profile.getAvatarName() : buddyId);
            buddyObj.putBool("isOnline", buddyState != null);
            buddyObj.putInt("mood", buddyState != null ? buddyState.getMood() : 0);
            buddyObj.putInt("buddyRating", 1);
            buddyObj.putInt("myRating", 1);
            buddyObj.putUtfString("imgPath", "");
            buddyObj.putUtfString("status", buddyState != null ? buddyState.getStatusMessage() : "");
            list.addSFSObject(buddyObj);
        }
        return list;
    }

    public SFSArray buildBuddyRequestsArray(String userId) {
        SFSArray list = new SFSArray();
        if (isBlank(userId)) {
            return list;
        }
        for (BuddyRequest request : getIncomingRequests(userId)) {
            SFSObject reqObj = new SFSObject();
            reqObj.putUtfString("avatarID", request.getRequesterId());
            reqObj.putUtfString("avatarName", request.getRequesterName());
            reqObj.putLong("date", request.getRequestDate());
            reqObj.putUtfString("status", request.getStatus());
            reqObj.putLong("requestId", request.getRequestId());
            list.addSFSObject(reqObj);
        }
        return list;
    }

    public SFSObject buildBuddyEntry(String buddyId) {
        SFSObject buddyObj = new SFSObject();
        buddyObj.putUtfString("avatarID", buddyId);
        UserState buddyState = findUserByName(buddyId);
        ProfileData profile = resolveProfile(buddyId, buddyId);
        buddyObj.putUtfString("avatarName", profile != null ? profile.getAvatarName() : buddyId);
        buddyObj.putBool("isOnline", buddyState != null);
        buddyObj.putInt("mood", buddyState != null ? buddyState.getMood() : 0);
        buddyObj.putInt("buddyRating", 1);
        buddyObj.putInt("myRating", 1);
        buddyObj.putUtfString("imgPath", "");
        buddyObj.putUtfString("status", buddyState != null ? buddyState.getStatusMessage() : "");
        return buddyObj;
    }

    // ========== PROFILE DATA CLASS ==========
    public static final class ProfileData {
        private final String avatarId;
        private String avatarName;
        private String city = "";
        private String age = "";
        private String statusMessage = "";
        private int banCount = 0;
        private ProfileSkin skin = ProfileSkin.defaultSkin();
        private final Set<String> likedBy = ConcurrentHashMap.newKeySet();
        private final Set<String> dislikedBy = ConcurrentHashMap.newKeySet();

        public ProfileData(String avatarId, String avatarName) {
            this.avatarId = avatarId;
            this.avatarName = avatarName == null ? "" : avatarName;
        }

        public String getAvatarId() { return avatarId; }
        public String getAvatarName() { return avatarName; }
        public void setAvatarName(String avatarName) { this.avatarName = avatarName == null ? "" : avatarName; }
        public String getCity() { return city; }
        public void setCity(String city) { this.city = city == null ? "" : city; }
        public String getAge() { return age; }
        public void setAge(String age) { this.age = age == null ? "" : age; }
        public String getStatusMessage() { return statusMessage; }
        public void setStatusMessage(String statusMessage) { this.statusMessage = statusMessage == null ? "" : statusMessage; }
        public int getBanCount() { return banCount; }
        public void incrementBanCount() { banCount++; }
        public void setBanCount(int banCount) { this.banCount = Math.max(0, banCount); }
        public ProfileSkin getSkin() { return skin; }
        public void setSkin(ProfileSkin skin) { this.skin = skin == null ? ProfileSkin.defaultSkin() : skin; }

        public int getLikeCount() { return likedBy.size(); }
        public int getDislikeCount() { return dislikedBy.size(); }

        public int getUserLikeStatus(String userId) {
            if (userId == null) {
                return 0;
            }
            if (likedBy.contains(userId)) {
                return 1;
            }
            if (dislikedBy.contains(userId)) {
                return -1;
            }
            return 0;
        }

        public void applyLikeStatus(String userId, int status) {
            if (userId == null) {
                return;
            }
            likedBy.remove(userId);
            dislikedBy.remove(userId);
            if (status == 1) {
                likedBy.add(userId);
            } else if (status == -1) {
                dislikedBy.add(userId);
            }
        }
    }

    public static final class ProfileSkinDefinition {
        private final int id;
        private final String clip;
        private final String bgColor;
        private final String alpha;
        private final String textColor;
        private final String roles;
        private final String name;
        private final String author;

        public ProfileSkinDefinition(int id, String clip, String bgColor, String alpha,
                                     String textColor, String roles, String name, String author) {
            this.id = id;
            this.clip = clip;
            this.bgColor = bgColor;
            this.alpha = alpha;
            this.textColor = textColor;
            this.roles = roles;
            this.name = name;
            this.author = author;
        }

        public int getId() { return id; }
        public String getClip() { return clip; }
        public String getBgColor() { return bgColor; }
        public String getAlpha() { return alpha; }
        public String getTextColor() { return textColor; }
        public String getRoles() { return roles; }
        public String getName() { return name; }
        public String getAuthor() { return author; }
    }

    public static final class ProfileSkin {
        private final String clip;
        private final String bgColor;
        private final String alpha;
        private final String textColor;
        private final String roles;

        public ProfileSkin(String clip, String bgColor, String alpha, String textColor, String roles) {
            this.clip = clip == null ? "" : clip;
            this.bgColor = bgColor == null ? "" : bgColor;
            this.alpha = alpha == null ? "" : alpha;
            this.textColor = textColor == null ? "" : textColor;
            this.roles = roles == null ? "" : roles;
        }

        public static ProfileSkin defaultSkin() {
            return new ProfileSkin("", "FEFFF2", "1", "fdeed5", "");
        }

        public String getClip() { return clip; }
        public String getBgColor() { return bgColor; }
        public String getAlpha() { return alpha; }
        public String getTextColor() { return textColor; }
        public String getRoles() { return roles; }

        public SFSObject toSFSObject() {
            SFSObject skin = new SFSObject();
            skin.putUtfString("clip", clip);
            SFSObject property = new SFSObject();
            property.putUtfString("bgColor", bgColor);
            property.putUtfString("alpha", alpha);
            property.putUtfString("cn", "ProfileSkinProperty");
            property.putUtfString("textColor", textColor);
            skin.putSFSObject("property", property);
            skin.putUtfString("roles", roles);
            return skin;
        }
    }


// ========== COMPLAINT / GUIDE RECORDS ==========
public static class ComplaintRecord {
    public final long id;
    public final String reporterId;
    public final String reporterName;
    public final String targetId;
    public final String targetName;
    public final String roomName;
    public final String text;
    public final String reason;
    public final long createdAtEpochSec;
    public volatile String status; // OPEN, RESOLVED

    public ComplaintRecord(long id, String reporterId, String reporterName,
                           String targetId, String targetName,
                           String roomName, String text, String reason, long createdAtEpochSec) {
        this.id = id;
        this.reporterId = reporterId;
        this.reporterName = reporterName;
        this.targetId = targetId;
        this.targetName = targetName;
        this.roomName = roomName;
        this.text = text;
        this.reason = reason;
        this.createdAtEpochSec = createdAtEpochSec;
        this.status = "OPEN";
    }

    public ISFSObject toSFSObject() {
        SFSObject o = new SFSObject();
        o.putLong("id", id);
        o.putUtfString("reporterId", reporterId);
        o.putUtfString("reporterName", reporterName);
        o.putUtfString("targetId", targetId);
        o.putUtfString("targetName", targetName);
        o.putUtfString("room", roomName);
        if (text != null) o.putUtfString("text", text);
        if (reason != null) o.putUtfString("reason", reason);
        o.putLong("time", createdAtEpochSec);
        o.putUtfString("status", status);
        return o;
    }
}

public static class ReportRecord {
    public final long reportId;
    public final String reporterId;
    public final String reportedId;
    public final String message;
    public final String comment;
    public final long createdAtEpochSec;
    public volatile String status; // OPEN, RESOLVED
    public volatile int isPervert;
    public volatile int isAbuse;
    public volatile int banCount;
    public volatile int nextBanMin;

    public ReportRecord(long reportId, String reporterId, String reportedId, String message, String comment,
                        int isPervert, int banCount, int nextBanMin, long createdAtEpochSec) {
        this.reportId = reportId;
        this.reporterId = reporterId;
        this.reportedId = reportedId;
        this.message = message == null ? "" : message;
        this.comment = comment == null ? "" : comment;
        this.isPervert = Math.max(0, isPervert);
        this.isAbuse = 0;
        this.banCount = Math.max(0, banCount);
        this.nextBanMin = Math.max(0, nextBanMin);
        this.createdAtEpochSec = createdAtEpochSec;
        this.status = "OPEN";
    }
}

public static class GuideRequestRecord {
    public final long id;
    public final String requesterId;
    public final String requesterName;
    public final String roomName;
    public final String message;
    public final long createdAtEpochSec;
    public volatile String status; // OPEN, TAKEN, CLOSED
    public volatile String assignedGuideId;
    public volatile String assignedGuideName;

    public GuideRequestRecord(long id, String requesterId, String requesterName,
                              String roomName, String message, long createdAtEpochSec) {
        this.id = id;
        this.requesterId = requesterId;
        this.requesterName = requesterName;
        this.roomName = roomName;
        this.message = message;
        this.createdAtEpochSec = createdAtEpochSec;
        this.status = "OPEN";
    }

    public ISFSObject toSFSObject() {
        SFSObject o = new SFSObject();
        o.putLong("id", id);
        o.putUtfString("requesterId", requesterId);
        o.putUtfString("requesterName", requesterName);
        o.putUtfString("room", roomName);
        if (message != null) o.putUtfString("message", message);
        o.putLong("time", createdAtEpochSec);
        o.putUtfString("status", status);
        if (assignedGuideId != null) o.putUtfString("guideId", assignedGuideId);
        if (assignedGuideName != null) o.putUtfString("guideName", assignedGuideName);
        return o;
    }
}

// ========== COMPLAINTS API ==========
public long addComplaint(String reporterId, String reporterName, String targetId, String targetName,
                         String roomName, String text, String reason) {
    long id = System.currentTimeMillis();
    long now = System.currentTimeMillis() / 1000;
    ComplaintRecord rec = new ComplaintRecord(id, reporterId, reporterName, targetId, targetName, roomName, text, reason, now);
    complaintsById.put(id, rec);
    complaintOrder.add(0, id);
    return id;
}

public List<ComplaintRecord> listComplaints(String statusOrNull, int limit) {
    List<ComplaintRecord> out = new ArrayList<>();
    synchronized (complaintOrder) {
        for (Long id : complaintOrder) {
            ComplaintRecord r = complaintsById.get(id);
            if (r == null) continue;
            if (statusOrNull != null && !statusOrNull.equalsIgnoreCase(r.status)) continue;
            out.add(r);
            if (limit > 0 && out.size() >= limit) break;
        }
    }
    return out;
}

public ComplaintRecord getComplaint(long id) {
    return complaintsById.get(id);
}

public boolean resolveComplaint(long id) {
    ComplaintRecord r = complaintsById.get(id);
    if (r == null) return false;
    r.status = "RESOLVED";
    return true;
}

// ========== REPORTS API ==========
public long addReport(String reporterId, String reportedId, String message, String comment,
                      int isPervert, int banCount, int nextBanMin) {
    long id = System.currentTimeMillis();
    long now = System.currentTimeMillis() / 1000;
    ReportRecord rec = new ReportRecord(id, reporterId, reportedId, message, comment, isPervert, banCount, nextBanMin, now);
    reportsById.put(id, rec);
    reportOrder.add(0, id);
    return id;
}

public List<ReportRecord> listReports(String statusOrNull, int limit) {
    List<ReportRecord> out = new ArrayList<>();
    synchronized (reportOrder) {
        for (Long id : reportOrder) {
            ReportRecord r = reportsById.get(id);
            if (r == null) continue;
            if (statusOrNull != null && !statusOrNull.equalsIgnoreCase(r.status)) continue;
            out.add(r);
            if (limit > 0 && out.size() >= limit) break;
        }
    }
    return out;
}

public ReportRecord getReport(long id) {
    return reportsById.get(id);
}

public boolean resolveReport(long id) {
    ReportRecord r = reportsById.get(id);
    if (r == null) return false;
    r.status = "RESOLVED";
    return true;
}

// ========== GUIDES API ==========
public long addGuideRequest(String requesterId, String requesterName, String roomName, String message) {
    long id = System.currentTimeMillis();
    long now = System.currentTimeMillis() / 1000;
    GuideRequestRecord rec = new GuideRequestRecord(id, requesterId, requesterName, roomName, message, now);
    guideRequestsById.put(id, rec);
    guideRequestOrder.add(0, id);
    return id;
}

public List<GuideRequestRecord> listGuideRequests(String statusOrNull, int limit) {
    List<GuideRequestRecord> out = new ArrayList<>();
    synchronized (guideRequestOrder) {
        for (Long id : guideRequestOrder) {
            GuideRequestRecord r = guideRequestsById.get(id);
            if (r == null) continue;
            if (statusOrNull != null && !statusOrNull.equalsIgnoreCase(r.status)) continue;
            out.add(r);
            if (limit > 0 && out.size() >= limit) break;
        }
    }
    return out;
}

public GuideRequestRecord getGuideRequest(long id) {
    return guideRequestsById.get(id);
}

public boolean takeGuideRequest(long id, String guideId, String guideName) {
    GuideRequestRecord r = guideRequestsById.get(id);
    if (r == null) return false;
    r.status = "TAKEN";
    r.assignedGuideId = guideId;
    r.assignedGuideName = guideName;
    return true;
}

public boolean closeGuideRequest(long id) {
    GuideRequestRecord r = guideRequestsById.get(id);
    if (r == null) return false;
    r.status = "CLOSED";
    return true;
}

}

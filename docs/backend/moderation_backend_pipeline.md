# Moderation backend pipeline (WARN / KICK / BAN)

This document maps the Java backend moderation flows in `Backend/` with entrypoints, target resolution, enforcement actions, and emitted packets.

## WARN flow (sequence diagram)

```
Client (security panel)
  -> complaintaction {action:"warn", id, reportedAvatarID, ...}
Backend/ComplaintActionHandler.handleClientRequest
  -> isSecurityUser(sender)
  -> resolveTarget(traceId, reportedAvatarID, report)
  -> warnTarget(target, reason, traceId)
     -> sendAdminMessage(target, title="Municipalty Message", message, trace)
        -> send cmd="adminMessage" to target
  -> response: cmd="complaintaction" {ok, id, action}
  -> pushComplaintListToSecurityUsers() -> cmd="complaintlist" to security users
```

**Steps and evidence**
1. **Request entrypoint + parsing**: `ComplaintActionHandler.handleClientRequest` reads `action`, `id`, `duration`, and `reportedAvatarID` from the incoming payload and enforces `isSecurityUser(sender, store)` before processing. (`Backend/ComplaintActionHandler.java`)
2. **Target resolution**: `resolveTarget` scans the zone by name, normalized IDs (including `Guest#N`), and user variables (`avatarID`, `playerID`, `avatarName`). (`Backend/ComplaintActionHandler.java`)
3. **Enforcement**: `warnTarget` calls `sendAdminMessage` to emit `cmd="adminMessage"` with `title`, `message`, `ts`, and `trace`. (`Backend/ComplaintActionHandler.java`)
4. **Ack + refresh**: `sendResponseWithRid("complaintaction", ...)` and `pushComplaintListToSecurityUsers()` send updated inbox state to security users. (`Backend/ComplaintActionHandler.java`)

## KICK flow (sequence diagram)

```
Client (security panel)
  -> complaintaction {action:"kick", id, reportedAvatarID, ...}
Backend/ComplaintActionHandler.handleClientRequest
  -> resolveTarget(...)
  -> kickUserHard(target, traceId)
     -> getApi().disconnectUser(target)
     -> tryLogout(target) (reflection-based)
     -> scheduleKickRetry(target)
  -> response: cmd="complaintaction" {ok, id, action}
  -> pushComplaintListToSecurityUsers()

Client (profile menu)
  -> kickAvatarFromRoom {avatarID, duration}
Backend/KickAvatarFromRoomHandler.handleClientRequest
  -> resolveTargetUser(avatarID)
  -> cmd="cmd2user" {type:"KICK", message:"You were kicked from the room."}
  -> getApi().disconnectUser(target)
  -> response: cmd="kickAvatarFromRoom" {ok, targetId}

Client (business UI)
  -> kickUserFromBusiness {avatarID}
Backend/KickUserFromBusinessHandler.handleClientRequest
  -> resolveTargetUser(avatarID)
  -> cmd="cmd2user" {type:"KICK", message:"You were kicked."}
  -> getApi().disconnectUser(target)
  -> response: cmd="kickUserFromBusiness" {ok, targetId}
```

**Steps and evidence**
- **Complaint kick**: `ComplaintActionHandler` invokes `kickUserHard`, which attempts `disconnectUser`, optionally `logout`, and schedules a retry if the user still exists in the zone. (`Backend/ComplaintActionHandler.java`)
- **Profile kick**: `KickAvatarFromRoomHandler` sends a `cmd2user` notification and disconnects the target. (`Backend/KickAvatarFromRoomHandler.java`)
- **Business kick**: `KickUserFromBusinessHandler` sends a `cmd2user` notification and disconnects the target. (`Backend/KickUserFromBusinessHandler.java`)

## BAN flow (chat ban + enforce-on-login) (sequence diagram)

```
Client (security panel)
  -> complaintaction {action:"ban"|"loginban", id, reportedAvatarID, duration, ...}
Backend/ComplaintActionHandler.handleClientRequest
  -> resolveTarget(...)
  -> banTarget(target, banType, duration, reportId, traceId)
     -> store.addBanForIp(ip, banType, duration)
     -> store.incrementBanCount(normalizedReportedId)
     -> cmd="banned" {type, startDate(ms), endDate(ms), timeLeft, trace}
     -> cmd="adminMessage" {title:"Ban Info", message, swear, swearTime, endDate?, reportID, ts, trace}
     -> kickUserHard(target)
  -> response: cmd="complaintaction" {ok, id, action}
  -> pushComplaintListToSecurityUsers()

Client (admin tools)
  -> banUser {avatarID, type, duration}
Backend/BanUserHandler.handleClientRequest
  -> resolveTargetUser(avatarID)
  -> store.addBanForIp(ip, type, duration)
  -> cmd="banned" {type, timeLeft, startDate, endDate?}
  -> if LOGIN: disconnectUser(target)
  -> response: cmd="banUser" {ok, targetId, type}

Server login event
  -> ServerEventHandler.onUserLogin
     -> store.isIpBanned(ip, "LOGIN")
        -> cmd="banned" {type:"LOGIN", startDate(ms), endDate(ms), timeLeft, trace}
        -> disconnectUser(user)
     -> store.isIpBanned(ip, "CHAT")
        -> cmd="banned" {type:"CHAT", startDate(ms), endDate(ms), timeLeft, trace}
        -> disconnectUser(user)

Public chat event
  -> ServerEventHandler.onPublicMessage
     -> store.isIpBanned(ip, "CHAT")
        -> cmd="banned" {type, timeLeft, startDate, endDate?}
        -> return (message blocked)
```

**Steps and evidence**
- **Complaint-based ban**: `ComplaintActionHandler.banTarget` records the IP ban, increments ban counts, sends `banned` + `adminMessage`, and hard-kicks the user for CHAT/LOGIN bans. (`Backend/ComplaintActionHandler.java`, `Backend/InMemoryStore.java`)
- **Direct ban**: `BanUserHandler` applies the ban and sends `banned`; it optionally disconnects on LOGIN bans. (`Backend/BanUserHandler.java`, `Backend/InMemoryStore.java`)
- **Enforcement on login**: `ServerEventHandler.onUserLogin` checks IP bans for `LOGIN` and `CHAT`, sends `banned`, and disconnects. (`Backend/ServerEventHandler.java`, `Backend/InMemoryStore.java`)
- **Enforcement on chat**: `ServerEventHandler.onPublicMessage` blocks public chat for CHAT-banned IPs and sends `banned`. (`Backend/ServerEventHandler.java`)

## Permission/policy gates (where applied in flow)
- `complaintlist` and `complaintaction` are gated by `ComplaintListHandler.isSecurityUser`, which checks the roles bitset for `SECURITY`, `EDITOR_SECURITY`, or `CARD_SECURITY`. (`Backend/ComplaintListHandler.java`, `Backend/AvatarPermissionIds.java`, `Backend/PermissionCodec.java`)
- `warnUser`, `banUser`, `kickAvatarFromRoom`, and `kickUserFromBusiness` do **not** perform role checks; they will act on any requester who can call the handler. (`Backend/WarnUserHandler.java`, `Backend/BanUserHandler.java`, `Backend/KickAvatarFromRoomHandler.java`, `Backend/KickUserFromBusinessHandler.java`)

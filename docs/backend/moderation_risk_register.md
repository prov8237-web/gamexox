# Moderation risk register (backend → client enforcement)

This register lists potential reasons moderation enforcement may fail to reach the client or fail to persist.

## Target resolution risks
1. **Target not found in zone**: `ComplaintActionHandler.resolveTarget` only searches the current zone user list; if the reported user is offline or in another zone, actions return `TARGET_NOT_FOUND` and no enforcement occurs. (`Backend/ComplaintActionHandler.java`)
2. **Identifier mismatch (Guest vs numeric)**: Normalization only lowercases `guest#` and trims IDs; other formats (e.g., `Guest#123` vs `123`) may fail if input does not match `buildNameCandidates`/user vars. (`Backend/ComplaintActionHandler.java`, `Backend/HandlerUtils.java`)
3. **Limited user variable matching**: Resolution depends on `avatarID`, `playerID`, or `avatarName` user variables; if these vars are missing or stale, resolution fails. (`Backend/ComplaintActionHandler.java`)
4. **Direct handlers use simpler resolution**: `WarnUserHandler`, `KickAvatarFromRoomHandler`, and `KickUserFromBusinessHandler` only check name + select user vars, which is less robust than the complaint flow resolution. (`Backend/WarnUserHandler.java`, `Backend/KickAvatarFromRoomHandler.java`, `Backend/KickUserFromBusinessHandler.java`)

## Payload schema / type risks
5. **`banned` payload date type mismatch**: Complaint and login enforcement emit `startDate/endDate` as **milliseconds long**, while `BanRecord.toSFSObject` emits **formatted strings**; clients expecting one format may mis-handle the other. (`Backend/ComplaintActionHandler.java`, `Backend/ServerEventHandler.java`, `Backend/InMemoryStore.java`)
6. **`banned` payload missing trace**: `BanRecord.toSFSObject` does not include `trace`, while other sources include it; downstream clients may depend on trace or ignore it. (`Backend/InMemoryStore.java`, `Backend/ComplaintActionHandler.java`, `Backend/ServerEventHandler.java`)
7. **`adminMessage` payload variants**: WARN vs BAN `adminMessage` payloads use different keys (`message/title/ts` vs `swear/swearTime/reportID`). Clients expecting a fixed schema may ignore missing fields. (`Backend/ComplaintActionHandler.java`)

## Delivery / disconnect risks
8. **Best-effort sends swallow exceptions**: Most sends are wrapped in `try/catch` and ignore exceptions, so delivery failures are silent. (`Backend/ComplaintActionHandler.java`, `Backend/BanUserHandler.java`, `Backend/KickAvatarFromRoomHandler.java`, `Backend/KickUserFromBusinessHandler.java`)
9. **Disconnect may not close session**: `ComplaintActionHandler.kickUserHard` calls `disconnectUser` and then attempts reflection-based logout + retry; if the session stays open, the user may remain online. (`Backend/ComplaintActionHandler.java`)
10. **Order of operations**: In complaint-based BAN, `banned` and `adminMessage` are sent before `kickUserHard`; if the disconnect occurs too quickly or the session is already closing, the client may miss messages. (`Backend/ComplaintActionHandler.java`)
11. **CHAT ban enforcement only on public chat**: `ServerEventHandler.onPublicMessage` checks CHAT bans and blocks messages, but private channels may not be blocked here. (`Backend/ServerEventHandler.java`)

## Routing / audience risks
12. **Complaint list pushed only to security users**: Updates are sent to `complaintlist` only for users with security roles; if roles are missing or miscomputed, moderators may not see updates. (`Backend/ComplaintActionHandler.java`, `Backend/ComplaintListHandler.java`, `Backend/InMemoryStore.java`)
13. **No target role immunity**: Lack of role hierarchy means high-privilege accounts can be warned/banned/kicked if targeted, potentially causing moderation feedback loops or accidental enforcement. (`Backend/ComplaintActionHandler.java`, `Backend/WarnUserHandler.java`, `Backend/BanUserHandler.java`)

## Persistence / scope risks
14. **IP-based bans only**: Bans are stored by IP; if the user changes IP or multiple users share an IP, enforcement may be misapplied or bypassed. (`Backend/InMemoryStore.java`, `Backend/ComplaintActionHandler.java`, `Backend/ServerEventHandler.java`)
15. **No offline persistence beyond memory**: Ban/report data lives in `InMemoryStore`; a server restart clears enforcement state. (`Backend/InMemoryStore.java`)

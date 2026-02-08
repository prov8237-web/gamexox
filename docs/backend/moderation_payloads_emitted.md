# Moderation payloads emitted (backend → client)

This document enumerates outbound moderation-related commands and their payload shapes as emitted by the backend.

## cmd="adminMessage"

### Source: `ComplaintActionHandler.sendAdminMessage`
- **Command**: `adminMessage`
- **Keys + types**:
  - `title` (string)
  - `message` (string)
  - `ts` (int, UNIX seconds)
  - `trace` (string)
  - `endDate` (string, optional)

### Source: `ComplaintActionHandler.sendBanAdminMessage`
- **Command**: `adminMessage`
- **Keys + types**:
  - `title` (string)
  - `message` (string)
  - `swear` (string, ban type)
  - `swearTime` (string, UNIX seconds as string)
  - `endDate` (string, optional)
  - `reportID` (long)
  - `ts` (int, UNIX seconds)
  - `trace` (string)

**Evidence**: Both payload shapes are constructed and sent via `getParentExtension().send("adminMessage", payload, target)`. (`Backend/ComplaintActionHandler.java`)

### Source: `InGameReportHandler`
- **Command**: `adminMessage`
- **Keys + types**:
  - `title` (string, `Municipalty Message`)
  - `message` (string, non-empty)
  - `ts` (int, UNIX seconds)
  - `trace` (string)

**Evidence**: `InGameReportHandler` builds and sends an `adminMessage` for `notice`/`kick` commands. (`Backend/InGameReportHandler.java`)

## cmd="banned"

### Source: `ComplaintActionHandler.banTarget`
- **Command**: `banned`
- **Keys + types**:
  - `type` (string, `CHAT` or `LOGIN`)
  - `startDate` (long, milliseconds epoch)
  - `endDate` (long, milliseconds epoch; `-1` for eternal)
  - `timeLeft` (int, seconds)
  - `trace` (string)

### Source: `ServerEventHandler.onUserLogin` (login enforcement)
- **Command**: `banned`
- **Keys + types**:
  - `type` (string, `LOGIN` or `CHAT`)
  - `startDate` (long, milliseconds epoch)
  - `endDate` (long, milliseconds epoch)
  - `timeLeft` (int, seconds)
  - `trace` (string)

### Source: `ServerEventHandler.onPublicMessage` (chat enforcement)
- **Command**: `banned`
- **Keys + types**:
  - `type` (string)
  - `timeLeft` (int, seconds)
  - `startDate` (string, formatted timestamp)
  - `endDate` (string, optional)

### Source: `BanUserHandler` (direct ban)
- **Command**: `banned`
- **Keys + types**:
  - `type` (string)
  - `timeLeft` (int, seconds)
  - `startDate` (string, formatted timestamp)
  - `endDate` (string, optional)

**Evidence**: `ComplaintActionHandler`, `ServerEventHandler`, and `BanUserHandler` construct and send the `banned` payloads with different date formats depending on source. (`Backend/ComplaintActionHandler.java`, `Backend/ServerEventHandler.java`, `Backend/BanUserHandler.java`, `Backend/InMemoryStore.java`)

## cmd="unbanned"

### Source: `BanUserHandler` (direct unban)
- **Command**: `unbanned`
- **Keys + types**:
  - `type` (string)

**Evidence**: `BanUserHandler` sends `unbanned` when the request has `unban/remove` or `duration == 0`. (`Backend/BanUserHandler.java`)

## cmd="cmd2user"

### Source: `WarnUserHandler`
- **Command**: `cmd2user`
- **Keys + types**:
  - `type` (string, `WARN`)
  - `message` (string)

### Source: `KickAvatarFromRoomHandler`
- **Command**: `cmd2user`
- **Keys + types**:
  - `type` (string, `KICK`)
  - `message` (string)

### Source: `KickUserFromBusinessHandler`
- **Command**: `cmd2user`
- **Keys + types**:
  - `type` (string, `KICK`)
  - `message` (string)

**Evidence**: `cmd2user` payloads are built and sent in the handler implementations noted above. (`Backend/WarnUserHandler.java`, `Backend/KickAvatarFromRoomHandler.java`, `Backend/KickUserFromBusinessHandler.java`)

## cmd="warnUser" (direct to target)

### Source: `WarnUserHandler`
- **Command**: `warnUser`
- **Keys + types**:
  - `targetId` (string)
  - `message` (string)
  - `ok` (bool)

**Evidence**: `WarnUserHandler` reuses the response payload and sends it directly to the target. (`Backend/WarnUserHandler.java`)

## Kick mechanism (disconnect, no packet)

### Source: `ComplaintActionHandler.kickUserHard`
- **Mechanism**: `getApi().disconnectUser(target)` and optional reflection-based logout.
- **Retries**: `scheduleKickRetry` attempts a delayed disconnect if the user is still in the zone.

### Source: `KickAvatarFromRoomHandler` / `KickUserFromBusinessHandler`
- **Mechanism**: `getApi().disconnectUser(target)` with a `cmd2user` notification.

**Evidence**: Kick flows are executed via `disconnectUser` calls rather than dedicated response packets. (`Backend/ComplaintActionHandler.java`, `Backend/KickAvatarFromRoomHandler.java`, `Backend/KickUserFromBusinessHandler.java`)

# Moderation runtime validation (manual)

## Preconditions
- Use a target user that is online and visible in the same zone.
- Ensure security/knight user has permission to trigger complaint actions.

## Test cases

### 1) WARN
**Steps**
1. Open complaint inbox and trigger WARN on a report.

**Expected client events**
- `adminMessage` popup with title `Municipalty Message` and non-empty `message`.

**Expected logs**
- `[MOD_SEND] cmd=adminMessage trace=... to=<user> payload={title(str)=..., message(str)=..., ts(int)=..., trace(str)=...}`
- `[MOD_WARN_SEND] trace=... sent=1`

### 2) KICK
**Steps**
1. Trigger KICK from complaint inbox or profile kick.

**Expected client events**
- `adminMessage` popup with title `Municipalty Message` and message `You were kicked.`
- Client disconnect (`connectionLost`).

**Expected logs**
- `[MOD_SEND] cmd=adminMessage trace=... to=<user> payload={title(str)=..., message(str)=..., ts(int)=..., trace(str)=...}`
- `[MOD_KICK] trace=... target=<user> disconnected=true retry=<n>`
- `[MOD_KICK_RETRY]` only if initial disconnect fails.

### 3) CHAT BAN (60s)
**Steps**
1. Trigger a CHAT ban with duration 60 seconds.

**Expected client events**
- `banned` event: `{type:"CHAT", timeLeft:60, startDate:"YYYY-MM-DD HH:mm:ss.0", endDate:"...", trace:"..."}`
- Client disconnect.

**Expected logs**
- `[MOD_SEND] cmd=banned trace=... to=<user> payload={type(str)=..., timeLeft(int)=..., startDate(str)=..., endDate(str)=..., trace(str)=...}`
- `[MOD_BAN_SEND] trace=... type=CHAT timeLeft=60`
- `[MOD_BAN_ENFORCE]` on re-login or chat attempt.

### 4) LOGIN BAN (60s)
**Steps**
1. Trigger a LOGIN ban with duration 60 seconds.

**Expected client events**
- `banned` event: `{type:"LOGIN", timeLeft:60, startDate:"YYYY-MM-DD HH:mm:ss.0", endDate:"...", trace:"..."}`
- Client disconnect.

**Expected logs**
- `[MOD_SEND] cmd=banned trace=... to=<user> payload={type(str)=..., timeLeft(int)=..., startDate(str)=..., endDate(str)=..., trace(str)=...}`
- `[MOD_BAN_SEND] trace=... type=LOGIN timeLeft=60`
- `[MOD_BAN_ENFORCE]` on re-login.

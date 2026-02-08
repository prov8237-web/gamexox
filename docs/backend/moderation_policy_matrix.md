# Moderation policy matrix (backend)

This matrix documents which backend flows enforce role checks and how roles are represented.

## Role storage and encoding
- Roles are stored as a **base64-encoded bitset** on `InMemoryStore.UserState.roles`. (`Backend/InMemoryStore.java`)
- Permissions are evaluated via `PermissionCodec.hasPermission(rolesBase64, permissionIndex)`. (`Backend/PermissionCodec.java`)
- Permission indexes are defined in `AvatarPermissionIds` and must match the client enum. (`Backend/AvatarPermissionIds.java`)
- Roles are recomputed from owned cards + privilege in `InMemoryStore.recomputeRoles` and sent to clients via `RolesHandler`/`InitHandler`. (`Backend/InMemoryStore.java`, `Backend/RolesHandler.java`, `Backend/InitHandler.java`)

## Enforcement matrix

| Flow / handler | Entry command | Gate check present? | Gate logic | Target role checks? | Notes |
| --- | --- | --- | --- | --- | --- |
| Complaint inbox list (`ComplaintListHandler`) | `complaintlist` | **Yes** | `isSecurityUser` requires `SECURITY`, `EDITOR_SECURITY`, or `CARD_SECURITY` bits | None | Access only for security roles. (`Backend/ComplaintListHandler.java`) |
| Complaint action (`ComplaintActionHandler`) | `complaintaction` | **Yes** | `isSecurityUser` requires `SECURITY`, `EDITOR_SECURITY`, or `CARD_SECURITY` bits | None | Applies to WARN/KICK/BAN/RESOLVE without target role comparison. (`Backend/ComplaintActionHandler.java`) |
| Report submission (`ReportHandler`) | `report` | **No** | None | None | Any caller can submit a report; stored and broadcast to security users. (`Backend/ReportHandler.java`) |
| Ban info (`BanInfoHandler`) | `baninfo` | **No** | None | None | Any caller can request ban info for a target. (`Backend/BanInfoHandler.java`) |
| Direct warn (`WarnUserHandler`) | `warnUser` | **No** | None | None | Anyone can trigger WARN delivery; no role gating. (`Backend/WarnUserHandler.java`) |
| Direct ban (`BanUserHandler`) | `banUser` | **No** | None | None | Anyone can apply or remove an IP ban; no role gating. (`Backend/BanUserHandler.java`) |
| Kick from room (`KickAvatarFromRoomHandler`) | `kickAvatarFromRoom` | **No** | None | None | Anyone can disconnect another user if they can call the handler. (`Backend/KickAvatarFromRoomHandler.java`) |
| Kick from business (`KickUserFromBusinessHandler`) | `kickUserFromBusiness` | **No** | None | None | Anyone can disconnect another user if they can call the handler. (`Backend/KickUserFromBusinessHandler.java`) |
| Login/chat enforcement (`ServerEventHandler`) | event-driven | **N/A** | IP ban lookup | None | Enforcement is based on IP bans, not role. (`Backend/ServerEventHandler.java`, `Backend/InMemoryStore.java`) |

## Can admin punish admin?
- **No explicit protection** exists in the moderation handlers against acting on another admin/security user. There is **no target role comparison** in `ComplaintActionHandler`, `WarnUserHandler`, `BanUserHandler`, or kick handlers. (`Backend/ComplaintActionHandler.java`, `Backend/WarnUserHandler.java`, `Backend/BanUserHandler.java`, `Backend/KickAvatarFromRoomHandler.java`, `Backend/KickUserFromBusinessHandler.java`)

## Priority / level system
- The code only checks **presence of a permission bit** (SECURITY/EDITOR_SECURITY/CARD_SECURITY) for complaint flows. There is no hierarchical priority comparison implemented in moderation actions. (`Backend/ComplaintListHandler.java`, `Backend/PermissionCodec.java`, `Backend/AvatarPermissionIds.java`)

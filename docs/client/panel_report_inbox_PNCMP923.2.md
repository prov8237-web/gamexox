# Complaint/Reports Inbox Panel (PNCMP923.2.swf)

Scope: `Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/*`.

## Overview
The reports inbox is implemented by `ComplaintPanel` and renders a list of `ComplaintItem` entries derived from server responses. It continuously polls for new complaints and provides actions to mark a complaint as correct/incorrect, flag pervert/abuse, warn the reported user, warn the reporter, and locate the reported avatar.

## Commands and actions

### Fetch list
- **Command**: `RequestDataKey.COMPLAINT_LIST` (`"complaintlist"`).【F:Client/Panel/PNCMP923.2.swf/scripts/com/oyunstudyosu/enums/RequestDataKey.as†L358-L360】
- **Call site**: `ComplaintPanel.getList()` → `requestData(RequestDataKey.COMPLAINT_LIST, {}, complaintListResponse)`.【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as†L170-L176】
- **Polling behavior**: list refresh scheduled every 20 seconds (`TweenMax.delayedCall(20, getList)`). If list is empty or missing, it displays a “No report...” / error message and retries after 20 seconds.【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as†L63-L187】

### Apply an action (resolve/flag)
- **Command**: `RequestDataKey.COMPLAINT_ACTION` (`"complaintaction"`).【F:Client/Panel/PNCMP923.2.swf/scripts/com/oyunstudyosu/enums/RequestDataKey.as†L358-L360】
- **Call site**: `ComplaintPanel.reportAction()` sends the following payload:
  - `id` (complaint ID)
  - `reportedAvatarID`
  - `isPervert` (0/1)
  - `isAbuse` (0/1)
  - `isCorrect` (0/1)
  - Handler: `moveNext` (advances to next complaint).【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as†L83-L100】
- **UI triggers** (from `ComplaintItem`):
  - **True** → `isCorrect = 1`, dispatches `"next"` event.
  - **False** → if any flag (pervert/abuse) is set, shows `reportMistake` alert; otherwise `isCorrect = 0` and dispatches `"next"`.
  - **Pervert/Abuse checkboxes** → toggle `isPervert` / `isAbuse` and update ban info copy (e.g., `reportOneMonthMute`, `reportAbuseBan`).【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintItem.as†L87-L213】

### Warn reported user / warn reporter
- **Action**: opens `BanPanel` (panel-only action; not a direct `requestData` call in this SWF).
- **Reported user**: `ComplaintPanel.warnAction()` opens `BanPanel` with `action="notice"`, `avatarID` = `reportedAvatarID`, and carries `banCount`/`nextBanMin` as duration. It also calls `reportAction` to mark the complaint processed.【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as†L106-L123】
- **Reporter**: `ComplaintPanel.warnReporter()` opens `BanPanel` with `action="notice"`, `avatarID` = `reporterAvatarID`, `banCount=0`, `duration=0`.【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as†L101-L105】

### Locate reported avatar
- **Command**: `BuddyRequestTypes.BUDDY_LOCATE` (from `com.oyunstudyosu.buddy.BuddyRequestTypes`).
- **Call site**: `ComplaintPanel.locationAction()` → `requestData(BuddyRequestTypes.BUDDY_LOCATE, { avatarID: reportedAvatarID }, locateResponse)`.
- **Response**: expects `universe` and `street` to show the location alert (`"Security Locate"`).【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as†L125-L147】

## List item schema (report payload)
`ComplaintPanel.complaintListResponse` maps server list items to `ComplaintData`, and `ComplaintItem` renders them.

Fields used:
- `id` → `complaintID`
- `message`
- `comment`
- `reporterAvatarID`
- `reportedAvatarID`
- `isPervert`
- `banCount`
- `nextBanMin`
- (Declared but not used in this mapping: `createdAt`)【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as†L190-L231】【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintData.as†L1-L27】

`ComplaintItem` displays:
- `message` as title (selectable).
- `comment` as description (selectable).
- `reporterAvatarID` and `reportedAvatarID` in their respective labels, with tooltips (`reporterAvatarID`, `reportedAvatarID`).【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintItem.as†L120-L180】

## Permission gating (who can open/use it)
- **No explicit permission checks** exist in `ComplaintPanel` or `ComplaintItem`. The panel assumes that access is controlled by the caller (likely server-driven panel availability or role gating elsewhere).【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as†L45-L187】

## How this connects to the reporting system
- The complaints inbox consumes aggregated report records from the `complaintlist` extension command and applies moderation actions via `complaintaction`. These actions are downstream of the `report` command in the create-report panel and provide the moderation lifecycle for reports created by players.【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as†L83-L231】

# Reporting commands: `baninfo` and `report`

This document summarizes the **client-visible contract** for reporting commands based on the ActionScript sources under `Client/snal.official.swf/scripts` and the report panel SWF (`Client/Panel/1449237199236-23.4.swf/scripts`).

## Command dictionary

### `baninfo`
- **Command string**: `baninfo` (`RequestDataKey.AVATAR_BANINFO`).
- **Request schema (client inputs)**:
  - `avatarID` (from the report panel’s `data.params.avatarId`).
- **Response schema (observed fields)**:
  - `banStatus` (if present, the panel shows an “already banned” alert and closes).
  - `banCount` (drives warning vs. next-ban messaging).
  - `nextBanMin` (used to render the “next ban in” timer).
  - `expireSecond` (used to compute remaining ban time when `banStatus` is present).

### `report`
- **Command string**: `report` (`RequestDataKey.REPORT`).
- **Request schema (client inputs)**:
  - `reportedAvatarID` (from `data.params.avatarId`).
  - `message` (from `data.params.lastMessage`).
  - `isPervert` (0/1 checkbox value).
  - `comment` (sanitized user input).
- **Response schema (observed fields)**:
  - `errorCode == "ALREADY_REPORTED"` triggers a specific “already reported” alert.
  - Any other `errorCode` triggers a generic report error alert.
  - When `errorCode` is absent/falsey, the panel shows a success message and closes.

## Timing / rate-limit semantics
- `ServiceModel.requestData` enforces **client-side throttling** via `ServiceRequestRate.check(cmd)`. If the request is blocked, it emits local error codes `FLOOD` or `EXTENSION_IDLE` and short-circuits callbacks.
- When a response arrives with `errorCode == "FLOOD"`, the client reads `nextRequest` and updates the throttle window via `ServiceRequestRate.create(cmd, nextRequest)`.

## Error handling behavior
`ServiceModel.onExtensionResponse` handles common error codes generically for all commands (including `baninfo` and `report`):
- `INSUFFICIENT_ROLE` → translated role requirements warning.
- `MISSING_ITEM` → tooltip with missing item info.
- `GUEST_NOT_ALLOWED` → opens `GuestPanel`.
- `WRONG_ITEM` → tooltip with translated item list.
- Any other `errorCode` → tooltip based on `ServiceErrorCode` message map.

These are handled before callbacks are dispatched.

## Unknowns + hypotheses (where to confirm)
- **Response payload structure**: No strongly typed response objects are defined in this repo. Confirm in the report panel SWF or server-side extension that produces `baninfo`/`report` responses.
- **Reports inbox and profile moderation actions**: There are no direct references to `/Client/Panel/PNCMP923.2.swf/scripts` or `/Client/Panel/PRFP.57/scripts` in this ActionScript bundle; those are likely separate panel SWFs loaded via `PanelModel` + `ModuleModel` mappings.

# Reporting commands: `baninfo` and `report`

This document summarizes the **client-visible contract** for reporting commands based on the ActionScript sources under `Client/snal.official.swf/scripts`.

## Command dictionary

### `baninfo`
- **Command string**: `baninfo` (`RequestDataKey.AVATAR_BANINFO`).
- **Likely request schema (client inputs)**:
  - The `ReportPanel` is opened with `params.avatarId` + `params.lastMessage`, which are the only report-related data passed from chat/report entry points. These values are the most probable inputs used by the report UI when requesting `baninfo`.
- **Response schema (observed fields)**:
  - All extension responses are routed through `ServiceModel.onExtensionResponse`, which expects (or tolerates) `errorCode`, `message`, and (for flood control) `nextRequest`. Any successful payload is forwarded directly to listeners/callbacks without schema validation, so `baninfo` response fields are **not defined in this repo**.

### `report`
- **Command string**: `report` (`RequestDataKey.REPORT`).
- **Likely request schema (client inputs)**:
  - Same as `baninfo`, the report UI is supplied `avatarId` and `lastMessage` in its panel parameters. The `report` command likely includes those fields plus report category/reason, but those fields are not defined in this repo’s ActionScript sources (they should be in the report panel SWF).
- **Response schema (observed fields)**:
  - `ServiceModel` expects `errorCode`/`message` and triggers error handling or user alerts when set, otherwise it hands the response to callbacks and listeners. No `report`-specific response shape is defined in this repo.

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
- **Request fields for `baninfo` and `report`**: The report UI logic is not present in `Client/snal.official.swf/scripts`; it should exist in the dynamically loaded report panel SWF (likely `/Client/Panel/1449237199236-23.4.swf/scripts`). Confirm by inspecting the `ReportPanel` class in that SWF.
- **Response payload structure**: No strongly typed response objects are defined in this repo. Confirm in the report panel SWF or server-side extension that produces `baninfo`/`report` responses.
- **Reports inbox and profile moderation actions**: There are no direct references to `/Client/Panel/PNCMP923.2.swf/scripts` or `/Client/Panel/PRFP.57/scripts` in this ActionScript bundle; those are likely separate panel SWFs loaded via `PanelModel` + `ModuleModel` mappings.


# Root-cause trace: "العنصر المطلوب: 2 (pro_undefined)" during moderation actions

## Summary
- **Arabic literal not found in code**: the string is composed at runtime from localization entries; the Arabic text corresponds to `translate("MISSING_ITEM")` plus a translated product key `$("pro_" + message)`.
- **Exact render path**: `ServiceModel.onExtensionResponse` handles any response with `errorCode == "MISSING_ITEM"` and constructs the message. If `message` is `undefined`, it becomes `pro_undefined`, yielding the observed suffix.

## Exact render code (snippet)

```actionscript
else if(_loc6_.errorCode != null && _loc6_.errorCode == "MISSING_ITEM")
{
   (_loc12_ = new AlertVo()).alertType = "tooltip";
   _loc12_.description = Sanalika.instance.localizationModel.translate("MISSING_ITEM") + ": " + $("pro_" + _loc6_.message);
   Dispatcher.dispatchEvent(new AlertEvent(_loc12_));
}
```
- **File**: `Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as`
- **Class/method**: `ServiceModel.onExtensionResponse`
- **Formatting logic**: concatenates localized `MISSING_ITEM` with `$("pro_" + message)`.
- **Payload fields read**: `errorCode` (string), `message` (string). If `message` is `undefined`, UI resolves to `pro_undefined`.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L295-L335】

## Where the moderation action response is received

Moderation actions are sent as `complaintaction` requests; their responses are processed by `ServiceModel.onExtensionResponse`.

```actionscript
Connectr.instance.serviceModel.requestData(RequestDataKey.COMPLAINT_ACTION,{
   "id":this.list[this.currentOrder].id,
   "reportedAvatarID":this.list[this.currentOrder].reportedAvatarID,
   "isPervert":(param1.target as ComplaintItem).isPervert,
   "isAbuse":(param1.target as ComplaintItem).isAbuse,
   "isCorrect":(param1.target as ComplaintItem).isCorrect
},this.moveNext);
```
- **File**: `Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as`
- **Class/method**: `ComplaintPanel.reportAction`
- **Incoming payload**: response to `complaintaction` is routed through `ServiceModel.onExtensionResponse` and then to `moveNext`. If the response includes `errorCode == "MISSING_ITEM"`, the UI tooltip described above appears. (The same applies to any request using `ServiceModel.requestData`.)【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as†L76-L94】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L295-L335】

## Listen registration (why this path is always used)

`ServiceModel` registers a global listener for SmartFox `extensionResponse` and funnels all responses through `onExtensionResponse`.

```actionscript
_sfs.addEventListener("extensionResponse",onExtensionResponse);
```
- **File**: `Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as`
- **Class/method**: `ServiceModel.activate`
- **Trigger**: any extension response (`cmd`) with payload `params` (converted to Object) enters `onExtensionResponse`.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L46-L117】【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L255-L336】

## Call stack diagram

```
ComplaintPanel.reportAction (complaintaction request)
  -> ServiceModel.requestData(cmd="complaintaction", data, callback)
     -> SmartFox extensionResponse event
        -> ServiceModel.onExtensionResponse
           -> if errorCode == "MISSING_ITEM":
              AlertVo.description = translate("MISSING_ITEM") + ": " + $("pro_" + message)
              Dispatcher.dispatchEvent(AlertEvent)
```

## Payload contract to avoid `pro_undefined`

| Field | Type | Required | Used by | Notes |
| --- | --- | --- | --- | --- |
| `errorCode` | string | required (to trigger) | `ServiceModel.onExtensionResponse` | Must be exactly `"MISSING_ITEM"` to render the error string. |
| `message` | string | required when `errorCode == "MISSING_ITEM"` | `ServiceModel.onExtensionResponse` | Appended to `"pro_"` and localized. If missing/undefined → `pro_undefined`. |

**Inbound command**: Any command using `ServiceModel.requestData` can trigger this if its response includes `errorCode == "MISSING_ITEM"` (e.g., `complaintaction` from moderation UI).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L295-L335】【F:Client/Panel/PNCMP923.2.swf/scripts/org/oyunstudyosu/sanalika/panels/complaint/ComplaintPanel.as†L76-L94】

## Top 5 fixes to prevent `pro_undefined`

1. **Backend: never use `MISSING_ITEM` for moderation actions** — use a moderation-specific errorCode (e.g., `TARGET_NOT_FOUND`) so the UI doesn’t try to translate a product key. (Prevents hitting the `MISSING_ITEM` branch entirely.)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L295-L335】
2. **Backend: always populate `message` with a valid product clip key when `MISSING_ITEM` is unavoidable** — ensures `$("pro_" + message)` resolves to an actual localized string.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L295-L335】
3. **Client: guard against empty `message`** — change the render logic to fallback to a generic string if `_loc6_.message` is empty/undefined (e.g., omit `pro_...`).【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L295-L335】
4. **Localization: add a safe fallback for `pro_undefined`** — even if backend sends bad data, UI will show a readable string instead of `pro_undefined`.【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L295-L335】
5. **Logging: add server-side audit when returning `MISSING_ITEM`** — attach trace + command name so moderation payload issues can be traced quickly. (Prevents silent misclassification.)【F:Client/snal.official.swf/scripts/com/oyunstudyosu/service/ServiceModel.as†L295-L335】

## Additional `pro_` usage (not the moderation error path)

Other `pro_` usages were found in inventory/transfer/quest UI, but they **do not** build the specific “MISSING_ITEM” alert string. The moderation error described here is exclusively from `ServiceModel.onExtensionResponse`.

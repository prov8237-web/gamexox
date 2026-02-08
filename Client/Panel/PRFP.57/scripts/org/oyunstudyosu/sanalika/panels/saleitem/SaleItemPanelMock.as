package org.oyunstudyosu.sanalika.panels.saleitem
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class SaleItemPanelMock implements IExtensionMock
   {
       
      
      public function SaleItemPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == "saleitemstartthx")
         {
            return {"data":{
               "thxID":1002,
               "timeLeft":60,
               "type":"HAND_ITEM"
            }};
         }
         if(param1 == "saleitemlist")
         {
            return {"data":{"items":[{
               "clip":"bp",
               "price":{
                  "currency":"SANIL",
                  "value":202
               },
               "ids":[635,634,633,632,343,356,987]
            },{
               "clip":"kf",
               "lifeTime":1000,
               "timeLeft":700,
               "price":{
                  "currency":"SANIL",
                  "value":400
               },
               "ids":[636]
            },{
               "clip":"k6",
               "lifeTime":100,
               "timeLeft":20,
               "price":{
                  "currency":"DIAMOND",
                  "value":50
               },
               "ids":[639]
            },{
               "clip":"0010",
               "lifeTime":2000,
               "timeLeft":700,
               "price":{
                  "currency":"SANIL",
                  "value":50
               },
               "ids":[100]
            },{
               "clip":"0778",
               "price":{
                  "currency":"SANIL",
                  "value":50
               },
               "ids":[101]
            },{
               "clip":"1038",
               "lifeTime":1000,
               "timeLeft":100,
               "price":{
                  "currency":"SANIL",
                  "value":50
               },
               "ids":[102]
            },{
               "clip":"0901",
               "price":{
                  "currency":"DIAMOND",
                  "value":50
               },
               "ids":[103]
            },{
               "clip":"0915",
               "price":{
                  "currency":"SANIL",
                  "value":50
               },
               "ids":[104,105]
            },{
               "clip":"0916",
               "lifeTime":5000,
               "timeLeft":4500,
               "price":{
                  "currency":"DIAMOND",
                  "value":50
               },
               "ids":[106]
            },{
               "clip":"0902",
               "price":{
                  "currency":"SANIL",
                  "value":50
               },
               "ids":[107]
            },{
               "clip":"0956",
               "price":{
                  "currency":"SANIL",
                  "value":8000
               },
               "ids":[108,5634,4534]
            },{
               "clip":"0957",
               "lifeTime":1000,
               "timeLeft":700,
               "price":{
                  "currency":"SANIL",
                  "value":50
               },
               "ids":[109]
            },{
               "clip":"0958",
               "price":{
                  "currency":"SANIL",
                  "value":50
               },
               "ids":[110]
            },{
               "clip":"0959",
               "price":{
                  "currency":"SANIL",
                  "value":50
               },
               "ids":[111,112,113,114,115,116]
            },{
               "clip":"0868",
               "price":{
                  "currency":"SANIL",
                  "value":50
               },
               "ids":[108]
            }]}};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("SaleItemPanel","",{"botKey":"tilki-cezmi"});
      }
      
      public function getExtensionResponse(param1:uint, param2:SmartFox) : void
      {
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}

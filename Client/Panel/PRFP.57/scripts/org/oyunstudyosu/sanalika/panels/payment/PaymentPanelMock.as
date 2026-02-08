package org.oyunstudyosu.sanalika.panels.payment
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class PaymentPanelMock implements IExtensionMock
   {
       
      
      public function PaymentPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         trace("mock");
         switch(param1)
         {
            case "saleproductlist":
               return {"data":{
                  "msisdn":"54x-xxx-xx-80",
                  "products":[{
                     "id":512,
                     "title":"Safari Hayvan Paketi",
                     "description":"When the g (global) flag is not set in the regular expression, then you can use exec() to find the first match in the string",
                     "type":"SANIL",
                     "imgUrl":"SANIL_1000",
                     "baseAmount":1000,
                     "baseSalePrice":1.9,
                     "baseSaleCurrency":"TRY",
                     "giftAmount":500,
                     "method":{
                        "salePrice":1.5,
                        "keyword":"zuppin",
                        "amount":1500,
                        "saleCurrency":"TRY"
                     }
                  },{
                     "id":513,
                     "title":"2.000 Sanil",
                     "description":"In the following example, the g (global) flag is set in the regular expression, so you can use exec() repeatedly to find multiple",
                     "type":"SANIL",
                     "imgUrl":"SANIL_2000",
                     "baseAmount":2000,
                     "baseSalePrice":2.9,
                     "baseSaleCurrency":"TRY",
                     "method":{
                        "salePrice":19.9,
                        "keyword":"zuppin",
                        "amount":9900,
                        "saleCurrency":"TRY"
                     }
                  }]
               }};
            case "report":
               return {"data":{}};
            default:
               return null;
         }
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("ReportPanel","",{
            "targetNick":"nick",
            "lastMessage":""
         });
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

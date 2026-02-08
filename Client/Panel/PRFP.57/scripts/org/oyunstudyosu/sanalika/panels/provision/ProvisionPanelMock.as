package org.oyunstudyosu.sanalika.panels.provision
{
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class ProvisionPanelMock implements IExtensionMock
   {
       
      
      public function ProvisionPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         trace("mock");
         switch(param1)
         {
            case RequestDataKey.PROVISION_REQUEST:
               return {"data":{"status":"success"}};
            case RequestDataKey.PROVISION_APPROVE:
               return {"data":{"status":"success"}};
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

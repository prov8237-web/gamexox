package org.oyunstudyosu.sanalika.panels.nerfReload
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class NerfReloadPanelMock implements IExtensionMock
   {
       
      
      public function NerfReloadPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         switch(param1)
         {
            case "gameaction":
               return {"data":{
                  "status":"success",
                  "totalBullet":5
               }};
            default:
               return null;
         }
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("NerfChargePanel","",{});
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

package org.oyunstudyosu.sanalika.panels.settings
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class SettingsPanelMock implements IExtensionMock
   {
       
      
      public function SettingsPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         return null;
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("SettingsPanel","",{});
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

package org.oyunstudyosu.sanalika.panels.map
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class MapPanelMock implements IExtensionMock
   {
       
      
      public function MapPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         return new PanelVO("MapPanel","",{});
      }
      
      public function getInitData() : Object
      {
         return null;
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

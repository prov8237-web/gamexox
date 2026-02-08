package org.oyunstudyosu.sanalika.panels.solarium
{
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class SolariumPanelMock implements IExtensionMock
   {
       
      
      public function SolariumPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         return null;
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

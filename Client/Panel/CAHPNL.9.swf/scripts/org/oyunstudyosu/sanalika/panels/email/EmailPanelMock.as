package org.oyunstudyosu.sanalika.panels.email
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class EmailPanelMock implements IExtensionMock
   {
       
      
      public function EmailPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         return {"data":{}};
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("EmailPanel","",{"lastEmail":"hede@hede.com"});
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

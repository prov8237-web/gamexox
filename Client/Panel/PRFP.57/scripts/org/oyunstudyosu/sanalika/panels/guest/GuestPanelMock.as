package org.oyunstudyosu.sanalika.panels.guest
{
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   
   public class GuestPanelMock implements IExtensionMock
   {
       
      
      public function GuestPanelMock()
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
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}

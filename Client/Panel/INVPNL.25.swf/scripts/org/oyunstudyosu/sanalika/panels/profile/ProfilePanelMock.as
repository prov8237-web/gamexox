package org.oyunstudyosu.sanalika.panels.profile
{
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class ProfilePanelMock implements IExtensionMock
   {
       
      
      public function ProfilePanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == RequestDataKey.PROFILE)
         {
            return {"data":{
               "status":"yarışmaya osmaniyeden ***ıyorum.",
               "mood":0,
               "avatarName":"Osman",
               "totalBuddies":5,
               "avarageRating":"3.00",
               "cards":[],
               "badges":[{"clip":"questFirstBadge"},{"clip":"diamondBadge1"},{"clip":"shoppingBadge1"},{"clip":"1stGenBadge"}]
            }};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("ProfilePanel","",{"avatarId":505});
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

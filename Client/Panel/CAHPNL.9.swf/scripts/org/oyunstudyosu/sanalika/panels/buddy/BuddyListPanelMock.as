package org.oyunstudyosu.sanalika.panels.buddy
{
   import com.oyunstudyosu.buddy.BuddyRequestTypes;
   import com.oyunstudyosu.buddy.BuddyResponseTypes;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   import flash.ui.Keyboard;
   import org.oyunstudyosu.sanalika.panels.buddy.buddyMock.BuddyController;
   
   public class BuddyListPanelMock implements IExtensionMock
   {
       
      
      public function BuddyListPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == BuddyRequestTypes.BUDDY_LIST)
         {
            return {"data":{
               "requests":[{
                  "avatarID":502,
                  "nick":"يبلبيل ي"
               },{
                  "avatarID":503,
                  "nick":"Sap"
               }],
               "buddies":[{
                  "avatarID":1,
                  "nick":"طارق",
                  "isOnline":false,
                  "mood":3,
                  "message":"Bunalımdayım... XX isteyen eklesin. Bunalımdayım... XX isteyen eklesin",
                  "myRelationToBuddy":3,
                  "buddyRelationToMe":2
               },{
                  "avatarID":2,
                  "nick":"Ezgi",
                  "isOnline":true,
                  "mood":7,
                  "message":"Yapma beee",
                  "myRelationToBuddy":3,
                  "buddyRelationToMe":3
               },{
                  "avatarID":504,
                  "nick":"KapıKomşum",
                  "isOnline":true,
                  "mood":7,
                  "message":"Ulannnnn",
                  "myRelationToBuddy":4,
                  "buddyRelationToMe":1
               },{
                  "avatarID":505,
                  "nick":"505",
                  "isOnline":false,
                  "mood":7,
                  "message":"Bunalımdayım... XX isteyen eklesin",
                  "myRelationToBuddy":1,
                  "buddyRelationToMe":0
               },{
                  "avatarID":505,
                  "nick":"505",
                  "isOnline":false,
                  "mood":7,
                  "message":"Bunalımdayım... XX isteyen eklesin",
                  "myRelationToBuddy":1,
                  "buddyRelationToMe":0
               },{
                  "avatarID":505,
                  "nick":"505",
                  "isOnline":false,
                  "mood":7,
                  "message":"Bunalımdayım... XX isteyen eklesin",
                  "myRelationToBuddy":1,
                  "buddyRelationToMe":0
               },{
                  "avatarID":505,
                  "nick":"505",
                  "isOnline":false,
                  "mood":7,
                  "message":"Bunalımdayım... XX isteyen eklesin",
                  "myRelationToBuddy":1,
                  "buddyRelationToMe":0
               },{
                  "avatarID":505,
                  "nick":"505",
                  "isOnline":false,
                  "mood":7,
                  "message":"Bunalımdayım... XX isteyen eklesin",
                  "myRelationToBuddy":1,
                  "buddyRelationToMe":0
               },{
                  "avatarID":506,
                  "nick":"506",
                  "isOnline":true,
                  "mood":7,
                  "message":"Bunalımdayım... XX isteyen eklesin",
                  "myRelationToBuddy":2,
                  "buddyRelationToMe":5
               }]
            }};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("BuddyListPanel","",{
            "page":"buddy",
            "controller":new BuddyController()
         });
      }
      
      public function getExtensionResponse(param1:uint, param2:SmartFox) : void
      {
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         var _loc2_:Object = {};
         _loc2_.params = {};
         switch(param1)
         {
            case Keyboard.NUMBER_1:
               _loc2_.key = BuddyResponseTypes.BUDDY_RELATION_CHANGED;
               _loc2_.params.id = 1;
               _loc2_.params.buddyRelationToMe = 3;
               return _loc2_;
            case Keyboard.NUMBER_2:
               _loc2_.key = BuddyResponseTypes.BUDDY_ADDED;
               _loc2_.params.id = 507;
               _loc2_.params.nick = "Jale";
               _loc2_.params.isOnline = true;
               _loc2_.params.message = "Ara beni boya beni";
               _loc2_.params.mood = 2;
               _loc2_.params.myRelationToBuddy = 15;
               _loc2_.params.buddyRelationToMe = 15;
               return _loc2_;
            case Keyboard.NUMBER_3:
               _loc2_.key = BuddyResponseTypes.BUDDY_REMOVED;
               _loc2_.params.id = 503;
               return _loc2_;
            case Keyboard.NUMBER_4:
               _loc2_.key = BuddyResponseTypes.BUDDY_REMOVED;
               _loc2_.params.id = 504;
               return _loc2_;
            case Keyboard.NUMBER_5:
               _loc2_.key = BuddyResponseTypes.BUDDY_ADDED;
               _loc2_.params.id = 504;
               _loc2_.params.nick = "Yeni Hatun";
               return _loc2_;
            case Keyboard.NUMBER_6:
               _loc2_.key = BuddyResponseTypes.BUDDY_ONLINE_STATUS_CHANGED;
               _loc2_.params.id = 505;
               _loc2_.params.isOnline = true;
               return _loc2_;
            default:
               return null;
         }
      }
   }
}

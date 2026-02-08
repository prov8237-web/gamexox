package org.oyunstudyosu.sanalika.mock
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.SFSUser;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import flash.display.Stage;
   import flash.events.EventDispatcher;
   
   public class Engine extends EventDispatcher
   {
       
      
      public var conn:Object;
      
      public var isGameRoom:Boolean;
      
      public var stage:Stage;
      
      public var scene:CurScene;
      
      public var clothManager:ClothManager;
      
      public var isPatternFilterEnabled:Boolean = false;
      
      public function Engine(param1:Stage)
      {
         super(null);
         this.conn = {};
         var _loc2_:SmartFox = new SmartFox();
         _loc2_.mySelf = new SFSUser(1,"username",true);
         this.conn.sfs = _loc2_;
         this.conn.createSFSObject = this.createSFSObject;
         this.conn.getMyComment = this.getMyComment;
         this.conn.getMyMood = this.getMyMood;
         this.scene = new CurScene();
         this.clothManager = new ClothManager();
      }
      
      protected function createSFSObject() : ISFSObject
      {
         return new SFSObject();
      }
      
      public function getVipID() : int
      {
         return 2;
      }
      
      public function getMyComment() : String
      {
         return "deneme";
      }
      
      public function getMyMood() : int
      {
         return 1;
      }
      
      public function addMsgBlockedUsers(param1:String) : void
      {
         trace("user blocked : ",param1);
      }
      
      public function changeScene(param1:String, param2:String, param3:String) : void
      {
      }
      
      public function openPopupPaymentSanil(param1:String = null, param2:String = null, param3:String = null) : void
      {
      }
      
      public function dispose() : void
      {
         this.stage = null;
      }
   }
}

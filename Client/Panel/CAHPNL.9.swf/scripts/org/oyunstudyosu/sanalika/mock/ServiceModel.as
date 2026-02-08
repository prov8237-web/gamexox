package org.oyunstudyosu.sanalika.mock
{
   import com.oyunstudyosu.sanalika.interfaces.IServiceMapping;
   import com.oyunstudyosu.sanalika.interfaces.IServiceVO;
   import com.oyunstudyosu.service.IServiceModel;
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.SFSRoom;
   import com.smartfoxserver.v2.entities.SFSUser;
   import flash.events.KeyboardEvent;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class ServiceModel implements IServiceModel
   {
       
      
      private var _sfs:SmartFox;
      
      private var list:Dictionary;
      
      private var listenerList:Dictionary;
      
      public function ServiceModel()
      {
         super();
         this._sfs = new SmartFox();
         this._sfs.lastJoinedRoom = new SFSRoom(1,"balloonRoom");
         var _loc1_:SFSUser = new SFSUser(1,"emin",true);
         var _loc2_:SFSUser = new SFSUser(2,"önder");
         this._sfs.lastJoinedRoom.addUser(_loc1_);
         this.list = new Dictionary();
         this.listenerList = new Dictionary(false);
         Sanalika.instance.layerModel.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      protected function onKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:Object = Sanalika.panelManager.popupMockHandler.dispatchExtension(param1.keyCode);
         if(_loc2_ && _loc2_.key && Boolean(_loc2_.params))
         {
            this.listenerList[_loc2_.key](_loc2_.params);
         }
      }
      
      public function get sfs() : SmartFox
      {
         return this._sfs;
      }
      
      public function set sfs(param1:SmartFox) : void
      {
         this._sfs = param1;
      }
      
      public function activate() : void
      {
      }
      
      public function deactivate() : void
      {
      }
      
      public function remove(param1:IServiceVO, param2:Boolean = true) : void
      {
      }
      
      public function removeByKey(param1:String, param2:Boolean = true) : void
      {
      }
      
      public function listenRoomVariable(param1:String, param2:Function) : void
      {
         this.listenerList[param1] = param2;
      }
      
      public function listenUserVariable(param1:String, param2:Function) : void
      {
         this.listenerList[param1] = param2;
      }
      
      public function listenExtension(param1:String, param2:Function) : void
      {
         this.listenerList[param1] = param2;
      }
      
      public function requestExtension(param1:String, param2:Object, param3:Function, param4:Room = null) : void
      {
         var _loc5_:Object;
         if(_loc5_ = Sanalika.panelManager.popupMockHandler.requestData(param1,param2))
         {
            this.list[param1] = setTimeout(param3,100,_loc5_["data"]);
         }
      }
      
      public function requestData(param1:String, param2:Object, param3:Function, param4:Room = null) : void
      {
         var _loc5_:Object;
         if(_loc5_ = Sanalika.panelManager.popupMockHandler.requestData(param1,param2))
         {
            this.list[param1] = setTimeout(param3,100,_loc5_["data"]);
         }
      }
      
      public function removeRequestData(param1:String, param2:Function) : void
      {
         clearTimeout(this.list[param1]);
      }
      
      public function removeRequestExtension(param1:String, param2:Function) : void
      {
         clearTimeout(this.list[param1]);
      }
      
      public function setRoomVariable(param1:Array, param2:Array) : void
      {
      }
      
      public function setUserVariable(param1:Array, param2:Array) : void
      {
      }
      
      public function removeExtension(param1:String, param2:Function) : void
      {
      }
      
      public function removeUserVariable(param1:String, param2:Function) : void
      {
      }
      
      public function removeRoomVariable(param1:String, param2:Function) : void
      {
      }
      
      public function get map() : IServiceMapping
      {
         return null;
      }
   }
}

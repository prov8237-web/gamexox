package org.oyunstudyosu.sanalika.panels.avatarSwitch
{
   import com.greensock.TweenMax;
   import com.greensock.plugins.GlowFilterPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import com.oyunstudyosu.events.AvatarEvent;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.avatarSwitch.AvatarItem")]
   public class AvatarItem extends MovieClip
   {
       
      
      public var txtFriend:TextField;
      
      public var id:String;
      
      public var friendName:String;
      
      public var imgUrl:String;
      
      private var sTextField:STextField;
      
      public var invited:Boolean = false;
      
      public var currentDisplay:MovieClip;
      
      public var itemContainer:MovieClip;
      
      public var avatarContainer:MovieClip;
      
      public var btnAction:MovieClip;
      
      private var fbRoot:String = "https://graph.facebook.com";
      
      public var _data:Object;
      
      public var ghost:MovieClip;
      
      public function AvatarItem()
      {
         super();
         if(this.sTextField == null)
         {
            this.sTextField = TextFieldManager.convertAsArabicTextField(getChildByName("txtFriend") as TextField,true,false);
         }
         this.buttonMode = true;
      }
      
      public function init(param1:Object) : void
      {
         var _loc2_:AvatarEvent = null;
         if(param1)
         {
            this._data = param1;
            this.sTextField.centerText = param1.avatarName;
            if(param1.avatarID != 0)
            {
               this.ghost.visible = false;
               this.loadAsset(param1.avatarID,param1.imgPath,param1.gender);
            }
            else
            {
               this.ghost.visible = true;
               this.ghost.gotoAndStop(3);
            }
            if(param1.avatarID == Connectr.instance.avatarModel.avatarId)
            {
               _loc2_ = new AvatarEvent("show");
               _loc2_.avatarID = this._data.avatarID;
               Dispatcher.dispatchEvent(_loc2_);
               TweenPlugin.activate([GlowFilterPlugin]);
               TweenMax.to(this.btnAction,1,{"glowFilter":{
                  "color":255,
                  "blurX":10,
                  "blurY":10,
                  "strength":1,
                  "alpha":1
               }});
               this.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
            }
            else if(param1.avatarID == 0)
            {
               this.addEventListener(MouseEvent.CLICK,this.onCreate);
               this.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
               this.addEventListener(MouseEvent.MOUSE_OVER,this.onOut);
            }
            else
            {
               this.addEventListener(MouseEvent.CLICK,this.onSwitch);
               this.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
               this.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
            }
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         var _loc2_:AvatarEvent = new AvatarEvent("show");
         _loc2_.avatarID = this._data.avatarID;
         Dispatcher.dispatchEvent(_loc2_);
         TweenPlugin.activate([GlowFilterPlugin]);
         if(this._data.avatarID != Connectr.instance.avatarModel.avatarId)
         {
            TweenMax.to(this.btnAction,1,{"glowFilter":{
               "color":65280,
               "blurX":10,
               "blurY":10,
               "strength":1,
               "alpha":1
            }});
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         TweenPlugin.activate([GlowFilterPlugin]);
         TweenMax.to(this.btnAction,1,{"glowFilter":{
            "color":65280,
            "blurX":10,
            "blurY":10,
            "strength":1,
            "alpha":0
         }});
      }
      
      private function onCreate(param1:MouseEvent) : void
      {
         this.btnAction.mouseEnabled = false;
         TweenMax.to(this.btnAction,0,{"colorMatrixFilter":{"saturation":0}});
         var _loc2_:AvatarEvent = new AvatarEvent("create");
         _loc2_.avatarID = this._data.avatarID;
         Dispatcher.dispatchEvent(_loc2_);
      }
      
      private function onSwitch(param1:MouseEvent) : void
      {
         this.btnAction.mouseEnabled = false;
         TweenMax.to(this.btnAction,0,{"colorMatrixFilter":{"saturation":0}});
         var _loc2_:AvatarEvent = new AvatarEvent("switch");
         _loc2_.avatarID = this._data.avatarID;
         Dispatcher.dispatchEvent(_loc2_);
      }
      
      private function loadAsset(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:AssetRequest;
         (_loc4_ = new AssetRequest()).assetId = "/cp/av/v2/" + param1 + "?instance=" + Connectr.instance.gameModel.serverName + "&ip=" + param2 + "&g=" + param3;
         _loc4_.context = Connectr.instance.domainModel.assetContext;
         _loc4_.loadedFunction = this.imgLoaded;
         Connectr.instance.assetModel.request(_loc4_);
      }
      
      private function imgLoaded(param1:IAssetRequest) : void
      {
         var _loc2_:DisplayObject = param1.display;
         this.currentDisplay = new MovieClip();
         this.currentDisplay.addChild(_loc2_);
         this.avatarContainer.addChild(this.currentDisplay);
         this.currentDisplay.x = -this.currentDisplay.width / 2;
         this.currentDisplay.y = -this.currentDisplay.height / 2;
      }
      
      public function dispose() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.onOut);
         this.removeEventListener(MouseEvent.CLICK,this.onOver);
         this.removeEventListener(MouseEvent.CLICK,this.onSwitch);
      }
   }
}

package org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat
{
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import com.oyunstudyosu.buddy.BuddyVo;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.PrivateChatEvent;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat.BuddyView")]
   public class BuddyView extends CoreMovieClip
   {
       
      
      public var avatarNameTxt:TextField;
      
      public var avatarStatusTxt:TextField;
      
      public var imageBg:MovieClip;
      
      public var avatarNameTextField:STextField;
      
      public var avatarStatusTextField:STextField;
      
      public var onlineicon:MovieClip;
      
      public var imageMask:MovieClip;
      
      public var imageContainer:MovieClip;
      
      private var request:IAssetRequest;
      
      private var image:Bitmap;
      
      private var imageReqDone:Boolean;
      
      private var _vo:BuddyVo;
      
      private var _isOnline:Boolean;
      
      public function BuddyView()
      {
         super();
      }
      
      override public function added() : void
      {
         if(this.avatarNameTextField == null)
         {
            this.avatarNameTextField = TextFieldManager.convertAsArabicTextField(this.getChildByName("avatarNameTxt") as TextField,false);
            this.avatarStatusTextField = TextFieldManager.convertAsArabicTextField(this.getChildByName("avatarStatusTxt") as TextField,false);
         }
         this.avatarStatusTextField.multiline = false;
         this.avatarStatusTextField.wordWrap = false;
         this.mouseChildren = false;
         this.buttonMode = true;
         this.cacheAsBitmap = true;
         this.addEventListener(MouseEvent.CLICK,this.openChatView);
      }
      
      protected function openChatView(param1:MouseEvent) : void
      {
         if(this.vo == null)
         {
            return;
         }
         var _loc2_:PrivateChatEvent = new PrivateChatEvent(PrivateChatEvent.OPEN_MESSAGE_VIEW);
         _loc2_.avatarVo = this.vo;
         if(this.image)
         {
            _loc2_.imageData = this.image.bitmapData.clone();
         }
         else
         {
            _loc2_.imageData = new BitmapData(10,10);
         }
         Dispatcher.dispatchEvent(_loc2_);
      }
      
      private function loadImage() : void
      {
         this.request = new AssetRequest();
         this.request.name = "avatarimage";
         this.request.data = {};
         this.request.context = Connectr.instance.domainModel.assetContext;
         this.request.assetId = "/cp/av/v2/" + this.vo.avatarID + "?instance=" + Connectr.instance.gameModel.serverName + "&ip=" + this.vo.imgPath + "&g=" + this.vo.gender;
         this.request.loadedFunction = this.onLoaded;
         this.request.errorFunction = this.onError;
         Connectr.instance.assetModel.request(this.request);
         this.imageReqDone = true;
      }
      
      private function onError(param1:IAssetRequest) : void
      {
         param1.dispose();
      }
      
      private function onLoaded(param1:IAssetRequest) : void
      {
         this.image = new Bitmap((param1.display as Bitmap).bitmapData.clone());
         this.image.scaleX = this.image.scaleY = 0.7;
         this.image.smoothing = true;
         this.imageContainer.addChild(this.image);
         this.imageContainer.x = this.imageMask.x + (this.imageMask.width - this.imageContainer.width) / 2;
         this.imageContainer.y = this.imageMask.y - this.imageContainer.height + 50;
         this.imageContainer.mask = this.imageMask;
      }
      
      public function get vo() : BuddyVo
      {
         return this._vo;
      }
      
      public function set vo(param1:BuddyVo) : void
      {
         this._vo = param1;
         this.avatarNameTextField.text = param1.avatarName;
         var _loc2_:* = param1.status;
         if(_loc2_.length > 30)
         {
            _loc2_ = _loc2_.substr(0,27) + "...";
         }
         this.avatarStatusTextField.text = _loc2_;
         this.avatarStatusTextField.width = 140;
         this.avatarStatusTextField.height = 15;
         this.isOnline = this.vo.isOnline;
         if(!this.imageReqDone)
         {
            this.loadImage();
         }
      }
      
      public function get isOnline() : Boolean
      {
         return this._isOnline;
      }
      
      public function set isOnline(param1:Boolean) : void
      {
         this._isOnline = param1;
         this.onlineicon.visible = this._isOnline;
      }
   }
}

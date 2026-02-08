package org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin
{
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.ProfileEvent;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin.WinnerAvatar")]
   public class WinnerAvatar extends MovieClip
   {
       
      
      public var avatarNameTxt:TextField;
      
      public var imageBg:MovieClip;
      
      public var avatarID:String;
      
      public var avatarName:String;
      
      public var gender:String;
      
      public var imgPath:String;
      
      private var xPos:Number = 0;
      
      private var yPos:Number = 0;
      
      private var xSpeed:Number = 0;
      
      private var ySpeed:Number = 0;
      
      private var maxHeight:Number = 0;
      
      private var maxWidth:Number = 0;
      
      private var request:IAssetRequest;
      
      public var avatarNameTextField:STextField;
      
      public var imageMask:MovieClip;
      
      public var imageContainer:MovieClip;
      
      private var image:Bitmap;
      
      public function WinnerAvatar()
      {
         super();
      }
      
      public function init() : void
      {
         this.SetInitialProperties();
         if(this.avatarNameTextField == null)
         {
            this.avatarNameTextField = TextFieldManager.convertAsArabicTextField(this.getChildByName("avatarNameTxt") as TextField,false);
         }
         this.avatarNameTextField.text = this.avatarName;
         this.mouseChildren = false;
         this.buttonMode = true;
         this.cacheAsBitmap = true;
         this.loadImage();
         this.addEventListener(MouseEvent.CLICK,this.openProfile);
      }
      
      public function SetInitialProperties() : void
      {
         this.xSpeed = 0.05 + Math.random() * 0.1;
         this.ySpeed = 0.1 + Math.random() * 3;
         this.maxWidth = 230;
         this.maxHeight = 375;
         this.x = Math.random() * this.maxWidth;
         this.y = Math.random() * this.maxHeight;
         this.xPos = this.x;
         this.yPos = this.y;
         this.addEventListener(Event.ENTER_FRAME,this.MoveMe);
      }
      
      private function MoveMe(param1:Event) : void
      {
         this.xPos += this.xSpeed;
         this.yPos += this.ySpeed;
         this.x += this.xSpeed;
         this.y += this.ySpeed;
         if(this.y - this.height > this.maxHeight)
         {
            this.y = -10 - this.height;
            this.x = Math.random() * this.maxWidth;
         }
      }
      
      private function openProfile(param1:MouseEvent) : void
      {
         var _loc2_:ProfileEvent = new ProfileEvent(ProfileEvent.SHOW_PROFILE);
         _loc2_.avatarID = this.avatarID;
         Dispatcher.dispatchEvent(_loc2_);
      }
      
      private function loadImage() : void
      {
         this.request = new AssetRequest();
         this.request.name = "avatarimage";
         this.request.data = {};
         this.request.context = Connectr.instance.domainModel.assetContext;
         this.request.assetId = "/cp/av/v2/" + this.avatarID + "?instance=" + Connectr.instance.gameModel.serverName + "&ip=" + this.imgPath + "&g=" + this.gender;
         this.request.loadedFunction = this.onLoaded;
         this.request.errorFunction = this.onError;
         Connectr.instance.assetModel.request(this.request);
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
   }
}

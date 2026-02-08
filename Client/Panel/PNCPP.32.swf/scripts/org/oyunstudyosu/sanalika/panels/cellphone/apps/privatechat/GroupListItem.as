package org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat
{
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import com.oyunstudyosu.buddy.BuddyVo;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.PrivateChatEvent;
   import com.oyunstudyosu.privatechat.IPrivateChatGroup;
   import com.oyunstudyosu.privatechat.IPrivateChatMessage;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat.GroupListItem")]
   public class GroupListItem extends CoreMovieClip
   {
       
      
      public var groupNameTxt:TextField;
      
      public var imageBg:MovieClip;
      
      public var lastMessageTxt:TextField;
      
      public var tipCountTxt:TextField;
      
      public var groupNameTextField:STextField;
      
      public var lastMessageTextField:STextField;
      
      public var tipCountTextField:TextField;
      
      public var tipBg:MovieClip;
      
      public var hitMc:MovieClip;
      
      public var junkButton:SimpleButton;
      
      private var count:int;
      
      public var imageMask:MovieClip;
      
      public var imageContainer:MovieClip;
      
      private var request:IAssetRequest;
      
      private var image:Bitmap;
      
      private var imageReqDone:Boolean;
      
      private var _group:IPrivateChatGroup;
      
      public function GroupListItem()
      {
         super();
      }
      
      override public function added() : void
      {
         if(this.groupNameTextField == null)
         {
            this.groupNameTextField = TextFieldManager.convertAsArabicTextField(this.getChildByName("groupNameTxt") as TextField,false);
            this.lastMessageTextField = TextFieldManager.convertAsArabicTextField(this.getChildByName("lastMessageTxt") as TextField,false);
            this.tipCountTextField = TextFieldManager.createNoneLanguageTextfield(this.getChildByName("tipCountTxt") as TextField);
         }
         this.hitMc.addEventListener(MouseEvent.CLICK,this.openChatView);
         this.junkButton.addEventListener(MouseEvent.CLICK,this.junkButtonClicked);
         Dispatcher.addEventListener(PrivateChatEvent.NEW_MESSAGE_ADDED,this.newMessageAdded);
      }
      
      protected function junkButtonClicked(param1:MouseEvent) : void
      {
         this.junkButton.removeEventListener(MouseEvent.CLICK,this.junkButtonClicked);
         var _loc2_:PrivateChatEvent = new PrivateChatEvent(PrivateChatEvent.REMOVE_GROUP);
         _loc2_.groupID = this.group.groupID;
         this.dispatchEvent(_loc2_);
      }
      
      private function newMessageAdded(param1:PrivateChatEvent) : void
      {
         var _loc2_:IPrivateChatGroup = param1.group;
         var _loc3_:IPrivateChatMessage = param1.message;
         if(Boolean(this.group) && _loc2_.groupID == this.group.groupID)
         {
            this.group = _loc2_;
         }
      }
      
      protected function openChatView(param1:MouseEvent) : void
      {
         var _loc2_:PrivateChatEvent = new PrivateChatEvent(PrivateChatEvent.OPEN_MESSAGE_VIEW);
         if(this.group != null)
         {
            this.group.unreadMessageCount = 0;
            this.group = this.group;
            _loc2_.group = this.group;
         }
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
      
      public function get group() : IPrivateChatGroup
      {
         return this._group;
      }
      
      public function set group(param1:IPrivateChatGroup) : void
      {
         this._group = param1;
         if(param1.groupName)
         {
            this.groupNameTextField.text = param1.groupName;
         }
         else
         {
            this.groupNameTextField.text = "";
         }
         var _loc2_:* = param1.lastMessage.content;
         if(_loc2_.length > 30)
         {
            _loc2_ = _loc2_.substr(0,27) + "...";
         }
         this.lastMessageTextField.text = _loc2_;
         if(param1.unreadMessageCount > 0)
         {
            this.tipCountTextField.visible = this.tipBg.visible = true;
            this.lastMessageTextField.x = 65;
            if(param1.unreadMessageCount > 100)
            {
               this.count = 99;
            }
            else
            {
               this.count = param1.unreadMessageCount;
            }
         }
         else
         {
            this.tipCountTextField.visible = this.tipBg.visible = false;
            this.lastMessageTextField.x = 45;
            this.count = 0;
         }
         this.tipCountTextField.text = this.count.toString();
         if(!this.imageReqDone)
         {
            this.loadImage();
         }
      }
      
      private function loadImage() : void
      {
         var _loc1_:BuddyVo = Connectr.instance.buddyModel.getBuddyVoById(this.group.avatarID);
         if(_loc1_ == null || this.image != null)
         {
            return;
         }
         this.request = new AssetRequest();
         this.request.name = "avatarimage";
         this.request.data = {};
         this.request.context = Connectr.instance.domainModel.assetContext;
         this.request.assetId = "/cp/av/v2/" + _loc1_.avatarID + "?instance=" + Connectr.instance.gameModel.serverName + "&ip=" + _loc1_.imgPath + "&g=" + _loc1_.gender;
         this.request.loadedFunction = this.groupImageLoaded;
         this.request.errorFunction = this.groupImageError;
         Connectr.instance.assetModel.request(this.request);
         this.imageReqDone = true;
      }
      
      private function groupImageError(param1:IAssetRequest) : void
      {
         param1.dispose();
      }
      
      private function groupImageLoaded(param1:IAssetRequest) : void
      {
         this.image = new Bitmap((param1.display as Bitmap).bitmapData.clone());
         this.image.scaleX = this.image.scaleY = 0.7;
         this.image.smoothing = true;
         this.imageContainer.addChild(this.image);
         this.imageContainer.x = this.imageMask.x + (this.imageMask.width - this.imageContainer.width) / 2;
         this.imageContainer.y = this.imageMask.y - this.imageContainer.height + 50;
         this.imageContainer.mask = this.imageMask;
      }
      
      override public function removed() : void
      {
         this.hitMc.removeEventListener(MouseEvent.CLICK,this.openChatView);
         this.junkButton.removeEventListener(MouseEvent.CLICK,this.junkButtonClicked);
         Dispatcher.removeEventListener(PrivateChatEvent.NEW_MESSAGE_ADDED,this.newMessageAdded);
         if(this.request)
         {
            this.request.dispose();
         }
      }
   }
}

package org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.greensock.easing.Strong;
   import com.greensock.plugins.ThrowPropsPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.buddy.BuddyResponseTypes;
   import com.oyunstudyosu.buddy.BuddyVo;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.PrivateChatEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.local.arabic.ArabicInputManager;
   import com.oyunstudyosu.privatechat.IPrivateChatGroup;
   import com.oyunstudyosu.privatechat.IPrivateChatMessage;
   import com.oyunstudyosu.privatechat.PrivateChatMessage;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.BlitMask;
   import com.oyunstudyosu.utils.DrawUtils;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   import org.oyunstudyosu.components.CoreMovieClip;
   import org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat.bubble.ChatBubble;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat.GroupChatDetailView")]
   public class GroupChatDetailView extends CoreMovieClip
   {
       
      
      public var avatarNameTxt:TextField;
      
      public var imageBg:MovieClip;
      
      public var messageText:TextField;
      
      public var quantityLabel:TextField;
      
      private var _buddyVo:BuddyVo;
      
      public var backButton:SimpleButton;
      
      public var sendButton:SimpleButton;
      
      private var image:Bitmap;
      
      private var bitmapData:BitmapData;
      
      public var imageContainer:MovieClip;
      
      public var imageMask:MovieClip;
      
      private var avatarNameTextField:STextField;
      
      public var messageTextField:TextField;
      
      private var defaultText:String;
      
      private var inputManager:ArabicInputManager;
      
      private var _group:IPrivateChatGroup;
      
      private var message:IPrivateChatMessage;
      
      private var messages:Array;
      
      private var chatContainer:Sprite;
      
      private var chatBubble:ChatBubble;
      
      private var bounds:Rectangle;
      
      private var t1:uint;
      
      private var t2:uint;
      
      private var y1:Number;
      
      private var y2:Number;
      
      private var yOverlap:Number;
      
      private var yOffset:Number;
      
      private var blitMask:BlitMask;
      
      private var isMoved:Boolean;
      
      private var chatContainerBg:Sprite;
      
      private var lastHeight:int;
      
      public var unreadTip:MovieClip;
      
      public var unreadBgClip:MovieClip;
      
      private var unreadTextField:TextField;
      
      public function GroupChatDetailView(param1:BitmapData)
      {
         super();
         this.bitmapData = param1;
         Connectr.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_REMOVED,this.onBuddyRemoved);
      }
      
      public function get group() : IPrivateChatGroup
      {
         return this._group;
      }
      
      public function set group(param1:IPrivateChatGroup) : void
      {
         this._group = param1;
         if(param1 != null)
         {
            Connectr.instance.privateChatModel.activeGroupID = param1.groupID;
         }
         else
         {
            Connectr.instance.privateChatModel.activeGroupID = null;
         }
      }
      
      public function get buddyVo() : BuddyVo
      {
         return this._buddyVo;
      }
      
      public function set buddyVo(param1:BuddyVo) : void
      {
         this._buddyVo = param1;
      }
      
      override public function added() : void
      {
         this.backButton.addEventListener(MouseEvent.CLICK,this.backButtonClicked);
         if(this.avatarNameTextField == null)
         {
            this.avatarNameTextField = TextFieldManager.convertAsArabicTextField(this.getChildByName("avatarNameTxt") as TextField,false);
            this.messageTextField = TextFieldManager.createNoneLanguageTextfield(this.getChildByName("messageText") as TextField);
            this.unreadTextField = TextFieldManager.createNoneLanguageTextfield(this.getChildByName("quantityLabel") as TextField);
         }
         TweenPlugin.activate([ThrowPropsPlugin]);
         this.chatContainer = new Sprite();
         this.addChild(this.chatContainer);
         this.chatContainer.y = 56;
         this.chatContainerBg = DrawUtils.getRectangleSprite(228,100,0,0);
         this.chatContainer.addChild(this.chatContainerBg);
         this.chatContainer.buttonMode = true;
         this.defaultText = $("sendPrivateMessage");
         this.messageTextField.text = this.defaultText;
         this.messageTextField.maxChars = 120;
         if(Connectr.instance.gameModel.language == "ar")
         {
            this.inputManager = new ArabicInputManager(this.messageTextField,this.messageTextField.defaultTextFormat);
         }
         this.image = new Bitmap(this.bitmapData);
         this.image.scaleX = this.image.scaleY = 0.7;
         this.image.smoothing = true;
         this.imageContainer.addChild(this.image);
         this.imageContainer.x = this.imageMask.x + (this.imageMask.width - this.imageContainer.width) / 2;
         this.imageContainer.y = this.imageMask.y - this.imageContainer.height + 50;
         this.imageContainer.mask = this.imageMask;
         this.messageTextField.addEventListener(FocusEvent.FOCUS_IN,this.focusIn);
         this.messageTextField.addEventListener(FocusEvent.FOCUS_OUT,this.focusOut);
         if(this.group == null && this.buddyVo != null)
         {
            this.group = Connectr.instance.privateChatModel.hasGroup(this.buddyVo.avatarID);
         }
         this.getDetails();
         if(this.buddyVo)
         {
            this.setName(this.buddyVo.avatarName);
            this.updateUnreadCount();
         }
         Dispatcher.addEventListener(PrivateChatEvent.NEW_MESSAGE_ADDED,this.newMessageAdded);
         this.sendButton.addEventListener(MouseEvent.CLICK,this.sendButtonClicked);
      }
      
      private function updateUnreadCount() : void
      {
         if(Connectr.instance.privateChatModel.unreadCount <= 0 || this.group == null)
         {
            this.unreadTextField.visible = this.unreadBgClip.visible = false;
         }
         else
         {
            this.unreadTextField.visible = this.unreadBgClip.visible = true;
            this.unreadTextField.text = Connectr.instance.privateChatModel.unreadCount.toString();
         }
      }
      
      private function newMessageAdded(param1:PrivateChatEvent) : void
      {
         var _loc2_:IPrivateChatGroup = param1.group;
         var _loc3_:IPrivateChatMessage = param1.message;
         this.lastHeight = this.chatContainer.height;
         if(Boolean(this.group) && _loc2_.groupID == this.group.groupID)
         {
            this.group.unreadMessageCount = 0;
            this.addMessage(_loc3_);
            if(this.chatContainer.y == 56 && this.chatContainer.height < this.bounds.height || this.chatContainer.y > this.bounds.height - this.lastHeight + 86)
            {
               return;
            }
            this.update();
         }
         else
         {
            this.updateUnreadCount();
         }
      }
      
      private function getDetails() : void
      {
         if(this.group)
         {
            Dispatcher.addEventListener(PrivateChatEvent.GROUP_MESSAGES_READY,this.groupMessagesReady);
            this.messages = this.group.getMessages();
            if(this.messages != null)
            {
               this.processMessages();
            }
            Connectr.instance.serviceModel.requestData(RequestDataKey.SET_ACTIVE_GROUP,{"groupID":this.group.groupID},this.activeGroupResponse);
         }
         else
         {
            this.warnUser();
            this.bounds = new Rectangle(this.chatContainer.x,this.chatContainer.y,228,275);
            this.update();
            this.blitMask = new BlitMask(this.chatContainer,this.bounds.x,this.bounds.y,this.bounds.width,this.bounds.height,false,true);
            this.blitMask.bitmapMode = false;
            this.blitMask.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            Dispatcher.addEventListener(PrivateChatEvent.NEW_GROUP_ADDED,this.newGroupAdded);
         }
      }
      
      private function activeGroupResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SET_ACTIVE_GROUP,this.activeGroupResponse);
         if(param1.updateUnread == 1)
         {
            Connectr.instance.privateChatModel.unreadCount = param1.totalUnread;
            this.updateUnreadCount();
         }
      }
      
      private function newGroupAdded(param1:PrivateChatEvent) : void
      {
         Dispatcher.removeEventListener(PrivateChatEvent.NEW_GROUP_ADDED,this.newGroupAdded);
         if(Boolean(this.buddyVo) && this.buddyVo.avatarID == param1.group.avatarID)
         {
            this.buddyVo = null;
            this.group = param1.group;
         }
      }
      
      private function groupMessagesReady(param1:PrivateChatEvent) : void
      {
         if(Boolean(this.group) && this.group.groupID == param1.groupID)
         {
            this.messages = this.group.getMessages();
            this.processMessages();
            this.setName(this.group.groupName);
         }
         else
         {
            this.setName(this.buddyVo.avatarName);
         }
      }
      
      private function warnUser() : void
      {
         var _loc1_:PrivateChatMessage = new PrivateChatMessage();
         _loc1_.content = Sanalika.instance.localizationModel.translate("warnWhisper");
         _loc1_.isAdmin = true;
         this.addMessage(_loc1_);
      }
      
      public function setName(param1:String) : void
      {
         var _loc2_:* = param1;
         if(_loc2_.length > 16)
         {
            _loc2_ = _loc2_.substr(0,13) + "...";
         }
         this.avatarNameTextField.text = _loc2_;
         this.avatarNameTextField.width = 105;
         this.avatarNameTextField.height = 17;
      }
      
      private function processMessages() : void
      {
         Dispatcher.removeEventListener(PrivateChatEvent.GROUP_MESSAGES_READY,this.groupMessagesReady);
         if(this.group)
         {
            this.setName(this.group.groupName);
         }
         else
         {
            this.setName(this.buddyVo.avatarName);
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.messages.length)
         {
            this.message = this.messages[_loc1_];
            this.addMessage(this.message);
            _loc1_++;
         }
         this.warnUser();
         this.bounds = new Rectangle(this.chatContainer.x,this.chatContainer.y,228,275);
         this.update();
         this.blitMask = new BlitMask(this.chatContainer,this.bounds.x,this.bounds.y,this.bounds.width,this.bounds.height,false,true);
         this.blitMask.bitmapMode = false;
         this.blitMask.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
      }
      
      public function addMessage(param1:IPrivateChatMessage) : void
      {
         var _loc2_:ChatBubble = null;
         if(this.chatContainer.numChildren > 0)
         {
            _loc2_ = this.chatContainer.getChildAt(this.chatContainer.numChildren - 1) as ChatBubble;
         }
         this.chatBubble = new ChatBubble(param1);
         if(_loc2_)
         {
            this.chatBubble.y = _loc2_.y + _loc2_.height + 10;
         }
         this.chatContainer.addChild(this.chatBubble);
      }
      
      private function update() : void
      {
         this.chatContainerBg.height = this.chatContainer.height + 2;
         if(this.chatContainer.height > this.bounds.height)
         {
            TweenMax.to(this.chatContainer,0.5,{
               "y":56 + this.bounds.height - this.chatContainer.height,
               "ease":Quint.easeOut
            });
         }
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this.chatContainer);
         this.y1 = this.y2 = this.chatContainer.y;
         this.yOffset = this.mouseY - this.chatContainer.y;
         this.yOverlap = Math.max(0,this.chatContainer.height - this.bounds.height);
         this.t1 = this.t2 = getTimer();
         Connectr.instance.layerModel.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         Connectr.instance.layerModel.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         this.isMoved = true;
         var _loc2_:Number = this.mouseY - this.yOffset;
         if(_loc2_ > this.bounds.top)
         {
            this.chatContainer.y = (_loc2_ + this.bounds.top) * 0.5;
         }
         else if(_loc2_ < this.bounds.top - this.yOverlap)
         {
            this.chatContainer.y = (_loc2_ + this.bounds.top - this.yOverlap) * 0.5;
         }
         else
         {
            this.chatContainer.y = _loc2_;
         }
         this.blitMask.update();
         var _loc3_:uint = uint(getTimer());
         if(_loc3_ - this.t2 > 50)
         {
            this.y2 = this.y1;
            this.t2 = this.t1;
            this.y1 = this.chatContainer.y;
            this.t1 = _loc3_;
         }
         param1.updateAfterEvent();
      }
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         var _loc2_:Number = (getTimer() - this.t2) / 1000;
         var _loc3_:Number = (this.chatContainer.y - this.y2) / _loc2_;
         ThrowPropsPlugin.to(this.chatContainer,{
            "throwProps":{"y":{
               "velocity":_loc3_,
               "max":this.bounds.top,
               "min":this.bounds.top - this.yOverlap,
               "resistance":300
            }},
            "onUpdate":this.blitMask.update,
            "ease":Strong.easeOut
         },1,0.3,1);
      }
      
      protected function focusOut(param1:FocusEvent) : void
      {
         this.messageTextField.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyPressed);
         if(this.messageTextField.text == "")
         {
            if(this.inputManager)
            {
               this.inputManager.clearText();
               this.inputManager.addText(this.defaultText);
               this.inputManager.draw();
            }
            else
            {
               this.messageTextField.text = this.defaultText;
            }
         }
      }
      
      protected function focusIn(param1:FocusEvent) : void
      {
         this.messageTextField.addEventListener(KeyboardEvent.KEY_DOWN,this.keyPressed);
         if(this.messageTextField.text == this.defaultText)
         {
            this.messageTextField.text = "";
         }
      }
      
      protected function sendButtonClicked(param1:MouseEvent) : void
      {
         this.sendRequest();
      }
      
      protected function keyPressed(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.sendRequest();
         }
      }
      
      private function sendRequest() : void
      {
         var _loc1_:String = null;
         if(this.inputManager)
         {
            _loc1_ = this.inputManager.getText();
         }
         else
         {
            _loc1_ = this.messageTextField.text;
         }
         if(_loc1_.length > 1 && _loc1_ != this.defaultText)
         {
            this.sendMessage(_loc1_);
            this.messageTextField.text = "";
         }
      }
      
      private function sendMessage(param1:String) : void
      {
         if(this.inputManager)
         {
            this.messageTextField.text = "";
            this.inputManager.clearText();
         }
         else
         {
            this.messageTextField.text = "";
         }
         var _loc2_:Object = {};
         if(this.group)
         {
            _loc2_.groupID = this.group.groupID;
            _loc2_.avatarIDs = [this.group.avatarID];
         }
         else
         {
            if(!this.buddyVo)
            {
               return;
            }
            _loc2_.groupID = "0";
            _loc2_.avatarIDs = [this.buddyVo.avatarID];
         }
         _loc2_.content = param1;
         Connectr.instance.serviceModel.requestData(RequestDataKey.SEND_PRIVATE_MESSAGE,_loc2_,this.onResponse);
      }
      
      protected function onResponse(param1:Object) : void
      {
         var _loc2_:AlertVo = null;
         if(param1.errorCode != undefined)
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.TOOLTIP;
            _loc2_.description = $(param1.errorCode);
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
            return;
         }
      }
      
      protected function onBuddyRemoved(param1:Object) : void
      {
         this.backButtonClicked();
      }
      
      protected function backButtonClicked(param1:MouseEvent = null) : void
      {
         this.sendButton.removeEventListener(MouseEvent.CLICK,this.sendButtonClicked);
         this.backButton.removeEventListener(MouseEvent.CLICK,this.backButtonClicked);
         Dispatcher.removeEventListener(PrivateChatEvent.GROUP_MESSAGES_READY,this.groupMessagesReady);
         Dispatcher.removeEventListener(PrivateChatEvent.NEW_MESSAGE_ADDED,this.newMessageAdded);
         Dispatcher.removeEventListener(PrivateChatEvent.NEW_GROUP_ADDED,this.newGroupAdded);
         Connectr.instance.serviceModel.removeExtension(BuddyResponseTypes.BUDDY_REMOVED,this.onBuddyRemoved);
         if(this.blitMask)
         {
            this.blitMask.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            this.blitMask.dispose();
         }
         Connectr.instance.privateChatModel.activeGroupID = null;
         var _loc2_:PrivateChatEvent = new PrivateChatEvent(PrivateChatEvent.BACK_TO_LIST);
         Dispatcher.dispatchEvent(_loc2_);
      }
   }
}

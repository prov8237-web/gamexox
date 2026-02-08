package org.oyunstudyosu.sanalika.panels.history
{
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.ban.BanData;
   import com.oyunstudyosu.chat.ChatColorTemplate;
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.data.DataRequest;
   import com.oyunstudyosu.data.IDataRequest;
   import com.oyunstudyosu.engine.ICharacter;
   import com.oyunstudyosu.engine.scene.components.ISceneCharacterComponent;
   import com.oyunstudyosu.enums.AvatarPermission;
   import com.oyunstudyosu.enums.BanType;
   import com.oyunstudyosu.enums.CharacterVariable;
   import com.oyunstudyosu.enums.LanguageKeys;
   import com.oyunstudyosu.enums.UpdateGroups;
   import com.oyunstudyosu.events.BanEvent;
   import com.oyunstudyosu.events.ChatHistoryEvent;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.HudEvent;
   import com.oyunstudyosu.events.ProfileEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.local.arabic.ArabicInputManager;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.panel.PanelType;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.sanalika.interfaces.IHistorySpeechBubble;
   import com.oyunstudyosu.service.ServiceErrorCode;
   import com.oyunstudyosu.service.ServiceRequestRate;
   import com.oyunstudyosu.timer.SyncTimer;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import com.oyunstudyosu.utils.TimeConverter;
   import com.oyunstudyosu.yandex.Translator;
   import com.printfas3.printf;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   import flash.display.MovieClip;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import org.oyunstudyosu.components.CoreMovieClip;
   import org.oyunstudyosu.components.scrollBar.CoreScrollBar;
   import org.oyunstudyosu.sanalika.buttons.newButtons.ProfileButton;
   import org.oyunstudyosu.sanalika.buttons.newButtons.ReportButton;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.BlackHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.BlueHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.DefaultHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.DiamondClubHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.GreyHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.LoveHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.MusicHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.PinkHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.RedHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.SanalikaXHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.WhisperHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.WingHistoryBubble;
   import org.oyunstudyosu.sanalika.panels.history.bubbles.YellowHistoryBubble;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.history.ChatHistoryPanel")]
   public class ChatHistoryPanel extends Panel
   {
      
      private static var GLOBAL_ROOM:String = "chat";
       
      
      public var header:MovieClip;
      
      public var lbl_Title:TextField;
      
      public var messageTxt:TextField;
      
      public var searchTxt:TextField;
      
      private var chatHolder:CoreMovieClip;
      
      public var chatHistoryMask:MovieClip;
      
      public var btnGlobal:MovieClip;
      
      private var scrollBar:CoreScrollBar;
      
      private var chatDisable:Boolean = false;
      
      private var defaultText:String;
      
      private var searchText:String;
      
      public var mcDragger:MovieClip;
      
      public var messageTextField:TextField;
      
      public var searchTextField:TextField;
      
      private var avatarId:String;
      
      private var hudEvent:HudEvent;
      
      public var btnClose:CloseButton;
      
      private var firstItem:CoreMovieClip;
      
      public var chatBg:MovieClip;
      
      private var reportMessage:String;
      
      public var bubbles:Array;
      
      private var len:int;
      
      private var item:IHistorySpeechBubble;
      
      private var reportBtn:ReportButton;
      
      private var profileBtn:ProfileButton;
      
      private var itemView:CoreMovieClip;
      
      private var inputManager:ArabicInputManager;
      
      private var searchManager:ArabicInputManager;
      
      private var sTitle:STextField;
      
      private var banData:BanData;
      
      public var timer:Timer;
      
      private var newText:String;
      
      private var txtlen:int;
      
      public var background:MovieClip;
      
      private var _mode:String;
      
      private var nextMessage:int = 0;
      
      public function ChatHistoryPanel()
      {
         this.bubbles = [];
         this._mode = ChatMode.LOCAL;
         super();
      }
      
      private function get mode() : String
      {
         return this._mode;
      }
      
      private function set mode(param1:String) : void
      {
         if(this._mode == param1)
         {
            return;
         }
         this.removeAll();
         this._mode = param1;
         if(this._mode == ChatMode.GLOBAL)
         {
            this.btnGlobal.gotoAndStop(2);
            Connectr.instance.toolTipModel.addTip(this.btnGlobal,Connectr.instance.localizationModel.translate("Chat Local"));
         }
         else
         {
            this.getLastMessages();
            this.btnGlobal.gotoAndStop(1);
            Connectr.instance.toolTipModel.addTip(this.btnGlobal,Connectr.instance.localizationModel.translate("Chat Global"));
         }
      }
      
      override public function init() : void
      {
         var _loc1_:ChatColorTemplate = null;
         var _loc2_:User = null;
         super.init();
         this.bubbles[1] = DefaultHistoryBubble;
         this.bubbles[2] = BlueHistoryBubble;
         this.bubbles[3] = YellowHistoryBubble;
         this.bubbles[4] = GreyHistoryBubble;
         this.bubbles[23] = BlackHistoryBubble;
         this.bubbles[24] = RedHistoryBubble;
         this.bubbles[25] = PinkHistoryBubble;
         this.bubbles[8] = WingHistoryBubble;
         this.bubbles[9] = MusicHistoryBubble;
         this.bubbles[22] = LoveHistoryBubble;
         this.bubbles[11] = WhisperHistoryBubble;
         this.bubbles[26] = DiamondClubHistoryBubble;
         this.bubbles[30] = SanalikaXHistoryBubble;
         dragHandler = this.mcDragger;
         bgHandler = this.background;
         this.chatHolder = new CoreMovieClip();
         if(this.sTitle == null)
         {
            this.sTitle = TextFieldManager.convertAsArabicTextField(getChildByName("lbl_Title") as TextField,false,true);
            this.sTitle.autoSize = TextFieldAutoSize.CENTER;
            this.sTitle.wordWrap = false;
            this.sTitle.mouseEnabled = false;
            this.messageTextField = TextFieldManager.createNoneLanguageTextfield(this.getChildByName("messageTxt") as TextField);
            this.searchTextField = TextFieldManager.createNoneLanguageTextfield(this.getChildByName("searchTxt") as TextField);
         }
         this.sTitle.text = $("Chat History");
         addChild(this.chatHolder);
         this.chatHolder.x = this.chatHistoryMask.x;
         this.chatHolder.y = this.chatHistoryMask.y;
         this.scrollBar = new CoreScrollBar();
         addChild(this.scrollBar);
         this.scrollBar.x = this.chatHistoryMask.x + this.chatHistoryMask.width + 4;
         this.scrollBar.y = this.chatHolder.y;
         this.scrollBar.barColor = 2201331;
         this.scrollBar.bgColor = 12312315;
         this.scrollBar.scrollBackground.width = 10;
         this.scrollBar.barMask.width = this.scrollBar.bar.width = 10;
         this.scrollBar.direction = "vertical";
         this.scrollBar.snap = 100;
         this.scrollBar.setTarget(this.chatHolder,this.chatHistoryMask);
         this.defaultText = LanguageKeys.DEFAULT_INPUT_TEXT;
         this.searchText = $("Search");
         if(Connectr.instance.gameModel.language == "ar")
         {
            this.inputManager = new ArabicInputManager(this.messageTextField,this.messageTextField.defaultTextFormat);
            this.searchManager = new ArabicInputManager(this.searchTextField,this.searchTextField.defaultTextFormat);
         }
         this.banData = Connectr.instance.banModel.getBanData(BanType.CHAT_BANNED);
         if(this.banData)
         {
            this.messageTextField.mouseEnabled = false;
            this.messageTextField.type = TextFieldType.DYNAMIC;
            if(this.banData.isLimited)
            {
               Connectr.instance.updateModel.getGroup(UpdateGroups.TIMER_1S).addFunction(this.banChecker);
               Dispatcher.addEventListener(BanEvent.CHAT_BANNED_COMPLETE,this.chatBanCompleted);
            }
            else if(this.inputManager)
            {
               this.inputManager.addText(LanguageKeys.DEFAULT_INPUT_UNLIMITED_BAN_TEXT);
               this.inputManager.draw();
            }
            else
            {
               this.messageTextField.text = LanguageKeys.DEFAULT_INPUT_UNLIMITED_BAN_TEXT;
            }
            _loc1_ = ChatColorTemplate.BAN;
            this.chatBg.gotoAndStop(_loc1_.bgFrame);
            this.messageTextField.textColor = _loc1_.textColor;
         }
         else
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
            _loc2_ = _loc2_ = Connectr.instance.serviceModel.sfs.mySelf;
            Connectr.instance.serviceModel.listenUserVariable(CharacterVariable.CHAT_BALLOON_COLOR,this.changeChatColor);
            this.changeChatColor(_loc2_ as Object);
         }
         if(this.searchManager)
         {
            this.searchManager.clearText();
            this.searchManager.addText(this.searchText);
            this.searchManager.draw();
         }
         else
         {
            this.searchTextField.text = this.searchText;
         }
         this.messageTextField.addEventListener(FocusEvent.FOCUS_IN,this.focusIn);
         this.messageTextField.addEventListener(FocusEvent.FOCUS_OUT,this.focusOut);
         this.searchTextField.addEventListener(KeyboardEvent.KEY_UP,this.searchTextUpdate);
         this.searchTextField.addEventListener(FocusEvent.FOCUS_IN,this.focusInSearch);
         this.searchTextField.addEventListener(FocusEvent.FOCUS_OUT,this.focusOutSearch);
         Dispatcher.addEventListener(ChatHistoryEvent.ADD,this.addNewHistoryMessage);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.closeClicked);
         this.getLastMessages();
         this.btnGlobal.gotoAndStop(1);
         Connectr.instance.toolTipModel.addTip(this.btnGlobal,Connectr.instance.localizationModel.translate("Chat Global"));
         this.btnGlobal.buttonMode = true;
         this.btnGlobal.addEventListener(MouseEvent.CLICK,this.onGlobalClicked);
         Connectr.instance.serviceModel.listenExtension("chat.message",this.onChatMessage);
         Connectr.instance.serviceModel.listenExtension("chat.sync",this.onChatSync);
         Connectr.instance.serviceModel.sfs.addEventListener(SFSEvent.ROOM_JOIN,this.onRoomJoin);
         Connectr.instance.serviceModel.sfs.addEventListener(SFSEvent.USER_EXIT_ROOM,this.onExitRoom);
         show();
      }
      
      private function onGlobalClicked(param1:MouseEvent) : void
      {
         if(this.mode == ChatMode.GLOBAL)
         {
            Connectr.instance.serviceModel.requestData("globalchat.leave",{},null);
         }
         else
         {
            Connectr.instance.serviceModel.requestData("globalchat.join",{},null);
         }
      }
      
      private function searchTextUpdate(param1:KeyboardEvent) : void
      {
         this.updateSort();
      }
      
      private function banChecker(param1:uint, param2:uint) : void
      {
         if(this.inputManager)
         {
            this.inputManager.clearText();
            this.inputManager.addText(printf(LanguageKeys.DEFAULT_INPUT_BAN_TEXT,TimeConverter.toTime(this.banData.banEndTime * 1000,TimeConverter.HOUR_MINUTE_SECOND_TYPE)));
            this.inputManager.draw();
         }
         else
         {
            this.messageTextField.text = printf(LanguageKeys.DEFAULT_INPUT_BAN_TEXT,TimeConverter.toTime(this.banData.banEndTime * 1000,TimeConverter.HOUR_MINUTE_SECOND_TYPE));
         }
      }
      
      protected function showTranslation(param1:IDataRequest) : void
      {
         this.updateSort();
      }
      
      protected function copyAvatarID(param1:MouseEvent) : void
      {
         var _loc2_:IDataRequest = null;
         var _loc3_:Object = null;
         var _loc4_:Translator = null;
         if(Connectr.instance.avatarModel.permission.check(AvatarPermission.MODERATOR))
         {
            _loc2_ = new DataRequest();
            _loc3_ = {};
            _loc3_.myText = this.reportMessage;
            _loc3_.toLanguage = "en";
            _loc3_.fromLanguage = Connectr.instance.gameModel.language;
            _loc2_.data = _loc3_;
            _loc2_.loadedFunction = this.showTranslation;
            _loc4_ = new Translator(_loc2_);
         }
         if(param1.ctrlKey)
         {
            System.setClipboard(this.reportMessage);
         }
         if(param1.shiftKey)
         {
            System.setClipboard(this.avatarId);
         }
      }
      
      private function chatBanCompleted(param1:BanEvent) : void
      {
         Dispatcher.removeEventListener(BanEvent.CHAT_BANNED_COMPLETE,this.chatBanCompleted);
         Connectr.instance.updateModel.getGroup(UpdateGroups.TIMER_1S).removeFunction(this.banChecker);
         var _loc2_:ChatColorTemplate = ChatColorTemplate.DEFAULT;
         this.chatBg.gotoAndStop(_loc2_.bgFrame);
         this.messageTextField.textColor = _loc2_.textColor;
         this.messageTextField.mouseEnabled = true;
         this.messageTextField.type = TextFieldType.INPUT;
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
      
      private function changeChatColor(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:User = param1 as User;
         if(_loc3_ == null)
         {
            return;
         }
         if(!_loc3_.isItMe)
         {
            return;
         }
         var _loc4_:UserVariable;
         if(_loc4_ = _loc3_.getVariable(CharacterVariable.CHAT_BALLOON_COLOR))
         {
            _loc2_ = parseInt(_loc4_.getStringValue());
            if(_loc2_ > this.chatBg.totalFrames - 1)
            {
               _loc2_ = 1;
            }
         }
         else
         {
            _loc2_ = 1;
         }
         var _loc5_:ChatColorTemplate;
         if((_loc5_ = Connectr.instance.chatBalloonModel.getTemplateByID(_loc2_)) == null)
         {
            _loc5_ = ChatColorTemplate.DEFAULT;
         }
         this.chatBg.gotoAndStop(_loc2_);
         this.messageTextField.textColor = _loc5_.textColor;
      }
      
      protected function closeClicked(param1:MouseEvent) : void
      {
         if(param1.ctrlKey)
         {
            this.clearHistory();
         }
         else
         {
            close();
         }
      }
      
      private function getLastMessages() : void
      {
         var _loc3_:ICharacter = null;
         var _loc1_:int = int(Connectr.instance.chatModel.list.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = Connectr.instance.chatModel.list[_loc2_].sender;
            this.add(_loc3_.id,_loc3_.avatarName,Connectr.instance.chatModel.list[_loc2_].message,Connectr.instance.chatModel.list[_loc2_].frameNo,Connectr.instance.chatModel.list[_loc2_].isPublic);
            _loc2_++;
         }
      }
      
      public function addNewHistoryMessage(param1:ChatHistoryEvent) : void
      {
         if(this.mode == ChatMode.GLOBAL)
         {
            return;
         }
         var _loc2_:ICharacter = param1.vo.sender;
         this.add(_loc2_.id,_loc2_.avatarName,param1.vo.message,param1.vo.frameNo,param1.vo.isPublic);
      }
      
      public function add(param1:String, param2:String, param3:String, param4:int = 0, param5:Boolean = false) : void
      {
         if(this.chatHolder.numChildren > 100)
         {
            this.firstItem = this.chatHolder.getChildAt(0) as CoreMovieClip;
            this.chatHolder.removeChild(this.firstItem);
         }
         var _loc6_:ChatColorTemplate = Connectr.instance.chatBalloonModel.getTemplateByID(param4);
         if(this.bubbles[_loc6_.bgFrame])
         {
            this.item = new this.bubbles[_loc6_.bgFrame]();
         }
         else
         {
            this.item = new this.bubbles[0]();
         }
         this.chatHolder.addChild(this.item as CoreMovieClip);
         this.item.speech(param1,param2,param3);
         if(Connectr.instance.avatarModel.avatarId == param1)
         {
            (this.item as CoreMovieClip).x = this.chatHistoryMask.width - (this.item as CoreMovieClip).width - 2;
         }
         else
         {
            (this.item as CoreMovieClip).addEventListener(MouseEvent.MOUSE_OVER,this.overMessage);
            (this.item as CoreMovieClip).addEventListener(MouseEvent.MOUSE_OUT,this.outMessage);
            (this.item as CoreMovieClip).addEventListener(MouseEvent.CLICK,this.copyAvatarID);
            if(param5)
            {
               this.reportBtn = new ReportButton();
               this.reportBtn.name = "reportBtn";
               this.reportBtn.visible = false;
               this.reportBtn.x = (this.item as CoreMovieClip).x + (this.item as CoreMovieClip).width - 20;
               this.reportBtn.y = ((this.item as CoreMovieClip).getChildByName("bg") as MovieClip).y;
               (this.item as CoreMovieClip).addChild(this.reportBtn);
               this.reportBtn.addEventListener(MouseEvent.CLICK,this.repportButtonClicked);
            }
            this.profileBtn = new ProfileButton();
            this.profileBtn.name = "profileBtn";
            this.profileBtn.visible = false;
            if(param5)
            {
               this.profileBtn.x = this.reportBtn.x - 32;
               this.profileBtn.y = this.reportBtn.y;
            }
            else
            {
               this.profileBtn.x = (this.item as CoreMovieClip).x + (this.item as CoreMovieClip).width - 20;
               this.profileBtn.y = ((this.item as CoreMovieClip).getChildByName("bg") as MovieClip).y;
            }
            (this.item as CoreMovieClip).addChild(this.profileBtn);
            this.profileBtn.addEventListener(MouseEvent.CLICK,this.openProfile);
         }
         this.updateSort();
      }
      
      public function removeAll() : void
      {
         this.chatHolder.removeChildren();
      }
      
      protected function updateSort() : void
      {
         var _loc3_:IHistorySpeechBubble = null;
         this.len = this.chatHolder.numChildren;
         if(!this.len)
         {
            return;
         }
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.len)
         {
            this.firstItem = this.chatHolder.getChildAt(_loc2_) as CoreMovieClip;
            _loc3_ = this.firstItem as IHistorySpeechBubble;
            if(this.searchManager)
            {
               if(_loc3_.avatarId == this.searchManager.getText() || _loc3_.message.toLowerCase().indexOf(this.searchManager.getText().toLowerCase()) != -1 || _loc3_.avatarName.toLowerCase().indexOf(this.searchManager.getText().toLowerCase()) != -1 || this.searchManager.getText() == $("Search") || this.searchManager.getText() == "")
               {
                  this.firstItem.visible = true;
                  this.firstItem.y = _loc1_;
                  _loc1_ += this.firstItem.getChildByName("bg").height + 2;
               }
               else
               {
                  this.firstItem.y = 0;
                  this.firstItem.visible = false;
               }
            }
            else if(_loc3_.avatarId == this.searchTextField.text || _loc3_.message.toLowerCase().indexOf(this.searchTextField.text.toLowerCase()) != -1 || _loc3_.avatarName.toLowerCase().indexOf(this.searchTextField.text.toLowerCase()) != -1 || this.searchTextField.text == $("Search") || this.searchTextField.text == "")
            {
               this.firstItem.visible = true;
               this.firstItem.y = _loc1_;
               _loc1_ += this.firstItem.getChildByName("bg").height + 2;
            }
            else
            {
               this.firstItem.y = 0;
               this.firstItem.visible = false;
            }
            _loc2_++;
         }
         this.scrollBar.containerH = this.chatHolder.height;
      }
      
      protected function openProfile(param1:MouseEvent) : void
      {
         var _loc2_:ProfileEvent = null;
         if(this.avatarId != null)
         {
            param1.stopPropagation();
            _loc2_ = new ProfileEvent(ProfileEvent.SHOW_PROFILE);
            _loc2_.avatarID = this.avatarId;
            Dispatcher.dispatchEvent(_loc2_);
         }
      }
      
      protected function repportButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:PanelVO = null;
         if(this.reportMessage != null && this.avatarId != null && !Sanalika.instance.avatarModel.guest)
         {
            param1.stopPropagation();
            _loc2_ = new PanelVO();
            _loc2_.name = "ReportPanel";
            _loc2_.type = PanelType.HUD;
            _loc2_.params = {};
            _loc2_.params.avatarId = this.avatarId;
            _loc2_.params.lastMessage = this.reportMessage;
            Connectr.instance.panelModel.openPanel(_loc2_);
         }
      }
      
      protected function outMessage(param1:MouseEvent) : void
      {
         this.item = param1.currentTarget as IHistorySpeechBubble;
         if((this.item as CoreMovieClip).getChildByName("reportBtn"))
         {
            (this.item as CoreMovieClip).getChildByName("reportBtn").visible = false;
         }
         if((this.item as CoreMovieClip).getChildByName("profileBtn"))
         {
            (this.item as CoreMovieClip).getChildByName("profileBtn").visible = false;
         }
      }
      
      protected function overMessage(param1:MouseEvent) : void
      {
         var _loc2_:ISceneCharacterComponent = null;
         this.item = param1.currentTarget as IHistorySpeechBubble;
         this.reportMessage = this.item.message;
         this.avatarId = this.item.avatarId;
         if((this.item as CoreMovieClip).getChildByName("profileBtn") != null && Sanalika.instance.engine.scene != null && Sanalika.instance.engine.scene.existsComponent(ISceneCharacterComponent))
         {
            _loc2_ = Sanalika.instance.engine.scene.getComponent(ISceneCharacterComponent) as ISceneCharacterComponent;
            (this.item as CoreMovieClip).getChildByName("profileBtn").visible = _loc2_.existsWithAvatarId(this.avatarId);
         }
         if((this.item as CoreMovieClip).getChildByName("reportBtn"))
         {
            (this.item as CoreMovieClip).getChildByName("reportBtn").visible = true;
         }
      }
      
      protected function focusOutSearch(param1:FocusEvent) : void
      {
         if(this.searchManager)
         {
            if(this.searchManager.getText() == "")
            {
               this.searchManager.addText(this.searchText);
            }
            this.searchManager.draw();
         }
         else if(this.searchTextField.text == "")
         {
            this.searchTextField.text = this.searchText;
         }
      }
      
      protected function focusInSearch(param1:FocusEvent) : void
      {
         if(this.searchManager)
         {
            this.searchManager.changeFormat(this.searchTextField.defaultTextFormat);
            if(this.searchManager.getText() == this.searchText)
            {
               this.searchManager.clearText();
            }
         }
         else if(this.searchTextField.text == this.searchText)
         {
            this.searchTextField.text = "";
         }
      }
      
      protected function focusOut(param1:FocusEvent) : void
      {
         this.messageTextField.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyPressed);
         this.messageTextField.removeEventListener(TextEvent.TEXT_INPUT,this.inpTextInput);
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
      
      protected function focusIn(param1:FocusEvent) : void
      {
         this.messageTextField.addEventListener(TextEvent.TEXT_INPUT,this.inpTextInput);
         this.messageTextField.addEventListener(KeyboardEvent.KEY_DOWN,this.keyPressed);
         if(this.inputManager)
         {
            this.inputManager.changeFormat(this.messageTextField.defaultTextFormat);
         }
         this.messageTextField.text = "";
      }
      
      protected function keyPressed(param1:KeyboardEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:AlertVo = null;
         var _loc4_:HudEvent = null;
         if(param1.keyCode == Keyboard.ENTER)
         {
            _loc2_ = this.inputManager != null ? this.inputManager.getText() : this.messageTextField.text;
            if(this.mode == ChatMode.GLOBAL)
            {
               if(this.nextMessage > SyncTimer.timestamp)
               {
                  return;
               }
               if(!Sanalika.instance.avatarModel.permission.check(AvatarPermission.VIP))
               {
                  _loc3_ = new AlertVo();
                  _loc3_.alertType = AlertType.TOOLTIP;
                  _loc3_.description = ServiceErrorCode.getRoleErrors([AvatarPermission.VIP]);
                  Dispatcher.dispatchEvent(new AlertEvent(_loc3_));
                  return;
               }
               Connectr.instance.serviceModel.requestData("chat.message",{"message":_loc2_},this.chatMessageResponse,Connectr.instance.serviceModel.sfs.getRoomByName(GLOBAL_ROOM));
            }
            else
            {
               (_loc4_ = new HudEvent(HudEvent.SEND_MESSAGE)).chatMessage = _loc2_;
               Dispatcher.dispatchEvent(_loc4_);
            }
            this.messageTextField.text = "";
            if(this.inputManager != null)
            {
               this.inputManager.clearText();
            }
            this.chatDisable = true;
         }
      }
      
      private function onChatMessage(param1:Object) : void
      {
         if(this.mode == ChatMode.LOCAL || param1.nextRequest != null)
         {
            return;
         }
         this.add(param1.avatarID,param1.avatarName,param1.message,param1.frameNo,true);
      }
      
      private function onChatSync(param1:Object) : void
      {
         var _loc3_:Object = null;
         if(this.mode == ChatMode.LOCAL)
         {
            return;
         }
         this.removeAll();
         var _loc2_:Array = param1.messages;
         for each(_loc3_ in _loc2_)
         {
            this.add(_loc3_.avatarID,_loc3_.avatarName,_loc3_.message,_loc3_.frameNo,true);
         }
      }
      
      private function inpTextInput(param1:TextEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(!this.isAvailableText() || !this.isTypedAvaliable(param1) || param1.text == ">" || param1.text == "<")
         {
            param1.preventDefault();
            return;
         }
         this.newText = null;
         this.txtlen = param1.text.length;
         if(this.newText != null)
         {
            _loc2_ = int(param1.target.caretIndex);
            _loc3_ = String(param1.target.text);
            _loc4_ = _loc3_.substr(0,_loc2_) + this.newText + _loc3_.substr(_loc2_,_loc3_.length - _loc2_);
            param1.target.text = _loc4_;
            param1.target.setSelection(_loc2_ + 1,_loc2_ + 1);
         }
      }
      
      private function chatMessageResponse(param1:Object) : void
      {
         this.nextMessage = param1.nextMessage;
      }
      
      private function isAvailableText() : Boolean
      {
         var _loc3_:String = null;
         var _loc1_:String = this.messageTextField.text;
         var _loc2_:int = _loc1_.length;
         var _loc4_:int = 1;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            if(_loc3_ != _loc1_.charAt(_loc5_))
            {
               _loc4_ = 1;
               _loc3_ = _loc1_.charAt(_loc5_);
            }
            else
            {
               _loc4_++;
            }
            if(_loc4_ == 8)
            {
               return false;
            }
            _loc5_++;
         }
         return true;
      }
      
      protected function isTypedAvaliable(param1:TextEvent) : Boolean
      {
         if(param1.text.length > 1)
         {
            param1.preventDefault();
            return false;
         }
         return true;
      }
      
      public function clearHistory() : void
      {
         while(this.chatHolder.numChildren > 0)
         {
            this.chatHolder.removeChildAt(0);
         }
         this.scrollBar.containerH = this.chatHolder.height;
      }
      
      private function onRoomJoin(param1:SFSEvent) : void
      {
         var _loc2_:Room = param1.params.room;
         if(_loc2_.name == GLOBAL_ROOM)
         {
            this.mode = ChatMode.GLOBAL;
         }
      }
      
      private function onExitRoom(param1:SFSEvent) : void
      {
         var _loc2_:Room = param1.params.room;
         var _loc3_:User = param1.params.user;
         if(_loc2_.name == GLOBAL_ROOM && Boolean(_loc3_.isItMe))
         {
            this.mode = ChatMode.LOCAL;
         }
      }
      
      override public function dispose() : void
      {
         this.messageTextField.removeEventListener(FocusEvent.FOCUS_IN,this.focusIn);
         this.messageTextField.removeEventListener(FocusEvent.FOCUS_OUT,this.focusOut);
         this.searchTextField.removeEventListener(FocusEvent.FOCUS_IN,this.focusInSearch);
         this.searchTextField.removeEventListener(FocusEvent.FOCUS_OUT,this.focusOutSearch);
         Dispatcher.removeEventListener(ChatHistoryEvent.ADD,this.addNewHistoryMessage);
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.closeClicked);
         this.chatHolder.removed();
         removeChild(this.chatHolder);
         removeChild(this.scrollBar);
         this.chatHolder = null;
         this.scrollBar = null;
         this.btnGlobal.removeEventListener(MouseEvent.CLICK,this.onGlobalClicked);
         Connectr.instance.toolTipModel.removeTip(this.btnGlobal);
         Connectr.instance.serviceModel.removeExtension("chat.message",this.onChatMessage);
         Connectr.instance.serviceModel.removeExtension("chat.sync",this.onChatSync);
         Connectr.instance.serviceModel.sfs.removeEventListener(SFSEvent.ROOM_JOIN,this.onRoomJoin);
         Connectr.instance.serviceModel.sfs.removeEventListener(SFSEvent.USER_EXIT_ROOM,this.onExitRoom);
         setTimeout(function():*
         {
            Connectr.instance.serviceModel.requestData("globalchat.leave",{},null);
         },ServiceRequestRate.leftTime("globalchat.leave"));
         if(this.inputManager)
         {
            this.inputManager.dispose();
         }
         if(this.searchManager)
         {
            this.searchManager.dispose();
         }
         super.dispose();
      }
   }
}

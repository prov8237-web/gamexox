package org.oyunstudyosu.sanalika.panels.profile
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.auth.IPermission;
   import com.oyunstudyosu.auth.Permission;
   import com.oyunstudyosu.buddy.BuddyResponseTypes;
   import com.oyunstudyosu.cloth.ICharPreview;
   import com.oyunstudyosu.combobox.ComboBoxVo;
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.engine.ICharacter;
   import com.oyunstudyosu.enums.AvatarPermission;
   import com.oyunstudyosu.enums.CharacterVariable;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.BuddyEvent;
   import com.oyunstudyosu.events.ComboBoxEvent;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.ProfileEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.local.arabic.ArabicInputManager;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.panel.PanelType;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.service.ServiceErrorCode;
   import com.oyunstudyosu.tooltip.TooltipAlign;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import com.printfas3.printf;
   import com.smartfoxserver.v2.entities.User;
   import flash.display.DisplayObject;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.Font;
   import flash.text.TextField;
   import org.oyunstudyosu.components.combobox.CoreComboBox;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.profile.ProfilePanel")]
   public class ProfilePanel extends Panel
   {
       
      
      public var editStatusMessageTxt:TextField;
      
      public var moodTxt:TextField;
      
      public var nameTxt:TextField;
      
      public var statusMessageTxt:TextField;
      
      public var txtFlatCount:TextField;
      
      public var txtTeamInfo:TextField;
      
      private var avatarID:String;
      
      private var playerID:String;
      
      private var skinClip:String;
      
      private var charPreview:ICharPreview;
      
      public var btnClose:CloseButton;
      
      public var charHolder:MovieClip;
      
      public var buddystatics:BuddyStatics;
      
      private var state:int;
      
      private var cmnt:String;
      
      private var avatarName:String;
      
      private var avatarAge:String;
      
      private var menu:ProfileMenu;
      
      public var background:MovieClip;
      
      private var sName:STextField;
      
      private var sMood:STextField;
      
      private var sStatus:STextField;
      
      private var profileBadgeContainer:ProfileBadgeContainer;
      
      private var profileStickerContainer:ProfileStickerContainer;
      
      public var profileSkin:ProfileSkin;
      
      private var profileSkinContainer:ProfileSkinContainer;
      
      private var comboBox:CoreComboBox;
      
      private var user:User;
      
      public var editButton:SimpleButton;
      
      public var btnFlat:SimpleButton;
      
      public var saveButton:SimpleButton;
      
      private var editStatusMessageTextField:TextField;
      
      private var inputManager:ArabicInputManager;
      
      public var mcBan:MovieClip;
      
      public var mcLike:MovieClip;
      
      public var mcDislike:MovieClip;
      
      public var sanalikaX:MovieClip;
      
      public var infoTxt:TextField;
      
      private var flatData:Object;
      
      public var stxtFlatCount:STextField;
      
      public var stxtTeamInfo:STextField;
      
      public var txtShareLink:TextField;
      
      public var txtAvatarID:TextField;
      
      public var txtPlayerID:TextField;
      
      public var dragger:MovieClip;
      
      public var mcMask:MovieClip;
      
      public var btnImproper:SimpleButton;
      
      public var btnImproperStatus:SimpleButton;
      
      public var btnImproperCity:SimpleButton;
      
      public var emailIcon:MovieClip;
      
      public var p1:MovieClip;
      
      public var p2:MovieClip;
      
      public var p3:MovieClip;
      
      public var p4:MovieClip;
      
      public var p5:MovieClip;
      
      public var p6:MovieClip;
      
      public var p7:MovieClip;
      
      public var p8:MovieClip;
      
      public var p9:MovieClip;
      
      public var btnProfileSkin:SimpleButton;
      
      public var btnSaveProfileSkin:SimpleButton;
      
      public function ProfilePanel()
      {
         super();
      }
      
      public static function hasEmbeddedAllGlyphs(param1:String, param2:String) : Boolean
      {
         var _loc3_:String = param1.split("\n").join();
         var _loc4_:Array = Font.enumerateFonts();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc4_[_loc5_].fontName == param2)
            {
               return _loc4_[_loc5_].hasGlyphs(_loc3_);
            }
            _loc5_++;
         }
         return false;
      }
      
      override public function init() : void
      {
         super.init();
         this.reset();
         this.avatarID = data.params.avatarId;
         this.p1.mouseEnabled = false;
         this.p2.mouseEnabled = false;
         this.p3.mouseEnabled = false;
         this.charHolder.mouseEnabled = false;
         Connectr.instance.serviceModel.requestData(RequestDataKey.PROFILE,{"avatarID":this.avatarID},this.profileResponse);
      }
      
      private function onShareLink(param1:MouseEvent) : void
      {
         System.setClipboard(this.txtShareLink.text);
         var _loc2_:AlertVo = new AlertVo();
         _loc2_.alertType = AlertType.TOOLTIP;
         _loc2_.description = $("ShareAndWin Url Copied");
         Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
      }
      
      private function onBuddyAdded(param1:Object) : void
      {
         if(param1.avatarID == null)
         {
            return;
         }
         trace("onAcceptRequest");
         if(param1.avatarID == this.avatarID)
         {
            this.menu.isBuddy = true;
            this.menu.isRequest = false;
            this.menu.setProfileVars();
         }
      }
      
      private function onBuddyRemoved(param1:Object) : void
      {
         trace("onRemoveBuddy");
         if(param1.avatarID == this.avatarID)
         {
            this.menu.isBuddy = false;
            this.menu.isRequest = false;
            this.menu.setProfileVars();
         }
      }
      
      private function initMoods() : void
      {
         var _loc2_:ComboBoxVo = null;
         var _loc1_:Vector.<ComboBoxVo> = new Vector.<ComboBoxVo>();
         var _loc3_:int = int(Connectr.instance.buddyModel.moods.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new ComboBoxVo();
            _loc2_.label = $(Connectr.instance.buddyModel.moods[_loc4_].label);
            _loc2_.index = Connectr.instance.buddyModel.moods[_loc4_].id;
            _loc1_.push(_loc2_);
            _loc4_++;
         }
         this.comboBox = new CoreComboBox();
         this.comboBox.x = 90;
         this.comboBox.y = 48;
         this.comboBox.dataProvider = _loc1_;
         this.comboBox.rowCount = 5;
         addChild(this.comboBox);
         this.comboBox.addEventListener(ComboBoxEvent.ITEM_SELECTED,this.changeMood);
         if(Boolean(this.user) && Boolean(this.user.getVariable(CharacterVariable.MOOD)))
         {
            this.comboBox.selectedIndex = this.user.getVariable(CharacterVariable.MOOD).getIntValue();
         }
         else
         {
            this.comboBox.selectedIndex = 0;
         }
      }
      
      private function onProfileSkin(param1:MouseEvent) : void
      {
         this.profileSkinContainer.move();
      }
      
      private function onSaveProfileSkin(param1:MouseEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:AlertVo = null;
         var _loc2_:IPermission = Sanalika.instance.avatarModel.permission;
         if(this.profileSkin.roles != null)
         {
            _loc3_ = new Permission(this.profileSkin.roles).grantedIndexes();
            if(!_loc2_.checkAny(_loc3_))
            {
               (_loc4_ = new AlertVo()).alertType = AlertType.TOOLTIP;
               _loc4_.description = ServiceErrorCode.getRoleErrors(_loc3_);
               Dispatcher.dispatchEvent(new AlertEvent(_loc4_));
               return;
            }
         }
         Connectr.instance.serviceModel.requestData(RequestDataKey.USE_PROFILE_SKIN_WITH_CLIP,{"clip":(this.profileSkin.clip == null ? "0" : this.profileSkin.clip)},null);
         this.skinClip = this.profileSkin.clip;
         this.btnSaveProfileSkin.visible = false;
      }
      
      private function editClicked(param1:MouseEvent) : void
      {
         this.editButton.visible = false;
         this.saveButton.visible = true;
         if(this.inputManager)
         {
            this.inputManager.clearText();
            this.inputManager.draw();
         }
         else
         {
            this.editStatusMessageTextField.text = this.sStatus.text;
         }
         this.sStatus.visible = false;
         this.editStatusMessageTextField.visible = true;
      }
      
      private function flatClicked(param1:MouseEvent) : void
      {
         var _loc2_:PanelVO = new PanelVO();
         _loc2_.name = "ProfileFlatPanel";
         _loc2_.params = {};
         _loc2_.params.list = this.flatData;
         _loc2_.type = PanelType.HUD;
         Connectr.instance.panelModel.openPanel(_loc2_);
      }
      
      private function saveClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         this.saveButton.visible = false;
         this.editButton.visible = true;
         if(this.inputManager)
         {
            _loc4_ = this.inputManager.getText();
         }
         else
         {
            _loc4_ = this.editStatusMessageTextField.text;
         }
         this.sStatus.visible = true;
         this.sStatus.mouseEnabled = false;
         this.editStatusMessageTextField.visible = false;
         var _loc5_:BuddyEvent = new BuddyEvent(BuddyEvent.CHANGE_STATUS_MESSAGE);
         _loc4_ = _loc4_.substr(0,_loc4_.length);
         this.sStatus.text = _loc4_;
         _loc5_.message = _loc4_;
         Dispatcher.dispatchEvent(_loc5_);
         this.editStatusMessageTextField.text = "";
         this.sStatus.height = 125;
      }
      
      private function selectText(param1:MouseEvent) : void
      {
         this.editStatusMessageTextField.setSelection(0,this.editStatusMessageTextField.text.length);
      }
      
      protected function changeMood(param1:ComboBoxEvent) : void
      {
         var _loc2_:BuddyEvent = new BuddyEvent(BuddyEvent.CHANGE_MOOD);
         this.sMood.text = $(Connectr.instance.buddyModel.moods[this.state].label);
         _loc2_.message = $(Connectr.instance.buddyModel.moods[this.state].label);
         _loc2_.moodID = this.comboBox.selectedIndex;
         Dispatcher.dispatchEvent(_loc2_);
      }
      
      private function btnImproperClicked(param1:MouseEvent) : void
      {
         this.btnImproper.visible = false;
         Connectr.instance.serviceModel.requestData(RequestDataKey.PROFILE_IMPROPER,{
            "avatarID":this.avatarID,
            "action":"nick"
         },this.onImproperResponse);
      }
      
      private function btnImproperStatusClicked(param1:MouseEvent) : void
      {
         this.btnImproperStatus.visible = false;
         Connectr.instance.serviceModel.requestData(RequestDataKey.PROFILE_IMPROPER,{
            "avatarID":this.avatarID,
            "action":"status"
         },this.onImproperStatusResponse);
      }
      
      private function btnImproperCityClicked(param1:MouseEvent) : void
      {
         this.btnImproperCity.visible = false;
         Connectr.instance.serviceModel.requestData(RequestDataKey.PROFILE_IMPROPER,{
            "avatarID":this.avatarID,
            "action":"city"
         },this.onImproperCityResponse);
      }
      
      private function onImproperResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.PROFILE_IMPROPER,this.onImproperResponse);
         this.sName.text = this.avatarID + "!!";
      }
      
      private function onImproperStatusResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.PROFILE_IMPROPER,this.onImproperStatusResponse);
         this.sStatus.text = $("improperContent");
      }
      
      private function onImproperCityResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.PROFILE_IMPROPER,this.onImproperCityResponse);
         this.infoTxt.text = $("improperCity");
         if(this.avatarAge != "")
         {
            this.infoTxt.appendText(" / " + this.avatarAge);
         }
      }
      
      private function onLike(param1:MouseEvent) : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.PROFILE_LIKE,{
            "avatarID":this.avatarID,
            "avatarLike":1
         },this.profileLikeResponse);
      }
      
      private function onDislike(param1:MouseEvent) : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.PROFILE_LIKE,{
            "avatarID":this.avatarID,
            "avatarLike":0
         },this.profileLikeResponse);
      }
      
      private function processLike(param1:Object) : void
      {
         if(param1.likeCount > 0)
         {
            this.mcLike.txt.text = param1.likeCount;
         }
         else
         {
            this.mcLike.txt.text = "-";
         }
         if(param1.dislikeCount > 0)
         {
            this.mcDislike.txt.text = param1.dislikeCount;
         }
         else
         {
            this.mcDislike.txt.text = "-";
         }
      }
      
      private function profileLikeResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.PROFILE_LIKE,this.profileLikeResponse);
         trace(JSON.stringify(param1));
         if(param1.errorCode)
         {
            return;
         }
         this.processLike(param1);
      }
      
      private function profileResponse(param1:Object) : void
      {
         var imgRegExp:RegExp;
         var imgTags:Array;
         var char:ICharacter;
         var profileStickerCardCount:int;
         var profileStickerContainerX:int;
         var hasSanalikaX:Boolean;
         var profileBadgeContainerY:int;
         var data:Object = param1;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.PROFILE,this.profileResponse);
         if(data.errorCode)
         {
            close();
            return;
         }
         dragHandler = this.dragger;
         this.sanalikaX.visible = false;
         if(this.sName == null)
         {
            this.sName = TextFieldManager.convertAsArabicTextField(this.getChildByName("nameTxt") as TextField,false,false);
            this.sMood = TextFieldManager.convertAsArabicTextField(this.getChildByName("moodTxt") as TextField,false,false);
            this.sStatus = TextFieldManager.convertAsArabicTextField(this.getChildByName("statusMessageTxt") as TextField,false,false);
            this.stxtFlatCount = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtFlatCount") as TextField,false,false);
            this.stxtTeamInfo = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtTeamInfo") as TextField,false,false);
            this.editStatusMessageTextField = TextFieldManager.createNoneLanguageTextfield(this.getChildByName("editStatusMessageTxt") as TextField);
         }
         TweenMax.to(this.background,0,{"colorTransform":{
            "tint":0,
            "tintAmount":0
         }});
         TweenMax.to(this.sName,0,{"colorTransform":{
            "tint":16777215,
            "tintAmount":0
         }});
         TweenMax.to(this.sMood,0,{"colorTransform":{
            "tint":16777215,
            "tintAmount":0
         }});
         TweenMax.to(this.infoTxt,0,{"colorTransform":{
            "tint":16777215,
            "tintAmount":0
         }});
         TweenMax.to(this.sStatus,0,{"colorTransform":{
            "tint":16777215,
            "tintAmount":0
         }});
         TweenMax.to(this.buddystatics,0,{"colorTransform":{
            "tint":16777215,
            "tintAmount":0
         }});
         this.txtShareLink.text = Connectr.instance.gameModel.webServer + "/landing/" + this.avatarID;
         this.txtAvatarID.text = this.avatarID;
         this.txtPlayerID.text = "";
         Connectr.instance.toolTipModel.addTip(this.txtShareLink,$("ShareAndWin"));
         this.txtShareLink.addEventListener(MouseEvent.CLICK,this.onShareLink);
         this.sStatus.wordWrap = true;
         Dispatcher.addEventListener(ProfileEvent.SHOW_PROFILE,this.updateProfile);
         Connectr.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_ADDED,this.onBuddyAdded);
         Connectr.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_REMOVED,this.onBuddyRemoved);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onCloseClick);
         this.buddystatics.visible = false;
         Connectr.instance.toolTipModel.addTip(this.buddystatics,$("BuddyIndex"));
         this.sMood.visible = false;
         this.editButton.visible = false;
         this.saveButton.visible = false;
         this.editStatusMessageTextField.visible = false;
         this.editButton.addEventListener(MouseEvent.CLICK,this.editClicked);
         this.saveButton.addEventListener(MouseEvent.CLICK,this.saveClicked);
         if(Connectr.instance.gameModel.language == "ar")
         {
            this.editStatusMessageTextField.maxChars = 150;
            this.inputManager = new ArabicInputManager(this.editStatusMessageTextField,this.editStatusMessageTextField.defaultTextFormat);
         }
         this.buddystatics.visible = true;
         if(data.mood)
         {
            this.state = data.mood;
         }
         else
         {
            this.state = 0;
         }
         this.user = Sanalika.instance.serviceModel.sfs.userManager.getUserByName(this.avatarID);
         trace(this.user.playerId);
         if(this.user != null && this.user.containsVariable(CharacterVariable.PLAYER_ID))
         {
            this.playerID = this.user.getVariable(CharacterVariable.PLAYER_ID).getIntValue() + "";
         }
         this.txtPlayerID.text = this.playerID;
         if(this.avatarID == Connectr.instance.engine.scene.myChar.id)
         {
            this.initMoods();
            this.editButton.visible = true;
            this.sMood.visible = false;
            this.sMood.text = "";
            this.sStatus.text = "";
            this.mcLike.buttonMode = false;
            this.mcDislike.buttonMode = false;
         }
         else
         {
            this.mcLike.addEventListener(MouseEvent.CLICK,this.onLike);
            this.mcLike.buttonMode = true;
            this.mcDislike.addEventListener(MouseEvent.CLICK,this.onDislike);
            this.mcDislike.buttonMode = true;
            this.sMood.visible = true;
            this.sMood.text = $(Connectr.instance.buddyModel.moods[this.state].label);
         }
         this.processLike(data);
         if(data.banCount > 1)
         {
            this.mcBan.txt.text = data.banCount - 1;
            this.mcBan.visible = true;
            this.sStatus.text = $("profileStatus");
         }
         else
         {
            this.mcBan.visible = false;
         }
         if(data.emailRegistered == 1)
         {
            this.emailIcon.visible = true;
            Connectr.instance.toolTipModel.addTip(this.emailIcon,$("Email Valid"));
         }
         else
         {
            this.emailIcon.visible = false;
         }
         this.infoTxt.text = "";
         if(data.avatarCity)
         {
            this.infoTxt.text = data.avatarCity;
         }
         if(data.avatarAge)
         {
            this.avatarAge = data.avatarAge;
            this.infoTxt.appendText(" / " + this.avatarAge);
         }
         this.infoTxt.mouseEnabled = false;
         this.avatarName = data.avatarName;
         if(this.avatarName.length > 15)
         {
            this.avatarName = this.avatarName.substr(0,12) + "...";
         }
         if(data.status)
         {
            this.cmnt = data.status;
         }
         else
         {
            this.cmnt = "";
         }
         this.buddystatics.totalBuddy = data.totalBuddies;
         this.buddystatics.buddyRating = data.avarageRating;
         imgRegExp = /<img[^>]+>/g;
         imgTags = this.cmnt.match(imgRegExp);
         if(data.banCount > 1)
         {
            this.sStatus.text = $("profileStatus");
         }
         else if(imgTags.length > 0)
         {
            this.sStatus.text = "";
         }
         else if(this.cmnt == "improperContent")
         {
            this.sStatus.text = $("improperContent");
         }
         else
         {
            this.sStatus.text = this.cmnt;
         }
         if(!hasEmbeddedAllGlyphs(this.avatarName,"Co Text Bold"))
         {
            this.avatarName += "????";
         }
         this.sName.text = this.avatarName;
         this.sName.mouseEnabled = false;
         this.txtAvatarID.addEventListener(MouseEvent.CLICK,this.copyAvatarID);
         this.txtPlayerID.addEventListener(MouseEvent.CLICK,this.copyPlayerID);
         char = Connectr.instance.engine.scene.getAvatarById(this.avatarID);
         if(char == null)
         {
            trace("PROFILE_PANEL: avatar not in scene, skipping character preview");
         }
         else
         {
            if(this.charPreview)
            {
               this.charPreview.terminate();
            }
            this.charPreview = Connectr.instance.clothModel.getNewCharPreview(this.charHolder,char,true);
            this.charPreview.rotate(5);
            if(!char.isMe)
            {
               this.menu = new ProfileMenu(this.avatarID,data.isBuddy,data.isRequest,data.banCount);
               this.addChildAt(this.menu,0);
               this.menu.x = 0;
            }
         }
         this.profileStickerContainer = new ProfileStickerContainer();
         this.profileStickerContainer.init(data.cards,data.stickers);
         this.addChildAt(this.profileStickerContainer,0);
         profileStickerCardCount = data.stickers.length + data.cards.length;
         profileStickerContainerX = 92;
         if(profileStickerCardCount > 6)
         {
            profileStickerContainerX += int((profileStickerCardCount - 1) / 6) * 44;
         }
         this.btnSaveProfileSkin.visible = false;
         if(this.profileSkinContainer != null)
         {
            this.profileSkinContainer.dispose();
         }
         if(char != null && char.isMe)
         {
            if(this.profileSkinContainer == null)
            {
               this.profileSkinContainer = new ProfileSkinContainer();
               this.profileSkinContainer.init();
               this.addChildAt(this.profileSkinContainer,0);
            }
            else
            {
               this.profileSkinContainer.dispose();
            }
            this.btnProfileSkin.visible = true;
            this.btnProfileSkin.addEventListener(MouseEvent.CLICK,this.onProfileSkin);
            Connectr.instance.toolTipModel.addTip(this.btnProfileSkin,$("Profile Skin"));
            this.btnSaveProfileSkin.addEventListener(MouseEvent.CLICK,this.onSaveProfileSkin);
         }
         if(Boolean(data.skin) && Boolean(data.skin.clip))
         {
            this.skinClip = data.skin.clip;
         }
         else
         {
            this.skinClip = null;
         }
         if(this.profileSkin == null)
         {
            this.profileSkin = new ProfileSkin();
            this.profileSkin.mask = this.mcMask;
            this.profileSkin.init(data.skin);
            addChildAt(this.profileSkin,this.getChildIndex(this.background) + 1);
         }
         else
         {
            this.profileSkin.dispose();
            this.profileSkin.init(data.skin);
         }
         hasSanalikaX = data.cards.filter(function(param1:Object, param2:int, param3:Array):Boolean
         {
            return param1.clip == "CARD_SANALIKAX";
         }).length > 0;
         this.sanalikaX.visible = hasSanalikaX;
         this.profileBadgeContainer = new ProfileBadgeContainer();
         this.profileBadgeContainer.init(data.badges);
         this.addChildAt(this.profileBadgeContainer,0);
         profileBadgeContainerY = this.background.height + 52;
         if(data.badges.length > 5)
         {
            profileBadgeContainerY += int((data.badges.length - 1) / 5) * 44;
         }
         if(data.runWinTeam)
         {
            this.stxtTeamInfo.text = data.runWinTeam;
         }
         else
         {
            this.stxtTeamInfo.text = $("TeamNA");
         }
         if(data.flats.length > 0)
         {
            this.flatData = data.flats;
            this.stxtFlatCount.text = printf($("Has %s place(s)"),data.flats.length);
            this.btnFlat.addEventListener(MouseEvent.CLICK,this.flatClicked);
         }
         else
         {
            this.stxtFlatCount.text = $("Has no place");
         }
         if(this.menu)
         {
            TweenMax.to(this.menu,0.5,{
               "delay":0.2,
               "x":-55,
               "ease":Back.easeOut
            });
         }
         if(this.profileBadgeContainer)
         {
            TweenMax.to(this.profileBadgeContainer,0.5,{
               "delay":0.8,
               "y":profileBadgeContainerY,
               "ease":Back.easeOut
            });
         }
         if(this.profileStickerContainer)
         {
            TweenMax.to(this.profileStickerContainer,0.5,{
               "delay":0.4,
               "x":profileStickerContainerX,
               "ease":Back.easeOut
            });
         }
         this.btnImproper.visible = false;
         this.btnImproperStatus.visible = false;
         this.btnImproperCity.visible = false;
         if(Boolean(Connectr.instance.avatarModel.permission.check(AvatarPermission.SECURITY)) && (char == null || !char.isMe))
         {
            Connectr.instance.toolTipModel.addTip(this.btnImproper,$("improperName"),TooltipAlign.ALIGN_RIGHT);
            Connectr.instance.toolTipModel.addTip(this.btnImproperStatus,$("improperStatus"),TooltipAlign.ALIGN_RIGHT);
            this.btnImproper.addEventListener(MouseEvent.CLICK,this.btnImproperClicked);
            this.btnImproper.visible = true;
            this.btnImproperStatus.addEventListener(MouseEvent.CLICK,this.btnImproperStatusClicked);
            this.btnImproperStatus.visible = true;
            if(data.avatarCity != "" && data.avatarCity != "improperCity")
            {
               this.btnImproperCity.addEventListener(MouseEvent.CLICK,this.btnImproperCityClicked);
               this.btnImproperCity.visible = true;
               Connectr.instance.toolTipModel.addTip(this.btnImproperCity,$("improperCity"),TooltipAlign.ALIGN_RIGHT);
            }
         }
         this.applyDefaultSkinStyle();
         show();
      }
      
      public function applyDefaultSkinStyle() : void
      {
         this.applySkinStyle({
            "bgColor":"FEFFF2",
            "alpha":"1",
            "cn":"ProfileSkinProperty",
            "textColor":"000000"
         });
         this.stxtFlatCount.textColor = 4944517;
         this.stxtTeamInfo.textColor = 16229376;
         this.txtShareLink.textColor = 26112;
         this.mcLike.txt.textColor = 1668818;
         this.mcDislike.txt.textColor = 13840175;
         this.txtAvatarID.textColor = 6710886;
         this.txtPlayerID.textColor = 6710886;
         this.p2.alpha = 0;
         this.p3.alpha = 0;
         this.p4.alpha = 0;
         this.btnSaveVisible();
      }
      
      public function applySkinStyle(param1:Object, param2:Boolean = false) : void
      {
         var _loc5_:TextField = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc10_:Array = null;
         var _loc3_:int = int(parseInt("0x" + param1.textColor));
         var _loc4_:Array = [this.sName,this.sMood,this.infoTxt,this.sStatus,this.stxtFlatCount,this.stxtTeamInfo,this.txtShareLink,this.mcLike.txt,this.mcDislike.txt,this.buddystatics.buddyCountTextField];
         for each(_loc5_ in _loc4_)
         {
            _loc5_.textColor = _loc3_;
         }
         _loc6_ = int(parseInt("0x" + param1.bgColor));
         _loc7_ = [this.p1,this.p2,this.p3,this.p4,this.p5,this.p6,this.p7,this.p8,this.p9];
         for each(_loc8_ in _loc7_)
         {
            TweenMax.killTweensOf(_loc8_);
            TweenMax.to(_loc8_,0,{"colorTransform":{
               "tint":_loc6_,
               "tintAmount":1
            }});
         }
         _loc9_ = Number(parseFloat(param1.alpha));
         _loc10_ = [this.p1,this.p2,this.p3,this.p4,this.p5,this.p6,this.p7,this.p8,this.p9];
         for each(_loc8_ in _loc10_)
         {
            _loc8_.alpha = _loc9_;
         }
         if(param2 == false)
         {
            _loc3_ = 16711666;
         }
         else
         {
            this.txtAvatarID.textColor = _loc3_;
            this.txtPlayerID.textColor = _loc3_;
         }
         if(this.profileStickerContainer != null)
         {
            TweenMax.to(this.profileStickerContainer.bg,0,{"colorTransform":{
               "tint":_loc6_,
               "tintAmount":1
            }});
         }
         if(this.profileBadgeContainer != null)
         {
            TweenMax.to(this.profileBadgeContainer.bg,0,{"colorTransform":{
               "tint":_loc6_,
               "tintAmount":1
            }});
         }
         if(this.profileSkinContainer != null)
         {
            TweenMax.to(this.profileSkinContainer.bg,0,{"colorTransform":{
               "tint":_loc6_,
               "tintAmount":1
            }});
         }
         if(this.menu != null)
         {
            TweenMax.to(this.menu.bg,0,{"colorTransform":{
               "tint":_loc6_,
               "tintAmount":1
            }});
         }
      }
      
      public function btnSaveVisible() : void
      {
         if(this.btnSaveProfileSkin != null && this.profileSkinContainer != null)
         {
            this.btnSaveProfileSkin.visible = !(this.profileSkin != null && this.skinClip == this.profileSkin.clip);
         }
      }
      
      private function movieClipHasLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc5_:FrameLabel = null;
         var _loc4_:int = int(param1.currentLabels.length);
         while(_loc3_ < _loc4_)
         {
            if((_loc5_ = param1.currentLabels[_loc3_]).name == param2)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function updateProfile(param1:ProfileEvent) : void
      {
         this.reset();
         this.avatarID = param1.avatarID;
         Connectr.instance.serviceModel.requestData(RequestDataKey.PROFILE,{"avatarID":this.avatarID},this.profileResponse);
      }
      
      protected function onCloseClick(param1:MouseEvent) : void
      {
         close();
      }
      
      protected function copyAvatarID(param1:MouseEvent) : void
      {
         if(param1.ctrlKey)
         {
            System.setClipboard(this.avatarID);
         }
         if(param1.shiftKey)
         {
            System.setClipboard(this.avatarName);
         }
      }
      
      protected function copyPlayerID(param1:MouseEvent) : void
      {
         if(param1.shiftKey)
         {
            System.setClipboard(this.playerID);
         }
      }
      
      public function reset() : void
      {
         var _loc1_:ICharPreview = null;
         this.avatarAge = null;
         this.flatData = null;
         this.txtAvatarID.text = "";
         this.buddystatics.visible = false;
         this.editButton.visible = false;
         this.saveButton.visible = false;
         this.btnProfileSkin.visible = false;
         if(this.editStatusMessageTextField)
         {
            this.editStatusMessageTextField.visible = false;
         }
         if(this.charHolder.numChildren > 0)
         {
            _loc1_ = this.charHolder.getChildAt(0) as ICharPreview;
            if(_loc1_)
            {
               _loc1_.terminate();
            }
         }
         if(this.menu)
         {
            this.removeChild(this.menu);
            this.menu = null;
         }
         if(this.comboBox)
         {
            this.comboBox.removeEventListener(ComboBoxEvent.ITEM_SELECTED,this.changeMood);
            removeChild(this.comboBox);
            this.comboBox = null;
         }
         if(this.profileStickerContainer)
         {
            this.removeChild(this.profileStickerContainer);
            this.profileStickerContainer = null;
         }
         if(this.profileBadgeContainer)
         {
            this.removeChild(this.profileBadgeContainer);
            this.profileBadgeContainer = null;
         }
         if(this.profileSkinContainer)
         {
            this.removeChild(this.profileSkinContainer);
            this.profileSkinContainer = null;
         }
         this.charHolder.removeChildren();
      }
      
      override public function dispose() : void
      {
         this.reset();
         Dispatcher.removeEventListener(ProfileEvent.SHOW_PROFILE,this.updateProfile);
         Connectr.instance.serviceModel.removeExtension(BuddyResponseTypes.BUDDY_ADDED,this.onBuddyAdded);
         Connectr.instance.serviceModel.removeExtension(BuddyResponseTypes.BUDDY_REMOVED,this.onBuddyRemoved);
         this.editButton.removeEventListener(MouseEvent.CLICK,this.editClicked);
         this.saveButton.removeEventListener(MouseEvent.CLICK,this.saveClicked);
         this.btnProfileSkin.removeEventListener(MouseEvent.CLICK,this.onProfileSkin);
         if(this.charPreview)
         {
            this.charPreview.terminate();
         }
         this.txtAvatarID.removeEventListener(MouseEvent.CLICK,this.copyAvatarID);
         this.txtPlayerID.removeEventListener(MouseEvent.CLICK,this.copyPlayerID);
         this.btnFlat.removeEventListener(MouseEvent.CLICK,this.flatClicked);
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.onCloseClick);
         this.btnImproper.removeEventListener(MouseEvent.CLICK,this.btnImproperClicked);
         this.btnImproperStatus.removeEventListener(MouseEvent.CLICK,this.btnImproperStatusClicked);
         this.btnImproperCity.removeEventListener(MouseEvent.CLICK,this.btnImproperCityClicked);
         Connectr.instance.toolTipModel.removeTip(this.buddystatics);
         Connectr.instance.toolTipModel.removeTip(this.btnImproper);
         Connectr.instance.toolTipModel.removeTip(this.btnImproperStatus);
         Connectr.instance.toolTipModel.removeTip(this.btnImproperCity);
         Connectr.instance.toolTipModel.removeTip(this.txtShareLink);
         Connectr.instance.toolTipModel.removeTip(this.emailIcon);
         Connectr.instance.toolTipModel.removeTip(this.btnProfileSkin);
         super.dispose();
      }
   }
}

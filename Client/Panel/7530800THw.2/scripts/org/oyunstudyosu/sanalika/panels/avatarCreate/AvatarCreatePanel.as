package org.oyunstudyosu.sanalika.panels.avatarCreate
{
   import com.greensock.TweenMax;
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.PackItemEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.local.arabic.ArabicInputManager;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.assets.clips.LoadingAnimationSmall;
   import org.oyunstudyosu.sanalika.buttons.newButtons.BlueButton;
   import org.oyunstudyosu.sanalika.buttons.newButtons.BtnColor;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.avatarCreate.AvatarCreatePanel")]
   public class AvatarCreatePanel extends Panel
   {
       
      
      public var background:MovieClip;
      
      public var inpAvatarName:TextField;
      
      public var txtHeader:TextField;
      
      public var txtInfo:TextField;
      
      public var medias:Array;
      
      public var colors:Array;
      
      public var currPlace:String;
      
      public var clipsIndexes:Array;
      
      public var bodyColorIndex:int;
      
      public var orderIndexes:Array;
      
      private var inputManager:ArabicInputManager;
      
      private var charContainer:Sprite;
      
      public var clrPanel:ShopItemColorPanel;
      
      public var loaderPanel:MovieClip;
      
      private var waitingList:Array;
      
      private var loadingAnimation:LoadingAnimationSmall;
      
      public var btnRandom:SimpleButton;
      
      public var btnClose:CloseButton;
      
      public var btnMale:SimpleButton;
      
      public var btnFemale:SimpleButton;
      
      public var btnConfirm:BlueButton;
      
      public var btnChangeBodyL:SimpleButton;
      
      public var btnChangeBodyR:SimpleButton;
      
      public var btnChangeSacL:SimpleButton;
      
      public var btnChangeSacR:SimpleButton;
      
      public var btnChangeTshortL:SimpleButton;
      
      public var btnChangeTshortR:SimpleButton;
      
      public var btnChangePantsL:SimpleButton;
      
      public var btnChangePantsR:SimpleButton;
      
      public var btnChangeShoesL:SimpleButton;
      
      public var btnChangeShoesR:SimpleButton;
      
      public var btnSacColor:BtnColor;
      
      public var btnTshirtColor:BtnColor;
      
      public var btnPantsColor:BtnColor;
      
      public var btnShoesColor:BtnColor;
      
      public var btnBodyColor:BtnColor;
      
      public var placeHolder:MovieClip;
      
      public var nInpAvatarName:TextField;
      
      private var sTxtHeader:STextField;
      
      private var sTxtInfo:STextField;
      
      private var avatarText:String;
      
      public var gender:String;
      
      public var clip:MovieClip;
      
      public var bg:MovieClip;
      
      private var _data:Object;
      
      public var bgAvatarName:MovieClip;
      
      public function AvatarCreatePanel()
      {
         this.waitingList = [];
         super();
      }
      
      override public function init() : void
      {
         super.init();
         if(this.sTxtHeader == null)
         {
            this.sTxtHeader = TextFieldManager.convertAsArabicTextField(getChildByName("txtHeader") as TextField,true,false);
            this.sTxtInfo = TextFieldManager.convertAsArabicTextField(getChildByName("txtInfo") as TextField,true,false);
            this.nInpAvatarName = TextFieldManager.createNoneLanguageTextfield(getChildByName("inpAvatarName") as TextField);
         }
         this.avatarText = $("Jack The One");
         if(this.inputManager)
         {
            this.inputManager.clearText();
            this.inputManager.addText(this.avatarText);
            this.inputManager.draw();
         }
         else
         {
            this.nInpAvatarName.text = this.avatarText;
         }
         this.nInpAvatarName.addEventListener(FocusEvent.FOCUS_IN,this.focusInAvatarName);
         this.nInpAvatarName.addEventListener(FocusEvent.FOCUS_OUT,this.focusOutAvatarName);
         this.sTxtInfo.multiline = true;
         this.btnClose.visible = false;
         if(data.params)
         {
            this.btnClose.visible = true;
         }
         Connectr.instance.serviceModel.requestData(RequestDataKey.BASE_CLOTHES,{},this.onListResponse);
      }
      
      protected function focusOutAvatarName(param1:FocusEvent) : void
      {
         if(this.inputManager)
         {
            if(this.inputManager.getText() == "")
            {
               this.inputManager.addText(this.avatarText);
            }
            this.inputManager.draw();
         }
         else if(this.nInpAvatarName.text == "")
         {
            this.nInpAvatarName.text = this.avatarText;
         }
      }
      
      protected function focusInAvatarName(param1:FocusEvent) : void
      {
         this.sTxtInfo.text = $("avatarCreateInfo");
         if(this.inputManager)
         {
            this.inputManager.changeFormat(this.nInpAvatarName.defaultTextFormat);
            if(this.inputManager.getText() == this.avatarText)
            {
               this.inputManager.clearText();
            }
         }
         else if(this.nInpAvatarName.text == this.avatarText)
         {
            this.nInpAvatarName.text = "";
         }
      }
      
      private function onListResponse(param1:Object) : void
      {
         this._data = param1;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.BASE_CLOTHES,this.onListResponse);
         this.initForm();
         show();
         (Connectr.instance.itemModel as IEventDispatcher).addEventListener(PackItemEvent.EVENT_ITEMLOADED,this.packEventFunction);
      }
      
      private function initList(param1:Array) : void
      {
         var _loc2_:String = null;
         this.clipsIndexes = new Array();
         this.medias = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = String(param1[_loc3_].placeBit);
            if(this.medias[_loc2_] == null)
            {
               this.medias[_loc2_] = new Array();
            }
            this.medias[_loc2_].push(new AccesoryData(parseInt(_loc2_),param1[_loc3_]));
            this.clipsIndexes[_loc2_] = 0;
            _loc3_++;
         }
      }
      
      public function initForm() : void
      {
         this.btnChangeBodyL.addEventListener(MouseEvent.CLICK,this.iterateBodyLeft);
         this.btnChangeBodyR.addEventListener(MouseEvent.CLICK,this.iterateBodyRight);
         this.btnBodyColor.addEventListener(MouseEvent.CLICK,this.showBodyColorPanel);
         this.btnChangeSacL.addEventListener(MouseEvent.CLICK,this.iterateHairLeft);
         this.btnChangeSacR.addEventListener(MouseEvent.CLICK,this.iterateHairRight);
         this.btnChangeTshortL.addEventListener(MouseEvent.CLICK,this.iterateTshortLeft);
         this.btnChangeTshortR.addEventListener(MouseEvent.CLICK,this.iterateTshortRight);
         this.btnChangePantsL.addEventListener(MouseEvent.CLICK,this.iteratePantsLeft);
         this.btnChangePantsR.addEventListener(MouseEvent.CLICK,this.iteratePantsRight);
         this.btnChangeShoesL.addEventListener(MouseEvent.CLICK,this.iterateShoesLeft);
         this.btnChangeShoesR.addEventListener(MouseEvent.CLICK,this.iterateShoesRight);
         this.btnSacColor.addEventListener(MouseEvent.CLICK,this.showSacColorPanel);
         this.btnTshirtColor.addEventListener(MouseEvent.CLICK,this.showThshirtColorPanel);
         this.btnPantsColor.addEventListener(MouseEvent.CLICK,this.showPantsColorPanel);
         this.btnShoesColor.addEventListener(MouseEvent.CLICK,this.showShoesColorPanel);
         this.btnBodyColor.addEventListener(MouseEvent.MOUSE_OUT,this.destroyColorPanel);
         this.btnSacColor.addEventListener(MouseEvent.MOUSE_OUT,this.destroyColorPanel);
         this.btnTshirtColor.addEventListener(MouseEvent.MOUSE_OUT,this.destroyColorPanel);
         this.btnPantsColor.addEventListener(MouseEvent.MOUSE_OUT,this.destroyColorPanel);
         this.btnShoesColor.addEventListener(MouseEvent.MOUSE_OUT,this.destroyColorPanel);
         this.btnRandom.addEventListener(MouseEvent.CLICK,this.randomAccesories);
         this.btnConfirm.addEventListener(MouseEvent.CLICK,this.confirm);
         this.btnFemale.addEventListener(MouseEvent.CLICK,this.selectGenderFemale);
         this.btnMale.addEventListener(MouseEvent.CLICK,this.selectGenderMale);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose);
         this.charContainer = new Sprite();
         addChild(this.charContainer);
         if(Connectr.instance.avatarModel.guest)
         {
            this.btnConfirm.setText($("avatarEditButton"));
            this.sTxtHeader.text = $("avatarEditHeader");
            this.sTxtInfo.text = $("avatarEditInfo");
            this.gender = "m";
            this.onGenderChange(this.gender);
            this.nInpAvatarName.visible = false;
            this.bgAvatarName.visible = false;
            this.sTxtInfo.visible = false;
         }
         else if(data.type == "BaseCloth")
         {
            this.btnConfirm.setText($("avatarEditButton"));
            this.sTxtHeader.text = $("avatarEditHeader");
            this.sTxtInfo.text = $("avatarEditInfo");
            if(Connectr.instance.avatarModel.gender != "")
            {
               this.btnMale.visible = false;
               this.btnFemale.visible = false;
               this.gender = Connectr.instance.avatarModel.gender;
               this.onGenderChange(this.gender);
            }
            else
            {
               this.gender = "f";
               this.onGenderChange(this.gender);
            }
            if(Connectr.instance.avatarModel.avatarName != "Guest#" + Connectr.instance.avatarModel.avatarId)
            {
               this.nInpAvatarName.visible = false;
               this.bgAvatarName.visible = false;
               this.sTxtInfo.visible = false;
            }
         }
         else
         {
            this.gender = "f";
            this.onGenderChange(this.gender);
            this.btnConfirm.setText($("avatarCreateButton"));
            this.sTxtHeader.text = $("avatarCreateHeader");
            this.sTxtInfo.text = $("avatarCreateInfo");
         }
      }
      
      public function selectGenderMale(param1:MouseEvent) : void
      {
         this.onGenderChange("m");
      }
      
      public function selectGenderFemale(param1:MouseEvent) : void
      {
         this.onGenderChange("f");
      }
      
      public function onGenderChange(param1:String) : void
      {
         var _loc2_:Array = null;
         this.gender = param1;
         this.resetCharContainer();
         if(param1 == "f")
         {
            param1 = "f";
            _loc2_ = this._data.f;
            this.btnFemale.mouseEnabled = false;
            this.btnMale.mouseEnabled = true;
            TweenMax.to(this.btnMale,0,{"colorMatrixFilter":{"saturation":1}});
            TweenMax.to(this.btnFemale,0,{"colorMatrixFilter":{
               "saturation":0,
               "hue":30
            }});
         }
         else
         {
            param1 = "m";
            _loc2_ = this._data.m;
            TweenMax.to(this.btnFemale,0,{"colorMatrixFilter":{"saturation":1}});
            TweenMax.to(this.btnMale,0,{"colorMatrixFilter":{
               "saturation":0,
               "hue":30
            }});
            this.btnFemale.mouseEnabled = true;
            this.btnMale.mouseEnabled = false;
         }
         this.initList(_loc2_);
         this.randomAccesories(null);
         this.charContainer.x = this.placeHolder.x;
         this.charContainer.y = this.placeHolder.y;
         this.charContainer.scaleX = 1;
         this.charContainer.scaleY = 1;
      }
      
      public function randomAccesories(param1:Event) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:AccesoryData = null;
         var _loc7_:Class = null;
         if(this.clipsIndexes != null)
         {
            this.clipsIndexes.splice(0,this.clipsIndexes.length);
            this.clipsIndexes = [];
         }
         var _loc2_:int = -1;
         var _loc3_:Boolean = false;
         for each(_loc4_ in this.medias)
         {
            _loc5_ = int(Math.random() * _loc4_.length);
            _loc6_ = AccesoryData(_loc4_[_loc5_]);
            this.clipsIndexes[_loc6_.place.toString()] = _loc5_;
            if(_loc6_.place == 0 || _loc6_.place == 1 || _loc6_.place == 2)
            {
               if(_loc2_ == -1)
               {
                  _loc6_.setColorIndex(int(Math.random() * _loc6_.colors.length));
                  this.bodyColorIndex = _loc6_.colorIndex;
                  _loc2_ = int(_loc6_.colors[_loc6_.colorIndex]);
               }
               else
               {
                  _loc6_.setColor(_loc2_);
               }
            }
            else if(_loc6_.colors != null)
            {
               _loc6_.setColorIndex(int(Math.random() * _loc6_.colors.length));
            }
            if((_loc7_ = Connectr.instance.itemModel.getClothClass(this.gender + "_" + _loc6_.def)) == null)
            {
               this.addElement2WaitingList(this.gender + "_" + _loc6_.def);
               _loc3_ = true;
            }
            _loc6_ = null;
            _loc7_ = null;
         }
         if(_loc3_)
         {
            this.showLoadingAnimation();
            this.reDraw();
         }
         else
         {
            this.reDraw();
         }
      }
      
      private function reDraw() : void
      {
         try
         {
            this.charContainer.removeChildren();
            this.iterateMedia("1",0);
            this.iterateMedia("131072",0);
            this.iterateMedia("512",0);
            this.iterateMedia("64",0);
            this.iterateMedia("16",0);
         }
         catch(error:Error)
         {
         }
      }
      
      private function confirm(param1:Event) : void
      {
         var _loc5_:String = null;
         var _loc6_:AccesoryData = null;
         var _loc7_:Object = null;
         if(this.nInpAvatarName.visible)
         {
            if(this.nInpAvatarName.text == this.avatarText)
            {
               return;
            }
            if(this.nInpAvatarName.text.length < 3 || this.nInpAvatarName.text.length > 20)
            {
               this.sTxtInfo.text = $("avatarNameLengthError");
               return;
            }
            if(this.nInpAvatarName.text.indexOf(">") >= 0 || this.nInpAvatarName.text.indexOf("<") >= 0)
            {
               this.sTxtInfo.text = $("nickChangeFormatError");
               return;
            }
         }
         this.btnConfirm.mouseEnabled = false;
         TweenMax.to(this.btnConfirm,0,{"colorMatrixFilter":{"saturation":0}});
         var _loc2_:Array = new Array();
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < this.charContainer.numChildren)
         {
            _loc5_ = String(MovieClip(this.charContainer.getChildAt(_loc4_)).place.toString());
            _loc6_ = AccesoryData(this.medias[_loc5_][this.clipsIndexes[_loc5_]]);
            _loc3_ += _loc6_.def + ",";
            _loc7_ = {};
            if(_loc6_.colors != null)
            {
               _loc7_.clip = _loc6_.clip;
               _loc7_.color = _loc6_.colors[_loc6_.colorIndex];
               _loc2_.push(_loc7_);
            }
            else
            {
               _loc7_.clip = _loc6_.clip;
               _loc2_.push(_loc7_);
            }
            _loc6_ = null;
            _loc4_++;
         }
         _loc3_ = _loc3_.substr(0,_loc3_.length - 1);
         if(data.type == "BaseCloth")
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.SAVE_BASE_CLOTHES,{
               "clothes":_loc2_,
               "gender":this.gender,
               "avatarName":this.nInpAvatarName.text
            },this.saveResponseFunction);
         }
         else
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.AVATAR_CREATE,{
               "clothes":_loc2_,
               "avatarName":this.nInpAvatarName.text,
               "gender":this.gender,
               "token":Connectr.instance.avatarModel.accessToken
            },this.saveResponseFunction);
         }
      }
      
      private function reEnable() : void
      {
         this.btnConfirm.mouseEnabled = true;
         TweenMax.to(this.btnConfirm,0,{"colorMatrixFilter":{"saturation":1}});
      }
      
      private function saveResponseFunction(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SAVE_BASE_CLOTHES,this.saveResponseFunction);
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.AVATAR_CREATE,this.saveResponseFunction);
         if(param1.errorCode != null)
         {
            this.btnConfirm.addEventListener(MouseEvent.MOUSE_DOWN,this.confirm);
            this.sTxtInfo.text = $(param1.message);
            TweenMax.delayedCall(2,this.reEnable);
            return;
         }
         Connectr.instance.avatarModel.data.saveAvatarImage = true;
         Connectr.instance.avatarModel.isBaseClothSelected = true;
         Connectr.instance.avatarModel.avatarId = param1.avatarID;
         close();
         Connectr.instance.reset();
      }
      
      public function destroyColorPanel(param1:Event) : void
      {
         if(this.clrPanel != null && this.clrPanel.visible)
         {
            this.clrPanel.msOut(param1);
         }
      }
      
      private function showColorPanel(param1:int, param2:int, param3:String) : void
      {
         var _loc6_:MovieClip = null;
         this.currPlace = param3;
         if(this.clrPanel == null)
         {
            this.clrPanel = new ShopItemColorPanel();
            this.clrPanel.visible = false;
            this.clrPanel.colorListener = this;
         }
         addChild(this.clrPanel);
         this.clrPanel.x = param1 + 22;
         this.clrPanel.y = param2;
         this.clrPanel.visible = true;
         var _loc4_:AccesoryData = this.medias[param3][this.clipsIndexes[param3]];
         var _loc5_:int = 0;
         while(_loc5_ < 9)
         {
            (_loc6_ = MovieClip(this.clrPanel.getChildByName("c" + _loc5_))).buttonMode = true;
            if(_loc4_.colors.length > _loc5_)
            {
               _loc6_.gotoAndStop(_loc4_.colors[_loc5_]);
               _loc6_.visible = true;
               _loc6_.color = _loc4_.colors[_loc5_];
            }
            else
            {
               _loc6_.visible = false;
               _loc6_.color = 0;
            }
            _loc5_++;
         }
      }
      
      private function playClips() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.charContainer.numChildren)
         {
            MovieClip(this.charContainer.getChildAt(_loc1_)).gotoAndStop("i3");
            _loc1_++;
         }
      }
      
      private function addAccesory(param1:AccesoryData, param2:String) : Boolean
      {
         var _loc3_:Class = Connectr.instance.itemModel.getClothClass(this.gender + "_" + param1.def);
         if(_loc3_ == null)
         {
            this.addElement2WaitingList(this.gender + "_" + param1.def);
            return true;
         }
         this.removeAccesoryAtPlace(param2);
         var _loc4_:MovieClip;
         (_loc4_ = new _loc3_()).place = param1.place;
         this.charContainer.addChild(_loc4_);
         return false;
      }
      
      private function showLoadingAnimation() : void
      {
         if(this.loadingAnimation != null)
         {
            return;
         }
         this.loadingAnimation = new LoadingAnimationSmall();
         this.loadingAnimation.x = this.placeHolder.x;
         this.loadingAnimation.y = this.placeHolder.y - 30;
         addChild(this.loadingAnimation);
         this.btnConfirm.mouseEnabled = false;
         TweenMax.to(this.btnConfirm,0,{"colorMatrixFilter":{"saturation":0}});
      }
      
      private function hideLoadingAnimation() : void
      {
         if(this.loadingAnimation == null)
         {
            return;
         }
         removeChild(this.loadingAnimation);
         this.loadingAnimation = null;
         this.btnRandom.alpha = this.btnConfirm.alpha = 1;
         this.btnRandom.mouseEnabled = this.btnConfirm.mouseEnabled = true;
         TweenMax.to(this.btnConfirm,0,{"colorMatrixFilter":{"saturation":1}});
      }
      
      public function setColor(param1:int) : void
      {
         var _loc3_:AccesoryData = null;
         var _loc4_:AccesoryData = null;
         var _loc5_:AccesoryData = null;
         var _loc6_:AccesoryData = null;
         var _loc2_:Boolean = false;
         if(this.currPlace == "1")
         {
            _loc3_ = this.medias[1][this.clipsIndexes[1]];
            _loc3_.setColor(param1);
            (_loc4_ = this.medias[2][this.clipsIndexes[2]]).setColor(param1);
            (_loc5_ = this.medias[4][this.clipsIndexes[4]]).setColor(param1);
            this.bodyColorIndex = _loc3_.colorIndex;
            _loc2_ = this.addAccesory(_loc3_,"1") || this.addAccesory(_loc4_,"2") || this.addAccesory(_loc5_,"4");
         }
         else
         {
            (_loc6_ = this.medias[this.currPlace][this.clipsIndexes[this.currPlace]]).setColor(param1);
            _loc2_ = this.addAccesory(_loc6_,this.currPlace);
         }
         if(_loc2_)
         {
            this.showLoadingAnimation();
         }
         else
         {
            this.reOrderDepth();
            this.playClips();
         }
      }
      
      private function removeAccesoryAtPlace(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.charContainer.numChildren)
         {
            if(MovieClip(this.charContainer.getChildAt(_loc2_)).place.toString() == param1)
            {
               this.charContainer.removeChildAt(_loc2_);
            }
            _loc2_++;
         }
      }
      
      private function iterateMedia(param1:String, param2:int) : void
      {
         var _loc4_:AccesoryData = null;
         if(this.clrPanel != null)
         {
            this.clrPanel.destroyColorPnl(null);
         }
         var _loc3_:Boolean = false;
         if(param1 == "1")
         {
            this.bodyColorIndex += param2;
            _loc4_ = AccesoryData(this.medias[param1][0]);
            if(this.bodyColorIndex >= _loc4_.colors.length)
            {
               this.bodyColorIndex = 0;
            }
            if(this.bodyColorIndex < 0)
            {
               this.bodyColorIndex = _loc4_.colors.length - 1;
            }
            AccesoryData(this.medias[1][0]).setColorIndex(this.bodyColorIndex);
            AccesoryData(this.medias[2][0]).setColorIndex(this.bodyColorIndex);
            AccesoryData(this.medias[4][0]).setColorIndex(this.bodyColorIndex);
            _loc3_ = this.addAccesory(AccesoryData(this.medias[1][this.clipsIndexes[1]]),"1") || this.addAccesory(AccesoryData(this.medias[2][this.clipsIndexes[2]]),"2") || this.addAccesory(AccesoryData(this.medias[4][this.clipsIndexes[4]]),"4");
         }
         else
         {
            this.clipsIndexes[param1] += param2;
            if(this.clipsIndexes[param1] >= this.medias[param1].length)
            {
               this.clipsIndexes[param1] = 0;
            }
            if(this.clipsIndexes[param1] < 0)
            {
               this.clipsIndexes[param1] = this.medias[param1].length - 1;
            }
            _loc3_ = this.addAccesory(AccesoryData(this.medias[param1][this.clipsIndexes[param1]]),param1);
         }
         if(_loc3_)
         {
            this.showLoadingAnimation();
         }
         else
         {
            this.reOrderDepth();
            this.playClips();
         }
      }
      
      private function reOrderDepth() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.charContainer.numChildren)
         {
            _loc2_ = 0;
            while(_loc2_ < this.charContainer.numChildren)
            {
               if(MovieClip(this.charContainer.getChildAt(_loc1_)).place <= MovieClip(this.charContainer.getChildAt(_loc2_)).place)
               {
                  this.charContainer.setChildIndex(this.charContainer.getChildAt(_loc1_),_loc2_);
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function showBodyColorPanel(param1:Event) : void
      {
         this.showColorPanel(param1.target.x,param1.target.y,"1");
         if(this.clrPanel != null)
         {
            this.clrPanel.rstTimer();
         }
      }
      
      public function showSacColorPanel(param1:Event) : void
      {
         this.showColorPanel(param1.target.x,param1.target.y,"131072");
         if(this.clrPanel != null)
         {
            this.clrPanel.rstTimer();
         }
      }
      
      public function showThshirtColorPanel(param1:Event) : void
      {
         this.showColorPanel(param1.target.x,param1.target.y,"512");
         if(this.clrPanel != null)
         {
            this.clrPanel.rstTimer();
         }
      }
      
      public function showPantsColorPanel(param1:Event) : void
      {
         this.showColorPanel(param1.target.x + 10,param1.target.y,"64");
         if(this.clrPanel != null)
         {
            this.clrPanel.rstTimer();
         }
      }
      
      public function showShoesColorPanel(param1:Event) : void
      {
         this.showColorPanel(param1.target.x,param1.target.y,"16");
         if(this.clrPanel != null)
         {
            this.clrPanel.rstTimer();
         }
      }
      
      public function iterateBodyLeft(param1:Event) : void
      {
         this.iterateMedia("1",-1);
      }
      
      public function iterateBodyRight(param1:Event) : void
      {
         this.iterateMedia("1",1);
      }
      
      public function iterateHairLeft(param1:Event) : void
      {
         this.iterateMedia("131072",-1);
      }
      
      public function iterateHairRight(param1:Event) : void
      {
         this.iterateMedia("131072",1);
      }
      
      public function iterateTshortLeft(param1:Event) : void
      {
         this.iterateMedia("512",-1);
      }
      
      public function iterateTshortRight(param1:Event) : void
      {
         this.iterateMedia("512",1);
      }
      
      public function iteratePantsLeft(param1:Event) : void
      {
         this.iterateMedia("64",-1);
      }
      
      public function iteratePantsRight(param1:Event) : void
      {
         this.iterateMedia("64",1);
      }
      
      public function iterateShoesLeft(param1:Event) : void
      {
         this.iterateMedia("16",-1);
      }
      
      public function iterateShoesRight(param1:Event) : void
      {
         this.iterateMedia("16",1);
      }
      
      private function addElement2WaitingList(param1:String) : void
      {
         var _loc2_:int = this.waitingList.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.waitingList.push(param1);
         }
      }
      
      private function packEventFunction(param1:PackItemEvent) : void
      {
         var _loc2_:int = this.waitingList.indexOf(param1.key);
         if(_loc2_ < 0)
         {
            return;
         }
         this.waitingList.splice(_loc2_,1);
         if(this.waitingList.length > 0)
         {
            return;
         }
         this.hideLoadingAnimation();
         this.reDraw();
      }
      
      private function resetCharContainer() : void
      {
         if(this.charContainer == null)
         {
            return;
         }
         while(this.charContainer.numChildren > 0)
         {
            this.charContainer.removeChildAt(0);
         }
      }
      
      public function onClose(param1:MouseEvent) : void
      {
         close();
      }
      
      override public function dispose() : void
      {
         (Connectr.instance.itemModel as IEventDispatcher).removeEventListener(PackItemEvent.EVENT_ITEMLOADED,this.packEventFunction);
         this.resetCharContainer();
         this.btnChangeBodyL.removeEventListener(MouseEvent.CLICK,this.iterateBodyLeft);
         this.btnChangeBodyR.removeEventListener(MouseEvent.CLICK,this.iterateBodyRight);
         this.btnBodyColor.removeEventListener(MouseEvent.CLICK,this.showBodyColorPanel);
         this.btnChangeSacL.removeEventListener(MouseEvent.CLICK,this.iterateHairLeft);
         this.btnChangeSacR.removeEventListener(MouseEvent.CLICK,this.iterateHairRight);
         this.btnChangeTshortL.addEventListener(MouseEvent.CLICK,this.iterateTshortLeft);
         this.btnChangeTshortR.removeEventListener(MouseEvent.CLICK,this.iterateTshortRight);
         this.btnChangePantsL.removeEventListener(MouseEvent.CLICK,this.iteratePantsLeft);
         this.btnChangePantsR.removeEventListener(MouseEvent.CLICK,this.iteratePantsRight);
         this.btnChangeShoesL.removeEventListener(MouseEvent.CLICK,this.iterateShoesLeft);
         this.btnChangeShoesR.removeEventListener(MouseEvent.CLICK,this.iterateShoesRight);
         this.btnSacColor.removeEventListener(MouseEvent.CLICK,this.showSacColorPanel);
         this.btnTshirtColor.removeEventListener(MouseEvent.CLICK,this.showThshirtColorPanel);
         this.btnPantsColor.removeEventListener(MouseEvent.CLICK,this.showPantsColorPanel);
         this.btnShoesColor.removeEventListener(MouseEvent.CLICK,this.showShoesColorPanel);
         this.btnBodyColor.removeEventListener(MouseEvent.MOUSE_OUT,this.destroyColorPanel);
         this.btnSacColor.removeEventListener(MouseEvent.MOUSE_OUT,this.destroyColorPanel);
         this.btnTshirtColor.removeEventListener(MouseEvent.MOUSE_OUT,this.destroyColorPanel);
         this.btnPantsColor.removeEventListener(MouseEvent.MOUSE_OUT,this.destroyColorPanel);
         this.btnShoesColor.removeEventListener(MouseEvent.MOUSE_OUT,this.destroyColorPanel);
         this.btnRandom.removeEventListener(MouseEvent.CLICK,this.randomAccesories);
         this.btnConfirm.removeEventListener(MouseEvent.CLICK,this.confirm);
         this.btnFemale.removeEventListener(MouseEvent.CLICK,this.selectGenderFemale);
         this.btnMale.removeEventListener(MouseEvent.CLICK,this.selectGenderMale);
         this.nInpAvatarName.visible = true;
         this.bgAvatarName.visible = true;
         this.sTxtInfo.visible = true;
         this.btnMale.visible = true;
         this.btnFemale.visible = true;
         if(this.medias != null)
         {
            this.medias.splice(0,this.medias.length - 1);
            this.medias = null;
         }
         if(this.colors != null)
         {
            this.colors.splice(0,this.colors.length - 1);
            this.colors = null;
         }
         if(this.clipsIndexes != null)
         {
            this.clipsIndexes.splice(0,this.clipsIndexes.length - 1);
            this.clipsIndexes = null;
         }
         this.clrPanel = null;
         this.loaderPanel = null;
         super.dispose();
      }
   }
}

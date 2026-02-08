package org.oyunstudyosu.sanalika.panels.cloth
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.cloth.ClothType;
   import com.oyunstudyosu.cloth.ICharPreview;
   import com.oyunstudyosu.cloth.ICloth;
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.engine.ICharacter;
   import com.oyunstudyosu.enums.CharacterVariable;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.PackPngEvent;
   import com.oyunstudyosu.events.PurchaseEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.Logger;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.StringUtil;
   import com.oyunstudyosu.utils.TextFieldManager;
   import com.printfas3.printf;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import org.oyunstudyosu.assets.clips.ToolTipClip;
   import org.oyunstudyosu.sanalika.buttons.newButtons.BlueButton;
   import org.oyunstudyosu.sanalika.buttons.newButtons.ShopBasketRemoveButton;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cloth.ClothPanel")]
   public class ClothPanel extends Panel
   {
       
      
      public var txtHeader:TextField;
      
      private var lastCategory:String;
      
      private var lastPage:int;
      
      private var lastPageCount:int;
      
      private var lastElementArray:Array;
      
      private var rightDirection:Boolean;
      
      private var wardrobeTip:Sprite;
      
      private var wardrobeTipX:int;
      
      private var wardrobeTipY:int;
      
      private var wardrobeTipCloth:ICloth;
      
      private var myClothes:Array;
      
      public var charPreview:ICharPreview;
      
      public var rotateLeft:SimpleButton;
      
      public var rotateRight:SimpleButton;
      
      public var btnClose:CloseButton;
      
      public var btnShirt:MovieClip;
      
      public var btnPants:MovieClip;
      
      public var btnShoes:MovieClip;
      
      public var btnHead:MovieClip;
      
      public var btnAccessory:MovieClip;
      
      public var btnCostume:MovieClip;
      
      public var btnOk:BlueButton;
      
      public var charContainer:MovieClip;
      
      public var wardrobe:MovieClip;
      
      public var lbl_clothTitle:TextField;
      
      public var mcDragger:MovieClip;
      
      public var quantitybtnHead:TextField;
      
      public var quantitybtnCostume:TextField;
      
      public var quantitybtnAccessory:TextField;
      
      public var quantitybtnShoes:TextField;
      
      public var quantitybtnPants:TextField;
      
      public var quantitybtnShirt:TextField;
      
      private var cloth:ICloth;
      
      private var slot:MovieClip;
      
      private var allClothIds:Array;
      
      private var sTitle:STextField;
      
      private var pageTextField:TextField;
      
      private var sorter:Function;
      
      public function ClothPanel()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         this.getList();
         Dispatcher.addEventListener(PurchaseEvent.CLOTH_PURCHASE_COMPLETED,this.updateAll);
         Connectr.instance.toolTipModel.addTip(this.btnShirt,$("T-Shirts"));
         Connectr.instance.toolTipModel.addTip(this.btnPants,$("Pants"));
         Connectr.instance.toolTipModel.addTip(this.btnShoes,$("Shoes"));
         Connectr.instance.toolTipModel.addTip(this.btnHead,$("Hats"));
         Connectr.instance.toolTipModel.addTip(this.btnAccessory,$("Accessories"));
         Connectr.instance.toolTipModel.addTip(this.btnCostume,$("Costumes"));
         dragHandler = this.mcDragger;
         if(this.sTitle == null)
         {
            this.sTitle = TextFieldManager.convertAsArabicTextField(getChildByName("txtHeader") as TextField,false,true);
            this.sTitle.autoSize = TextFieldAutoSize.CENTER;
            this.sTitle.wordWrap = false;
            this.sTitle.mouseEnabled = false;
            this.pageTextField = TextFieldManager.createNoneLanguageTextfield(this.wardrobe.getChildByName("lblPage") as TextField);
         }
         this.sTitle.text = $("Your Clothes");
      }
      
      private function getList() : void
      {
         this.btnOk.setText($("Accept"));
         this.btnClose.addEventListener(MouseEvent.CLICK,this.btnCloseClicked);
         Connectr.instance.serviceModel.requestData(RequestDataKey.CLOTH_LIST,{},this.onClothResponse);
      }
      
      private function updateAll(param1:PurchaseEvent) : void
      {
         this.disableUI();
         this.getList();
      }
      
      private function enableUI() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.baseMouseClicked);
         this.rotateLeft.addEventListener(MouseEvent.CLICK,this.rotateLeftClicked);
         this.rotateRight.addEventListener(MouseEvent.CLICK,this.rotateRightClicked);
         this.btnShirt.addEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnShirt.addEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnShirt.addEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnShirt.buttonMode = true;
         this.btnShirt.gotoAndStop(1);
         this.btnPants.addEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnPants.addEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnPants.addEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnPants.buttonMode = true;
         this.btnPants.gotoAndStop(1);
         this.btnShoes.addEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnShoes.addEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnShoes.addEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnShoes.buttonMode = true;
         this.btnShoes.gotoAndStop(1);
         this.btnHead.addEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnHead.addEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnHead.addEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnHead.buttonMode = true;
         this.btnHead.gotoAndStop(1);
         this.btnAccessory.addEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnAccessory.addEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnAccessory.addEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnAccessory.buttonMode = true;
         this.btnAccessory.gotoAndStop(1);
         this.btnCostume.addEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnCostume.addEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnCostume.addEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnCostume.buttonMode = true;
         this.btnCostume.gotoAndStop(1);
         this.btnOk.addEventListener(MouseEvent.CLICK,this.btnSaveClicked);
         TweenMax.to(this.btnOk,0,{"colorMatrixFilter":{"saturation":1}});
         Connectr.instance.clothModel.addPngListener(this.packEventFunction);
         Connectr.instance.clothModel.getElementsWithCategory(this.myClothes,"btnCostume").length;
         this.quantitybtnHead.text = "x " + Connectr.instance.clothModel.getElementsWithCategory(this.myClothes,"btnHead").length;
         this.quantitybtnCostume.text = "x " + Connectr.instance.clothModel.getElementsWithCategory(this.myClothes,"btnCostume").length;
         this.quantitybtnAccessory.text = "x " + Connectr.instance.clothModel.getElementsWithCategory(this.myClothes,"btnAccessory").length;
         this.quantitybtnShoes.text = "x " + Connectr.instance.clothModel.getElementsWithCategory(this.myClothes,"btnShoes").length;
         this.quantitybtnPants.text = "x " + Connectr.instance.clothModel.getElementsWithCategory(this.myClothes,"btnPants").length;
         this.quantitybtnShirt.text = "x " + Connectr.instance.clothModel.getElementsWithCategory(this.myClothes,"btnShirt").length;
      }
      
      private function packEventFunction(param1:PackPngEvent) : void
      {
         var _loc3_:int = 0;
         if(!this.lastElementArray)
         {
            return;
         }
         if(this.lastElementArray.length == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 9)
         {
            if(this.lastElementArray.length > (this.lastPage - 1) * 9 + _loc2_)
            {
               _loc3_ = (this.lastPage - 1) * 9 + _loc2_;
               this.cloth = this.lastElementArray[_loc3_];
               if(param1.key == "r_" + this.cloth.key)
               {
                  this.slot = this.wardrobe.getChildByName("h" + (_loc2_ + 1)) as MovieClip;
                  if(this.slot.container.numChildren == 0)
                  {
                     this.slot.container.addChild(param1.getClothClip());
                     (this.slot.container as MovieClip).getChildAt(0).x = -(this.slot.container as MovieClip).getChildAt(0).width / 2;
                     (this.slot.container as MovieClip).getChildAt(0).y = -(this.slot.container as MovieClip).getChildAt(0).height / 2;
                  }
               }
            }
            _loc2_++;
         }
      }
      
      private function onClothResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.CLOTH_LIST,this.onClothResponse);
         if(param1.errorCode)
         {
            close();
            return;
         }
         Connectr.instance.clothModel.load(param1.items);
         this.myClothes = Connectr.instance.clothModel.allClothes;
         this.enableUI();
         this.charPreview = Connectr.instance.clothModel.getNewCharPreview(this.charContainer);
         show();
      }
      
      private function disableUI() : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.CLOTH_LIST,this.onClothResponse);
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.CHANGE_CLOTHES,this.onChangeResponse);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.baseMouseDown);
         removeEventListener(MouseEvent.MOUSE_UP,this.baseMouseUp);
         removeEventListener(MouseEvent.CLICK,this.baseMouseClicked);
         this.rotateLeft.removeEventListener(MouseEvent.CLICK,this.rotateLeftClicked);
         this.rotateRight.removeEventListener(MouseEvent.CLICK,this.rotateRightClicked);
         this.btnShirt.removeEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnShirt.removeEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnShirt.removeEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnPants.removeEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnPants.removeEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnPants.removeEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnShoes.removeEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnShoes.removeEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnShoes.removeEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnHead.removeEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnHead.removeEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnHead.removeEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnAccessory.removeEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnAccessory.removeEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnAccessory.removeEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnCostume.removeEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.btnCostume.removeEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.btnCostume.removeEventListener(MouseEvent.CLICK,this.showWardrobe);
         this.btnOk.removeEventListener(MouseEvent.CLICK,this.btnSaveClicked);
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.btnCloseClicked);
         Connectr.instance.itemModel.removePngListener(this.packEventFunction);
         this.wardrobe.x = 32;
         this.lastCategory = null;
      }
      
      private function btnSaveClicked(param1:MouseEvent) : void
      {
         var _loc5_:AlertVo = null;
         this.btnOk.removeEventListener(MouseEvent.CLICK,this.btnSaveClicked);
         TweenMax.to(this.btnOk,0,{"colorMatrixFilter":{"saturation":0}});
         TweenMax.delayedCall(5,this.enableUI);
         if(this.hasItemOnHand(Connectr.instance.serviceModel.sfs.mySelf))
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.USE_HAND_ITEM,{"id":0},null);
         }
         this.charPreview.setStatus("","i",4);
         var _loc2_:Array = new Array();
         var _loc3_:Array = this.charPreview.getClothes();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_.push(_loc3_[_loc4_].cloth.getPreviewID());
            _loc4_++;
         }
         if(Connectr.instance.roomModel.key == "sanalikaXMars")
         {
            (_loc5_ = new AlertVo()).alertType = AlertType.INFO;
            _loc5_.description = $("notAllowedChangeCloth");
            Dispatcher.dispatchEvent(new AlertEvent(_loc5_));
            return;
         }
         Connectr.instance.serviceModel.requestData(RequestDataKey.CHANGE_CLOTHES,{"clothes":_loc2_},this.onChangeResponse);
      }
      
      private function hasItemOnHand(param1:Object) : Boolean
      {
         var _loc2_:User = param1 as User;
         if(Connectr.instance.engine.scene == null)
         {
            return false;
         }
         var _loc3_:ICharacter = Connectr.instance.engine.scene.getAvatarById(_loc2_.name);
         if(!_loc3_.isMe)
         {
            return false;
         }
         var _loc4_:UserVariable;
         if(_loc4_ = _loc2_.getVariable(CharacterVariable.HAND_ITEM))
         {
            return true;
         }
         return false;
      }
      
      private function onChangeResponse(param1:Object) : void
      {
         if(param1.errorCode)
         {
            return;
         }
         Connectr.instance.avatarModel.data.saveAvatarImage = true;
         close();
      }
      
      private function btnCloseClicked(param1:MouseEvent) : void
      {
         close();
      }
      
      private function baseMouseDown(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         startDrag(false);
      }
      
      private function baseMouseUp(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         stopDrag();
      }
      
      private function baseMouseClicked(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      private function rotateLeftClicked(param1:MouseEvent) : void
      {
         this.charPreview.rotateLeft();
      }
      
      private function rotateRightClicked(param1:MouseEvent) : void
      {
         this.charPreview.rotateRight();
      }
      
      private function mouseOver(param1:MouseEvent) : void
      {
         if(MovieClip(param1.target).currentFrame == 3)
         {
            return;
         }
         MovieClip(param1.target).gotoAndStop(2);
      }
      
      private function mouseOut(param1:MouseEvent) : void
      {
         if(MovieClip(param1.target).currentFrame == 3)
         {
            return;
         }
         MovieClip(param1.target).gotoAndStop(1);
      }
      
      private function changeClothes(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      public function clothModified(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ICloth = null;
         var _loc5_:MovieClip = null;
         this.myClothes = param1;
         if(this.lastCategory == null)
         {
            return;
         }
         this.lastElementArray = Connectr.instance.clothModel.getElementsWithCategory(param1,this.lastCategory);
         if(this.lastElementArray.length == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 9)
         {
            if(this.lastElementArray.length > (this.lastPage - 1) * 9 + _loc2_)
            {
               _loc3_ = (this.lastPage - 1) * 9 + _loc2_;
               if((_loc4_ = this.lastElementArray[_loc3_]).timeLeft >= 0)
               {
                  if(!_loc4_.previewLoaded)
                  {
                     Connectr.instance.clothModel.loadClothPreview(_loc4_);
                  }
                  (_loc5_ = this.wardrobe.getChildByName("h" + (_loc2_ + 1)) as MovieClip).barMask.width = 26 * _loc4_.timeLeft / _loc4_.lifeTime;
                  if(this.wardrobeTip != null)
                  {
                     if(this.wardrobeTipCloth.getPreviewID() == _loc4_.getPreviewID())
                     {
                        this.showTip(this.wardrobeTipX,this.wardrobeTipY,_loc4_);
                     }
                  }
               }
            }
            _loc2_++;
         }
      }
      
      public function clothDeleted() : void
      {
         if(this.lastCategory != null)
         {
            this.clearWardrobe();
            this.updateWardrobe();
         }
      }
      
      private function resetClothes(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this.charPreview.reset();
      }
      
      private function showWardrobe(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(this.lastCategory != null)
         {
            (getChildByName(this.lastCategory) as MovieClip).gotoAndStop(1);
         }
         this.toggleWardobe(param1.target);
      }
      
      private function toggleWardobe(param1:Object) : void
      {
         if(this.lastCategory != null)
         {
            (getChildByName(this.lastCategory) as MovieClip).gotoAndStop(2);
            if(this.lastCategory == param1.name)
            {
               this.lastCategory = null;
               TweenMax.to(this.wardrobe,0.3,{
                  "x":32,
                  "ease":Quad.easeOut,
                  "onComplete":this.clearWardrobe
               });
            }
            else
            {
               this.lastCategory = param1.name;
               MovieClip(param1).gotoAndStop(3);
               TweenMax.to(this.wardrobe,0.3,{
                  "x":32,
                  "ease":Quad.easeOut,
                  "onComplete":this.showCategory
               });
            }
         }
         else
         {
            this.lastCategory = param1.name;
            MovieClip(param1).gotoAndStop(3);
            this.showCategory();
         }
      }
      
      private function showCategory() : void
      {
         this.clearWardrobe();
         if(this.lastCategory == "btnShirt" || this.lastCategory == "btnPants" || this.lastCategory == "btnShoes")
         {
            this.rightDirection = true;
            TweenMax.to(this.wardrobe,0.3,{
               "x":246,
               "ease":Quad.easeOut
            });
         }
         else if(this.lastCategory == "btnHead" || this.lastCategory == "btnAccessory" || this.lastCategory == "btnCostume")
         {
            this.rightDirection = false;
            TweenMax.to(this.wardrobe,0.3,{
               "x":-180,
               "ease":Quad.easeOut
            });
         }
         this.lastPage = 1;
         this.updateWardrobe();
      }
      
      private function clearWardrobe() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         this.hideTip();
         this.wardrobe.btnPrevious.visible = false;
         if(this.wardrobe.btnPrevious.hasEventListener(MouseEvent.CLICK))
         {
            this.wardrobe.btnPrevious.addEventListener(MouseEvent.CLICK,this.btnPreviousClicked);
         }
         this.wardrobe.btnNext.visible = false;
         if(this.wardrobe.btnNext.hasEventListener(MouseEvent.CLICK))
         {
            this.wardrobe.btnNext.addEventListener(MouseEvent.CLICK,this.btnNextClicked);
         }
         if(this.wardrobe.sorter.hasEventListener(MouseEvent.CLICK))
         {
            this.wardrobe.sorter.addEventListener(MouseEvent.CLICK,this.btnSorterClicked);
         }
         this.pageTextField.visible = false;
         var _loc1_:int = 1;
         while(_loc1_ < 10)
         {
            _loc2_ = this.wardrobe.getChildByName("h" + _loc1_) as MovieClip;
            while(_loc2_.container.numChildren > 0)
            {
               _loc2_.container.removeChildAt(0);
            }
            _loc2_.index = -1;
            _loc2_.def = "";
            _loc2_.remove = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.numChildren)
            {
               _loc2_.closeButton.visible = false;
               _loc3_++;
            }
            if(_loc2_.hasEventListener(MouseEvent.ROLL_OVER))
            {
               _loc2_.removeEventListener(MouseEvent.ROLL_OVER,this.rollOverSlot);
            }
            if(_loc2_.hasEventListener(MouseEvent.ROLL_OUT))
            {
               _loc2_.removeEventListener(MouseEvent.ROLL_OUT,this.rollOutSlot);
            }
            if(_loc2_.hasEventListener(MouseEvent.CLICK))
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,this.elementSelected);
            }
            _loc2_.buttonMode = false;
            _loc2_.bg.gotoAndStop(1);
            _loc2_.bar.visible = false;
            _loc2_.barBg.visible = false;
            _loc2_.quantity.visible = false;
            _loc1_++;
         }
      }
      
      public function updateWardrobe() : void
      {
         var _loc2_:int = 0;
         var _loc3_:ICloth = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Bitmap = null;
         this.lastElementArray = Connectr.instance.clothModel.getElementsWithCategory(this.myClothes,this.lastCategory);
         if(this.lastElementArray.length == 0)
         {
            return;
         }
         if(this.sorter != null)
         {
            this.lastElementArray = this.lastElementArray.sort(this.sorter);
         }
         this.lastPageCount = Math.ceil(this.lastElementArray.length / 9);
         if(this.lastPage > this.lastPageCount)
         {
            this.lastPage = this.lastPageCount;
         }
         if(this.lastPageCount > 1)
         {
            this.wardrobe.btnPrevious.visible = true;
            this.wardrobe.btnPrevious.addEventListener(MouseEvent.CLICK,this.btnPreviousClicked);
            this.wardrobe.btnNext.visible = true;
            this.wardrobe.btnNext.addEventListener(MouseEvent.CLICK,this.btnNextClicked);
         }
         this.wardrobe.sorter.addEventListener(MouseEvent.CLICK,this.btnSorterClicked);
         this.pageTextField.visible = true;
         this.pageTextField.text = this.lastPage + " / " + this.lastPageCount;
         var _loc1_:int = 0;
         while(_loc1_ < 9)
         {
            if(this.lastElementArray.length > (this.lastPage - 1) * 9 + _loc1_)
            {
               _loc2_ = (this.lastPage - 1) * 9 + _loc1_;
               _loc3_ = this.lastElementArray[_loc2_];
               _loc4_ = this.wardrobe.getChildByName("h" + (_loc1_ + 1)) as MovieClip;
               if(_loc3_.previewLoaded)
               {
                  if((_loc5_ = new Bitmap((_loc3_.previewImage as Bitmap).bitmapData.clone())).width > 48)
                  {
                     _loc5_.height = _loc5_.height / _loc5_.width * 48;
                     _loc5_.width = 48;
                  }
                  _loc5_.x = -_loc5_.width / 2;
                  _loc5_.y = -_loc5_.height / 2;
                  if(_loc4_.container.numChildren == 0)
                  {
                     _loc4_.container.addChild(_loc5_);
                  }
               }
               else
               {
                  Connectr.instance.clothModel.loadClothPreview(_loc3_);
               }
               _loc4_.index = _loc2_;
               _loc4_.def = _loc3_.key;
               _loc4_.id = _loc3_.getPreviewID();
               _loc4_.addEventListener(MouseEvent.ROLL_OVER,this.rollOverSlot);
               _loc4_.addEventListener(MouseEvent.ROLL_OUT,this.rollOutSlot);
               _loc4_.addEventListener(MouseEvent.CLICK,this.elementSelected);
               if(this.isRemoveButtonActive(_loc3_))
               {
                  _loc4_.remove = 1;
                  _loc4_.closeButton.visible = true;
                  _loc4_.closeButton.addEventListener(MouseEvent.CLICK,this.removeButtonClicked);
               }
               else
               {
                  _loc4_.closeButton.visible = false;
                  _loc4_.remove = 0;
               }
               _loc4_.buttonMode = true;
               _loc4_.container.mouseChildren = false;
               _loc4_.container.mouseEnabled = false;
               if(this.charPreview.isActiveOnThePreview(_loc3_.getPreviewID()))
               {
                  _loc4_.bg.gotoAndStop(3);
               }
               else
               {
                  _loc4_.bg.gotoAndStop(2);
               }
               if(_loc3_.timeLeft > 0 && _loc3_.timeLeft != _loc3_.lifeTime)
               {
                  _loc4_.bar.visible = true;
                  _loc4_.barBg.visible = true;
                  _loc4_.barMask.width = 26 * _loc3_.timeLeft / _loc3_.lifeTime;
               }
               if(Boolean(_loc3_.quantity) && _loc3_.quantity > 1)
               {
                  _loc4_.quantity.visible = true;
                  _loc4_.quantityTextField.text = "x" + _loc3_.quantity;
               }
               _loc4_.quantity.mouseEnabled = _loc4_.bar.mouseEnabled = _loc4_.barBg.mouseEnabled = false;
               _loc4_.quantity.mouseChildren = _loc4_.bar.mouseChildren = _loc4_.barBg.mouseChildren = false;
            }
            _loc1_++;
         }
      }
      
      public function rollOverSlot(param1:Event) : void
      {
         this.showSlotTip(MovieClip(param1.target));
      }
      
      private function showSlotTip(param1:MovieClip, param2:Boolean = true) : void
      {
         var _loc3_:int = param1.x;
         var _loc4_:int = param1.y;
         var _loc5_:int = int(param1.index);
         var _loc6_:ICloth;
         if((_loc6_ = this.lastElementArray[_loc5_]) == null)
         {
            return;
         }
         if(param2)
         {
            this.showTip(_loc3_,_loc4_,_loc6_);
         }
         if(param1.remove == 0)
         {
            return;
         }
      }
      
      public function rollOutSlot(param1:Event) : void
      {
         this.hideTip();
      }
      
      private function hideTip() : void
      {
         if(this.wardrobeTip == null)
         {
            return;
         }
         this.wardrobe.removeChild(this.wardrobeTip);
         this.wardrobeTip = null;
      }
      
      private function showTip(param1:int, param2:int, param3:ICloth) : void
      {
         this.hideTip();
         this.wardrobeTip = this.getTip(param1,param2,param3);
         this.wardrobe.addChild(this.wardrobeTip);
      }
      
      public function getTip(param1:int, param2:int, param3:ICloth) : Sprite
      {
         this.wardrobeTipX = param1;
         this.wardrobeTipY = param2;
         this.wardrobeTipCloth = param3;
         param2 += 20;
         var _loc4_:Sprite = new Sprite();
         var _loc5_:TooltipTextField;
         (_loc5_ = new TooltipTextField()).sText.multiline = true;
         _loc5_.sText.wordWrap = true;
         _loc5_.sText.width = 140;
         _loc5_.x = 4;
         _loc5_.y = 4;
         var _loc6_:* = printf($("clothQuantityClip"),param3.quantity <= 1 ? 1 : param3.quantity,$(param3.getLanguageKey())) + "<br>";
         if(param3.lifeTime == -1)
         {
            _loc6_ += $("unlimitedItem");
         }
         else if(param3.timeLeft == -1)
         {
            _loc6_ += $("limitedItem") + " , " + printf($("leftTime"),StringUtil.secondToString(param3.lifeTime));
         }
         else
         {
            _loc6_ += printf($("leftTime"),StringUtil.secondToString(param3.timeLeft));
         }
         _loc5_.sText.htmlText = _loc6_;
         var _loc7_:ToolTipClip;
         (_loc7_ = new ToolTipClip()).width = _loc5_.sText.width + _loc5_.x * 2;
         _loc7_.height = _loc5_.sText.height + _loc5_.y * 2;
         TweenMax.to(_loc7_,0,{"dropShadowFilter":{
            "color":1381653,
            "alpha":0.5,
            "blurX":2,
            "blurY":2,
            "distance":2,
            "angle":45
         }});
         _loc4_.addChild(_loc7_);
         _loc4_.addChild(_loc5_);
         if(this.rightDirection)
         {
            _loc4_.x = param1;
         }
         else
         {
            _loc4_.x = param1 - _loc7_.width;
         }
         _loc4_.y = param2;
         return _loc4_;
      }
      
      private function btnPreviousClicked(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(this.lastPage <= 1)
         {
            return;
         }
         this.clearWardrobe();
         --this.lastPage;
         this.updateWardrobe();
      }
      
      private function btnNextClicked(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(this.lastPage >= this.lastPageCount)
         {
            return;
         }
         this.clearWardrobe();
         ++this.lastPage;
         this.updateWardrobe();
      }
      
      private function btnSorterClicked(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(this.sorter == null)
         {
            this.sorter = function(param1:ICloth, param2:ICloth):*
            {
               var _loc3_:Number = 0;
               if(param1.timeLeft > 0 && param1.timeLeft != param1.lifeTime)
               {
                  _loc3_ = param1.timeLeft / param1.lifeTime;
               }
               var _loc4_:Number = 0;
               if(param2.timeLeft > 0 && param2.timeLeft != param2.lifeTime)
               {
                  _loc4_ = param2.timeLeft / param2.lifeTime;
               }
               if(_loc3_ > _loc4_)
               {
                  return -1;
               }
               if(_loc3_ < _loc4_)
               {
                  return 1;
               }
               return 0;
            };
         }
         else
         {
            this.sorter = null;
         }
         e.stopPropagation();
         this.clearWardrobe();
         this.updateWardrobe();
      }
      
      private function elementSelected(param1:MouseEvent) : void
      {
         if(!(param1.target is MovieClip))
         {
            return;
         }
         var _loc2_:int = int(param1.target.parent.index);
         var _loc3_:ICloth = this.lastElementArray[_loc2_];
         var _loc4_:Array = _loc3_.key.split("_");
         var _loc5_:AlertVo = new AlertVo();
         if(param1.ctrlKey)
         {
            Logger.log(_loc3_.key);
            System.setClipboard(_loc3_.key);
         }
         if(_loc4_[1] == "0804")
         {
            _loc5_.alertType = AlertType.INFO;
            _loc5_.description = $("notAllowedIceScateCloth");
            Dispatcher.dispatchEvent(new AlertEvent(_loc5_));
            return;
         }
         this.charPreview.addCloth(_loc3_);
         this.updateWardrobe();
         this.showSlotTip(MovieClip(param1.target.parent),false);
      }
      
      private function isRemoveButtonActive(param1:ICloth) : Boolean
      {
         if(!this.charPreview.isActiveOnThePreview(param1.getPreviewID()))
         {
            return false;
         }
         if(param1.placeBit == ClothType.BIT00_BODY_BOTTOM)
         {
            return false;
         }
         if(param1.placeBit == ClothType.BIT01_BODY_MIDDLE)
         {
            return false;
         }
         if(param1.placeBit == ClothType.BIT02_BODY_TOP)
         {
            return false;
         }
         if(param1.placeBit == ClothType.BIT04_FOOT)
         {
            return false;
         }
         if(param1.placeBit == ClothType.BIT06_LEG_TOP)
         {
            return false;
         }
         if(param1.placeBit == ClothType.BIT09_SHIRT)
         {
            return false;
         }
         if(param1.placeBit == ClothType.BIT17_HAIR)
         {
            return false;
         }
         return true;
      }
      
      private function removeButtonClicked(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(!(param1.target is ShopBasketRemoveButton))
         {
            return;
         }
         var _loc2_:int = int(param1.target.parent.index);
         var _loc3_:ICloth = this.lastElementArray[_loc2_];
         if(!this.isRemoveButtonActive(_loc3_))
         {
            return;
         }
         this.charPreview.removeCloth(_loc3_.getPreviewID());
         this.updateWardrobe();
      }
      
      override public function dispose() : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.CHANGE_CLOTHES,this.onChangeResponse);
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.CLOTH_LIST,this.onClothResponse);
         if(this.charPreview)
         {
            this.charPreview.terminate();
         }
         TweenMax.to(this.wardrobe,0,{
            "x":32,
            "ease":Quad.easeOut,
            "onComplete":this.clearWardrobe
         });
         this.clearWardrobe();
         this.lastCategory = null;
         Connectr.instance.toolTipModel.removeTip(this.btnShirt);
         Connectr.instance.toolTipModel.removeTip(this.btnPants);
         Connectr.instance.toolTipModel.removeTip(this.btnShoes);
         Connectr.instance.toolTipModel.removeTip(this.btnHead);
         Connectr.instance.toolTipModel.removeTip(this.btnAccessory);
         Connectr.instance.toolTipModel.removeTip(this.btnCostume);
         TweenMax.killDelayedCallsTo(this.enableUI);
         Dispatcher.removeEventListener(PurchaseEvent.CLOTH_PURCHASE_COMPLETED,this.updateAll);
         super.dispose();
      }
   }
}

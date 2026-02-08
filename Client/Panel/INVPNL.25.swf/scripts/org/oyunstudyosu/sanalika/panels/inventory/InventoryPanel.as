package org.oyunstudyosu.sanalika.panels.inventory
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Quad;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.engine.ICharacter;
   import com.oyunstudyosu.enums.CharacterVariable;
   import com.oyunstudyosu.enums.ItemType;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.FarmEvent;
   import com.oyunstudyosu.events.InventoryEvent;
   import com.oyunstudyosu.events.PackPngEvent;
   import com.oyunstudyosu.events.PurchaseEvent;
   import com.oyunstudyosu.events.TransferEvent;
   import com.oyunstudyosu.inventory.InventoryProcessor;
   import com.oyunstudyosu.inventory.Item;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.local.arabic.ArabicInputManager;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.panel.PanelType;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.Logger;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.ui.Keyboard;
   import org.oyunstudyosu.assets.clips.LoadingAnimationSmall;
   import org.oyunstudyosu.assets.clips.ToolTipClip;
   import org.oyunstudyosu.sanalika.buttons.newButtons.RedButton;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.inventory.InventoryPanel")]
   public class InventoryPanel extends Panel
   {
       
      
      public var quantityBg:MovieClip;
      
      public var s0:Slot;
      
      public var s1:Slot;
      
      public var s10:Slot;
      
      public var s11:Slot;
      
      public var s12:Slot;
      
      public var s13:Slot;
      
      public var s14:Slot;
      
      public var s2:Slot;
      
      public var s3:Slot;
      
      public var s4:Slot;
      
      public var s5:Slot;
      
      public var s6:Slot;
      
      public var s7:Slot;
      
      public var s8:Slot;
      
      public var s9:Slot;
      
      public var txtHeader:TextField;
      
      private var currentPage:int;
      
      private var lastRolledOverSlotName:String;
      
      private var stack:Array;
      
      private var myItems:Array;
      
      private var gender:String;
      
      private var inventoryWaitingList:Array;
      
      public var btnNext:SimpleButton;
      
      public var btnPrevious:SimpleButton;
      
      public var btnClose:CloseButton;
      
      public var btnFarm:SimpleButton;
      
      public var btnSpecial:SimpleButton;
      
      public var btnCraft:SimpleButton;
      
      public var btnTool:SimpleButton;
      
      public var pageTextField:TextField;
      
      public var dropAreaTextField:TextField;
      
      public var btnHoldoff:RedButton;
      
      public var background:MovieClip;
      
      public var dropArea:MovieClip;
      
      public var mcDragger:MovieClip;
      
      public var selected:MovieClip;
      
      private var tipContainer:MovieClip;
      
      private var tip:Sprite;
      
      private var sTitle:STextField;
      
      private var processor:InventoryProcessor;
      
      private var cardProcessor:InventoryProcessor;
      
      private var vipCardContainer:VipCardContainer;
      
      private var cards:Array;
      
      private var draggingItem:Item;
      
      private var draggingItemID:int;
      
      private var totalPage:int;
      
      private var inputManager:ArabicInputManager;
      
      private var _inventoryState:String;
      
      public var lblPage:TextField;
      
      public var inpSearch:TextField;
      
      private var sort:String = "created_desc";
      
      public var sorter:MovieClip;
      
      public function InventoryPanel()
      {
         this.stack = new Array();
         super();
      }
      
      private function get inventoryState() : String
      {
         return this._inventoryState;
      }
      
      private function set inventoryState(param1:String) : void
      {
         if(this._inventoryState == param1)
         {
            return;
         }
         this.searchSetDefaultText();
         this._inventoryState = param1;
      }
      
      override public function init() : void
      {
         super.init();
         this.inpSearch.multiline = false;
         this.searchSetDefaultText();
         this.processor = new InventoryProcessor();
         this.cardProcessor = new InventoryProcessor();
         dragHandler = this.mcDragger;
         if(this.sTitle == null)
         {
            this.sTitle = TextFieldManager.convertAsArabicTextField(getChildByName("txtHeader") as TextField,false,true);
            this.sTitle.autoSize = TextFieldAutoSize.CENTER;
            this.sTitle.wordWrap = false;
            this.sTitle.mouseEnabled = false;
            this.dropAreaTextField = TextFieldManager.convertAsArabicTextField(this.dropArea.getChildByName("lbl_dropToOpen") as TextField);
            if(Connectr.instance.gameModel.language == "ar")
            {
               this.inputManager = new ArabicInputManager(this.inpSearch,this.inpSearch.defaultTextFormat);
            }
         }
         this.sTitle.text = $("Inventory");
         this.dropAreaTextField.text = $("dropheretoopen");
         this.dropArea.alpha = 0;
         this.inventoryState = "HAND";
         this.selected.alpha = 0;
         this.createUI();
         Connectr.instance.toolTipModel.addTip(this.sorter,$("sortLifeTime"));
         Connectr.instance.serviceModel.listenUserVariable(CharacterVariable.HAND_ITEM,this.onHandItemUpdate);
         this.onHandItemUpdate(Connectr.instance.serviceModel.sfs.mySelf);
         this.lblPage.addEventListener(FocusEvent.FOCUS_IN,this.focusIn);
         this.lblPage.addEventListener(FocusEvent.FOCUS_OUT,this.focusOut);
         this.lblPage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyPressed);
         this.lblPage.restrict = "0-9";
         if(Connectr.instance.avatarModel.holdedItem == 0 || !Connectr.instance.avatarModel.holdedItem)
         {
            this.btnHoldoff.visible = false;
         }
         this.inpSearch.addEventListener(FocusEvent.FOCUS_IN,this.focusInSearch);
         this.inpSearch.addEventListener(FocusEvent.FOCUS_OUT,this.focusOutSearch);
         this.inpSearch.addEventListener(KeyboardEvent.KEY_DOWN,this.onSearch);
         this.searchSetDefaultText();
      }
      
      private function onSorter(param1:MouseEvent) : void
      {
         if(this.sort == "created_desc")
         {
            this.sort = "lifeTime_asc";
            this.sorter.gotoAndStop(2);
            Connectr.instance.toolTipModel.removeTip(this.sorter);
            Connectr.instance.toolTipModel.addTip(this.sorter,$("sortNewToOld"));
         }
         else
         {
            this.sort = "created_desc";
            this.sorter.gotoAndStop(1);
            Connectr.instance.toolTipModel.removeTip(this.sorter);
            Connectr.instance.toolTipModel.addTip(this.sorter,$("sortLifeTime"));
         }
         this.getItemsByPage(this.currentPage);
      }
      
      protected function onSearch(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.getItemsByPage();
            stage.focus = null;
         }
      }
      
      protected function keyPressed(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.getItemsByPage(Number(this.lblPage.text));
            stage.focus = null;
         }
      }
      
      private function searchSetDefaultText() : void
      {
         if(this.inputManager != null)
         {
            this.inputManager.clearText();
            this.inputManager.addText($("Search"));
            this.inputManager.draw();
         }
         else
         {
            this.inpSearch.text = $("Search");
         }
      }
      
      protected function focusOutSearch(param1:FocusEvent = null) : void
      {
         if(this.inputManager != null)
         {
            this.inputManager.clearText();
            this.inputManager.addText($("Search"));
            this.inputManager.draw();
         }
         else if(this.inpSearch.text == "")
         {
            this.inpSearch.text = $("Search");
         }
      }
      
      protected function focusInSearch(param1:FocusEvent) : void
      {
         if(this.inputManager != null)
         {
            this.inpSearch.text = "";
            this.inputManager.changeFormat(this.inpSearch.defaultTextFormat);
         }
         else if(this.inpSearch.text == $("Search"))
         {
            this.inpSearch.text = "";
         }
      }
      
      protected function focusOut(param1:FocusEvent) : void
      {
         this.lblPage.text = this.currentPage + " / " + this.totalPage;
      }
      
      protected function focusIn(param1:FocusEvent) : void
      {
         this.lblPage.text = this.currentPage.toString();
      }
      
      private function onHandItemUpdate(param1:Object) : void
      {
         var _loc2_:User = param1 as User;
         if(Connectr.instance.engine.scene == null)
         {
            return;
         }
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:ICharacter = Connectr.instance.engine.scene.getAvatarById(_loc2_.name);
         if(!_loc3_.isMe)
         {
            return;
         }
         var _loc4_:UserVariable;
         if(_loc4_ = _loc2_.getVariable(CharacterVariable.HAND_ITEM))
         {
            this.btnHoldoff.visible = true;
         }
         else
         {
            this.btnHoldoff.visible = false;
         }
      }
      
      private function createUI() : void
      {
         this.inventoryWaitingList = [];
         this.currentPage = 1;
         this.tipContainer = new MovieClip();
         addChild(this.tipContainer);
         this.sorter.addEventListener(MouseEvent.CLICK,this.onSorter);
         Connectr.instance.toolTipModel.addTip(this.sorter,$("sortLifeTime"));
         this.btnFarm.addEventListener(MouseEvent.CLICK,this.btnFarmClicked);
         Connectr.instance.toolTipModel.addTip(this.btnFarm,$("farmITEMS"));
         this.btnSpecial.addEventListener(MouseEvent.CLICK,this.btnSpecialClicked);
         Connectr.instance.toolTipModel.addTip(this.btnSpecial,$("specialITEMS"));
         this.btnCraft.addEventListener(MouseEvent.CLICK,this.btnCraftClicked);
         Connectr.instance.toolTipModel.addTip(this.btnCraft,$("craftItems"));
         this.btnClose.addEventListener(MouseEvent.CLICK,this.closeClicked);
         this.btnHoldoff.addEventListener(MouseEvent.CLICK,this.holdOffItem);
         this.btnNext.addEventListener(MouseEvent.CLICK,this.nextPage);
         this.btnPrevious.addEventListener(MouseEvent.CLICK,this.previousPage);
         this.btnHoldoff.setText($("RELEASE"));
         Dispatcher.addEventListener(PurchaseEvent.HAND_ITEM_PURCHASE_COMPLETED,this.updateAll);
         Dispatcher.addEventListener(TransferEvent.TRANSFER_COMPLETED,this.transferAction);
         Dispatcher.addEventListener(TransferEvent.TRANSFER_CANCELLED,this.transferCancelled);
         Dispatcher.addEventListener(InventoryEvent.UPDATE_INVENTORY,this.updateInventory);
         Dispatcher.addEventListener(FarmEvent.IMPLANTED,this.getItemsByPage);
         Dispatcher.addEventListener(FarmEvent.HARVEST,this.getItemsByPage);
         Connectr.instance.itemModel.addPngListener(this.packEventFunction);
         if(!Connectr.instance.avatarModel.guest)
         {
            Connectr.instance.serviceModel.requestData("cardlist",{},this.cardListResponse);
         }
         this.getItemsByPage(this.currentPage);
      }
      
      public function getItemsBySearch(param1:String) : void
      {
         if(param1 != "")
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.HAND_ITEM_LIST,{
               "search":param1,
               "page":1,
               "sort":this.sort
            },this.inventoryAnswer);
         }
      }
      
      public function getItemsByPage(param1:int = 1) : void
      {
         if(param1 == 0)
         {
            param1 = 1;
         }
         else if(param1 > this.totalPage && this.totalPage != 0)
         {
            param1 = this.totalPage;
         }
         var _loc2_:String = this.inputManager != null ? this.inputManager.getText() : this.inpSearch.text;
         if(_loc2_ == $("Search"))
         {
            _loc2_ = "";
         }
         this.currentPage = param1;
         if(this.inventoryState == "HAND")
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.HAND_ITEM_LIST,{
               "search":_loc2_,
               "page":param1,
               "sort":this.sort
            },this.inventoryAnswer);
         }
         else if(this.inventoryState == "SPECIAL")
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.SPECIAL_ITEM_LIST,{
               "search":_loc2_,
               "page":param1,
               "sort":this.sort
            },this.inventoryAnswer);
         }
         else if(this.inventoryState == "FARM")
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.FARM_ITEM_LIST,{
               "search":_loc2_,
               "page":param1,
               "sort":this.sort
            },this.inventoryAnswer);
         }
      }
      
      private function updateInventory(param1:InventoryEvent) : void
      {
         this.updateAll();
      }
      
      private function transferAction(param1:Object) : void
      {
         this.updateAll();
      }
      
      private function transferCancelled(param1:Object) : void
      {
      }
      
      private function updateAll(param1:PurchaseEvent = null) : void
      {
         this.getItemsByPage();
      }
      
      private function inventoryAnswer(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SPECIAL_ITEM_LIST,this.inventoryAnswer);
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.FARM_ITEM_LIST,this.inventoryAnswer);
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.HAND_ITEM_LIST,this.inventoryAnswer);
         if(param1.errorCode)
         {
            close();
            return;
         }
         this.btnNext.mouseEnabled = true;
         this.btnPrevious.mouseEnabled = true;
         this.gender = Connectr.instance.avatarModel.gender;
         this.myItems = this.processor.processInventory(param1.items.list);
         this.totalPage = param1.totalPages;
         this.updateUI();
         show();
      }
      
      private function cardListResponse(param1:Object) : void
      {
         this.vipCardContainer = new VipCardContainer();
         this.cards = this.cardProcessor.processInventory(param1.items);
         this.vipCardContainer.init(this.cards);
         var _loc2_:int = -56;
         if(this.cards.length > 0)
         {
            _loc2_ = -(Math.ceil(this.cards.length / 5) * 50) - 6;
         }
         this.addChildAt(this.vipCardContainer,0);
         TweenMax.to(this.vipCardContainer,0.5,{
            "delay":0.5,
            "x":_loc2_,
            "ease":Back.easeOut
         });
         Connectr.instance.serviceModel.removeRequestData("cardlist",this.cardListResponse);
      }
      
      private function packEventFunction(param1:PackPngEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc2_:int = this.inventoryWaitingList.indexOf(param1.key);
         if(_loc2_ < 0)
         {
            return;
         }
         this.inventoryWaitingList.splice(_loc2_,1);
         var _loc3_:int = 0;
         while(_loc3_ < 15)
         {
            _loc4_ = "s" + _loc3_;
            if((_loc5_ = this.getChildByName(_loc4_) as MovieClip).holder.numChildren != 0)
            {
               if((_loc6_ = _loc5_.holder.getChildAt(0)).clip == param1.key)
               {
                  while(_loc5_.holder.numChildren > 0)
                  {
                     _loc5_.holder.removeChildAt(0);
                  }
                  (_loc7_ = Connectr.instance.itemModel.getItemImage(this.gender + "_" + param1.key)).id = _loc6_.id;
                  _loc7_.clip = _loc6_.clip;
                  TweenMax.to(_loc7_,0,{"glowFilter":{
                     "color":11730777,
                     "alpha":0.5,
                     "blurX":10,
                     "blurY":10,
                     "strength":1
                  }});
                  if(_loc7_.width > 40)
                  {
                     _loc7_.height = _loc7_.height / _loc7_.width * 40;
                     _loc7_.width = 40;
                  }
                  _loc5_.holder.addChild(_loc7_);
               }
            }
            _loc3_++;
         }
      }
      
      public function updateUI() : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:String = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Item = null;
         var _loc1_:int = int(this.myItems.length);
         if(this.currentPage < 1)
         {
            this.currentPage = 1;
         }
         else if(this.currentPage > this.totalPage)
         {
            this.currentPage = this.totalPage;
         }
         this.lblPage.text = this.currentPage + " / " + this.totalPage;
         if(this.currentPage <= this.totalPage && this.currentPage > 0)
         {
            this.btnNext.visible = true;
            this.btnPrevious.visible = true;
         }
         else
         {
            this.btnNext.visible = false;
            this.btnPrevious.visible = false;
         }
         this.clearStack();
         _loc2_ = 0;
         while(_loc2_ < 15)
         {
            _loc3_ = getChildByName("s" + _loc2_) as MovieClip;
            if(_loc3_.holder.numChildren != 0)
            {
               this.addStack(_loc3_.holder.getChildAt(0));
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 15)
         {
            _loc4_ = "s" + _loc2_;
            _loc3_ = getChildByName(_loc4_) as MovieClip;
            while(_loc3_.holder.numChildren > 0)
            {
               _loc3_.holder.removeChildAt(0);
            }
            _loc3_.mouseChildren = false;
            if(_loc2_ < _loc1_)
            {
               if((_loc6_ = this.getVisibleItem(this.gender,_loc2_)) != null)
               {
                  if((_loc5_ = Connectr.instance.itemModel.getItemImage(this.gender + "_" + _loc6_.clip)) == null)
                  {
                     this.inventoryWaitingList.push(_loc6_.clip);
                     _loc5_ = new LoadingAnimationSmall();
                  }
                  _loc5_.id = _loc6_.productID;
                  _loc5_.clip = _loc6_.clip;
                  if(_loc5_.width > 30)
                  {
                     _loc5_.height = _loc5_.height / _loc5_.width * 30;
                     _loc5_.width = 30;
                  }
                  _loc3_.holder.addChild(_loc5_);
                  if(_loc6_.quantity > 1)
                  {
                     _loc3_.quantity.visible = true;
                     _loc3_.quantityTextField.text = "x" + _loc6_.quantity;
                  }
                  else
                  {
                     _loc3_.quantity.visible = false;
                  }
                  if(_loc6_.lifeTime > -1)
                  {
                     _loc3_.bar.visible = true;
                     _loc3_.barbg.visible = true;
                     if(_loc6_.timeLeft / _loc6_.lifeTime > 1)
                     {
                        _loc3_.bar.width = _loc3_.barbg.width;
                     }
                     else if(_loc6_.timeLeft > 0 && _loc6_.timeLeft != _loc6_.lifeTime)
                     {
                        _loc3_.bar.width = _loc3_.barbg.width * _loc6_.timeLeft / _loc6_.lifeTime;
                     }
                     else
                     {
                        _loc3_.bar.visible = false;
                        _loc3_.barbg.visible = false;
                     }
                  }
                  else
                  {
                     _loc3_.bar.visible = false;
                     _loc3_.barbg.visible = false;
                  }
                  if(this.lastRolledOverSlotName != null && _loc4_ == this.lastRolledOverSlotName)
                  {
                     _loc3_.bg.gotoAndStop("s2");
                  }
                  else
                  {
                     _loc3_.bg.gotoAndStop("s1");
                  }
                  _loc3_.id = _loc6_.productID;
                  _loc3_.item = _loc6_;
                  _loc3_.buttonMode = true;
                  _loc3_.addEventListener(MouseEvent.ROLL_OVER,this.rollOverSlot);
                  _loc3_.addEventListener(MouseEvent.ROLL_OUT,this.rollOutSlot);
                  _loc3_.addEventListener(MouseEvent.CLICK,this.mouseClickSlot);
                  _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownSlot);
               }
               else
               {
                  _loc3_.buttonMode = false;
                  this.clear(_loc3_);
               }
            }
            else
            {
               _loc3_.buttonMode = false;
               this.clear(_loc3_);
            }
            _loc3_ = null;
            _loc2_++;
         }
      }
      
      private function clearStack() : void
      {
         this.stack = new Array();
      }
      
      private function searchStack(param1:String) : MovieClip
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.stack.length)
         {
            if(MovieClip(this.stack[_loc3_]).id == param1)
            {
               _loc2_ = MovieClip(this.stack[_loc3_]);
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function addStack(param1:MovieClip) : void
      {
         this.stack.push(param1);
      }
      
      private function getVisibleItem(param1:String, param2:int) : Item
      {
         var _loc6_:Item = null;
         var _loc3_:int = 0;
         var _loc4_:Item = null;
         var _loc5_:int = 0;
         while(_loc5_ < this.myItems.length)
         {
            if((_loc6_ = this.myItems[_loc5_]).quantity > 0)
            {
               _loc3_++;
            }
            if(_loc3_ == param2 + 1)
            {
               _loc4_ = _loc6_;
               break;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function clear(param1:MovieClip) : void
      {
         param1.id = null;
         param1.clip = null;
         param1.quantity.visible = false;
         param1.bar.visible = false;
         param1.barbg.visible = false;
         param1.bg.gotoAndStop("s0");
         param1.removeEventListener(MouseEvent.ROLL_OVER,this.rollOverSlot);
         param1.removeEventListener(MouseEvent.ROLL_OUT,this.rollOutSlot);
         param1.removeEventListener(MouseEvent.CLICK,this.mouseClickSlot);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownSlot);
      }
      
      public function mouseClickSlot(param1:Event) : void
      {
         var item:Item;
         var type:int;
         var vo:AlertVo = null;
         var e:Event = param1;
         var slot:Slot = e.target as Slot;
         slot.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveSlot);
         item = slot.item;
         try
         {
            if(!Connectr.instance.engine.scene.myChar.canIUseHandItem())
            {
               vo = new AlertVo();
               vo.alertType = AlertType.TOOLTIP;
               vo.description = $("Can not use hand item");
               Dispatcher.dispatchEvent(new AlertEvent(vo));
               return;
            }
         }
         catch(error:Error)
         {
            Logger.log("mouseClickSlot : " + error.getStackTrace(),true);
         }
         type = int(Connectr.instance.itemModel.getItemType(this.gender + "_" + item.clip));
         if(ItemType.isViewable(type))
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.USE_HAND_ITEM,{"id":item.id},this.useHandItemResponse);
         }
         else
         {
            vo = new AlertVo();
            vo.alertType = AlertType.TOOLTIP;
            if(this.inventoryState != "FARM")
            {
               vo.description = $("Not an hand item");
            }
            else
            {
               vo.description = $("Farm Item");
            }
            Dispatcher.dispatchEvent(new AlertEvent(vo));
         }
      }
      
      private function useHandItemResponse(param1:Object) : void
      {
         var _loc2_:AlertVo = null;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.USE_HAND_ITEM,this.useHandItemResponse);
         if(param1.errorMessage != undefined)
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.ERROR;
            _loc2_.description = param1.errorMessage;
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
         }
         close();
      }
      
      public function holdOffItem(param1:Event) : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.USE_HAND_ITEM,{"id":0},this.useHandItemResponse);
      }
      
      public function mouseDownSlot(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveSlot);
         Connectr.instance.layerModel.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageUp);
      }
      
      protected function onStageUp(param1:MouseEvent) : void
      {
         if(!this.draggingItem)
         {
            return;
         }
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageUp);
         if(this.dropArea.hitTestPoint(param1.stageX,param1.stageY) && this.dropArea.alpha == 1)
         {
            this.draggingItemID = this.draggingItem.id;
            Connectr.instance.serviceModel.requestData(RequestDataKey.OPEN_PACKAGE,{
               "id":this.draggingItemID,
               "command":"show"
            },this.showPackageResponse);
         }
         TweenMax.to(this.dropArea,1,{
            "y":240,
            "alpha":0,
            "ease":Quad.easeOut
         });
         var _loc2_:TransferEvent = new TransferEvent(TransferEvent.STOP_DRAGGING);
         _loc2_.mouseEvent = param1;
         Dispatcher.dispatchEvent(_loc2_);
         this.draggingItem = null;
      }
      
      private function showPackageResponse(param1:Object) : void
      {
         var _loc2_:PanelVO = null;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.OPEN_PACKAGE,this.showPackageResponse);
         if(!param1.errorCode)
         {
            _loc2_ = new PanelVO();
            _loc2_.name = "PackageListPanel";
            _loc2_.type = PanelType.STATIC;
            _loc2_.params = {};
            _loc2_.params.command = "show";
            _loc2_.params.draggingItemID = this.draggingItemID;
            _loc2_.params.packageData = param1;
            Connectr.instance.panelModel.openPanel(_loc2_);
            close();
         }
      }
      
      public function mouseMoveSlot(param1:Event) : void
      {
         var _loc5_:AlertVo = null;
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveSlot);
         var _loc3_:Item = this.getItemById(_loc2_.id);
         if(_loc3_ == null)
         {
            return;
         }
         if(_loc3_.lifeTime > -1 && _loc3_.subType != "PLANT" && _loc3_.subType != "PACKAGE")
         {
            if(_loc3_.timeLeft / _loc3_.lifeTime < 1)
            {
               (_loc5_ = new AlertVo()).alertType = AlertType.TOOLTIP;
               _loc5_.description = $("Not Transferable");
               Dispatcher.dispatchEvent(new AlertEvent(_loc5_));
               return;
            }
         }
         this.draggingItem = _loc3_;
         var _loc4_:TransferEvent;
         (_loc4_ = new TransferEvent(TransferEvent.START_DRAGGING)).draggingItem = _loc3_;
         Dispatcher.dispatchEvent(_loc4_);
         if(_loc3_.subType == "PACKAGE")
         {
            TweenMax.to(this.dropArea,0.3,{
               "y":282,
               "alpha":1,
               "ease":Quad.easeOut
            });
         }
      }
      
      public function rollOverSlot(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         this.lastRolledOverSlotName = _loc2_.name;
         _loc2_.bg.gotoAndStop("s2");
         var _loc3_:Item = _loc2_.item as Item;
         if(_loc3_ == null)
         {
            return;
         }
         this.showTip(_loc2_.x,_loc2_.y,_loc3_);
      }
      
      public function getItemById(param1:String) : Item
      {
         var _loc2_:Item = null;
         for each(_loc2_ in this.myItems)
         {
            if(_loc2_.productID.toString() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function rollOutSlot(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.bg.gotoAndStop("s1");
         this.lastRolledOverSlotName = null;
         this.hideTip();
      }
      
      public function nextPage(param1:MouseEvent) : void
      {
         if(this.currentPage < this.totalPage)
         {
            this.btnNext.mouseEnabled = false;
            this.btnPrevious.mouseEnabled = false;
            ++this.currentPage;
            this.getItemsByPage(this.currentPage);
         }
      }
      
      public function previousPage(param1:MouseEvent) : void
      {
         if(this.currentPage > 1)
         {
            this.btnNext.mouseEnabled = false;
            this.btnPrevious.mouseEnabled = false;
            --this.currentPage;
            this.getItemsByPage(this.currentPage);
         }
      }
      
      private function btnFarmClicked(param1:MouseEvent) : void
      {
         this.selected.x = this.btnFarm.x;
         if(this.inventoryState == "FARM")
         {
            this.selected.alpha = 0;
            this.inventoryState = "HAND";
         }
         else
         {
            this.selected.alpha = 1;
            this.inventoryState = "FARM";
         }
         this.getItemsByPage(1);
      }
      
      private function btnSpecialClicked(param1:MouseEvent) : void
      {
         this.selected.x = this.btnSpecial.x;
         if(this.inventoryState == "SPECIAL")
         {
            this.selected.alpha = 0;
            this.inventoryState = "HAND";
         }
         else
         {
            this.selected.alpha = 1;
            this.inventoryState = "SPECIAL";
         }
         this.getItemsByPage(1);
      }
      
      private function btnCraftClicked(param1:MouseEvent) : void
      {
         var _loc2_:PanelVO = new PanelVO();
         _loc2_.name = "CraftPanel";
         Sanalika.instance.panelModel.openPanel(_loc2_);
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         close();
      }
      
      public function clearItems() : void
      {
         var _loc1_:MovieClip = null;
         this.searchSetDefaultText();
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.closeClicked);
         this.btnHoldoff.removeEventListener(MouseEvent.CLICK,this.holdOffItem);
         this.btnNext.removeEventListener(MouseEvent.CLICK,this.nextPage);
         this.btnPrevious.removeEventListener(MouseEvent.CLICK,this.previousPage);
         Connectr.instance.itemModel.removePngListener(this.packEventFunction);
         this.btnFarm.removeEventListener(MouseEvent.CLICK,this.btnFarmClicked);
         this.btnSpecial.removeEventListener(MouseEvent.CLICK,this.btnSpecialClicked);
         this.lblPage.removeEventListener(FocusEvent.FOCUS_OUT,this.focusOutSearch);
         this.lblPage.removeEventListener(FocusEvent.FOCUS_IN,this.focusInSearch);
         this.lblPage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyPressed);
         this.inpSearch.removeEventListener(FocusEvent.FOCUS_OUT,this.focusOutSearch);
         this.inpSearch.removeEventListener(FocusEvent.FOCUS_IN,this.focusInSearch);
         this.inpSearch.removeEventListener(KeyboardEvent.KEY_DOWN,this.onSearch);
         Connectr.instance.toolTipModel.removeTip(this.btnFarm);
         Connectr.instance.toolTipModel.removeTip(this.btnSpecial);
         Dispatcher.removeEventListener(PurchaseEvent.HAND_ITEM_PURCHASE_COMPLETED,this.updateAll);
         Dispatcher.removeEventListener(TransferEvent.TRANSFER_COMPLETED,this.transferAction);
         Dispatcher.removeEventListener(TransferEvent.TRANSFER_CANCELLED,this.transferCancelled);
         Dispatcher.removeEventListener(InventoryEvent.UPDATE_INVENTORY,this.updateInventory);
         this.tipContainer.removeChildren();
         this.removeChild(this.tipContainer);
         this.tipContainer = null;
         this.vipCardContainer.dispose();
         this.removeChild(this.vipCardContainer);
         this.vipCardContainer = null;
         var _loc2_:int = 0;
         while(_loc2_ < 15)
         {
            _loc1_ = getChildByName("s" + _loc2_) as MovieClip;
            while(_loc1_.holder.numChildren > 0)
            {
               _loc1_.holder.removeChildAt(0);
            }
            this.clear(_loc1_);
            _loc2_++;
         }
      }
      
      private function hideTip() : void
      {
         if(this.tip != null && this.tipContainer.contains(this.tip))
         {
            this.tipContainer.removeChild(this.tip);
         }
      }
      
      private function showTip(param1:int, param2:int, param3:Item) : void
      {
         this.hideTip();
         this.tip = this.getTip(param1,param2,param3);
         this.tipContainer.addChild(this.tip);
      }
      
      public function getTip(param1:int, param2:int, param3:Item) : Sprite
      {
         var _loc4_:Sprite = new Sprite();
         var _loc5_:TooltipTextField;
         (_loc5_ = new TooltipTextField()).sText.multiline = true;
         _loc5_.sText.wordWrap = true;
         _loc5_.sText.width = 140;
         _loc5_.x = 4;
         _loc5_.y = 4;
         _loc5_.sText.htmlText = param3.getInfo();
         _loc5_.sText.height = _loc5_.sText.textHeight + 4;
         if(_loc5_.sText.numLines == 1)
         {
            _loc5_.sText.height = _loc5_.sText.textHeight;
         }
         var _loc6_:ToolTipClip;
         (_loc6_ = new ToolTipClip()).width = _loc5_.sText.width + _loc5_.x * 2;
         _loc6_.height = _loc5_.sText.height + _loc5_.y * 2;
         TweenMax.to(_loc6_,0,{"dropShadowFilter":{
            "color":1381653,
            "alpha":0.5,
            "blurX":2,
            "blurY":2,
            "distance":2,
            "angle":45
         }});
         _loc4_.addChild(_loc6_);
         _loc4_.addChild(_loc5_);
         _loc4_.x = param1 - (_loc4_.width - 55) / 2;
         _loc4_.y = param2 - _loc4_.height - 5;
         return _loc4_;
      }
      
      override public function dispose() : void
      {
         var _loc1_:Item = null;
         for each(_loc1_ in this.myItems)
         {
            _loc1_.dispose();
         }
         this.myItems = [];
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.USE_HAND_ITEM,this.useHandItemResponse);
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.HAND_ITEM_LIST,this.inventoryAnswer);
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.FARM_ITEM_LIST,this.inventoryAnswer);
         Dispatcher.removeEventListener(PurchaseEvent.HAND_ITEM_PURCHASE_COMPLETED,this.updateAll);
         Dispatcher.removeEventListener(TransferEvent.TRANSFER_COMPLETED,this.transferAction);
         Dispatcher.removeEventListener(InventoryEvent.UPDATE_INVENTORY,this.updateInventory);
         Dispatcher.removeEventListener(FarmEvent.IMPLANTED,this.getItemsByPage);
         Dispatcher.removeEventListener(FarmEvent.HARVEST,this.getItemsByPage);
         this.clearItems();
         this.lastRolledOverSlotName = null;
         super.dispose();
      }
   }
}

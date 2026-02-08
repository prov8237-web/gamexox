package org.oyunstudyosu.sanalika.panels.smiley
{
   import com.oyunstudyosu.auth.Permission;
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.SmileyEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import org.oyunstudyosu.sanalika.buttons.newButtons.Arrow;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.smiley.SmileyPanel")]
   public class SmileyPanel extends Panel
   {
       
      
      public var background:MovieClip;
      
      public var header:MovieClip;
      
      public var lbl_Title:TextField;
      
      public var txtPage:TextField;
      
      private var itemArr:Array;
      
      private var column:int = 5;
      
      private var row:int = 6;
      
      private var defaultX:int = 16;
      
      private var defaultY:int = 78;
      
      private var margin:int = 5;
      
      private var _currentPage:int;
      
      private var _totalPage:int;
      
      private var listData:Array;
      
      private var listLen:uint;
      
      public var pageTextField:TextField;
      
      public var btnNext:Arrow;
      
      public var btnPrev:Arrow;
      
      public var btnClose:CloseButton;
      
      public var mcDragger:MovieClip;
      
      private var sTitle:STextField;
      
      public function SmileyPanel()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         dragHandler = this.mcDragger;
         if(this.sTitle == null)
         {
            this.sTitle = TextFieldManager.convertAsArabicTextField(getChildByName("lbl_Title") as TextField,false,true);
            this.sTitle.autoSize = TextFieldAutoSize.CENTER;
            this.sTitle.wordWrap = false;
            this.sTitle.mouseEnabled = false;
            this.pageTextField = TextFieldManager.createNoneLanguageTextfield(getChildByName("txtPage") as TextField);
         }
         this.sTitle.text = $("Head Symbols");
         this.setDefaults();
         this.addItems();
         Connectr.instance.serviceModel.requestData(RequestDataKey.SMILEY_LIST,{},this.onSmileyList);
         this.btnNext.addEventListener(MouseEvent.CLICK,this.changePage);
         this.btnPrev.addEventListener(MouseEvent.CLICK,this.changePage);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.closePanel);
         Dispatcher.addEventListener(SmileyEvent.LIST_UPDATED,this.onSmileyListUpdated);
      }
      
      private function onSmileyList(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SMILEY_LIST,this.onSmileyList);
         this.listData = param1.smilies;
      }
      
      private function onSmileyListUpdated(param1:Event) : void
      {
         this.listData = Connectr.instance.smileyModel.list;
         this.getService();
         show();
      }
      
      protected function closePanel(param1:MouseEvent) : void
      {
         close();
      }
      
      protected function changePage(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "btnNext")
         {
            ++this.currentPage;
         }
         else if(param1.currentTarget.name == "btnPrev")
         {
            --this.currentPage;
         }
      }
      
      private function getService() : void
      {
         this.listLen = this.listData.length;
         this.totalPage = Math.ceil(this.listLen / (this.row * this.column));
         this.currentPage = 1;
      }
      
      private function setDefaults() : void
      {
         this.pageTextField.text = "";
         this.btnNext.mouseEnabled = this.btnPrev.mouseEnabled = false;
      }
      
      private function addItems() : void
      {
         var _loc1_:SmileyItem = null;
         this.itemArr = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.column * this.row)
         {
            _loc1_ = new SmileyItem();
            _loc1_.x = this.defaultX + (_loc1_.width + this.margin) * (_loc2_ % this.column);
            _loc1_.y = this.defaultY + (_loc1_.height + this.margin) * Math.floor(_loc2_ / this.column);
            _loc1_.visible = true;
            _loc1_.positionId = _loc2_;
            addChild(_loc1_);
            this.itemArr.push(_loc1_);
            _loc1_.addEventListener(MouseEvent.CLICK,this.itemClicked);
            _loc2_++;
         }
      }
      
      protected function itemClicked(param1:MouseEvent) : void
      {
         close();
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      public function set currentPage(param1:int) : void
      {
         if(param1 <= 1)
         {
            this._currentPage = 1;
            this.btnNext.mouseEnabled = true;
            this.btnPrev.mouseEnabled = false;
            this.btnPrev.alpha = 0.5;
            this.btnNext.alpha = 1;
         }
         else if(param1 >= this.totalPage)
         {
            this._currentPage = this.totalPage;
            this.btnNext.mouseEnabled = false;
            this.btnPrev.mouseEnabled = true;
            this.btnPrev.alpha = 1;
            this.btnNext.alpha = 0.5;
         }
         else
         {
            this._currentPage = param1;
            this.btnNext.mouseEnabled = true;
            this.btnPrev.mouseEnabled = true;
            this.btnPrev.alpha = 1;
            this.btnNext.alpha = 1;
         }
         if(this.totalPage == 1)
         {
            this.btnNext.mouseEnabled = this.btnPrev.mouseEnabled = false;
            this.btnPrev.alpha = 0.5;
            this.btnNext.alpha = 0.5;
         }
         this.pageTextField.text = this.currentPage.toString() + " / " + this.totalPage.toString();
         this.updateItems();
      }
      
      private function updateItems() : void
      {
         var _loc2_:SmileyItem = null;
         var _loc4_:ItemVo = null;
         var _loc1_:uint = uint((this.currentPage - 1) * (this.column * this.row));
         var _loc3_:uint = _loc1_;
         while(_loc3_ < _loc1_ + this.column * this.row)
         {
            _loc2_ = this.itemArr[_loc3_ - _loc1_];
            if(_loc3_ < this.listLen)
            {
               _loc2_.visible = true;
               (_loc4_ = new ItemVo()).key = this.listData[_loc3_].metaKey;
               _loc4_.id = this.listData[_loc3_].id;
               _loc4_.sorting = this.listData[_loc3_].sorting;
               _loc4_.permission = new Permission(this.listData[_loc3_].requirements);
               _loc2_.vo = _loc4_;
            }
            else
            {
               _loc2_.visible = false;
               _loc2_.vo = null;
            }
            _loc3_++;
         }
      }
      
      public function get totalPage() : int
      {
         return this._totalPage;
      }
      
      public function set totalPage(param1:int) : void
      {
         this._totalPage = param1;
      }
      
      override public function dispose() : void
      {
         var _loc1_:SmileyItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.itemArr.length)
         {
            _loc1_ = this.itemArr[_loc2_] as SmileyItem;
            _loc1_.removeEventListener(MouseEvent.CLICK,this.itemClicked);
            removeChild(_loc1_);
            _loc1_.dispose();
            _loc2_++;
         }
         this.itemArr = null;
         this.listData = null;
         this.btnNext.removeEventListener(MouseEvent.CLICK,this.changePage);
         this.btnPrev.removeEventListener(MouseEvent.CLICK,this.changePage);
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.closePanel);
         Dispatcher.removeEventListener(SmileyEvent.LIST_UPDATED,this.onSmileyListUpdated);
         super.dispose();
      }
   }
}

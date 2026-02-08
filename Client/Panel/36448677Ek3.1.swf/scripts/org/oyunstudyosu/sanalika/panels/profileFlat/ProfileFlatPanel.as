package org.oyunstudyosu.sanalika.panels.profileFlat
{
   import com.greensock.TweenMax;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.panel.PanelEvent;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.sanalika.buttons.newButtons.Arrow;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.profileFlat.ProfileFlatPanel")]
   public class ProfileFlatPanel extends Panel
   {
       
      
      public var txtHeader:TextField;
      
      public var txtInfo:TextField;
      
      public var container:MovieClip;
      
      public var background:MovieClip;
      
      private var currentX:int;
      
      private var currentY:int;
      
      private var badgeCount:int;
      
      public var btnNext:Arrow;
      
      public var btnPrev:Arrow;
      
      public var currentItemIndex:int;
      
      public var list:Object;
      
      public var listLength:int;
      
      public var txtPage:TextField;
      
      public var btnClose:CloseButton;
      
      public var sFlatName:STextField;
      
      public var sFlatInfo:STextField;
      
      public var profileFlatData:ProfileFlatData;
      
      public function ProfileFlatPanel()
      {
         super();
      }
      
      override public function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:AlertVo = null;
         super.init();
         this.currentItemIndex = 0;
         this.listLength = 0;
         dragHandler = this.background;
         this.list = data.params.list;
         if(this.sFlatName == null)
         {
            this.sFlatName = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtHeader") as TextField,true,false);
            this.sFlatInfo = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtInfo") as TextField,true,false);
         }
         this.sFlatName.mouseEnabled = false;
         this.btnPrev.mouseEnabled = false;
         this.btnNext.mouseEnabled = false;
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose);
         this.btnNext.addEventListener(MouseEvent.CLICK,this.onNext);
         this.btnPrev.addEventListener(MouseEvent.CLICK,this.onPrev);
         TweenMax.to(this.btnPrev,0,{"colorMatrixFilter":{"saturation":0}});
         TweenMax.to(this.btnNext,0,{"colorMatrixFilter":{"saturation":1}});
         this.txtPage = this.getChildByName("txtPage") as TextField;
         this.container = this.getChildByName("container") as MovieClip;
         this.listLength = this.list.length;
         if(this.listLength > 0)
         {
            this.btnNext.mouseEnabled = true;
            _loc1_ = 0;
            while(_loc1_ < this.listLength)
            {
               this.profileFlatData = new ProfileFlatData();
               this.profileFlatData.title = this.list[_loc1_].title;
               this.profileFlatData.type = this.list[_loc1_].type;
               this.profileFlatData.imgPath = this.list[_loc1_].imgPath;
               _loc1_++;
            }
            this.txtPage.text = "1 / " + this.listLength;
            visible = true;
            this.loadAsset(this.list[this.currentItemIndex].id,this.list[this.currentItemIndex].imgPath);
            this.sFlatName.centerText = this.list[this.currentItemIndex].title;
         }
         else
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.TOOLTIP;
            _loc2_.description = $("noFlat");
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
            this.dispose();
         }
      }
      
      private function loadAsset(param1:String, param2:String) : void
      {
         var _loc3_:AssetRequest = null;
         if(param2 == "")
         {
            this.sFlatInfo.centerText = $("FlatImageDoesNotCreatedYet");
         }
         else
         {
            this.sFlatInfo.visible = true;
            this.sFlatInfo.centerText = $("FlatImageLoading");
            _loc3_ = new AssetRequest();
            _loc3_.name = param1;
            _loc3_.context = Connectr.instance.domainModel.assetContext;
            _loc3_.assetId = "/cp/rm/v2/" + param1 + "?instance=" + Connectr.instance.gameModel.serverName + "&ip=" + param2 + "&t=f";
            _loc3_.loadedFunction = this.imgLoaded;
            Connectr.instance.assetModel.request(_loc3_);
         }
      }
      
      private function imgLoaded(param1:IAssetRequest) : void
      {
         this.sFlatInfo.text = "";
         var _loc2_:Bitmap = param1.display as Bitmap;
         var _loc3_:Number = 600 / _loc2_.bitmapData.width;
         _loc2_.smoothing = true;
         if(_loc2_.bitmapData.width > 200 || _loc2_.bitmapData.height > 200)
         {
            _loc2_.width = _loc2_.bitmapData.width * _loc3_ * 0.7;
            _loc2_.height = _loc2_.bitmapData.height * _loc3_ * 0.7;
         }
         this.container.addChild(_loc2_);
         this.container.x = this.background.width / 2 - this.container.width / 2;
         this.container.y = this.background.height / 2 - this.container.height / 2 - 8;
      }
      
      protected function onPrev(param1:MouseEvent) : void
      {
         if(this.currentItemIndex > 0)
         {
            --this.currentItemIndex;
            this.btnNext.mouseEnabled = true;
            TweenMax.to(this.btnNext,0,{"colorMatrixFilter":{"saturation":1}});
            this.txtPage.text = this.currentItemIndex + 1 + " / " + this.listLength;
            this.sFlatName.centerText = this.list[this.currentItemIndex].title;
            if(this.currentItemIndex == 0)
            {
               this.btnPrev.mouseEnabled = false;
               TweenMax.to(this.btnPrev,0,{"colorMatrixFilter":{"saturation":0}});
            }
            while(this.container.numChildren > 0)
            {
               this.container.removeChildAt(0);
            }
            this.loadAsset(this.list[this.currentItemIndex].id,this.list[this.currentItemIndex].imgPath);
         }
         else
         {
            this.btnPrev.mouseEnabled = false;
            TweenMax.to(this.btnPrev,0,{"colorMatrixFilter":{"saturation":0}});
         }
      }
      
      protected function onClose(param1:MouseEvent) : void
      {
         Dispatcher.dispatchEvent(new PanelEvent(PanelEvent.CLOSE,this));
         this.dispose();
      }
      
      protected function onNext(param1:MouseEvent) : void
      {
         if(this.currentItemIndex + 1 < this.listLength)
         {
            ++this.currentItemIndex;
            this.btnPrev.mouseEnabled = true;
            TweenMax.to(this.btnPrev,0,{"colorMatrixFilter":{"saturation":1}});
            this.txtPage.text = this.currentItemIndex + 1 + " / " + this.listLength;
            this.sFlatName.centerText = this.list[this.currentItemIndex].title;
            if(this.currentItemIndex + 1 == this.listLength)
            {
               this.btnNext.mouseEnabled = false;
               TweenMax.to(this.btnNext,0,{"colorMatrixFilter":{"saturation":0}});
            }
            while(this.container.numChildren > 0)
            {
               this.container.removeChildAt(0);
            }
            this.loadAsset(this.list[this.currentItemIndex].id,this.list[this.currentItemIndex].imgPath);
         }
         else
         {
            TweenMax.to(this.btnNext,0,{"colorMatrixFilter":{"saturation":0}});
            this.btnNext.mouseEnabled = false;
         }
      }
      
      override public function dispose() : void
      {
         while(this.container.numChildren > 0)
         {
            this.container.removeChildAt(0);
         }
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.onClose);
         this.btnNext.removeEventListener(MouseEvent.CLICK,this.onNext);
         this.btnPrev.removeEventListener(MouseEvent.CLICK,this.onPrev);
         super.dispose();
      }
   }
}

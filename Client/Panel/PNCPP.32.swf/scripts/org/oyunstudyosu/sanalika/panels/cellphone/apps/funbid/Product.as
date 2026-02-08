package org.oyunstudyosu.sanalika.panels.cellphone.apps.funbid
{
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.enums.BalanceType;
   import com.oyunstudyosu.enums.GenderType;
   import com.oyunstudyosu.enums.ModuleType;
   import com.oyunstudyosu.enums.ProductType;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.ProfileEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.StringUtil;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funbid.Product")]
   public class Product extends MovieClip
   {
       
      
      public var inputBg:MovieClip;
      
      public var txtProductName:TextField;
      
      public var lblBid:TextField;
      
      public var lblBidderAvatarName:TextField;
      
      public var mcDiamond:MovieClip;
      
      public var mcSanil:MovieClip;
      
      public var txtPrice:TextField;
      
      public var txtAvatarName:TextField;
      
      public var txtCount:TextField;
      
      public var sProductName:TextField;
      
      public var sLblBid:TextField;
      
      public var sLblBidAvatarName:TextField;
      
      public var request:AssetRequest;
      
      public var currentBidAvatarID:String;
      
      public var displayContainer:MovieClip;
      
      public function Product()
      {
         super();
         this.visible = false;
         this.displayContainer = new MovieClip();
         this.displayContainer.x = 10;
         this.displayContainer.y = 50;
         addChild(this.displayContainer);
      }
      
      public function init(param1:Object) : void
      {
         if(this.sProductName == null)
         {
            this.sProductName = TextFieldManager.convertAsArabicTextField(this.txtProductName,false);
            this.sLblBid = TextFieldManager.convertAsArabicTextField(this.lblBid,false);
            this.sLblBidAvatarName = TextFieldManager.convertAsArabicTextField(this.lblBidderAvatarName,false);
            this.sLblBid.text = $("BID");
            this.sLblBidAvatarName.text = $("BIDDER");
         }
         var _loc2_:String = String(param1.cl);
         this.sProductName.text = $("pro_" + _loc2_);
         var _loc3_:String = "";
         var _loc4_:String = String(param1.cd);
         var _loc5_:int = int(param1.lt);
         if(_loc4_ == "MIDNIGHT")
         {
            _loc3_ = $("MIDNIGHT");
         }
         else if(_loc4_ == "IMMORTAL")
         {
            _loc3_ = $(_loc4_);
         }
         else
         {
            _loc3_ = StringUtil.secondToString(_loc5_) + " " + $(_loc4_);
         }
         this.txtAvatarName.text = "---NA---";
         this.txtCount.text = "0";
         if(param1.cu == BalanceType.DIAMOND)
         {
            this.mcDiamond.visible = true;
            this.mcSanil.visible = false;
            this.txtPrice.text = "DIAMOND";
         }
         else
         {
            this.mcDiamond.visible = false;
            this.mcSanil.visible = true;
            this.txtPrice.text = "SANIL";
         }
         this.txtAvatarName.addEventListener(MouseEvent.CLICK,this.openProfile);
         this.productAsset(param1.ty,_loc2_,param1.cf,param1.cm);
         this.visible = true;
      }
      
      private function openProfile(param1:MouseEvent) : void
      {
         var _loc2_:ProfileEvent = null;
         if(this.currentBidAvatarID != null)
         {
            _loc2_ = new ProfileEvent(ProfileEvent.SHOW_PROFILE);
            _loc2_.avatarID = this.currentBidAvatarID;
            Dispatcher.dispatchEvent(_loc2_);
         }
      }
      
      public function dispose() : void
      {
         this.currentBidAvatarID = null;
         this.txtAvatarName.removeEventListener(MouseEvent.CLICK,this.openProfile);
         this.displayContainer.removeChildren();
      }
      
      private function productAsset(param1:String, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:* = null;
         this.request = new AssetRequest();
         if(param1 == ProductType.HAND_ITEM || param1 == ProductType.FARM_ITEM)
         {
            _loc5_ = "/static/items/inventory/" + param2 + ".png";
         }
         else if(param1 == ProductType.CLOTH_ITEM)
         {
            if(Connectr.instance.avatarModel.gender == GenderType.MALE)
            {
               _loc5_ = "/static/items/clothes/" + "r_" + Connectr.instance.avatarModel.gender + "_" + param2 + "_" + param4 + ".png";
            }
            else
            {
               _loc5_ = "/static/items/clothes/" + "r_" + Connectr.instance.avatarModel.gender + "_" + param2 + "_" + param3 + ".png";
            }
         }
         else
         {
            _loc5_ = "/static/items/furnitures/" + "r_" + param2 + ".png";
         }
         this.request.type = ModuleType.PNG;
         this.request.assetId = _loc5_;
         this.request.loadedFunction = this.productImageLoaded;
         this.request.priority = 97;
         Connectr.instance.assetModel.request(this.request);
      }
      
      private function productImageLoaded(param1:AssetRequest) : void
      {
         this.displayContainer.removeChildren();
         var _loc2_:Bitmap = param1.display as Bitmap;
         _loc2_.smoothing = true;
         this.displayContainer.addChild(_loc2_);
         _loc2_.x = 50 - _loc2_.width / 2;
         _loc2_.y = 50 - _loc2_.height / 2;
         param1.dispose();
      }
   }
}

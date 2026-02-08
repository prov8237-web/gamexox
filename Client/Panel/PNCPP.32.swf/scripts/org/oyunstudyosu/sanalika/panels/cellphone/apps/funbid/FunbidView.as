package org.oyunstudyosu.sanalika.panels.cellphone.apps.funbid
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.greensock.easing.Quad;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.HudEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import com.smartfoxserver.v2.entities.Room;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funbid.FunbidView")]
   public class FunbidView extends CoreMovieClip
   {
       
      
      public var flakes:MovieClip;
      
      public var mcMsg:MovieClip;
      
      public var lblError:TextField;
      
      public var sLblError:STextField;
      
      public var mcProduct:Product;
      
      public var mcBid:Bid;
      
      private var sTxtMessage:STextField;
      
      public function FunbidView()
      {
         super();
      }
      
      override public function added() : void
      {
         this.makeItFun(3);
         if(this.sTxtMessage == null)
         {
            this.sLblError = TextFieldManager.convertAsArabicTextField(getChildByName("lblError") as TextField,false,false);
            this.sTxtMessage = TextFieldManager.convertAsArabicTextField(this.mcMsg.getChildByName("txtMessage") as TextField,true,true);
            this.sTxtMessage.autoSize = TextFieldAutoSize.LEFT;
            this.sTxtMessage.wordWrap = true;
            this.sTxtMessage.multiline = true;
            this.mcProduct = new Product();
            this.mcProduct.y = 46;
            this.mcProduct.x = 12;
            this.addChild(this.mcProduct);
            this.mcBid = new Bid();
            this.mcBid.y = 300;
            this.mcBid.x = 12;
            this.addChild(this.mcBid);
         }
         Dispatcher.addEventListener(HudEvent.SHOW_FUNBID,this.joinFunbid);
         Dispatcher.addEventListener(HudEvent.HIDE_FUNBID,this.leaveFunbid);
         Connectr.instance.serviceModel.listenExtension("startextension",this.onStartExtension);
         Connectr.instance.serviceModel.listenExtension("stopextension",this.onStopExtension);
         Connectr.instance.serviceModel.listenExtension("funbid.showProduct",this.onShowProduct);
         Connectr.instance.serviceModel.listenExtension("funbid.hideProduct",this.onHideProduct);
         Connectr.instance.serviceModel.listenExtension("funbid.message",this.onMessage);
         Connectr.instance.serviceModel.listenExtension("funbid.bidStart",this.onBidStart);
         Connectr.instance.serviceModel.listenExtension("funbid.bidResult",this.onBidResult);
         Connectr.instance.serviceModel.listenExtension("funbid.finalizeBid",this.onFinalizeBid);
         this.clearRequests();
         this.showMessage("greetings");
         Connectr.instance.serviceModel.requestData(RequestDataKey.FUNBID_JOIN,{},this.onJoinResponse);
      }
      
      private function onStartExtension(param1:Object) : void
      {
         if(param1.key == "FunbidExtension")
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.FUNBID_JOIN,{},this.onJoinResponse);
         }
      }
      
      private function onStopExtension(param1:Object) : void
      {
         if(param1.key == "FunbidExtension")
         {
            this.closeView();
         }
      }
      
      private function onJoinResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.FUNBID_JOIN,this.onJoinResponse);
         if(param1.errorCode != null)
         {
            return;
         }
         this.sTxtMessage.visible = true;
         if(param1.status == "ready")
         {
            this.showMessage("funbidStarting");
         }
         else if(param1.status == "started")
         {
            this.showMessage("funbidStarted");
         }
         else
         {
            this.showMessage("funbidNotActive");
         }
      }
      
      public function bid(param1:int) : void
      {
         var _loc3_:AlertVo = null;
         var _loc2_:Room = Connectr.instance.serviceModel.sfs.getRoomByName("funbid");
         if(_loc2_ == null)
         {
            _loc3_ = new AlertVo();
            _loc3_.alertType = AlertType.TOOLTIP;
            _loc3_.description = $("funbidRoomFailed");
            Dispatcher.dispatchEvent(new AlertEvent(_loc3_));
            return;
         }
         this.mcBid.disableButton();
         Connectr.instance.serviceModel.requestData(RequestDataKey.FUNBID_BID,{"bid":param1},this.onBidResponse,_loc2_);
      }
      
      private function onBidResponse(param1:Object) : void
      {
         var _loc2_:AlertVo = null;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.FUNBID_BID,this.onBidResponse);
         if(param1.errorCode == "INSUFFICIENT_BALANCE")
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.TOOLTIP;
            _loc2_.description = Sanalika.instance.localizationModel.translate("Not enough balance.");
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
         }
         if(param1.errorCode != null)
         {
            this.mcBid.enableButton();
            return;
         }
         if(param1.status == "bidOk")
         {
            this.sLblError.text = "success";
         }
         else
         {
            this.sLblError.text = param1.status;
            this.mcBid.enableButton();
         }
      }
      
      private function onShowProduct(param1:Object) : void
      {
         this.mcProduct.init(param1);
         this.showMessage("SHOWPRODUCT");
         this.clearRequests();
      }
      
      private function onHideProduct(param1:Object) : void
      {
         this.mcProduct.dispose();
         this.removeChild(this.mcProduct);
         this.mcProduct = null;
         this.clearRequests();
      }
      
      private function onMessage(param1:Object) : void
      {
         var _loc2_:String = String(param1.m);
         this.showMessage(_loc2_);
         this.clearRequests();
      }
      
      private function onBidStart(param1:Object) : void
      {
         this.mcBid.init();
         this.showMessage("BIDSTART");
         this.clearRequests();
      }
      
      private function onBidResult(param1:Object) : void
      {
         this.makeItFun(10);
         this.mcProduct.currentBidAvatarID = param1.bai;
         this.mcProduct.txtPrice.text = Std.string(param1.bam);
         this.mcProduct.txtAvatarName.text = param1.ban;
         this.mcProduct.txtCount.text = Std.string(param1.bc);
         this.mcBid.dispose();
         this.showMessage("SHOWBIDRESULT");
         this.clearRequests();
      }
      
      private function onFinalizeBid(param1:Object) : void
      {
         this.makeItFun(10);
         this.mcProduct.currentBidAvatarID = param1.bai;
         this.mcProduct.txtPrice.text = Std.string(param1.bam);
         this.mcProduct.txtAvatarName.text = param1.ban;
         this.mcBid.dispose();
         this.showMessage("FINALIZEBID");
         this.clearRequests();
      }
      
      private function joinFunbid(param1:HudEvent) : void
      {
         this.clearRequests();
         Connectr.instance.serviceModel.requestData(RequestDataKey.FUNBID_JOIN,{},this.onJoinResponse);
      }
      
      private function leaveFunbid(param1:HudEvent) : void
      {
         this.clearFlakes();
         this.showMessage("funbidNotActive");
         if(this.mcProduct)
         {
            this.mcProduct.dispose();
         }
         this.clearRequests();
      }
      
      private function showMessage(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         TweenMax.to(this.mcMsg,0,{"colorTransform":{
            "tint":6174129,
            "tintAmount":1
         }});
         this.sTxtMessage.htmlText = $(param1);
         this.mcMsg.bgTxt.x = this.sTxtMessage.x - 2;
         this.mcMsg.bgTxt.y = this.sTxtMessage.y + 2;
         this.mcMsg.bgTxt.width = this.sTxtMessage.width + 2;
         this.mcMsg.bgTxt.height = this.sTxtMessage.height + 2;
         this.mcMsg.tipTxt.y = this.mcMsg.bgTxt.height + this.mcMsg.bgTxt.y - 1;
         this.mcMsg.tipTxt.x = this.mcMsg.bgTxt.x + 4;
         if(this.mcProduct != null && this.mcProduct.visible)
         {
            _loc2_ = int(this.mcProduct.y + this.mcProduct.height) + 10;
            TweenMax.to(this.mcMsg,1,{
               "y":_loc2_,
               "ease":Quad.easeOut
            });
         }
         else
         {
            _loc3_ = 20 + int((230 - this.mcMsg.height) / 2);
            TweenMax.to(this.mcMsg,1,{
               "y":_loc3_,
               "ease":Quad.easeOut
            });
         }
         TweenMax.to(this.mcMsg,1,{"colorTransform":{
            "tint":0,
            "tintAmount":0
         }});
      }
      
      public function closeView(param1:MouseEvent = null) : void
      {
         this.clearFlakes();
         if(this.mcProduct)
         {
            this.mcProduct.dispose();
         }
         TweenMax.to(this,0.2,{
            "x":0,
            "ease":Linear.easeNone
         });
      }
      
      private function makeItFun(param1:int) : void
      {
         var _loc3_:Flake = null;
         this.clearFlakes();
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            _loc3_ = new Flake();
            this.flakes.addChild(_loc3_);
            _loc2_++;
         }
      }
      
      private function clearFlakes() : void
      {
         var _loc1_:Flake = null;
         while(this.flakes.numChildren > 0)
         {
            if(Std.isOfType(this.flakes.getChildAt(0),Flake))
            {
               _loc1_ = this.flakes.getChildAt(0) as Flake;
               _loc1_.dispose();
            }
            this.flakes.removeChildAt(0);
         }
      }
      
      public function clearRequests() : void
      {
         this.sLblError.text = "";
      }
      
      public function dispose() : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.FUNBID_JOIN,this.onJoinResponse);
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.FUNBID_BID,this.onBidResponse);
         Connectr.instance.serviceModel.removeExtension("startextension",this.onStartExtension);
         Connectr.instance.serviceModel.removeExtension("stopextension",this.onStopExtension);
         Connectr.instance.serviceModel.removeExtension("funbid.showProduct",this.onShowProduct);
         Connectr.instance.serviceModel.removeExtension("funbid.hideProduct",this.onHideProduct);
         Connectr.instance.serviceModel.removeExtension("funbid.message",this.onMessage);
         Connectr.instance.serviceModel.removeExtension("funbid.bidStart",this.onBidStart);
         Connectr.instance.serviceModel.removeExtension("funbid.bidResult",this.onBidResult);
         Connectr.instance.serviceModel.removeExtension("funbid.finalizeBid",this.onFinalizeBid);
         this.clearFlakes();
         Dispatcher.removeEventListener(HudEvent.SHOW_FUNBID,this.joinFunbid);
         Dispatcher.removeEventListener(HudEvent.HIDE_FUNBID,this.leaveFunbid);
         this.clearRequests();
      }
   }
}

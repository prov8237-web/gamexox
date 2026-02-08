package org.oyunstudyosu.sanalika.panels.complaint
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.buddy.BuddyRequestTypes;
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.enums.LanguageKeys;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.panel.PanelType;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.complaint.ComplaintPanel")]
   public class ComplaintPanel extends Panel
   {
       
      
      public var background:MovieClip;
      
      public var txtHeader:TextField;
      
      private var complaintData:ComplaintData;
      
      private var complaintItem:ComplaintItem;
      
      private var currentOrder:int;
      
      private var listLength:int;
      
      private var list:Array;
      
      private var sTxtHeader:STextField;
      
      public var btnClose:CloseButton;
      
      public var iext:IExtensionMock;
      
      public var mcDragger:MovieClip;
      
      public var mainContainer:MovieClip;
      
      public var panelTxt:TextField;
      
      private var mySec:int = 20;
      
      public function ComplaintPanel()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         if(this.sTxtHeader == null)
         {
            this.sTxtHeader = TextFieldManager.convertAsArabicTextField(getChildByName("txtHeader") as TextField,true,true);
            this.panelTxt = TextFieldManager.convertAsArabicTextField(this.panelTxt);
         }
         this.sTxtHeader.htmlText = $("complaintPanelHeader");
         dragHandler = this.mcDragger;
         this.btnClose.addEventListener(MouseEvent.CLICK,this.closeClicked);
         this.getList();
         show();
      }
      
      private function refreshList() : void
      {
         TweenMax.killDelayedCallsTo(this.getList);
         TweenMax.delayedCall(20,this.getList);
      }
      
      private function reportAction(param1:Event) : void
      {
         this.currentOrder = (param1.target as ComplaintItem).order;
         this.refreshList();
         Connectr.instance.serviceModel.requestData(RequestDataKey.COMPLAINT_ACTION,{
            "id":this.list[this.currentOrder].id,
            "reportedAvatarID":this.list[this.currentOrder].reportedAvatarID,
            "isPervert":(param1.target as ComplaintItem).isPervert,
            "isAbuse":(param1.target as ComplaintItem).isAbuse,
            "isCorrect":(param1.target as ComplaintItem).isCorrect
         },this.moveNext);
      }
      
      private function warnReporter(param1:Event) : void
      {
         var _loc2_:PanelVO = new PanelVO();
         _loc2_.name = "BanPanel";
         _loc2_.params = {};
         _loc2_.params.action = "notice";
         _loc2_.params.avatarID = this.list[this.currentOrder].reporterAvatarID;
         _loc2_.params.banCount = 0;
         _loc2_.params.duration = 0;
         _loc2_.type = PanelType.HUD;
         Connectr.instance.panelModel.openPanel(_loc2_);
      }
      
      private function warnAction(param1:Event) : void
      {
         var _loc2_:PanelVO = new PanelVO();
         _loc2_.name = "BanPanel";
         _loc2_.params = {};
         _loc2_.params.action = "notice";
         _loc2_.params.avatarID = this.list[this.currentOrder].reportedAvatarID;
         _loc2_.params.banCount = this.list[this.currentOrder].banCount;
         _loc2_.params.duration = this.list[this.currentOrder].nextBanMin;
         _loc2_.type = PanelType.HUD;
         Connectr.instance.panelModel.openPanel(_loc2_);
         this.reportAction(param1);
      }
      
      private function locationAction(param1:Event) : void
      {
         var _loc2_:Object = {};
         _loc2_.avatarID = this.list[this.currentOrder].reportedAvatarID;
         Connectr.instance.serviceModel.requestData(BuddyRequestTypes.BUDDY_LOCATE,_loc2_,this.locateResponse);
      }
      
      private function locateResponse(param1:Object) : void
      {
         var _loc2_:AlertVo = null;
         Connectr.instance.serviceModel.removeRequestData(BuddyRequestTypes.BUDDY_LOCATE,this.locateResponse);
         if(Boolean(param1.universe) && Boolean(param1.street))
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.INFO;
            _loc2_.title = LanguageKeys.SECURITY_LOCATE_TITLE;
            _loc2_.description = $("universe_" + param1.universe) + " - " + $("room_" + param1.street);
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
         }
      }
      
      private function moveNext(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.COMPLAINT_ACTION,this.moveNext);
         trace("currentOrder",this.currentOrder);
         if(param1.errorCode)
         {
            this.getList();
            return;
         }
         this.mainContainer.getChildByName("complaint" + this.currentOrder).visible = false;
         if(this.currentOrder + 1 == this.listLength)
         {
            this.getList();
         }
         else
         {
            this.mainContainer.getChildByName("complaint" + (this.currentOrder + 1)).visible = true;
            TweenMax.from(this.mainContainer.getChildByName("complaint" + (this.currentOrder + 1)),0.2,{
               "y":-100,
               "ease":Quad.easeInOut
            });
         }
      }
      
      private function getList() : void
      {
         TweenMax.killDelayedCallsTo(this.getList);
         this.panelTxt.htmlText = "loading...";
         Connectr.instance.serviceModel.requestData(RequestDataKey.COMPLAINT_LIST,{},this.complaintListResponse);
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         close();
      }
      
      private function updateText() : void
      {
         --this.mySec;
         this.panelTxt.htmlText = "No report... Will retry in " + this.mySec + " sec!<br/><br/><font color=\'#DD0000\'>" + $("knightNotice") + "</font>";
         TweenMax.killDelayedCallsTo(1,this.updateText);
         if(this.mySec > 1)
         {
            TweenMax.delayedCall(1,this.updateText);
         }
      }
      
      private function complaintListResponse(param1:Object) : void
      {
         this.mySec = 20;
         trace("complaintListResponse");
         this.panelTxt.htmlText = "";
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.COMPLAINT_LIST,this.complaintListResponse);
         while(this.mainContainer.numChildren)
         {
            this.complaintItem = this.mainContainer.getChildAt(0) as ComplaintItem;
            this.complaintItem.dispose();
            this.mainContainer.removeChildAt(0);
         }
         if(!param1.complaints)
         {
            TweenMax.delayedCall(20,this.getList);
            this.panelTxt.htmlText = "Error... Will retry in " + this.mySec + " sec!";
            return;
         }
         this.list = param1.complaints;
         if(!this.list || this.list.length == 0)
         {
            TweenMax.delayedCall(20,this.getList);
            TweenMax.delayedCall(1,this.updateText);
            this.panelTxt.htmlText = "No report... Will retry in " + this.mySec + " sec!";
            return;
         }
         this.listLength = this.list.length;
         var _loc2_:int = 0;
         while(_loc2_ < this.listLength)
         {
            this.complaintData = new ComplaintData();
            this.complaintData.complaintID = this.list[_loc2_].id;
            this.complaintData.message = this.list[_loc2_].message;
            this.complaintData.comment = this.list[_loc2_].comment;
            this.complaintData.reporterAvatarID = this.list[_loc2_].reporterAvatarID;
            this.complaintData.reportedAvatarID = this.list[_loc2_].reportedAvatarID;
            this.complaintData.isPervert = this.list[_loc2_].isPervert;
            this.complaintData.banCount = this.list[_loc2_].banCount;
            this.complaintData.nextBanMin = this.list[_loc2_].nextBanMin;
            this.complaintItem = new ComplaintItem(this.complaintData);
            this.complaintItem.name = "complaint" + _loc2_;
            this.complaintItem.order = _loc2_;
            this.mainContainer.addChild(this.complaintItem);
            this.complaintItem.init();
            this.complaintItem.addEventListener("next",this.reportAction);
            this.complaintItem.addEventListener("warn",this.warnAction);
            this.complaintItem.addEventListener("warnReporter",this.warnReporter);
            this.complaintItem.addEventListener("location",this.locationAction);
            _loc2_++;
         }
         this.refreshList();
         this.mainContainer.getChildByName("complaint0").visible = true;
         TweenMax.from(this.mainContainer.getChildByName("complaint0"),0.2,{
            "y":-100,
            "ease":Quad.easeInOut
         });
      }
      
      override public function dispose() : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.COMPLAINT_LIST,this.complaintListResponse);
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.closeClicked);
         var _loc1_:int = 0;
         while(_loc1_ < this.mainContainer.numChildren)
         {
            this.complaintItem = this.mainContainer.getChildAt(_loc1_) as ComplaintItem;
            this.complaintItem.dispose();
            _loc1_++;
         }
         TweenMax.killDelayedCallsTo(this.getList);
         super.dispose();
      }
   }
}

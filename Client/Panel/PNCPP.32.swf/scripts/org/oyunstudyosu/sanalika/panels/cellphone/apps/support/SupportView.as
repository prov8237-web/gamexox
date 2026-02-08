package org.oyunstudyosu.sanalika.panels.cellphone.apps.support
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertResponse;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.combobox.ComboBoxVo;
   import com.oyunstudyosu.components.MobileScroll;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.tooltip.TooltipAlign;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   import org.oyunstudyosu.components.combobox.CoreComboBox;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.support.SupportView")]
   public class SupportView extends CoreMovieClip
   {
      
      public static const CLOSED:String = "CLOSED";
      
      public static const REPLIED:String = "REPLIED";
      
      public static const OPEN:String = "OPEN";
       
      
      public var txtHeader:TextField;
      
      private var myItem:SupportItem;
      
      private var myMessage:SupportMessage;
      
      private var myListID:Object;
      
      public var headerBg:MovieClip;
      
      public var sHeader:STextField;
      
      public var request:AssetRequest;
      
      private var scrollContainer:MobileScroll;
      
      private var scrollContainerV:MobileScroll;
      
      public var supportNew:SupportNew;
      
      public var btnNew:SimpleButton;
      
      public var btnCloseTicket:SimpleButton;
      
      private var selectedTicketID:int;
      
      private var selectedTicketState:String;
      
      private var comboBox:CoreComboBox;
      
      public function SupportView()
      {
         super();
      }
      
      override public function added() : void
      {
         this.scrollContainer = new MobileScroll();
         this.scrollContainer.y = this.headerBg.height + this.headerBg.y;
         if(this.sHeader == null)
         {
            this.sHeader = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtHeader") as TextField,false);
         }
         this.addChild(this.scrollContainer);
         this.headerBg.addEventListener(MouseEvent.CLICK,this.closeView);
         this.headerBg.buttonMode = true;
         this.btnCloseTicket.visible = false;
         Connectr.instance.serviceModel.requestData(RequestDataKey.SUPPORT_TICKET_GET,{"type":"list"},this.onListInit);
      }
      
      public function openView(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = null;
         _loc2_ = (param1.target as SupportItem).data;
         this.selectedTicketID = _loc2_.id;
         this.selectedTicketState = _loc2_.state;
         this.sHeader.text = $(_loc2_.supportSubject);
         this.scrollContainerV = new MobileScroll();
         this.scrollContainerV.y = this.headerBg.height + this.headerBg.y;
         this.scrollContainerV.x = 230;
         this.addChild(this.scrollContainerV);
         if(_loc2_.state == REPLIED || _loc2_.state == OPEN)
         {
            this.btnCloseTicket.visible = true;
            this.btnCloseTicket.addEventListener(MouseEvent.CLICK,this.closeTicketConfirm);
            Connectr.instance.toolTipModel.addTip(this.btnCloseTicket,$("Close Support Ticket"),TooltipAlign.ALIGN_MIDDLE_LEFT);
            this.setChildIndex(this.btnCloseTicket,this.numChildren - 1);
         }
         else
         {
            this.btnCloseTicket.visible = false;
         }
         Connectr.instance.serviceModel.requestData(RequestDataKey.SUPPORT_TICKET_MESSAGES_GET,{"ticketId":(param1.target as SupportItem).id},this.onMessagesInit);
      }
      
      public function closeView(param1:MouseEvent = null) : void
      {
         this.selectedTicketID = 0;
         this.selectedTicketState = "";
         if(this.comboBox)
         {
            this.comboBox.visible = false;
         }
         if(this.scrollContainerV)
         {
            this.scrollContainerV.dispose();
            this.supportNew = null;
         }
         if(this.supportNew)
         {
            this.supportNew.visible = false;
         }
         TweenMax.to(this,0.3,{
            "x":0,
            "ease":Linear.easeIn
         });
      }
      
      private function addComboBoxView(param1:MovieClip, param2:int, param3:int, param4:Array) : void
      {
         var _loc6_:ComboBoxVo = null;
         var _loc5_:Vector.<ComboBoxVo> = new Vector.<ComboBoxVo>();
         var _loc7_:int = int(param4.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            (_loc6_ = new ComboBoxVo()).label = $(param4[_loc8_].nameTransKey);
            _loc6_.data = param4[_loc8_];
            _loc6_.bgW = 210;
            _loc6_.index = _loc8_;
            _loc5_.push(_loc6_);
            _loc8_++;
         }
         this.comboBox = new CoreComboBox("down");
         this.comboBox.dataProvider = _loc5_;
         this.comboBox.rowCount = 5;
         param1.addChild(this.comboBox);
         this.comboBox.x = param2;
         this.comboBox.y = param3;
         this.comboBox.selectedIndex = 0;
      }
      
      private function removeComboBoxView(param1:MovieClip) : void
      {
         if(this.comboBox)
         {
            if(param1.getChildIndex(this.comboBox) > 0)
            {
               param1.removeChild(this.comboBox);
            }
            this.comboBox = null;
         }
      }
      
      private function onListInit(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SUPPORT_TICKET_GET,this.onListInit);
         this.placeItems(param1);
         this.scrollContainer.init(230,330,4);
      }
      
      private function onList(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SUPPORT_TICKET_GET,this.onList);
         this.placeItems(param1);
         this.scrollContainer.setPositions();
      }
      
      private function placeItems(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SUPPORT_TICKET_GET,this.onList);
         this.scrollContainer.disposeItems(this.openView);
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < param1.tickets.length)
         {
            this.myItem = new SupportItem();
            this.myItem.id = param1.tickets[_loc3_].id;
            this.myItem.data = param1.tickets[_loc3_];
            this.myItem.addEventListener(MouseEvent.CLICK,this.openView);
            this.myItem.buttonMode = true;
            this.scrollContainer.listContainer.addChild(this.myItem);
            this.myItem.y = _loc3_ * this.myItem.height + this.headerBg.height;
            if(param1.tickets[_loc3_].state == "OPEN" || param1.tickets[_loc3_].state == "REPLIED")
            {
               _loc2_ = false;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            this.btnNew.addEventListener(MouseEvent.CLICK,this.openNew);
            this.btnNew.visible = true;
            Connectr.instance.toolTipModel.addTip(this.btnNew,$("New Support Ticket"),TooltipAlign.ALIGN_MIDDLE_LEFT);
            this.setChildIndex(this.btnNew,this.numChildren - 1);
         }
         else
         {
            this.btnNew.removeEventListener(MouseEvent.CLICK,this.openNew);
            this.btnNew.visible = false;
            Connectr.instance.toolTipModel.removeTip(this.btnNew);
         }
         param1 = null;
      }
      
      private function openNew(param1:MouseEvent) : void
      {
         this.btnCloseTicket.visible = false;
         Connectr.instance.serviceModel.requestData(RequestDataKey.SUPPORT_SUBJECTS,{},this.onSubjectList);
      }
      
      private function onSubjectList(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SUPPORT_SUBJECTS,this.onSubjectList);
         if(!this.supportNew)
         {
            this.supportNew = new SupportNew();
            this.supportNew.y = 100;
            this.supportNew.x = 236;
            this.supportNew.btnSend.addEventListener(MouseEvent.CLICK,this.sendTicketConfirm);
            this.addChild(this.supportNew);
            this.addComboBoxView(this,236,60,param1.supportSubjects);
            this.sHeader.text = $("New Support Ticket");
         }
         else
         {
            this.comboBox.visible = true;
            this.supportNew.visible = true;
         }
         TweenMax.to(this,0.3,{
            "x":-230,
            "ease":Linear.easeOut
         });
      }
      
      private function sendTicketConfirm(param1:MouseEvent) : void
      {
         var _loc2_:AlertVo = new AlertVo();
         _loc2_.alertType = AlertType.CONFIRM;
         _loc2_.title = $("New Support Ticket");
         _loc2_.description = $("About to send new ticket");
         _loc2_.callBack = this.openSupportTicket;
         Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
      }
      
      private function openSupportTicket(param1:int) : void
      {
         if(param1 == AlertResponse.OK)
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.SUPPORT_TICKET_ADD,{
               "subjectId":this.comboBox.selectedData.id,
               "message":this.supportNew.inpNew.text
            },this.onOpenTicketResponse);
         }
      }
      
      private function onOpenTicketResponse(param1:*) : void
      {
         var _loc2_:AlertVo = null;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SUPPORT_TICKET_ADD,this.onOpenTicketResponse);
         if(param1.errorCode)
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.INFO;
            _loc2_.title = $("New Support Ticket");
            _loc2_.description = $(param1.message);
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
            return;
         }
         if(this.supportNew)
         {
            this.removeChild(this.supportNew);
            this.supportNew = null;
         }
         if(this.comboBox)
         {
            this.removeComboBoxView(this);
         }
         this.closeView();
         Connectr.instance.serviceModel.requestData(RequestDataKey.SUPPORT_TICKET_GET,{"type":"list"},this.onList);
      }
      
      private function replyTicketConfirm(param1:MouseEvent) : void
      {
         var _loc2_:AlertVo = new AlertVo();
         _loc2_.alertType = AlertType.CONFIRM;
         _loc2_.title = $("Reply Support Ticket");
         _loc2_.description = $("About to reply support ticket");
         _loc2_.callBack = this.replyTicket;
         Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
      }
      
      private function replyTicket(param1:int) : void
      {
         if(param1 == AlertResponse.OK)
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.SUPPORT_TICKET_MESSAGE_ADD,{
               "ticketId":this.selectedTicketID,
               "message":this.supportNew.inpNew.text
            },this.onReplyTicketResponse);
         }
      }
      
      private function onReplyTicketResponse(param1:*) : void
      {
         var _loc2_:AlertVo = null;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SUPPORT_TICKET_MESSAGE_ADD,this.onReplyTicketResponse);
         if(param1.errorCode)
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.INFO;
            _loc2_.title = $("Reply Support Ticket");
            _loc2_.description = $(param1.message);
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
            return;
         }
         this.supportNew = null;
         this.onMessages(param1);
      }
      
      private function closeTicketConfirm(param1:MouseEvent) : void
      {
         var _loc2_:AlertVo = new AlertVo();
         _loc2_.alertType = AlertType.CONFIRM;
         _loc2_.title = $("Close Support Ticket");
         _loc2_.description = $("About to close support ticket");
         _loc2_.callBack = this.closeTicket;
         Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
      }
      
      private function closeTicket(param1:int) : void
      {
         if(param1 == AlertResponse.OK)
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.SUPPORT_TICKET_GET,{
               "type":"close",
               "ticketId":this.selectedTicketID
            },this.onCloseTicket);
         }
      }
      
      private function onCloseTicket(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SUPPORT_TICKET_GET,this.onCloseTicket);
         this.scrollContainerV.dispose();
         if(this.supportNew)
         {
            this.supportNew = null;
         }
         this.onList(param1);
         TweenMax.to(this,0.3,{
            "x":0,
            "ease":Linear.easeIn
         });
      }
      
      private function onMessagesInit(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SUPPORT_TICKET_MESSAGES_GET,this.onMessagesInit);
         this.placeMessages(param1);
         this.scrollContainerV.init(230,330,4);
      }
      
      private function onMessages(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SUPPORT_TICKET_GET,this.onMessages);
         this.placeMessages(param1);
         this.scrollContainerV.setPositions();
      }
      
      private function placeMessages(param1:*) : void
      {
         this.scrollContainerV.dispose();
         var _loc2_:int = 0;
         while(_loc2_ < param1.ticketmessages.length)
         {
            this.myMessage = new SupportMessage();
            this.myMessage.message = param1.ticketmessages[_loc2_].message;
            if(param1.ticketmessages[_loc2_].moderator == 0)
            {
               this.myMessage.sName.htmlText += "<font color=\'#1B5E20\'>" + Connectr.instance.avatarModel.avatarName + ": </font>";
               this.myMessage.x = 12;
               this.myMessage.bg.gotoAndStop(2);
            }
            else
            {
               this.myMessage.x = 4;
               this.myMessage.sName.htmlText += "<font color=\'#0D47A1\'>" + $("moderator") + ": </font>";
            }
            this.myMessage.sName.htmlText += param1.ticketmessages[_loc2_].message + "<br><font color=\'#616161\'>" + param1.ticketmessages[_loc2_].createdAt + "</font>";
            this.myMessage.sName.height = this.myMessage.sName.textHeight + 4;
            this.myMessage.bg.height = this.myMessage.sName.height + 4;
            this.scrollContainerV.listContainer.addChild(this.myMessage);
            _loc2_++;
         }
         if(this.selectedTicketState == OPEN || this.selectedTicketState == REPLIED)
         {
            if(!this.supportNew)
            {
               this.supportNew = new SupportNew();
               this.supportNew.btnSend.addEventListener(MouseEvent.CLICK,this.replyTicketConfirm);
               this.supportNew.x = 6;
               this.scrollContainerV.listContainer.addChild(this.supportNew);
            }
         }
         TweenMax.to(this,0.3,{
            "x":-230,
            "ease":Linear.easeOut
         });
      }
      
      override public function removed() : void
      {
         this.removeComboBoxView(this);
         if(this.scrollContainer)
         {
            if(this.contains(this.scrollContainer))
            {
               this.removeChild(this.scrollContainer);
            }
            this.scrollContainer.dispose(this.openView);
         }
         if(this.scrollContainerV)
         {
            if(this.contains(this.scrollContainerV))
            {
               this.removeChild(this.scrollContainerV);
            }
            this.scrollContainerV.dispose();
         }
         if(this.supportNew)
         {
            this.supportNew.btnSend.removeEventListener(MouseEvent.CLICK,this.sendTicketConfirm);
            if(this.contains(this.supportNew))
            {
               this.removeChild(this.supportNew);
            }
         }
         this.headerBg.removeEventListener(MouseEvent.CLICK,this.closeView);
         this.btnNew.removeEventListener(MouseEvent.CLICK,this.openNew);
      }
   }
}

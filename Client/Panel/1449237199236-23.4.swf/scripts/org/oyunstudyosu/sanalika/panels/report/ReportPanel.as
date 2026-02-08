package org.oyunstudyosu.sanalika.panels.report
{
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.enums.AvatarPermission;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.local.arabic.ArabicInputManager;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.StringUtil;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import org.oyunstudyosu.sanalika.buttons.newButtons.RedButton;
   import org.oyunstudyosu.sanalika.buttons.newButtons.YellowButton;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.report.ReportPanel")]
   public class ReportPanel extends Panel
   {
       
      
      public var inpFrm:TextField;
      
      public var lblChat:TextField;
      
      public var lbl_describeReport:TextField;
      
      public var lbl_reportContext:TextField;
      
      public var lbl_reportDescription:TextField;
      
      public var lbl_reportTitle:TextField;
      
      public var txtIsPervert:TextField;
      
      private var avatarId:String;

      private var avatarName:String;
      
      private var lastMessage:String;
      
      public var background:MovieClip;
      
      public var btnBlockUser:YellowButton;
      
      public var btnSend:RedButton;
      
      public var btnClose:CloseButton;
      
      private var defaultText:String;
      
      private var sChat:STextField;
      
      private var sReport:STextField;
      
      private var sReportDescription:STextField;
      
      private var sReportContext:STextField;
      
      private var sDescribeReport:STextField;
      
      private var sIsPervert:STextField;
      
      private var inpFormTextField:TextField;
      
      private var inputManager:ArabicInputManager;
      
      private var reportData:Object;
      
      private var lastComment:String = "";
      
      public var infoBan:TextField;
      
      public var checkbox:MovieClip;
      
      public var isPervert:int;
      
      public var mcDragger:MovieClip;
      
      public var infoBanTxt:String;
      
      private var _banCount:int;
      
      public function ReportPanel()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         var _loc1_:Object = data != null ? data.params : null;
         this.avatarId = _loc1_ != null && _loc1_.avatarId != null ? _loc1_.avatarId : null;
         if((this.avatarId == null || String(this.avatarId) == "0" || String(this.avatarId) == "null") && _loc1_ != null && _loc1_.avatarID != null)
         {
            this.avatarId = _loc1_.avatarID;
         }
         this.avatarName = _loc1_ != null ? _loc1_.avatarName : null;
         if((this.avatarName == null || String(this.avatarName) == "null") && _loc1_ != null && _loc1_.name != null)
         {
            this.avatarName = _loc1_.name;
         }
         dragHandler = this.mcDragger;
         this.lastMessage = _loc1_ != null ? _loc1_.lastMessage : null;
         if(this.sChat == null)
         {
            this.sChat = TextFieldManager.convertAsArabicTextField(getChildByName("lblChat") as TextField,true,true);
            this.sReport = TextFieldManager.convertAsArabicTextField(getChildByName("lbl_reportTitle") as TextField,false,false);
            this.sReportDescription = TextFieldManager.convertAsArabicTextField(getChildByName("lbl_reportDescription") as TextField,true,true);
            this.sReportContext = TextFieldManager.convertAsArabicTextField(getChildByName("lbl_reportContext") as TextField,true,true);
            this.sDescribeReport = TextFieldManager.convertAsArabicTextField(getChildByName("lbl_describeReport") as TextField,true,true);
            this.sIsPervert = TextFieldManager.convertAsArabicTextField(getChildByName("txtIsPervert") as TextField,true,true);
            this.inpFormTextField = TextFieldManager.createNoneLanguageTextfield(getChildByName("inpFrm") as TextField);
            this.infoBan = TextFieldManager.convertAsArabicTextField(this.infoBan);
            this.sReport.autoSize = TextFieldAutoSize.CENTER;
            this.sReport.wordWrap = false;
            this.sReportDescription.wordWrap = true;
            this.sReport.htmlText = $("reportPanelTitle");
            this.sReportDescription.htmlText = $("reportInpDefaultText");
            this.sReportContext.htmlText = $("reportKeyTitle");
            this.sDescribeReport.htmlText = $("reportDescribeTitle");
            this.btnBlockUser.setText($("avatarMute"));
            this.sIsPervert.htmlText = $("reportPervert");
         }
         this.checkbox.addEventListener(MouseEvent.CLICK,this.onCheck);
         this.sChat.htmlText = this.lastMessage;
         this.isPervert = 0;
         if(Connectr.instance.avatarModel.permission.check(AvatarPermission.CARD_SECURITY))
         {
            this.btnSend.setText($("avatarBan"));
         }
         else
         {
            this.btnSend.setText($("avatarReport"));
         }
         this.defaultText = $("Write your message!");
         this.inpFormTextField.text = this.defaultText;
         if(Connectr.instance.gameModel.language == "ar")
         {
            this.inputManager = new ArabicInputManager(this.inpFormTextField,this.inpFormTextField.getTextFormat());
         }
         this.btnBlockUser.addEventListener(MouseEvent.CLICK,this.onBlockUser);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.closeClicked);
         this.inpFormTextField.addEventListener(FocusEvent.FOCUS_IN,this.focusIn);
         this.inpFormTextField.addEventListener(FocusEvent.FOCUS_OUT,this.focusOut);
         this.reportData = {};
         this.reportData.reportedAvatarID = this.avatarId;
         if(this.avatarName != null)
         {
            this.reportData.reportedAvatarName = this.avatarName;
         }
         this.reportData.message = this.lastMessage;
         this.reportData.isPervert = this.isPervert;
         this.btnSend.addEventListener(MouseEvent.CLICK,this.onReportUser);
         Connectr.instance.serviceModel.requestData(RequestDataKey.AVATAR_BANINFO,{"avatarID":this.avatarId},this.onResponse);
      }
      
      protected function onResponse(param1:Object) : void
      {
         var _loc2_:AlertVo = null;
         var _loc3_:Date = null;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.AVATAR_BANINFO,this.onResponse);
         this._banCount = param1.banCount;
         if(param1.banStatus != null)
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.INFO;
            _loc2_.title = $("Info");
            _loc3_ = new Date();
            _loc2_.description = $("reportAlreadyBanned") + "\n" + StringUtil.secondToString(int(param1.expireSecond / 1000));
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
            close();
            return;
         }
         if(param1.banCount == 0)
         {
            this.infoBan.text = $("avatarWarning");
         }
         else
         {
            this.infoBan.text = $("avatarNextBan") + " " + StringUtil.secondToString(int(param1.nextBanMin * 60));
         }
         this.checkbox.gotoAndStop(1);
         this.infoBanTxt = this.infoBan.text;
         show();
      }
      
      protected function closeClicked(param1:MouseEvent) : void
      {
         close();
      }
      
      protected function onCheck(param1:MouseEvent) : void
      {
         if(this.checkbox.currentFrame == 2)
         {
            this.checkbox.gotoAndStop(1);
            this.isPervert = 0;
            this.infoBan.text = this.infoBanTxt;
         }
         else
         {
            this.checkbox.gotoAndStop(2);
            this.isPervert = 1;
            if(this._banCount == 0)
            {
               this.infoBan.text = $("reportPervertWarning");
            }
            else
            {
               this.infoBan.text = $("reportOneMonthMute");
            }
         }
      }
      
      protected function focusIn(param1:FocusEvent) : void
      {
         if(this.inputManager)
         {
            this.inputManager.changeFormat(this.inpFormTextField.defaultTextFormat);
         }
         this.inpFormTextField.text = "";
      }
      
      protected function focusOut(param1:FocusEvent) : void
      {
         this.lastComment = this.inpFormTextField.text;
      }
      
      private function onBlockUser(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         Connectr.instance.avatarModel.blockUser(this.avatarId);
         close();
      }
      
      private function onReportUser(param1:MouseEvent = null) : void
      {
         var _loc2_:RegExp = /<[^<]+?>'/gi;
         this.lastComment = this.lastComment.replace(_loc2_,"");
         var _loc3_:RegExp = /'/gi;
         this.lastComment = this.lastComment.replace(_loc3_,"");
         this.reportData.comment = this.lastComment;
         this.reportData.isPervert = this.isPervert;
         Connectr.instance.serviceModel.requestData(RequestDataKey.REPORT,this.reportData,this.onReportResponse);
         this.btnBlockUser.removeEventListener(MouseEvent.CLICK,this.onBlockUser);
         this.btnSend.removeEventListener(MouseEvent.CLICK,this.onReportUser);
      }
      
      private function onReportResponse(param1:Object) : void
      {
         var _loc2_:AlertVo = null;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.REPORT,this.onReportResponse);
         _loc2_ = new AlertVo();
         _loc2_.alertType = AlertType.INFO;
         if(param1.errorCode == "ALREADY_REPORTED")
         {
            _loc2_.description = $("reportAlreadyReported");
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
            close();
            return;
         }
         if(param1.errorCode)
         {
            _loc2_.title = $("preReportError");
            _loc2_.description = $("reportProblemDescription");
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
            close();
            return;
         }
         if(Connectr.instance.avatarModel.permission.check(AvatarPermission.CARD_SECURITY))
         {
            _loc2_.title = $("Info");
            _loc2_.description = $("reportCompleteKnight");
         }
         else
         {
            _loc2_.title = $("reportReceived");
            _loc2_.description = $("reportReceivedDescription");
         }
         Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
         close();
      }
      
      override public function dispose() : void
      {
         this.lastComment = "";
         super.dispose();
      }
   }
}

package org.oyunstudyosu.sanalika.panels.complaint
{
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.tooltip.TooltipAlign;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.StringUtil;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.sanalika.buttons.newButtons.BlueButton;
   import org.oyunstudyosu.sanalika.buttons.newButtons.RedButton;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.complaint.ComplaintItem")]
   public class ComplaintItem extends MovieClip
   {
       
      
      public var txtBanInfo:TextField;
      
      public var txtDescription:TextField;
      
      public var txtIsAbuse:TextField;
      
      public var txtIsPervert:TextField;
      
      public var txtTitle:TextField;
      
      private var complaintData:ComplaintData;
      
      private var sTxtTitle:STextField;
      
      private var sTxtDescription:STextField;
      
      private var infoBanTxt:String;
      
      private var sIsPervert:STextField;
      
      private var sIsAbuse:STextField;
      
      public var order:int;
      
      public var btnTrue:RedButton;
      
      public var btnWarn:SimpleButton;
      
      public var btnLocation:SimpleButton;
      
      public var btnFalse:BlueButton;
      
      public var sTxtBanInfo:STextField;
      
      public var checkboxPervert:MovieClip;
      
      public var checkboxAbuse:MovieClip;
      
      public var isPervert:int;
      
      public var isAbuse:int;
      
      public var isCorrect:int;
      
      public var txtReporterID:TextField;
      
      public var txtReportedID:TextField;
      
      public var btnWarnReporter:SimpleButton;
      
      public function ComplaintItem(param1:ComplaintData)
      {
         super();
         this.complaintData = param1;
      }
      
      public function init() : void
      {
         this.isCorrect = 0;
         this.isPervert = 0;
         visible = false;
         this.btnTrue.addEventListener(MouseEvent.CLICK,this.trueClicked);
         this.btnWarn.addEventListener(MouseEvent.CLICK,this.warnClicked);
         this.btnLocation.addEventListener(MouseEvent.CLICK,this.locationClicked);
         this.btnFalse.addEventListener(MouseEvent.CLICK,this.falseClicked);
         this.checkboxPervert.addEventListener(MouseEvent.CLICK,this.onCheck);
         this.checkboxAbuse.addEventListener(MouseEvent.CLICK,this.onClickAbuse);
         this.btnWarnReporter.addEventListener(MouseEvent.CLICK,this.warnReporterClicked);
         Connectr.instance.toolTipModel.addTip(this.btnWarnReporter,$("warnReporter"),TooltipAlign.ALIGN_LEFT);
         if(this.sTxtTitle == null)
         {
            this.sTxtTitle = TextFieldManager.convertAsArabicTextField(getChildByName("txtTitle") as TextField,true,false);
            this.sTxtTitle.wordWrap = true;
            this.sTxtDescription = TextFieldManager.convertAsArabicTextField(getChildByName("txtDescription") as TextField,true,false);
            this.sTxtDescription.wordWrap = true;
            this.sIsPervert = TextFieldManager.convertAsArabicTextField(getChildByName("txtIsPervert") as TextField,true,false);
            this.sIsAbuse = TextFieldManager.convertAsArabicTextField(getChildByName("txtIsAbuse") as TextField,true,false);
            this.sTxtBanInfo = TextFieldManager.convertAsArabicTextField(getChildByName("txtBanInfo") as TextField,true,false);
         }
         if(this.complaintData.banCount == 0)
         {
            this.sTxtBanInfo.htmlText = $("avatarWarning");
         }
         else
         {
            this.sTxtBanInfo.htmlText = $("avatarNextBan") + " " + StringUtil.secondToString(int(this.complaintData.nextBanMin * 60));
         }
         this.sIsPervert.htmlText = $("reportPervert");
         this.sIsAbuse.htmlText = $("reportAbuse");
         this.btnTrue.setText($("avatarBan"));
         this.btnFalse.setText($("reportFalse"));
         this.infoBanTxt = this.sTxtBanInfo.htmlText;
         this.sTxtTitle.text = this.complaintData.message;
         this.sTxtTitle.selectable = true;
         this.sTxtDescription.text = this.complaintData.comment;
         this.sTxtDescription.selectable = true;
         if(this.complaintData.isPervert == 1)
         {
            this.isPervert = 1;
            this.checkboxPervert.gotoAndStop(2);
            if(this.complaintData.banCount == 0)
            {
               this.sTxtBanInfo.htmlText = $("reportPervertWarning");
            }
            else
            {
               this.sTxtBanInfo.htmlText = $("reportOneMonthMute");
            }
         }
         if(this.sTxtDescription.text.length > 2)
         {
            this.btnWarnReporter.visible = true;
            this.txtReporterID.text = this.complaintData.reporterAvatarID;
            Connectr.instance.toolTipModel.addTip(this.txtReporterID,$("reporterAvatarID"));
         }
         else
         {
            this.btnWarnReporter.visible = false;
            this.txtReporterID.text = "";
         }
         if(this.complaintData.reportedAvatarID != "")
         {
            this.txtReportedID.text = this.complaintData.reportedAvatarID;
            Connectr.instance.toolTipModel.addTip(this.txtReportedID,$("reportedAvatarID"));
         }
      }
      
      private function trueClicked(param1:MouseEvent) : void
      {
         this.isCorrect = 1;
         dispatchEvent(new Event("next"));
      }
      
      private function warnClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("warn"));
      }
      
      private function warnReporterClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("warnReporter"));
      }
      
      private function locationClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("location"));
      }
      
      private function falseClicked(param1:MouseEvent) : void
      {
         var _loc2_:AlertVo = null;
         if(Boolean(this.isPervert) || Boolean(this.isAbuse))
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.INFO;
            _loc2_.title = $("Info");
            _loc2_.description = $("reportMistake");
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
         }
         else
         {
            this.isCorrect = 0;
            dispatchEvent(new Event("next"));
         }
      }
      
      protected function onCheck(param1:MouseEvent) : void
      {
         this.checkboxAbuse.gotoAndStop(1);
         this.isAbuse = 0;
         if(this.checkboxPervert.currentFrame == 2)
         {
            this.checkboxPervert.gotoAndStop(1);
            this.isPervert = 0;
            this.sTxtBanInfo.htmlText = this.infoBanTxt;
         }
         else
         {
            this.checkboxPervert.gotoAndStop(2);
            this.isPervert = 1;
            if(this.complaintData.banCount == 0)
            {
               this.sTxtBanInfo.htmlText = $("reportPervertWarning");
            }
            else
            {
               this.sTxtBanInfo.htmlText = $("reportOneMonthMute");
            }
         }
      }
      
      protected function onClickAbuse(param1:MouseEvent) : void
      {
         this.isPervert = 0;
         this.checkboxPervert.gotoAndStop(1);
         if(this.checkboxAbuse.currentFrame == 2)
         {
            this.checkboxAbuse.gotoAndStop(1);
            this.isAbuse = 0;
            this.sTxtBanInfo.htmlText = this.infoBanTxt;
         }
         else
         {
            this.checkboxAbuse.gotoAndStop(2);
            this.isAbuse = 1;
            this.sTxtBanInfo.htmlText = $("reportAbuseBan");
         }
      }
      
      public function dispose() : void
      {
         this.complaintData = null;
         this.btnTrue.removeEventListener(MouseEvent.CLICK,this.trueClicked);
         this.btnWarn.removeEventListener(MouseEvent.CLICK,this.warnClicked);
         this.btnWarnReporter.removeEventListener(MouseEvent.CLICK,this.warnReporterClicked);
         this.btnLocation.removeEventListener(MouseEvent.CLICK,this.locationClicked);
         this.btnFalse.removeEventListener(MouseEvent.CLICK,this.falseClicked);
         this.checkboxPervert.removeEventListener(MouseEvent.CLICK,this.onCheck);
         this.checkboxAbuse.removeEventListener(MouseEvent.CLICK,this.onClickAbuse);
         Connectr.instance.toolTipModel.removeTip(this.btnWarnReporter);
         Connectr.instance.toolTipModel.removeTip(this.txtReportedID);
         Connectr.instance.toolTipModel.removeTip(this.txtReporterID);
      }
   }
}

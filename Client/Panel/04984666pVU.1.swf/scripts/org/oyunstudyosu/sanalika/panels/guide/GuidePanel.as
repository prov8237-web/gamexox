package org.oyunstudyosu.sanalika.panels.guide
{
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.ProfileEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.sanalika.sound.SoundKey;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import com.printfas3.printf;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.sanalika.buttons.newButtons.BlueButton;
   import org.oyunstudyosu.sanalika.buttons.newButtons.GreenButton;
   import org.oyunstudyosu.sanalika.buttons.newButtons.RedButton;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.guide.GuidePanel")]
   public class GuidePanel extends Panel
   {
       
      
      public var background:MovieClip;
      
      public var header:MovieClip;
      
      public var txtDescription:TextField;
      
      public var txtHeader:TextField;
      
      public var txtInfo:TextField;
      
      public var btnClose:CloseButton;
      
      public var btnOk:BlueButton;
      
      public var btnNA:RedButton;
      
      public var btnMessage:GreenButton;
      
      public var sHeader:STextField;
      
      public var sDescription:STextField;
      
      public var sInfo:STextField;
      
      private var onAir:Boolean = false;
      
      private var visitorAvatarID:String;
      
      public var dragger:MovieClip;
      
      public var btnProfile:SimpleButton;
      
      public function GuidePanel()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         Connectr.instance.serviceModel.listenExtension("guideInviteLocation",this.onInvite);
         this.btnOk.addEventListener(MouseEvent.CLICK,this.btnOkClicked);
         this.btnOk.setText($("Available"));
         this.btnOk.buttonMode = true;
         this.btnNA.addEventListener(MouseEvent.CLICK,this.btnNAClicked);
         this.btnNA.setText($("NotAvailable"));
         this.btnNA.buttonMode = true;
         this.btnMessage.addEventListener(MouseEvent.CLICK,this.btnMessageClicked);
         this.btnMessage.setText($("SendMessage"));
         this.btnClose.addEventListener(MouseEvent.CLICK,this.btnCloseClicked);
         this.btnProfile.visible = false;
         if(this.getChildByName("txtHeader"))
         {
            this.sHeader = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtHeader") as TextField,false);
            this.sDescription = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtDescription") as TextField,false);
            this.sDescription.wordWrap = true;
            this.sInfo = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtInfo") as TextField,false);
            this.sInfo.wordWrap = true;
         }
         this.sHeader.text = $("GuidePanel");
         if(this.onAir)
         {
            this.sDescription.text = $("GuideOnAir");
            this.btnNA.visible = true;
            this.btnOk.visible = false;
         }
         else
         {
            this.btnOk.visible = true;
            this.btnNA.visible = false;
            this.btnMessage.visible = false;
            this.sDescription.text = printf($("GuideDesc"),Connectr.instance.avatarModel.avatarName);
         }
         dragHandler = this.dragger;
         show();
      }
      
      private function onInvite(param1:Object) : void
      {
         if(param1.avatarID)
         {
            Connectr.instance.soundModel.playSound(SoundKey.ALERT,1,3);
            this.sInfo.htmlText = $("avatarName") + ": " + param1.avatarName + "\n" + $("Room Info") + ": " + $("room_" + param1.street) + ", " + $("universe_" + param1.universe);
            this.visitorAvatarID = param1.avatarID;
            this.btnNA.visible = false;
            this.btnMessage.visible = true;
            this.btnProfile.visible = true;
            this.btnProfile.addEventListener(MouseEvent.CLICK,this.openProfile);
         }
      }
      
      protected function openProfile(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         var _loc2_:ProfileEvent = new ProfileEvent(ProfileEvent.SHOW_PROFILE);
         _loc2_.avatarID = this.visitorAvatarID;
         Dispatcher.dispatchEvent(_loc2_);
      }
      
      protected function btnMessageClicked(param1:MouseEvent) : void
      {
         this.btnMessage.mouseEnabled = false;
         Connectr.instance.serviceModel.requestData(RequestDataKey.GUIDE_ACTION,{
            "action":"guideMessage",
            "avatarID":this.visitorAvatarID,
            "message":printf($("GuideMessage"),Connectr.instance.avatarModel.avatarName)
         },this.onResponseMessage);
      }
      
      private function onResponseMessage(param1:Object) : void
      {
         this.sDescription.text = $("GuideMessageSent");
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.GUIDE_ACTION,this.onResponseMessage);
      }
      
      protected function btnOkClicked(param1:MouseEvent) : void
      {
         this.btnOk.visible = false;
         Connectr.instance.serviceModel.requestData(RequestDataKey.GUIDE_ACTION,{"action":"available"},this.onResponse);
      }
      
      protected function btnCloseClicked(param1:MouseEvent) : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.GUIDE_ACTION,{"action":"na"},this.onNAResponse);
      }
      
      protected function btnNAClicked(param1:MouseEvent) : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.GUIDE_ACTION,{"action":"na"},this.onNAResponse);
      }
      
      private function onResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.GUIDE_ACTION,this.onResponse);
         if(param1.status == "success")
         {
            this.onAir = true;
            this.sDescription.text = $("GuideOnAir");
            this.btnNA.visible = true;
         }
         else
         {
            this.sDescription.text = $("GuideError");
         }
      }
      
      protected function onNAResponse(param1:Object) : void
      {
         this.btnNA.visible = false;
         this.btnMessage.visible = false;
         this.btnOk.visible = true;
         this.visitorAvatarID = "";
         this.onAir = false;
         this.btnProfile.visible = false;
         this.sInfo.text = "";
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.GUIDE_ACTION,this.onNAResponse);
         close();
      }
      
      override public function dispose() : void
      {
         this.btnNA.visible = false;
         this.btnMessage.visible = false;
         this.btnMessage.mouseEnabled = true;
         this.btnOk.mouseEnabled = true;
         this.btnOk.visible = true;
         this.visitorAvatarID = "";
         this.onAir = false;
         this.sInfo.text = "";
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.btnCloseClicked);
         this.btnOk.removeEventListener(MouseEvent.CLICK,this.btnOkClicked);
         this.btnNA.removeEventListener(MouseEvent.CLICK,this.btnNAClicked);
         this.btnMessage.removeEventListener(MouseEvent.CLICK,this.btnMessageClicked);
         this.btnProfile.removeEventListener(MouseEvent.CLICK,this.openProfile);
         super.dispose();
      }
   }
}

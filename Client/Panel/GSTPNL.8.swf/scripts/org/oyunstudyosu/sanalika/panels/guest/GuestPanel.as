package org.oyunstudyosu.sanalika.panels.guest
{
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import org.oyunstudyosu.sanalika.buttons.newButtons.BlueButton;
   import org.oyunstudyosu.sanalika.buttons.newButtons.GreenButton;
   import org.oyunstudyosu.sanalika.buttons.newButtons.YellowButton;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.guest.GuestPanel")]
   public class GuestPanel extends Panel
   {
       
      
      public var btnClose:CloseButton;
      
      public var btnGuest:YellowButton;
      
      public var btnRegister:GreenButton;
      
      public var btnLogin:BlueButton;
      
      public var mcDragger:MovieClip;
      
      public var txtGuestContinue:TextField;
      
      public var txtGuestLogin:TextField;
      
      public var txtGuestRegister:TextField;
      
      public var txtHeader:TextField;
      
      private var sContinue:STextField;
      
      private var sLogin:STextField;
      
      private var sRegister:STextField;
      
      public var sHeader:STextField;
      
      private var authBypass:Array;
      
      public function GuestPanel()
      {
         this.authBypass = [Connectr.instance.gameModel.webServer + "/app/success"];
         super();
      }
      
      override public function init() : void
      {
         super.init();
         dragHandler = this.mcDragger;
         if(this.sContinue == null)
         {
            this.sHeader = TextFieldManager.convertAsArabicTextField(this.txtHeader,false,false);
            this.sHeader.wordWrap = false;
            this.sContinue = TextFieldManager.convertAsArabicTextField(this.txtGuestContinue,true,true);
            this.sContinue.wordWrap = true;
            this.sLogin = TextFieldManager.convertAsArabicTextField(this.txtGuestLogin,true,true);
            this.sLogin.wordWrap = true;
            this.sRegister = TextFieldManager.convertAsArabicTextField(this.txtGuestRegister,true,true);
            this.sRegister.wordWrap = true;
         }
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose);
         this.btnGuest.setText(Connectr.instance.localizationModel.translate("guestBtnContinue"));
         this.btnLogin.setText(Connectr.instance.localizationModel.translate("guestBtnLogin"));
         this.btnRegister.setText(Connectr.instance.localizationModel.translate("guestBtnRegister"));
         this.sHeader.htmlText = Connectr.instance.localizationModel.translate("guestHeader");
         this.sContinue.htmlText = Connectr.instance.localizationModel.translate("guestContinue");
         this.sLogin.htmlText = Connectr.instance.localizationModel.translate("guestLogin");
         this.sRegister.htmlText = Connectr.instance.localizationModel.translate("guestRegister");
         this.btnGuest.addEventListener(MouseEvent.CLICK,this.btnGuestClicked);
         this.btnLogin.addEventListener(MouseEvent.CLICK,this.btnLoginClicked);
         this.btnRegister.addEventListener(MouseEvent.CLICK,this.btnRegisterClicked);
         show();
      }
      
      private function onURLChanging(param1:String) : void
      {
         if(param1 == Connectr.instance.gameModel.webServer + "/facebook-register/" + Connectr.instance.serviceModel.sfs.sessionToken)
         {
         }
      }
      
      private function onLoggedIn() : void
      {
      }
      
      private function onCancel() : void
      {
      }
      
      private function onError(param1:String) : void
      {
      }
      
      private function btnLoginClicked(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:String = Connectr.instance.gameModel.webServer + "/app/login/" + Connectr.instance.serviceModel.sfs.sessionToken;
         if(Connectr.instance.airModel.isMobile())
         {
            this.openAuthenticator(_loc2_);
         }
         else
         {
            navigateToURL(new URLRequest(_loc2_),"_blank");
            if(Sanalika.instance.stage["nativeWindow"] != null)
            {
               _loc3_ = Sanalika.instance.stage["nativeWindow"];
               _loc3_.orderToBack();
            }
         }
      }
      
      private function openAuthenticator(param1:String) : Boolean
      {
         if(!stage.loaderInfo.applicationDomain.hasDefinition("com.oyunstudyosu.air.display.AuthenticationDisplay"))
         {
            return false;
         }
         var _loc2_:Class = stage.loaderInfo.applicationDomain.getDefinition("com.oyunstudyosu.air.display.AuthenticationDisplay") as Class;
         var _loc3_:* = new _loc2_();
         stage.addChild(_loc3_);
         _loc3_.viewPort.width = stage.stageWidth;
         _loc3_.viewPort.height = stage.stageHeight;
         _loc3_.loadURL(param1);
         return true;
      }
      
      private function btnRegisterClicked(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:String = Connectr.instance.gameModel.webServer + "/app/register/" + Connectr.instance.serviceModel.sfs.sessionToken;
         if(Connectr.instance.airModel.isMobile())
         {
            this.openAuthenticator(_loc2_);
         }
         else
         {
            navigateToURL(new URLRequest(_loc2_),"_blank");
            if(Sanalika.instance.stage["nativeWindow"] != null)
            {
               _loc3_ = Sanalika.instance.stage["nativeWindow"];
               _loc3_.orderToBack();
            }
         }
      }
      
      private function btnGuestClicked(param1:MouseEvent) : void
      {
         if(!Connectr.instance.avatarModel.guest)
         {
            Connectr.instance.initialize();
         }
         close();
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.onClose);
         this.btnGuest.removeEventListener(MouseEvent.CLICK,this.btnGuestClicked);
         this.btnLogin.removeEventListener(MouseEvent.CLICK,this.btnLoginClicked);
         this.btnRegister.removeEventListener(MouseEvent.CLICK,this.btnRegisterClicked);
         close();
      }
   }
}

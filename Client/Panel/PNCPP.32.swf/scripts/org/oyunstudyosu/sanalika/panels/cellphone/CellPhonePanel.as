package org.oyunstudyosu.sanalika.panels.cellphone
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertResponse;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.enums.UpdateGroups;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.LocalTranslation;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import org.oyunstudyosu.sanalika.panels.cellphone.events.ApplicationEvent;
   import org.oyunstudyosu.sanalika.panels.cellphone.icons.BanListIcon;
   import org.oyunstudyosu.sanalika.panels.cellphone.icons.BaseIcon;
   import org.oyunstudyosu.sanalika.panels.cellphone.icons.FunbidIcon;
   import org.oyunstudyosu.sanalika.panels.cellphone.icons.FunwinIcon;
   import org.oyunstudyosu.sanalika.panels.cellphone.icons.NewsListIcon;
   import org.oyunstudyosu.sanalika.panels.cellphone.icons.PrivateChatIcon;
   import org.oyunstudyosu.sanalika.panels.cellphone.icons.QuestListIcon;
   import org.oyunstudyosu.sanalika.panels.cellphone.icons.RunWinIcon;
   import org.oyunstudyosu.sanalika.panels.cellphone.icons.SnowballIcon;
   import org.oyunstudyosu.sanalika.panels.cellphone.icons.SupportIcon;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.CellPhonePanel")]
   public class CellPhonePanel extends Panel
   {
       
      
      private var privateChatApp:CellPhoneApplication;
      
      public var appContainer:MovieClip;
      
      public var bg:MovieClip;
      
      private var currentApp:CellPhoneApplication;
      
      public var backToAppsButton:SimpleButton;
      
      public var closeButton:SimpleButton;
      
      private var targetIcon:BaseIcon;
      
      public var baseIcon:PrivateChatIcon;
      
      public var funwinIcon:FunwinIcon;
      
      public var funbidIcon:FunbidIcon;
      
      public var questListIcon:QuestListIcon;
      
      public var newsListIcon:NewsListIcon;
      
      public var banListIcon:BanListIcon;
      
      public var runWinIcon:RunWinIcon;
      
      public var snowballIcon:SnowballIcon;
      
      public var supportIcon:SupportIcon;
      
      public var btnAd:SimpleButton;
      
      public var opBar:MovieClip;
      
      public var timerTextField:TextField;
      
      private var date:Date;
      
      public function CellPhonePanel()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         dragHandler = this.bg;
         this.appContainer.x = 12;
         this.appContainer.y = 30;
         Dispatcher.addEventListener(ApplicationEvent.SHOW_APPLICATION,this.showNewApplication);
         Dispatcher.addEventListener(ApplicationEvent.CLOSE_APPLICATION,this.closeApplicationEvent);
         this.closeButton.addEventListener(MouseEvent.CLICK,this.closeClicked);
         this.backToAppsButton.addEventListener(MouseEvent.CLICK,this.backToAppsClicked);
         if(this.btnAd)
         {
            this.btnAd.addEventListener(MouseEvent.CLICK,this.btnAdClicked);
         }
         Connectr.instance.privateChatModel.cellPhoneActive = true;
         this.snowballIcon.visible = false;
         if(data.params != null && Boolean(data.params.isLoginBanned))
         {
            this.banListIcon.x = this.baseIcon.x;
            this.banListIcon.y = this.baseIcon.y;
            this.supportIcon.x = this.questListIcon.x;
            this.supportIcon.y = this.questListIcon.y;
            this.baseIcon.visible = false;
            this.funwinIcon.visible = false;
            this.funbidIcon.visible = false;
            this.newsListIcon.visible = false;
            this.questListIcon.visible = false;
            this.runWinIcon.visible = false;
         }
         if(this.timerTextField == null)
         {
            this.timerTextField = TextFieldManager.createNoneLanguageTextfield(this.opBar.getChildByName("timerTxt") as TextField);
            this.timerTextField.cacheAsBitmap = true;
         }
         Connectr.instance.updateModel.getGroup(UpdateGroups.TIMER_60S).addFunction(this.updateTimer);
         this.updateTimer(0,0);
         show();
      }
      
      public function changeOpBar() : void
      {
         TweenMax.to(this.opBar.opBarBg,1,{"colorTransform":{
            "tint":10586239,
            "tintAmount":0
         }});
      }
      
      private function updateTimer(param1:Number, param2:Number) : void
      {
         this.timerTextField.text = this.getFormatTime();
      }
      
      private function getFormatTime() : String
      {
         this.date = new Date();
         var _loc1_:String = this.date.getHours().toString();
         var _loc2_:String = this.date.getMinutes().toString();
         if(_loc1_.length < 2)
         {
            _loc1_ = "0" + _loc1_;
         }
         if(_loc2_.length < 2)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc1_ + ":" + _loc2_;
      }
      
      protected function btnAdClicked(param1:MouseEvent) : void
      {
      }
      
      protected function closeApplicationEvent(param1:ApplicationEvent) : void
      {
         this.closeApplication();
      }
      
      protected function closeApplication() : void
      {
         if(this.currentApp != null && this.targetIcon != null)
         {
            TweenMax.to(this.currentApp,0.3,{
               "x":this.targetIcon.x,
               "y":this.targetIcon.y,
               "alpha":0,
               "scaleX":0,
               "scaleY":0,
               "ease":Quad.easeOut,
               "onComplete":function():void
               {
                  if(currentApp != null)
                  {
                     currentApp.dispose();
                     appContainer.removeChild(currentApp);
                     currentApp = null;
                  }
                  targetIcon = null;
               }
            });
         }
      }
      
      protected function backToAppsClicked(param1:MouseEvent) : void
      {
         this.closeApplication();
      }
      
      protected function closeClicked(param1:MouseEvent) : void
      {
         var _loc2_:AlertVo = null;
         if(data.isPermanent)
         {
            _loc2_ = new AlertVo();
            _loc2_.callBack = this.logoutCallback;
            _loc2_.alertType = AlertType.CONFIRM;
            _loc2_.title = LocalTranslation.translate("Do you want logout?");
            _loc2_.description = LocalTranslation.translate("You will be logged out.");
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
         }
         else
         {
            close();
         }
      }
      
      private function logoutCallback(param1:int) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:Class = null;
         var _loc5_:Class = null;
         var _loc6_:Class = null;
         var _loc7_:Class = null;
         var _loc8_:XML = null;
         var _loc9_:Namespace = null;
         var _loc10_:String = null;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         if(param1 == AlertResponse.OK)
         {
            if(Sanalika.instance.stage.loaderInfo.applicationDomain.hasDefinition("com.oyunstudyosu.air.controller.DataStorageController"))
            {
               _loc2_ = Sanalika.instance.stage.loaderInfo.applicationDomain.getDefinition("com.oyunstudyosu.air.controller.DataStorageController") as Class;
               _loc2_.set("token",null);
            }
            if(Connectr.instance.airModel.isMobile())
            {
               _loc3_ = Sanalika.instance.stage.loaderInfo.applicationDomain.getDefinition("com.oyunstudyosu.restart.RestartApplication") as Class;
               _loc3_.restart();
            }
            else
            {
               _loc4_ = Sanalika.instance.stage.loaderInfo.applicationDomain.getDefinition("flash.filesystem.File") as Class;
               _loc5_ = Sanalika.instance.stage.loaderInfo.applicationDomain.getDefinition("flash.desktop.NativeApplication") as Class;
               _loc6_ = Sanalika.instance.stage.loaderInfo.applicationDomain.getDefinition("flash.desktop.NativeProcessStartupInfo") as Class;
               _loc7_ = Sanalika.instance.stage.loaderInfo.applicationDomain.getDefinition("flash.desktop.NativeProcess") as Class;
               _loc8_ = _loc5_.nativeApplication.applicationDescriptor;
               _loc9_ = new Namespace(_loc8_.namespace());
               _loc10_ = _loc8_._loc9_::filename;
               _loc11_ = new _loc6_();
               _loc12_ = new _loc7_();
               if(Capabilities.os.indexOf("Win") > -1)
               {
                  _loc13_ = new _loc4_(_loc4_.applicationDirectory.nativePath + "/" + _loc10_ + ".exe");
               }
               else
               {
                  _loc13_ = new _loc4_(_loc4_.applicationDirectory.nativePath.replace("Resources","MacOS/" + _loc10_));
               }
               _loc11_.executable = _loc13_;
               _loc12_.start(_loc11_);
               _loc5_.nativeApplication.exit();
            }
         }
      }
      
      private function showNewApplication(param1:ApplicationEvent) : void
      {
         var _loc3_:PanelVO = null;
         if(Connectr.instance.avatarModel.guest)
         {
            _loc3_ = new PanelVO();
            _loc3_.name = "GuestPanel";
            _loc3_.params = {};
            Connectr.instance.panelModel.openPanel(_loc3_);
            return;
         }
         this.targetIcon = param1.icon;
         var _loc2_:CellPhoneApplication = param1.app as CellPhoneApplication;
         this.appContainer.addChild(_loc2_);
         _loc2_.init();
         _loc2_.x = this.targetIcon.x;
         _loc2_.y = this.targetIcon.y;
         _loc2_.scaleX = _loc2_.scaleY = 0;
         _loc2_.alpha = 0.3;
         this.currentApp = _loc2_;
         TweenMax.to(_loc2_,0.3,{
            "x":0,
            "y":0,
            "alpha":1,
            "scaleX":1,
            "scaleY":1,
            "ease":Quad.easeOut
         });
      }
      
      override public function dispose() : void
      {
         gotoAndStop(1);
         if(this.currentApp)
         {
            this.currentApp.dispose();
            this.currentApp = null;
         }
         this.appContainer.removeChildren();
         this.closeButton.removeEventListener(MouseEvent.CLICK,this.closeClicked);
         this.backToAppsButton.removeEventListener(MouseEvent.CLICK,this.backToAppsClicked);
         if(this.btnAd)
         {
            this.btnAd.removeEventListener(MouseEvent.CLICK,this.btnAdClicked);
         }
         Dispatcher.removeEventListener(ApplicationEvent.SHOW_APPLICATION,this.showNewApplication);
         Connectr.instance.privateChatModel.cellPhoneActive = false;
         Connectr.instance.privateChatModel.activeGroupID = null;
         super.dispose();
      }
   }
}

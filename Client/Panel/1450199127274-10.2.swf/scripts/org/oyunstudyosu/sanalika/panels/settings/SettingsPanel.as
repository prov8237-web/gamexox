package org.oyunstudyosu.sanalika.panels.settings
{
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import org.oyunstudyosu.sanalika.buttons.newButtons.BlueButton;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.settings.SettingsPanel")]
   public class SettingsPanel extends Panel
   {
       
      
      public var lbl_Title:TextField;
      
      public var background:MovieClip;
      
      public var version:TextField;
      
      public var btnSave:BlueButton;
      
      public var btnClose:CloseButton;
      
      private var settingList:Vector.<SettingItem>;
      
      private var sTitle:STextField;
      
      private var paddingY:Number = 33.2;
      
      public function SettingsPanel()
      {
         this.settingList = new Vector.<SettingItem>();
         super();
      }
      
      override public function init() : void
      {
         var _loc3_:SettingItem = null;
         super.init();
         if(this.sTitle == null)
         {
            this.sTitle = TextFieldManager.convertAsArabicTextField(getChildByName("lbl_Title") as TextField,false,true);
            this.sTitle.autoSize = TextFieldAutoSize.CENTER;
            this.sTitle.wordWrap = false;
            this.sTitle.mouseEnabled = false;
         }
         this.sTitle.text = $("Settings");
         this.btnClose.addEventListener(MouseEvent.CLICK,this.closeClicked);
         this.btnSave.addEventListener(MouseEvent.CLICK,this.save);
         this.clear();
         this.add("verifySession","Verify session");
         this.add("showInvitations","Show invitations",["VIP"]);
         if(!Connectr.instance.airModel.isMobile())
         {
            this.add("wideScreenMode","Wide Screen Mode");
            this.add("performanceMode","Performance Mode");
         }
         this.add("hideRequests","Show notifications on bottom right");
         this.add("incomingMessages","Show messages");
         this.add("tradeRequests","Allow trade requests");
         this.add("transferRequests","Allow transfer requests");
         this.add("flatNotifications","Allow flat notifications");
         this.add("rainOn","Dont show rain/snow");
         this.add("onlyBuddyWhisper","Whisper: Friends only");
         var _loc1_:Number = 16.2;
         var _loc2_:int = 0;
         while(_loc2_ < this.settingList.length)
         {
            _loc3_ = this.settingList[_loc2_];
            _loc3_.y = _loc1_ + this.paddingY * (_loc2_ + 1);
            this.addChild(_loc3_);
            _loc2_++;
         }
         this.background.height = 80 + this.paddingY * (this.settingList.length + 1);
         this.btnSave.setText($("Save"));
         dragHandler = this.background;
         this.version.text = "v." + Connectr.instance.configModel.getVariable("version");
         this.version.y = this.background.height - 30;
         this.btnSave.y = this.background.height - 50;
         this.show();
      }
      
      override public function show() : void
      {
         if(Connectr.instance.panelModel)
         {
            Connectr.instance.panelModel.showBg(data,this);
         }
         Mouse.cursor = MouseCursor.AUTO;
         this.visible = true;
         this.alpha = 1;
         this.x = (Connectr.instance.layerModel.stage.stageWidth - this.width) / 2;
         this.y = (Connectr.instance.layerModel.stage.stageHeight - this.height) / 2;
      }
      
      public function clear() : void
      {
         var _loc2_:SettingItem = null;
         this.background.height = 80;
         var _loc1_:int = 0;
         while(_loc1_ < this.settingList.length)
         {
            _loc2_ = this.settingList[_loc1_];
            this.removeChild(_loc2_);
            _loc1_++;
         }
         this.settingList = new Vector.<SettingItem>();
      }
      
      public function add(param1:String, param2:String, param3:Array = null) : void
      {
         if(param3 == null)
         {
            param3 = new Array();
         }
         var _loc4_:SettingItem = new SettingItem(param1,param2,param3);
         this.settingList.push(_loc4_);
      }
      
      public function closeClicked(param1:MouseEvent) : void
      {
         close();
      }
      
      public function save(param1:MouseEvent) : void
      {
         this.saveUserSettings();
         close();
      }
      
      public function saveUserSettings() : void
      {
         var settingItem:SettingItem = null;
         for each(settingItem in this.settingList)
         {
            try
            {
               Connectr.instance.avatarModel.settings[settingItem.key] = settingItem.value;
            }
            catch(e:Error)
            {
            }
         }
         Connectr.instance.serviceModel.requestData(RequestDataKey.CHANGE_AVATAR_SETTINGS,{"settings":Connectr.instance.avatarModel.settings.getData()},null);
      }
      
      private function isSoundMuted(param1:Boolean) : void
      {
         var _loc2_:SoundTransform = new SoundTransform();
         if(param1 == true)
         {
            _loc2_.volume = 0;
            SoundMixer.soundTransform = _loc2_;
         }
         else
         {
            _loc2_.volume = 1;
            SoundMixer.soundTransform = _loc2_;
         }
      }
      
      override public function dispose() : void
      {
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.closeClicked);
         this.btnSave.removeEventListener(MouseEvent.CLICK,this.save);
         super.dispose();
      }
   }
}

package org.oyunstudyosu.sanalika.panels.avatarSwitch
{
   import com.greensock.TweenMax;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.AvatarEvent;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.panel.PanelType;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import org.oyunstudyosu.components.scrollBar.CoreScrollBar;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.avatarSwitch.AvatarSwitchPanel")]
   public class AvatarSwitchPanel extends Panel
   {
       
      
      public var background:MovieClip;
      
      public var txtA:TextField;
      
      public var txtB:TextField;
      
      public var txtC:TextField;
      
      public var txtD:TextField;
      
      public var txtDescription:TextField;
      
      public var txtInfo:TextField;
      
      public var dragger:MovieClip;
      
      public var btnClose:CloseButton;
      
      public var txtHeader:TextField;
      
      public var txtTitle:TextField;
      
      public var assetUrl:String;
      
      public var strInfo:String;
      
      private var sTxtHeader:STextField;
      
      private var sTxtInfo:STextField;
      
      public var sTxtA:STextField;
      
      public var sTxtB:STextField;
      
      public var sTxtC:STextField;
      
      public var sTxtD:STextField;
      
      public var strDescription:String;
      
      private var sTxtDescription:STextField;
      
      public var avatarList:Array;
      
      public var avatarItem:AvatarItem;
      
      public var avatarHolder:MovieClip;
      
      public var avatarID:String;
      
      private var scrollBarL:CoreScrollBar;
      
      public var mcMaskL:MovieClip;
      
      public var map:Dictionary;
      
      private var sendLoader:URLLoader;
      
      public function AvatarSwitchPanel()
      {
         this.avatarList = [];
         this.map = new Dictionary();
         super();
      }
      
      override public function init() : void
      {
         super.init();
         dragHandler = this.dragger;
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose);
         Dispatcher.addEventListener("switch",this.switchAvatar);
         Dispatcher.addEventListener("create",this.createAvatar);
         Dispatcher.addEventListener("show",this.showAvatar);
         var _loc1_:String = "";
         if(this.sTxtHeader == null)
         {
            this.sTxtHeader = TextFieldManager.convertAsArabicTextField(getChildByName("txtHeader") as TextField,true,true);
            this.sTxtInfo = TextFieldManager.convertAsArabicTextField(getChildByName("txtInfo") as TextField,true,false);
            this.sTxtA = TextFieldManager.convertAsArabicTextField(getChildByName("txtA") as TextField,true,false);
            this.sTxtB = TextFieldManager.convertAsArabicTextField(getChildByName("txtB") as TextField,true,false);
            this.sTxtC = TextFieldManager.convertAsArabicTextField(getChildByName("txtC") as TextField,true,false);
            this.sTxtD = TextFieldManager.convertAsArabicTextField(getChildByName("txtD") as TextField,true,false);
            this.sTxtDescription = TextFieldManager.convertAsArabicTextField(getChildByName("txtDescription") as TextField,true,false);
         }
         this.sTxtHeader.htmlText = $("avatarSwitchHeader");
         this.sTxtInfo.text = $("avatarSwitchInfo");
         this.sTxtDescription.text = $("avatarSwitchDescription");
         Connectr.instance.serviceModel.requestData(RequestDataKey.AVATAR_LIST,{},this.onListResponse);
      }
      
      private function onListResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.AVATAR_LIST,this.onListResponse);
         this.avatarList = param1.avatarList;
         this.scrollBarL = new CoreScrollBar();
         addChild(this.scrollBarL);
         this.scrollBarL.barColor = 1868503;
         this.scrollBarL.bgColor = 16448250;
         this.scrollBarL.scrollBackground.width = 8;
         this.scrollBarL.scrollBackground.height = 8;
         this.scrollBarL.barMask.width = this.scrollBarL.bar.width = 8;
         this.scrollBarL.barMask.height = this.scrollBarL.bar.height = 8;
         this.scrollBarL.direction = "horizontal";
         this.scrollBarL.snap = 100;
         this.scrollBarL.setTarget(this.avatarHolder,this.mcMaskL);
         this.scrollBarL.mode = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.avatarList.length)
         {
            this.avatarItem = new AvatarItem();
            this.avatarItem.x = _loc2_ * 116;
            this.map[this.avatarList[_loc2_].avatarID] = this.avatarList[_loc2_];
            this.avatarItem.init(this.avatarList[_loc2_]);
            this.avatarHolder.addChild(this.avatarItem);
            _loc2_++;
         }
         if(_loc2_ < 5 && Connectr.instance.gameModel.serverName != "marhab" && Connectr.instance.gameModel.serverName != "egypt")
         {
            this.avatarList[_loc2_] = {
               "avatarID":0,
               "avatarName":"",
               "avatarNick":"",
               "gender":"",
               "statusMessage":"",
               "loginCount":0,
               "lastLoginDate":""
            };
            this.avatarItem = new AvatarItem();
            this.avatarItem.x = _loc2_ * 116;
            this.avatarItem.init(this.avatarList[_loc2_]);
            this.avatarHolder.addChild(this.avatarItem);
         }
         this.scrollBarL.containerW = this.avatarHolder.width;
         this.scrollBarL.x = this.avatarHolder.x - 10;
         this.scrollBarL.y = this.avatarHolder.y + this.avatarHolder.height + 20;
         if(_loc2_ < 6)
         {
            this.scrollBarL.visible = false;
         }
         this.avatarList = [];
         param1 = null;
         show();
      }
      
      public function switchAvatar(param1:AvatarEvent) : void
      {
         Connectr.instance.avatarModel.avatarId = param1.avatarID;
         TweenMax.delayedCall(1,this.initServer);
      }
      
      public function initServer() : void
      {
         Connectr.instance.serviceModel.requestData("changeActiveAvatar",{"avatarID":Connectr.instance.avatarModel.avatarId},this.onServerResponse);
      }
      
      private function onServerResponse(param1:Object) : void
      {
         var _loc2_:AlertVo = null;
         Connectr.instance.serviceModel.removeRequestData("changeActiveAvatar",this.onServerResponse);
         if(param1.errorCode)
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.TOOLTIP;
            _loc2_.description = $(param1.errorCode);
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
         }
         else
         {
            this.clearPanel();
            Connectr.instance.reset();
         }
      }
      
      public function showAvatar(param1:AvatarEvent) : void
      {
         var _loc2_:String = null;
         if(param1.avatarID != "0")
         {
            if(this.map[param1.avatarID].gender == "m")
            {
               this.map[param1.avatarID].gender = "male";
            }
            else if(this.map[param1.avatarID].gender == "f")
            {
               this.map[param1.avatarID].gender = "female";
            }
            _loc2_ = "<font color=\'#999999\'> | </font>";
            this.sTxtA.htmlText = "<font color=\'#444444\'>" + $("avatarName") + ":</font> " + this.map[param1.avatarID].avatarName + _loc2_ + "<font color=\'#444444\'>" + $("avatarNick") + ":</font> " + this.map[param1.avatarID].avatarNick + _loc2_ + "<font color=\'#444444\'>" + $("avatarGender") + ":</font> " + $(this.map[param1.avatarID].gender);
            this.sTxtB.htmlText = "<font color=\'#444444\'>" + $("avatarStatusMessage") + ":</font> " + this.map[param1.avatarID].statusMessage;
            this.sTxtC.htmlText = "<font color=\'#444444\'>" + $("registerDate") + ":</font> " + this.map[param1.avatarID].createdAt + _loc2_ + "<font color=\'#444444\'>" + $("avatarLoginCount") + ":</font> " + this.map[param1.avatarID].loginCount + _loc2_ + "<font color=\'#444444\'>" + $("avatarLastLoginDate") + ":</font> " + this.map[param1.avatarID].lastLoginDate + _loc2_ + "<font color=\'#444444\'>" + $("avatarLastRoom") + ":</font> " + $("room_" + this.map[param1.avatarID].lastRoom);
            this.sTxtD.htmlText = "<font color=\'#A87807\'>" + $("SANIL") + ": " + this.map[param1.avatarID].sanil + "</font>" + _loc2_ + "<font color=\'#1B4166\'>" + $("DIAMOND") + ": " + this.map[param1.avatarID].diamond + "</font>";
         }
         else
         {
            this.sTxtA.htmlText = $("avatarCreate");
            this.sTxtB.htmlText = "";
            this.sTxtC.htmlText = "";
            this.sTxtD.htmlText = "";
         }
      }
      
      public function createAvatar(param1:AvatarEvent) : void
      {
         var _loc2_:PanelVO = new PanelVO();
         _loc2_.name = "AvatarCreatePanel";
         _loc2_.params = {};
         _loc2_.params.permitClose = true;
         _loc2_.type = PanelType.STATIC;
         Connectr.instance.panelModel.openPanel(_loc2_);
         this.clearPanel();
      }
      
      protected function clearPanel() : void
      {
         Dispatcher.removeEventListener("switch",this.switchAvatar);
         Dispatcher.removeEventListener("create",this.createAvatar);
         Dispatcher.removeEventListener("show",this.showAvatar);
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.onClose);
         while(this.avatarHolder.numChildren > 0)
         {
            this.avatarHolder.removeChildAt(0);
         }
         close();
      }
      
      protected function onClose(param1:MouseEvent) : void
      {
         this.clearPanel();
      }
   }
}

package org.oyunstudyosu.sanalika.panels.profile
{
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertResponse;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.buddy.BuddyVo;
   import com.oyunstudyosu.engine.ICharacter;
   import com.oyunstudyosu.enums.AvatarPermission;
   import com.oyunstudyosu.enums.LanguageKeys;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.BarterEvent;
   import com.oyunstudyosu.events.BuddyEvent;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.ProfileEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.panel.PanelType;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.tooltip.TooltipAlign;
   import com.printfas3.printf;
   import de.polygonal.core.fmt.Sprintf;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.profile.ProfileMenu")]
   public class ProfileMenu extends CoreMovieClip
   {
       
      
      public var removeFriendButton:SimpleButton;
      
      public var requestFriendButton:SimpleButton;
      
      public var addFriendButton:SimpleButton;
      
      public var tradeButton:SimpleButton;
      
      public var whisperButton:SimpleButton;
      
      public var blockUserButton:SimpleButton;
      
      public var unBlockUserButton:SimpleButton;
      
      public var kickUserFromHomeButton:SimpleButton;
      
      public var banButton:SimpleButton;
      
      public var noticeButton:SimpleButton;
      
      private var avatarID:String;
      
      public var isBuddy:Boolean;
      
      public var isRequest:Boolean;
      
      public var banCount:int;
      
      private var aEvent:ProfileEvent;
      
      public var bg:MovieClip;
      
      private var vo:AlertVo;
      
      private var char:ICharacter;
      
      private var duration:String = "";
      
      public function ProfileMenu(param1:String, param2:Boolean, param3:Boolean, param4:int)
      {
         super();
         this.avatarID = param1;
         this.isBuddy = param2;
         this.isRequest = param3;
         this.banCount = param4;
         this.setProfileVars();
      }
      
      private function banDuration() : String
      {
         switch(this.banCount)
         {
            case 0:
               this.duration = $("Warning");
               break;
            case 1:
               this.duration = printf($("minute"),1);
               break;
            case 2:
               this.duration = printf($("minute"),5);
               break;
            case 3:
               this.duration = printf($("minute"),10);
               break;
            case 4:
               this.duration = printf($("minute"),30);
               break;
            case 5:
               this.duration = printf($("hour"),1);
               break;
            case 6:
               this.duration = printf($("hour"),2);
               break;
            case 7:
               this.duration = printf($("hour"),6);
               break;
            case 8:
               this.duration = printf($("day"),1);
               break;
            case 9:
               this.duration = printf($("week"),1);
               break;
            case 10:
               this.duration = printf($("month"),1);
         }
         return this.duration;
      }
      
      override public function added() : void
      {
         Connectr.instance.toolTipModel.addTip(this.addFriendButton,$("addFriendButton"),TooltipAlign.ALIGN_LEFT);
         Connectr.instance.toolTipModel.addTip(this.removeFriendButton,$("removeFriendButton"),TooltipAlign.ALIGN_LEFT);
         Connectr.instance.toolTipModel.addTip(this.requestFriendButton,$("requestFriendButton"),TooltipAlign.ALIGN_LEFT);
         Connectr.instance.toolTipModel.addTip(this.tradeButton,$("tradeButton"),TooltipAlign.ALIGN_LEFT);
         Connectr.instance.toolTipModel.addTip(this.blockUserButton,$("blockUserButton"),TooltipAlign.ALIGN_LEFT);
         Connectr.instance.toolTipModel.addTip(this.unBlockUserButton,$("unBlockUserButton"),TooltipAlign.ALIGN_LEFT);
         Connectr.instance.toolTipModel.addTip(this.whisperButton,$("whisperButton"),TooltipAlign.ALIGN_LEFT);
         Connectr.instance.toolTipModel.addTip(this.kickUserFromHomeButton,$("kickUserFromHome"),TooltipAlign.ALIGN_LEFT);
         var _loc1_:ICharacter = Connectr.instance.engine.scene.getAvatarById(this.avatarID);
         if(Connectr.instance.avatarModel.atHome)
         {
            this.kickUserFromHomeButton.visible = true;
            this.bg.height = 240;
         }
         else
         {
            this.kickUserFromHomeButton.visible = false;
            this.bg.height = 200;
         }
         if(Boolean(Connectr.instance.avatarModel.permission.check(AvatarPermission.CARD_SECURITY)) && !_loc1_.isMe)
         {
            Connectr.instance.toolTipModel.addTip(this.banButton,$("kickButton") + " [" + this.banDuration() + "]",TooltipAlign.ALIGN_LEFT);
            Connectr.instance.toolTipModel.addTip(this.noticeButton,$("noticeButton"),TooltipAlign.ALIGN_LEFT);
            this.banButton.addEventListener(MouseEvent.CLICK,this.banButtonClicked);
            this.noticeButton.addEventListener(MouseEvent.CLICK,this.noticeButtonClicked);
            this.bg.height = 290;
         }
         else
         {
            this.noticeButton.visible = false;
            this.banButton.visible = false;
         }
         y = 24;
      }
      
      protected function banButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:PanelVO = new PanelVO();
         _loc2_.name = "BanPanel";
         _loc2_.params = {};
         _loc2_.params.action = "kick";
         _loc2_.params.avatarID = this.avatarID;
         _loc2_.params.banCount = this.banCount;
         _loc2_.params.duration = this.duration;
         _loc2_.type = PanelType.HUD;
         Connectr.instance.panelModel.openPanel(_loc2_);
      }
      
      protected function noticeButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:PanelVO = new PanelVO();
         _loc2_.name = "BanPanel";
         _loc2_.params = {};
         _loc2_.params.action = "notice";
         _loc2_.params.avatarID = this.avatarID;
         _loc2_.params.banCount = this.banCount;
         _loc2_.params.duration = this.duration;
         _loc2_.type = PanelType.HUD;
         Connectr.instance.panelModel.openPanel(_loc2_);
      }
      
      public function setProfileVars() : void
      {
         if(this.isBuddy)
         {
            this.requestFriendButton.visible = false;
            this.addFriendButton.visible = false;
            this.removeFriendButton.visible = true;
         }
         else if(this.isRequest)
         {
            this.addFriendButton.visible = false;
            this.removeFriendButton.visible = false;
            this.requestFriendButton.visible = true;
         }
         else
         {
            this.requestFriendButton.visible = false;
            this.removeFriendButton.visible = false;
            this.addFriendButton.visible = true;
         }
         if(Connectr.instance.avatarModel.isBlocked(this.avatarID.toString()))
         {
            this.unBlockUserButton.visible = true;
            this.blockUserButton.visible = false;
         }
         else
         {
            this.blockUserButton.visible = true;
            this.unBlockUserButton.visible = false;
         }
         this.whisperButton.addEventListener(MouseEvent.CLICK,this.whisperButtonClicked);
         this.blockUserButton.addEventListener(MouseEvent.CLICK,this.blockUserButtonClicked);
         this.removeFriendButton.addEventListener(MouseEvent.CLICK,this.removeFriendClicked);
         this.addFriendButton.addEventListener(MouseEvent.CLICK,this.addFriendClicked);
         this.unBlockUserButton.addEventListener(MouseEvent.CLICK,this.unBlockUserButtonClicked);
         this.tradeButton.addEventListener(MouseEvent.CLICK,this.tradeButtonClicked);
         this.kickUserFromHomeButton.addEventListener(MouseEvent.CLICK,this.kickButtonClicked);
      }
      
      protected function kickButtonClicked(param1:MouseEvent) : void
      {
         this.char = Connectr.instance.engine.scene.getAvatarById(this.avatarID);
         if(this.char == null)
         {
            return;
         }
         this.vo = new AlertVo();
         this.vo.alertType = AlertType.KICK_SELECT_TIME;
         this.vo.title = $("Kick User");
         this.vo.stepperComment = $("kickComboBoxInfo");
         this.vo.callBack = this.kickResponse;
         this.vo.description = printf(LanguageKeys.KICK_FROM_HOME_ALERT,this.char.avatarName);
         Dispatcher.dispatchEvent(new AlertEvent(this.vo));
      }
      
      private function kickResponse(param1:int, param2:Number) : void
      {
         if(param1 == AlertResponse.OK)
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.KICK_AVATAR_FROM_ROOM,{
               "avatarID":this.avatarID,
               "duration":param2
            },this.kickAvatarResponse);
         }
      }
      
      private function kickAvatarResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.KICK_AVATAR_FROM_ROOM,this.kickAvatarResponse);
         if(!param1.errorCode)
         {
            this.vo = new AlertVo();
            this.vo.alertType = AlertType.TOOLTIP;
            this.vo.description = printf(LanguageKeys.KICKED_FROM_HOME,this.char.avatarName);
            Dispatcher.dispatchEvent(new AlertEvent(this.vo));
         }
      }
      
      protected function tradeButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:BarterEvent = null;
         var _loc3_:AlertVo = null;
         if(this.isBuddy)
         {
            _loc2_ = new BarterEvent(BarterEvent.BARTER_START_REQUEST);
            _loc2_.avatarID = this.avatarID;
            Dispatcher.dispatchEvent(_loc2_);
         }
         else
         {
            _loc3_ = new AlertVo();
            _loc3_.alertType = AlertType.TOOLTIP;
            _loc3_.description = $("barterRequirement");
            Dispatcher.dispatchEvent(new AlertEvent(_loc3_));
         }
      }
      
      protected function whisperButtonClicked(param1:MouseEvent) : void
      {
         this.aEvent = new ProfileEvent(ProfileEvent.WHISPER);
         this.aEvent.avatarID = this.avatarID.toString();
         this.aEvent.whisperMode = true;
         Dispatcher.dispatchEvent(this.aEvent);
      }
      
      protected function blockUserButtonClicked(param1:MouseEvent) : void
      {
         this.unBlockUserButton.visible = true;
         this.blockUserButton.visible = false;
         this.aEvent = new ProfileEvent(ProfileEvent.BLOCK);
         this.aEvent.avatarID = this.avatarID.toString();
         Dispatcher.dispatchEvent(this.aEvent);
      }
      
      protected function unBlockUserButtonClicked(param1:MouseEvent) : void
      {
         this.unBlockUserButton.visible = false;
         this.blockUserButton.visible = true;
         this.aEvent = new ProfileEvent(ProfileEvent.UNBLOCK);
         this.aEvent.avatarID = this.avatarID.toString();
         Dispatcher.dispatchEvent(this.aEvent);
      }
      
      protected function houseButtonClicked(param1:MouseEvent) : void
      {
         this.aEvent = new ProfileEvent(ProfileEvent.SHOW_ROOMS);
         this.aEvent.avatarID = this.avatarID.toString();
         Dispatcher.dispatchEvent(this.aEvent);
      }
      
      protected function removeFriendClicked(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         var buddyVo:BuddyVo = Sanalika.instance.buddyModel.getBuddyVoById(this.avatarID);
         var avatarName:String = buddyVo == null ? this.avatarID : buddyVo.avatarName;
         var vo:AlertVo = new AlertVo();
         vo.alertType = AlertType.CONFIRM;
         vo.callBack = function(param1:int):*
         {
            var _loc2_:BuddyEvent = null;
            if(param1 == AlertResponse.OK)
            {
               removeFriendButton.visible = false;
               addFriendButton.visible = true;
               _loc2_ = new BuddyEvent(BuddyEvent.REMOVE_BUDDY);
               _loc2_.avatarID = avatarID;
               Dispatcher.dispatchEvent(_loc2_);
            }
         };
         vo.description = Sprintf.format(Sanalika.instance.localizationModel.translate(LanguageKeys.BUDDY_REMOVE_CONFIRM),[avatarName]);
         Dispatcher.dispatchEvent(new AlertEvent(vo));
      }
      
      protected function addFriendClicked(param1:MouseEvent) : void
      {
         this.addFriendButton.visible = false;
         this.requestFriendButton.visible = true;
         var _loc2_:BuddyEvent = new BuddyEvent(BuddyEvent.ADD_FRIEND);
         _loc2_.avatarID = this.avatarID;
         Dispatcher.dispatchEvent(_loc2_);
      }
      
      override public function removed() : void
      {
         this.whisperButton.removeEventListener(MouseEvent.CLICK,this.whisperButtonClicked);
         this.blockUserButton.removeEventListener(MouseEvent.CLICK,this.blockUserButtonClicked);
         this.unBlockUserButton.removeEventListener(MouseEvent.CLICK,this.unBlockUserButtonClicked);
         this.removeFriendButton.removeEventListener(MouseEvent.CLICK,this.removeFriendClicked);
         this.addFriendButton.removeEventListener(MouseEvent.CLICK,this.addFriendClicked);
         this.tradeButton.removeEventListener(MouseEvent.CLICK,this.tradeButtonClicked);
         this.kickUserFromHomeButton.removeEventListener(MouseEvent.CLICK,this.kickButtonClicked);
         this.banButton.removeEventListener(MouseEvent.CLICK,this.banButtonClicked);
         this.noticeButton.removeEventListener(MouseEvent.CLICK,this.noticeButtonClicked);
         Connectr.instance.toolTipModel.removeTip(this.banButton);
         Connectr.instance.toolTipModel.removeTip(this.noticeButton);
         Connectr.instance.toolTipModel.removeTip(this.addFriendButton);
         Connectr.instance.toolTipModel.removeTip(this.requestFriendButton);
         Connectr.instance.toolTipModel.removeTip(this.removeFriendButton);
         Connectr.instance.toolTipModel.removeTip(this.tradeButton);
         Connectr.instance.toolTipModel.removeTip(this.blockUserButton);
         Connectr.instance.toolTipModel.removeTip(this.unBlockUserButton);
         Connectr.instance.toolTipModel.removeTip(this.whisperButton);
         Connectr.instance.toolTipModel.removeTip(this.kickUserFromHomeButton);
      }
   }
}

package org.oyunstudyosu.sanalika.panels.cellphone.apps.runwin
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.components.MobileScroll;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   import org.oyunstudyosu.sanalika.buttons.newButtons.BlueButton;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.runwin.RunWinView")]
   public class RunWinView extends CoreMovieClip
   {
       
      
      public var txtDescription:TextField;
      
      public var txtHeader:TextField;
      
      public var txtInputDesc:TextField;
      
      public var txtInputError:TextField;
      
      private var myItem:TeamItem;
      
      private var myListID:Object;
      
      public var headerBg:MovieClip;
      
      public var sHeader:STextField;
      
      public var sDescription:STextField;
      
      public var request:AssetRequest;
      
      public var btnNewTeam:BlueButton;
      
      public var btnJoinTeam:BlueButton;
      
      public var inpField:TextField;
      
      public var sInpDesc:STextField;
      
      public var sInputError:STextField;
      
      public var inputBg:MovieClip;
      
      public var scrollContainer:MobileScroll;
      
      private var list:Boolean;
      
      public function RunWinView()
      {
         super();
      }
      
      override public function added() : void
      {
         this.scrollContainer = new MobileScroll();
         this.scrollContainer.y = this.headerBg.height + this.headerBg.y;
         this.scrollContainer.x = 232;
         this.scrollContainer.init(230,330,2);
         this.addChild(this.scrollContainer);
         if(this.sHeader == null)
         {
            this.sHeader = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtHeader") as TextField,false);
            this.sDescription = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtDescription") as TextField,true,false);
            this.sInpDesc = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtInputDesc") as TextField,false);
            this.sInputError = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtInputError") as TextField,false);
         }
         this.sHeader.text = $("TeamList");
         this.inputBg.visible = false;
         this.inpField.visible = false;
         this.btnNewTeam.visible = false;
         this.btnJoinTeam.visible = false;
         this.sInpDesc.visible = false;
         Connectr.instance.serviceModel.requestData(RequestDataKey.RUNWIN_STATUS,{},this.onResponse);
      }
      
      public function closeView(param1:MouseEvent = null) : void
      {
         TweenMax.to(this,0.2,{
            "x":0,
            "ease":Linear.easeIn
         });
      }
      
      private function onResponse(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.RUNWIN_STATUS,this.onResponse);
         this.btnNewTeam.visible = false;
         this.btnJoinTeam.visible = false;
         this.inpField.visible = false;
         this.inputBg.visible = false;
         this.sInpDesc.visible = false;
         this.sInputError.visible = false;
         if(param1.response == "success")
         {
            _loc2_ = "<font color=\'#DD0000\'>" + $("TeamName") + "</font>" + "<br>";
            _loc2_ += param1.title + "<br>";
            if(param1.secret)
            {
               _loc2_ += "<font color=\'#DD0000\'>" + $("TeamSecret") + "</font>" + "<br>";
               _loc2_ += param1.secret + "<br>";
            }
            if(param1.members)
            {
               _loc2_ += "<font color=\'#DD0000\'>" + $("TeamMembers") + "</font>" + "<br>";
               _loc3_ = 0;
               while(_loc3_ < param1.members.length)
               {
                  _loc2_ += param1.members[_loc3_].avatarName + " [" + param1.members[_loc3_].avatarID + "]" + "<br>";
                  _loc3_++;
               }
            }
            this.sDescription.htmlText = _loc2_;
         }
         else
         {
            this.sDescription.htmlText = $("TeamCreateOrJoinDesc");
            this.btnNewTeam.visible = true;
            this.btnJoinTeam.visible = true;
            this.btnNewTeam.setText($("TeamCreate"));
            this.btnJoinTeam.setText($("TeamJoin"));
            this.btnNewTeam.addEventListener(MouseEvent.CLICK,this.btnNewTeamClicked);
            this.btnJoinTeam.addEventListener(MouseEvent.CLICK,this.btnJoinTeamClicked);
         }
         param1 = null;
      }
      
      private function createTeam(param1:MouseEvent) : void
      {
         if(this.inpField.text == "")
         {
            return;
         }
         Connectr.instance.serviceModel.requestData(RequestDataKey.RUNWIN_NEWTEAM,{"title":this.inpField.text},this.onTeamCreated);
      }
      
      private function joinTeam(param1:MouseEvent) : void
      {
         if(this.inpField.text == "")
         {
            return;
         }
         Connectr.instance.serviceModel.requestData(RequestDataKey.RUNWIN_JOINTEAM,{"secret":this.inpField.text},this.onTeamJoined);
      }
      
      private function reload(param1:MouseEvent) : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.RUNWIN_STATUS,{},this.onResponse);
      }
      
      private function onTeamJoined(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.RUNWIN_JOINTEAM,this.onTeamJoined);
         if(param1.response == "success")
         {
            this.sInpDesc.text = $("TeamJoined");
            this.btnJoinTeam.removeEventListener(MouseEvent.CLICK,this.joinTeam);
            this.btnJoinTeam.addEventListener(MouseEvent.CLICK,this.reload);
            this.btnJoinTeam.setText($("Close"));
            this.inputBg.visible = false;
            this.inpField.visible = false;
            this.sInputError.visible = false;
         }
         else
         {
            this.sInputError.visible = true;
            if(param1.reason)
            {
               this.sInputError.text = $(param1.reason);
            }
            else
            {
               this.sInputError.text = $("TeamJoinFail");
            }
         }
      }
      
      private function onTeamCreated(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.RUNWIN_NEWTEAM,this.onTeamCreated);
         if(param1.response == "success")
         {
            this.sInpDesc.text = $("TeamCreated");
            this.btnNewTeam.removeEventListener(MouseEvent.CLICK,this.createTeam);
            this.btnNewTeam.addEventListener(MouseEvent.CLICK,this.reload);
            this.btnNewTeam.setText($("Close"));
            this.inputBg.visible = false;
            this.inpField.visible = false;
            this.sInputError.visible = false;
         }
         else
         {
            this.sInputError.visible = true;
            if(param1.reason)
            {
               this.sInputError.text = $(param1.reason);
            }
            else
            {
               this.sInputError.text = $("TeamCreateFail");
            }
         }
      }
      
      public function getTeamList() : void
      {
         if(!this.list)
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.RUNWIN_TEAMLIST,{},this.onTeamListResponse);
         }
         else
         {
            TweenMax.to(this,0.3,{
               "x":-230,
               "ease":Linear.easeOut
            });
         }
      }
      
      private function onTeamListResponse(param1:*) : void
      {
         var _loc3_:TeamItem = null;
         this.list = true;
         var _loc2_:int = 0;
         while(_loc2_ < param1.teams.length)
         {
            _loc3_ = new TeamItem();
            _loc3_.data = param1.teams[_loc2_];
            this.scrollContainer.listContainer.addChild(_loc3_);
            _loc2_++;
         }
         param1 = null;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.RUNWIN_TEAMLIST,this.onTeamListResponse);
         TweenMax.to(this,0.3,{
            "x":-230,
            "ease":Linear.easeOut
         });
      }
      
      private function btnNewTeamClicked(param1:MouseEvent) : void
      {
         this.btnNewTeam.removeEventListener(MouseEvent.CLICK,this.btnNewTeamClicked);
         this.btnNewTeam.addEventListener(MouseEvent.CLICK,this.createTeam);
         this.sInpDesc.visible = true;
         this.sInpDesc.text = $("TeamName");
         this.inputBg.visible = true;
         this.inpField.visible = true;
         this.btnJoinTeam.visible = false;
         this.btnNewTeam.setText($("Create"));
      }
      
      private function btnJoinTeamClicked(param1:MouseEvent) : void
      {
         this.sInpDesc.visible = true;
         this.sInpDesc.text = $("TeamSecret");
         this.inputBg.visible = true;
         this.inpField.visible = true;
         this.btnNewTeam.visible = false;
         this.btnJoinTeam.removeEventListener(MouseEvent.CLICK,this.btnJoinTeamClicked);
         this.btnJoinTeam.addEventListener(MouseEvent.CLICK,this.joinTeam);
         this.btnJoinTeam.setText($("Join"));
      }
      
      override public function removed() : void
      {
         this.scrollContainer.dispose();
         this.removeChild(this.scrollContainer);
      }
   }
}

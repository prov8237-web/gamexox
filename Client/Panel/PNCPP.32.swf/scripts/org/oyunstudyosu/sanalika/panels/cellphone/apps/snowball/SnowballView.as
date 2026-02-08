package org.oyunstudyosu.sanalika.panels.cellphone.apps.snowball
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.components.MobileScroll;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.sanalika.sound.SoundKey;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.snowball.SnowballView")]
   public class SnowballView extends CoreMovieClip
   {
       
      
      public var txtDescription:TextField;
      
      public var txtHeader:TextField;
      
      private var myListID:Object;
      
      public var headerBg:MovieClip;
      
      public var txtRed:TextField;
      
      public var txtBlue:TextField;
      
      public var sHeader:STextField;
      
      public var sTxtMessage:STextField;
      
      public var request:AssetRequest;
      
      public var inpField:TextField;
      
      public var inputBg:MovieClip;
      
      public var scrollContainer:MobileScroll;
      
      private var list:Boolean;
      
      private var myItem:TeamItem;
      
      public var btnBlueTeam:SimpleButton;
      
      public var btnRedTeam:SimpleButton;
      
      public function SnowballView()
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
            this.sTxtMessage = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtDescription") as TextField,true,false);
         }
         this.sHeader.text = $("TeamList");
         this.inputBg.visible = false;
         this.inpField.visible = false;
         Connectr.instance.serviceModel.listenExtension(RequestDataKey.SNOWBALL,this.snowball);
         Connectr.instance.serviceModel.requestData(RequestDataKey.SNOWBALL_ACTION,{"type":"joinTeam"},this.onResponse);
         this.btnBlueTeam.addEventListener(MouseEvent.CLICK,this.showBlueTeam);
         this.btnRedTeam.addEventListener(MouseEvent.CLICK,this.showRedTeam);
      }
      
      private function showRedTeam(param1:MouseEvent) : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.SNOWBALL_ACTION,{"type":"redTeam"},this.onShowTeamResponse);
      }
      
      private function showBlueTeam(param1:MouseEvent) : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.SNOWBALL_ACTION,{"type":"blueTeam"},this.onShowTeamResponse);
      }
      
      private function onShowTeamResponse(param1:Object) : void
      {
         var _loc3_:TeamItem = null;
         TweenMax.to(this,0.3,{
            "x":-230,
            "ease":Linear.easeOut
         });
         this.list = true;
         var _loc2_:int = 0;
         while(_loc2_ < param1.team.length)
         {
            _loc3_ = new TeamItem();
            _loc3_.data = param1.team[_loc2_];
            this.scrollContainer.listContainer.addChild(_loc3_);
            _loc2_++;
         }
         param1 = null;
         TweenMax.to(this,0.3,{
            "x":-230,
            "ease":Linear.easeOut
         });
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SNOWBALL_ACTION,this.onShowTeamResponse);
      }
      
      private function snowball(param1:Object) : void
      {
         switch(param1.type)
         {
            case "s":
               Connectr.instance.soundModel.playSound(SoundKey.ALERT,1,1);
               this.txtRed.text = param1.r;
               this.txtBlue.text = param1.b;
               break;
            case "e":
            case "s":
               break;
            case "m":
               this.showMessage(param1.m);
               break;
            case "p":
            case "l":
         }
      }
      
      private function showMessage(param1:String) : void
      {
         this.sTxtMessage.htmlText = $(param1);
      }
      
      public function closeView(param1:MouseEvent = null) : void
      {
         TweenMax.to(this,0.2,{
            "x":0,
            "ease":Linear.easeIn
         });
         while(this.scrollContainer.listContainer.numChildren > 0)
         {
            this.scrollContainer.listContainer.removeChildAt(0);
         }
      }
      
      private function onResponse(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.SNOWBALL_ACTION,this.onResponse);
         if(param1.errorCode)
         {
            return;
         }
         this.sTxtMessage.htmlText = param1.result;
         this.txtRed.text = "";
         this.txtBlue.text = "";
         param1 = null;
      }
      
      override public function removed() : void
      {
         if(this.scrollContainer)
         {
            this.scrollContainer.dispose();
            this.removeChild(this.scrollContainer);
         }
      }
   }
}

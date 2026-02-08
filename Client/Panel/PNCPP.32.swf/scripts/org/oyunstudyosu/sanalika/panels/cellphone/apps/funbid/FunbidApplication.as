package org.oyunstudyosu.sanalika.panels.cellphone.apps.funbid
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.greensock.easing.Quint;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.DrawUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.oyunstudyosu.sanalika.panels.cellphone.CellPhoneApplication;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funbid.FunbidApplication")]
   public class FunbidApplication extends CellPhoneApplication
   {
       
      
      public var bg:MovieClip;
      
      private var funbidView:FunbidView;
      
      private var welcomeView:WelcomeView;
      
      private var index:int;
      
      private var sceneContainer:Sprite;
      
      private var sceneContainerMask:Sprite;
      
      private var timeoutId:uint;
      
      public function FunbidApplication()
      {
         super();
      }
      
      override public function init() : void
      {
         this.index = this.getChildIndex(this.bg) + 1;
         this.sceneContainer = new Sprite();
         this.addChildAt(this.sceneContainer,this.index);
         this.sceneContainerMask = DrawUtils.getRectangleSprite(228,375,0,1);
         this.addChild(this.sceneContainerMask);
         this.sceneContainer.mask = this.sceneContainerMask;
         this.welcomeView = new WelcomeView();
         this.sceneContainer.addChild(this.welcomeView);
         this.timeoutId = setTimeout(this.showFunbid,2000);
      }
      
      private function showFunbid() : void
      {
         this.funbidView = new FunbidView();
         this.sceneContainer.addChild(this.funbidView);
         TweenMax.to(this.funbidView,0.6,{
            "y":0,
            "ease":Quint.easeOut,
            "onComplete":this.clearWelcome
         });
      }
      
      private function clearWelcome() : void
      {
         if(this.welcomeView != null)
         {
            this.sceneContainer.removeChild(this.welcomeView);
            this.welcomeView = null;
         }
      }
      
      public function closeClicked(param1:MouseEvent) : void
      {
         TweenMax.to(this.funbidView,0.2,{
            "x":0,
            "ease":Linear.easeNone
         });
      }
      
      override public function dispose() : void
      {
         Connectr.instance.serviceModel.requestData("funbid.leave",{},null);
         clearTimeout(this.timeoutId);
         this.clearWelcome();
         if(this.sceneContainer != null)
         {
            this.removeChild(this.sceneContainer);
            this.removeChild(this.sceneContainerMask);
         }
         if(this.funbidView != null)
         {
            TweenMax.killDelayedCallsTo(this.funbidView);
            this.funbidView.dispose();
            this.funbidView = null;
         }
         this.sceneContainer = null;
         this.sceneContainerMask = null;
      }
   }
}

package org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.oyunstudyosu.utils.DrawUtils;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.oyunstudyosu.sanalika.panels.cellphone.CellPhoneApplication;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin.FunwinApplication")]
   public class FunwinApplication extends CellPhoneApplication
   {
       
      
      private var funwinView:FunwinView;
      
      private var welcomeView:WelcomeView;
      
      private var funwinTopListView:FunwinTopListView;
      
      public var bg:MovieClip;
      
      private var index:int;
      
      private var sceneContainer:Sprite;
      
      private var sceneContainerMask:Sprite;
      
      public var btnTopList:SimpleButton;
      
      public function FunwinApplication()
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
         TweenMax.delayedCall(2,this.showFunwin);
         this.btnTopList.visible = false;
      }
      
      private function clearWelcome() : void
      {
         if(this.welcomeView)
         {
            this.sceneContainer.removeChild(this.welcomeView);
            this.welcomeView = null;
            this.btnTopList.visible = true;
            this.btnTopList.addEventListener(MouseEvent.CLICK,this.showTopList);
         }
      }
      
      private function showTopList(param1:MouseEvent = null) : void
      {
         if(Boolean(this.funwinTopListView) && this.sceneContainer.contains(this.funwinTopListView))
         {
            this.sceneContainer.removeChild(this.funwinTopListView);
            this.funwinTopListView = null;
         }
         else
         {
            this.funwinTopListView = new FunwinTopListView();
            this.sceneContainer.addChild(this.funwinTopListView);
            TweenMax.to(this.funwinTopListView,0.6,{
               "y":0,
               "ease":Quint.easeOut,
               "onComplete":this.clearWelcome
            });
         }
      }
      
      private function showFunwin() : void
      {
         this.funwinView = new FunwinView();
         this.sceneContainer.addChild(this.funwinView);
         this.funwinView.y = 350;
         TweenMax.to(this.funwinView,0.6,{
            "y":0,
            "ease":Quint.easeOut,
            "onComplete":this.clearWelcome
         });
      }
      
      override public function dispose() : void
      {
         if(this.sceneContainer)
         {
            this.removeChild(this.sceneContainer);
            this.removeChild(this.sceneContainerMask);
         }
         TweenMax.killDelayedCallsTo(this.showFunwin);
         TweenMax.killTweensOf(this.funwinView);
         TweenMax.killTweensOf(this.welcomeView);
         TweenMax.killTweensOf(this.funwinTopListView);
         this.sceneContainer = null;
         this.sceneContainerMask = null;
         this.funwinView = null;
         this.welcomeView = null;
         this.funwinTopListView = null;
      }
   }
}

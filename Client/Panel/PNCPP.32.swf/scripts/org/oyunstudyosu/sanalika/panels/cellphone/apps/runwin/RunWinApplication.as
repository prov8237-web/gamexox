package org.oyunstudyosu.sanalika.panels.cellphone.apps.runwin
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.DrawUtils;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.oyunstudyosu.sanalika.panels.cellphone.CellPhoneApplication;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.runwin.RunWinApplication")]
   public class RunWinApplication extends CellPhoneApplication
   {
       
      
      private var runWinView:RunWinView;
      
      public var bg:MovieClip;
      
      private var index:int;
      
      private var sceneContainer:Sprite;
      
      private var sceneContainerMask:Sprite;
      
      public var btnTopList:SimpleButton;
      
      public function RunWinApplication()
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
         this.runWinView = new RunWinView();
         this.sceneContainer.addChild(this.runWinView);
         Connectr.instance.toolTipModel.addTip(this.btnTopList,$("TeamList"));
         this.btnTopList.addEventListener(MouseEvent.CLICK,this.btnTopListClicked);
         this.runWinView.headerBg.addEventListener(MouseEvent.CLICK,this.closeTeamListClicked);
         this.runWinView.headerBg.buttonMode = true;
         this.btnTopList.visible = true;
      }
      
      private function btnTopListClicked(param1:MouseEvent) : void
      {
         this.runWinView.getTeamList();
         this.btnTopList.visible = false;
      }
      
      private function closeTeamListClicked(param1:MouseEvent) : void
      {
         TweenMax.to(this.runWinView,0.2,{
            "x":0,
            "ease":Linear.easeIn
         });
         this.btnTopList.visible = true;
      }
      
      override public function dispose() : void
      {
         this.btnTopList.removeEventListener(MouseEvent.CLICK,this.btnTopListClicked);
         this.runWinView.headerBg.removeEventListener(MouseEvent.CLICK,this.closeTeamListClicked);
         if(this.sceneContainer)
         {
            this.removeChild(this.sceneContainer);
            this.removeChild(this.sceneContainerMask);
         }
         this.sceneContainer = null;
         this.sceneContainerMask = null;
         this.runWinView = null;
      }
   }
}

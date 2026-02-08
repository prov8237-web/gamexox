package org.oyunstudyosu.sanalika.panels.cellphone.apps.snowball
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.oyunstudyosu.utils.DrawUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.oyunstudyosu.sanalika.panels.cellphone.CellPhoneApplication;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.snowball.SnowballApplication")]
   public class SnowballApplication extends CellPhoneApplication
   {
       
      
      private var snowballView:SnowballView;
      
      public var bg:MovieClip;
      
      private var index:int;
      
      private var sceneContainer:Sprite;
      
      private var sceneContainerMask:Sprite;
      
      public function SnowballApplication()
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
         this.snowballView = new SnowballView();
         this.sceneContainer.addChild(this.snowballView);
         this.snowballView.headerBg.addEventListener(MouseEvent.CLICK,this.closeTeamListClicked);
         this.snowballView.headerBg.buttonMode = true;
      }
      
      private function closeTeamListClicked(param1:MouseEvent) : void
      {
         TweenMax.to(this.snowballView,0.2,{
            "x":0,
            "ease":Linear.easeIn
         });
      }
      
      override public function dispose() : void
      {
         this.snowballView.headerBg.removeEventListener(MouseEvent.CLICK,this.closeTeamListClicked);
         if(this.sceneContainer)
         {
            this.removeChild(this.sceneContainer);
            this.removeChild(this.sceneContainerMask);
         }
         this.sceneContainer = null;
         this.sceneContainerMask = null;
         this.snowballView = null;
      }
   }
}

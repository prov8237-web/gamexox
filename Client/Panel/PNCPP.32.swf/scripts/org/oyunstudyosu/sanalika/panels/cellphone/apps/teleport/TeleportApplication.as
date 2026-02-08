package org.oyunstudyosu.sanalika.panels.cellphone.apps.teleport
{
   import com.oyunstudyosu.utils.DrawUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import org.oyunstudyosu.sanalika.panels.cellphone.CellPhoneApplication;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.teleport.TeleportApplication")]
   public class TeleportApplication extends CellPhoneApplication
   {
       
      
      private var teleportView:TeleportView;
      
      public var bg:MovieClip;
      
      private var index:int;
      
      private var sceneContainer:Sprite;
      
      private var sceneContainerMask:Sprite;
      
      public function TeleportApplication()
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
         this.teleportView = new TeleportView();
         this.sceneContainer.addChild(this.teleportView);
      }
      
      override public function dispose() : void
      {
         if(this.sceneContainer)
         {
            this.removeChild(this.sceneContainer);
            this.removeChild(this.sceneContainerMask);
         }
         this.sceneContainer = null;
         this.sceneContainerMask = null;
         this.teleportView = null;
      }
   }
}

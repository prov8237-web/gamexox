package org.oyunstudyosu.sanalika.panels.settings
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.settings.OnOffButton")]
   public class OnOffButton extends CoreMovieClip
   {
       
      
      public var dragMc:MovieClip;
      
      public var onTextField:TextField;
      
      public var offTextfield:TextField;
      
      public var mcX:MovieClip;
      
      public var mcY:MovieClip;
      
      private var isDrag:Boolean = false;
      
      private var _selected:Boolean;
      
      private var rect:Rectangle;
      
      public function OnOffButton()
      {
         super();
      }
      
      override public function added() : void
      {
         this.rect = new Rectangle(2,2,18,0);
         this.buttonMode = true;
         this.mouseChildren = false;
         this.addEventListener(MouseEvent.CLICK,this.dragClicked);
         this.dragMc.x = 2;
      }
      
      protected function dragClicked(param1:MouseEvent) : void
      {
         this.selected = !this.selected;
         this.updatePosition();
      }
      
      public function disable() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.dragClicked);
      }
      
      protected function startDragging(param1:MouseEvent) : void
      {
         this.dragMc.startDrag(false,this.rect);
         Connectr.instance.layerModel.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.moveItem);
         Connectr.instance.layerModel.stage.addEventListener(MouseEvent.MOUSE_UP,this.stopDragging);
         this.isDrag = true;
      }
      
      protected function stopDragging(param1:MouseEvent) : void
      {
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveItem);
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopDragging);
         this.dragMc.stopDrag();
         this.updatePosition();
         this.isDrag = false;
      }
      
      private function updatePosition() : void
      {
         if(!this.selected)
         {
            TweenLite.to(this.dragMc,0.1,{
               "x":20,
               "ease":Quad.easeOut
            });
         }
         else
         {
            TweenLite.to(this.dragMc,0.1,{
               "x":2,
               "ease":Quad.easeOut
            });
         }
      }
      
      protected function moveItem(param1:MouseEvent = null) : void
      {
         if(this.dragMc.x > 11)
         {
            this.selected = false;
            this.mcX.visible = true;
            this.mcY.visible = false;
         }
         else
         {
            this.selected = true;
            this.mcY.visible = true;
            this.mcX.visible = false;
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(param1)
         {
            this.dragMc.gotoAndStop(1);
            this.mcY.visible = true;
            this.mcX.visible = false;
         }
         else
         {
            this.dragMc.gotoAndStop(2);
            this.mcX.visible = true;
            this.mcY.visible = false;
         }
         if(!this.isDrag)
         {
            this.updatePosition();
         }
      }
      
      override public function removed() : void
      {
         this.isDrag = false;
         this.selected = true;
      }
   }
}

package org.oyunstudyosu.sanalika.panels.avatarCreate
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.avatarCreate.ShopItemColorPanel")]
   public class ShopItemColorPanel extends MovieClip
   {
       
      
      public var timer:Timer;
      
      public var colorListener:MovieClip;
      
      public var c0:MovieClip;
      
      public var c1:MovieClip;
      
      public var c2:MovieClip;
      
      public var c3:MovieClip;
      
      public var c4:MovieClip;
      
      public var c5:MovieClip;
      
      public var c6:MovieClip;
      
      public var c7:MovieClip;
      
      public var c8:MovieClip;
      
      public function ShopItemColorPanel()
      {
         super();
         this.addEventListener(MouseEvent.MOUSE_OUT,this.msOut);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.msOver);
         this.stop();
         this.c0.addEventListener(MouseEvent.MOUSE_DOWN,this.colorSelected);
         this.c1.addEventListener(MouseEvent.MOUSE_DOWN,this.colorSelected);
         this.c2.addEventListener(MouseEvent.MOUSE_DOWN,this.colorSelected);
         this.c3.addEventListener(MouseEvent.MOUSE_DOWN,this.colorSelected);
         this.c4.addEventListener(MouseEvent.MOUSE_DOWN,this.colorSelected);
         this.c5.addEventListener(MouseEvent.MOUSE_DOWN,this.colorSelected);
         this.c6.addEventListener(MouseEvent.MOUSE_DOWN,this.colorSelected);
         this.c7.addEventListener(MouseEvent.MOUSE_DOWN,this.colorSelected);
         this.c8.addEventListener(MouseEvent.MOUSE_DOWN,this.colorSelected);
      }
      
      public function colorSelected(param1:Event) : void
      {
         if(this.colorListener)
         {
            this.colorListener.setColor(MovieClip(param1.target).color);
         }
      }
      
      private function msOver(param1:Event) : void
      {
         this.rstTimer();
      }
      
      public function msOut(param1:Event) : void
      {
         this.rstTimer();
         this.timer = new Timer(600);
         this.timer.addEventListener(TimerEvent.TIMER,this.destroyColorPnl);
         this.timer.start();
      }
      
      public function destroyColorPnl(param1:Event) : void
      {
         this.rstTimer();
         this.visible = false;
         if(parent)
         {
            MovieClip(parent).removeChild(this);
         }
      }
      
      public function rstTimer() : void
      {
         if(this.timer == null)
         {
            return;
         }
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.destroyColorPnl);
         this.timer = null;
      }
   }
}

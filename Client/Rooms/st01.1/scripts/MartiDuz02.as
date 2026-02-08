package
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="MartiDuz02")]
   public dynamic class MartiDuz02 extends MovieClip
   {
       
      
      public var timer:Timer;
      
      public function MartiDuz02()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function randomize() : void
      {
         var _loc1_:int = Math.random() * 50;
         this.timer = new Timer(_loc1_ * 1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.tick);
         this.timer.start();
      }
      
      public function tick(param1:TimerEvent) : void
      {
         if(this.timer)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.tick);
            this.timer.stop();
            this.timer = null;
         }
         gotoAndPlay(1);
      }
      
      internal function frame1() : *
      {
         stop();
         this.randomize();
      }
   }
}

package org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin.Flake")]
   public class Flake extends MovieClip
   {
       
      
      private var xPos:Number = 0;
      
      private var yPos:Number = 0;
      
      private var xSpeed:Number = 0;
      
      private var ySpeed:Number = 0;
      
      private var radius:Number = 0;
      
      private var scale:Number = 0;
      
      private var alphaValue:Number = 0;
      
      private var maxHeight:Number = 0;
      
      private var maxWidth:Number = 0;
      
      public function Flake()
      {
         super();
         addFrameScript(0,this.frame1);
         this.SetInitialProperties();
      }
      
      public function SetInitialProperties() : void
      {
         this.xSpeed = 0.05 + Math.random() * 0.1;
         this.ySpeed = 0.1 + Math.random() * 3;
         this.radius = 0.1 + Math.random() * 2;
         this.scale = 0.01 + Math.random();
         this.alphaValue = 0.1 + Math.random();
         this.maxWidth = 230;
         this.maxHeight = 375;
         this.gotoAndStop(int(Math.random() * 22) + 1);
         this.x = Math.random() * this.maxWidth;
         this.y = Math.random() * this.maxHeight;
         this.xPos = this.x;
         this.yPos = this.y;
         this.scaleX = this.scaleY = this.scale;
         this.alpha = this.alphaValue;
         this.addEventListener(Event.ENTER_FRAME,this.MoveSnowFlake);
      }
      
      private function MoveSnowFlake(param1:Event) : void
      {
         this.xPos += this.xSpeed;
         this.yPos += this.ySpeed;
         this.x += this.radius * Math.cos(this.xPos);
         this.y += this.ySpeed;
         this.rotation += Math.random() * 5;
         if(this.y - this.height > this.maxHeight)
         {
            this.y = -10 - this.height;
            this.x = Math.random() * this.maxWidth;
         }
      }
      
      public function dispose() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.MoveSnowFlake);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

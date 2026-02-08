package org.oyunstudyosu.assets.clips
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.assets.clips.BotMessageUI")]
   public dynamic class BotMessageUI extends MovieClip
   {
       
      
      public var background:MovieClip;
      
      public var botMask:MovieClip;
      
      public var botPng:MovieClip;
      
      public var hitButton:MovieClip;
      
      public var maskContainer:MovieClip;
      
      public var rotateAnim:MovieClip;
      
      public var shadow:MovieClip;
      
      public var timeLabel:TextField;
      
      public var timerbackground:MovieClip;
      
      public function BotMessageUI()
      {
         super();
      }
   }
}

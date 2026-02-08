package org.oyunstudyosu.assets.clips
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.assets.clips.Joystick")]
   public class Joystick extends MovieClip
   {
       
      
      public var joystick:MovieClip;
      
      public var mcPlayer:MovieClip;
      
      public function Joystick()
      {
         super();
      }
   }
}

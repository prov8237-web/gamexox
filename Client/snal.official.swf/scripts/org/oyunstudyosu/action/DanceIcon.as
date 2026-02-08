package org.oyunstudyosu.action
{
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.action.DanceIcon")]
   public class DanceIcon extends ActionIcon
   {
       
      
      public function DanceIcon()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

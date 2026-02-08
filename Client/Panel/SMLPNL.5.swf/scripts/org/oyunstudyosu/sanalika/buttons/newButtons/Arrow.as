package org.oyunstudyosu.sanalika.buttons.newButtons
{
   import com.oyunstudyosu.components.SanalikaButton;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.buttons.newButtons.Arrow")]
   public class Arrow extends SanalikaButton
   {
       
      
      public function Arrow()
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

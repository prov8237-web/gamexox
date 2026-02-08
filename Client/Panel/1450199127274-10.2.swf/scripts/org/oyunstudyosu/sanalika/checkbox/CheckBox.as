package org.oyunstudyosu.sanalika.checkbox
{
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.checkbox.CheckBox")]
   public class CheckBox extends CoreCheckBox
   {
       
      
      public function CheckBox()
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

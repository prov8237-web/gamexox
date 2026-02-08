package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.blue_bubble_bg_6")]
   public dynamic class blue_bubble_bg_6 extends MovieClip
   {
       
      
      public function blue_bubble_bg_6()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.red_bubble_bg_23")]
   public dynamic class red_bubble_bg_23 extends MovieClip
   {
       
      
      public function red_bubble_bg_23()
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

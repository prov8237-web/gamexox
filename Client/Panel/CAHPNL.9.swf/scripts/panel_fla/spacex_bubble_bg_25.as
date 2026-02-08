package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.spacex_bubble_bg_25")]
   public dynamic class spacex_bubble_bg_25 extends MovieClip
   {
       
      
      public function spacex_bubble_bg_25()
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

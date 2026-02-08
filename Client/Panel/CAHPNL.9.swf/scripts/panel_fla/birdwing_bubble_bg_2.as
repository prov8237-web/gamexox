package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.birdwing_bubble_bg_2")]
   public dynamic class birdwing_bubble_bg_2 extends MovieClip
   {
       
      
      public function birdwing_bubble_bg_2()
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

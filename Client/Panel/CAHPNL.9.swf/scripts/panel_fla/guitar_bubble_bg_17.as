package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.guitar_bubble_bg_17")]
   public dynamic class guitar_bubble_bg_17 extends MovieClip
   {
       
      
      public function guitar_bubble_bg_17()
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

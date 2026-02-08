package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.default_bubble_bg_18")]
   public dynamic class default_bubble_bg_18 extends MovieClip
   {
       
      
      public function default_bubble_bg_18()
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

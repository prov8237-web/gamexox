package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.black_bubble_bg_4")]
   public dynamic class black_bubble_bg_4 extends MovieClip
   {
       
      
      public function black_bubble_bg_4()
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

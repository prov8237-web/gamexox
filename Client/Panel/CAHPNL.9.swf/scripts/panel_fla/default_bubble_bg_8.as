package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.default_bubble_bg_8")]
   public dynamic class default_bubble_bg_8 extends MovieClip
   {
       
      
      public function default_bubble_bg_8()
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

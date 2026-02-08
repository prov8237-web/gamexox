package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.green_bubble_bg_13")]
   public dynamic class green_bubble_bg_13 extends MovieClip
   {
       
      
      public function green_bubble_bg_13()
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

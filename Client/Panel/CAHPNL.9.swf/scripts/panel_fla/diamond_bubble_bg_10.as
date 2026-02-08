package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.diamond_bubble_bg_10")]
   public dynamic class diamond_bubble_bg_10 extends MovieClip
   {
       
      
      public function diamond_bubble_bg_10()
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

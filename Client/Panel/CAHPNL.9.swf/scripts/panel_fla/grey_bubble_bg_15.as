package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.grey_bubble_bg_15")]
   public dynamic class grey_bubble_bg_15 extends MovieClip
   {
       
      
      public function grey_bubble_bg_15()
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

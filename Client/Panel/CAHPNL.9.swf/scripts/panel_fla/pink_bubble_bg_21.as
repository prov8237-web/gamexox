package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.pink_bubble_bg_21")]
   public dynamic class pink_bubble_bg_21 extends MovieClip
   {
       
      
      public function pink_bubble_bg_21()
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

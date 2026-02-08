package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.whisper_bubble_bg_27")]
   public dynamic class whisper_bubble_bg_27 extends MovieClip
   {
       
      
      public function whisper_bubble_bg_27()
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

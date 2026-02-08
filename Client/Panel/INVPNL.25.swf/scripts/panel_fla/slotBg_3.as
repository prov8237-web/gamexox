package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.slotBg_3")]
   public dynamic class slotBg_3 extends MovieClip
   {
       
      
      public function slotBg_3()
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

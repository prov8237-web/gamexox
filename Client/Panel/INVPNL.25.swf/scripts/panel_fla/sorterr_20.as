package panel_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.sorterr_20")]
   public dynamic class sorterr_20 extends MovieClip
   {
       
      
      public var sorter:SimpleButton;
      
      public function sorterr_20()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

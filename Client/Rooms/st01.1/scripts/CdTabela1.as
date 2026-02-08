package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="CdTabela1")]
   public dynamic class CdTabela1 extends MovieClip
   {
       
      
      public function CdTabela1()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         stop();
      }
   }
}

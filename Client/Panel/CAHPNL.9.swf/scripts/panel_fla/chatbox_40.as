package panel_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="panel_fla.chatbox_40")]
   public dynamic class chatbox_40 extends MovieClip
   {
       
      
      public function chatbox_40()
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

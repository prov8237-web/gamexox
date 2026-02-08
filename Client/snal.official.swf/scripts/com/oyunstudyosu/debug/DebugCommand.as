package com.oyunstudyosu.debug
{
   import com.junkbyte.console.Cc;
   
   public class DebugCommand
   {
       
      
      private var objectVector:Vector.<Object>;
      
      private var command:String;
      
      public function DebugCommand(param1:String)
      {
         objectVector = new Vector.<Object>();
         super();
         this.command = param1;
         Cc.addSlashCommand(param1,onDebugCommand);
      }
      
      private function onDebugCommand(param1:String = "") : void
      {
         Sanalika.instance.serviceModel.requestData("debugcommand",{"params":this.command + " " + param1},null,null);
      }
   }
}

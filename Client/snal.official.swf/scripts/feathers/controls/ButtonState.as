package feathers.controls
{
   import flash.Boot;
   
   public final class ButtonState
   {
      
      public static var DISABLED:ButtonState;
      
      public static var DOWN:ButtonState;
      
      public static var HOVER:ButtonState;
      
      public static var UP:ButtonState;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function ButtonState(param1:String, param2:int, param3:Array)
      {
         tag = param1;
         index = param2;
         params = param3;
      }
      
      final public function toString() : String
      {
         return Boot.enum_to_string(this);
      }
   }
}

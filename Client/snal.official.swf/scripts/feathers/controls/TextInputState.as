package feathers.controls
{
   import flash.Boot;
   
   public final class TextInputState
   {
      
      public static var DISABLED:TextInputState;
      
      public static var ENABLED:TextInputState;
      
      public static var ERROR:TextInputState;
      
      public static var FOCUSED:TextInputState;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function TextInputState(param1:String, param2:int, param3:Array)
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

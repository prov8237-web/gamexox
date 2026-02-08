package lime.ui
{
   import flash.Boot;
   
   public final class MouseWheelMode
   {
      
      public static var LINES:MouseWheelMode;
      
      public static var PAGES:MouseWheelMode;
      
      public static var PIXELS:MouseWheelMode;
      
      public static var UNKNOWN:MouseWheelMode;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function MouseWheelMode(param1:String, param2:int, param3:Array)
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

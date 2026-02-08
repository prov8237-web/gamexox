package lime.ui
{
   import flash.Boot;
   
   public final class MouseCursor
   {
      
      public static var ARROW:MouseCursor;
      
      public static var CROSSHAIR:MouseCursor;
      
      public static var CUSTOM:MouseCursor;
      
      public static var DEFAULT:MouseCursor;
      
      public static var MOVE:MouseCursor;
      
      public static var POINTER:MouseCursor;
      
      public static var RESIZE_NESW:MouseCursor;
      
      public static var RESIZE_NS:MouseCursor;
      
      public static var RESIZE_NWSE:MouseCursor;
      
      public static var RESIZE_WE:MouseCursor;
      
      public static var TEXT:MouseCursor;
      
      public static var WAIT:MouseCursor;
      
      public static var WAIT_ARROW:MouseCursor;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function MouseCursor(param1:String, param2:int, param3:Array)
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

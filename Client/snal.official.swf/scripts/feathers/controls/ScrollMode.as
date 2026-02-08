package feathers.controls
{
   import flash.Boot;
   
   public final class ScrollMode
   {
      
      public static var MASK:ScrollMode;
      
      public static var MASKLESS:ScrollMode;
      
      public static var SCROLL_RECT:ScrollMode;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function ScrollMode(param1:String, param2:int, param3:Array)
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

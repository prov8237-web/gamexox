package feathers.core
{
   import flash.Boot;
   
   public final class InvalidationFlag
   {
      
      public static var DATA:InvalidationFlag;
      
      public static var FOCUS:InvalidationFlag;
      
      public static var LAYOUT:InvalidationFlag;
      
      public static var SCROLL:InvalidationFlag;
      
      public static var SELECTION:InvalidationFlag;
      
      public static var SIZE:InvalidationFlag;
      
      public static var SKIN:InvalidationFlag;
      
      public static var SORT:InvalidationFlag;
      
      public static var STATE:InvalidationFlag;
      
      public static var STYLES:InvalidationFlag;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function InvalidationFlag(param1:String, param2:int, param3:Array)
      {
         tag = param1;
         index = param2;
         params = param3;
      }
      
      public static function CUSTOM(param1:String) : InvalidationFlag
      {
         return new InvalidationFlag("CUSTOM",10,[param1]);
      }
      
      final public function toString() : String
      {
         return Boot.enum_to_string(this);
      }
   }
}

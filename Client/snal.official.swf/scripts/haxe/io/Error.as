package haxe.io
{
   import flash.Boot;
   
   public final class Error
   {
      
      public static var Blocked:Error;
      
      public static var OutsideBounds:Error;
      
      public static var Overflow:Error;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function Error(param1:String, param2:int, param3:Array)
      {
         tag = param1;
         index = param2;
         params = param3;
      }
      
      public static function Custom(param1:*) : Error
      {
         return new Error("Custom",3,[param1]);
      }
      
      final public function toString() : String
      {
         return Boot.enum_to_string(this);
      }
   }
}

package lime.graphics
{
   import flash.Boot;
   
   public final class ImageType
   {
      
      public static var CANVAS:ImageType;
      
      public static var CUSTOM:ImageType;
      
      public static var DATA:ImageType;
      
      public static var FLASH:ImageType;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function ImageType(param1:String, param2:int, param3:Array)
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

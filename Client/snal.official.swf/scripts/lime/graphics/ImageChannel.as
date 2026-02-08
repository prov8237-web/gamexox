package lime.graphics
{
   import flash.Boot;
   
   public final class ImageChannel
   {
      
      public static var ALPHA:ImageChannel;
      
      public static var BLUE:ImageChannel;
      
      public static var GREEN:ImageChannel;
      
      public static var RED:ImageChannel;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function ImageChannel(param1:String, param2:int, param3:Array)
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

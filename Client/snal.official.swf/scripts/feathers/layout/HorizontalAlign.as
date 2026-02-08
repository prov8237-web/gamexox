package feathers.layout
{
   import flash.Boot;
   
   public final class HorizontalAlign
   {
      
      public static var CENTER:HorizontalAlign;
      
      public static var JUSTIFY:HorizontalAlign;
      
      public static var LEFT:HorizontalAlign;
      
      public static var RIGHT:HorizontalAlign;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function HorizontalAlign(param1:String, param2:int, param3:Array)
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

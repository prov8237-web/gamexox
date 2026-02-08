package feathers.layout
{
   import flash.Boot;
   
   public final class VerticalAlign
   {
      
      public static var BOTTOM:VerticalAlign;
      
      public static var JUSTIFY:VerticalAlign;
      
      public static var MIDDLE:VerticalAlign;
      
      public static var TOP:VerticalAlign;
      
      public static var __constructs__:Array;
      
      public static const __isenum:Boolean = true;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function VerticalAlign(param1:String, param2:int, param3:Array)
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

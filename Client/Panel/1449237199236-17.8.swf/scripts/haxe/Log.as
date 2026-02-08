package haxe
{
   public class Log
   {
      
      public static var trace:Function;
       
      
      public function Log()
      {
      }
      
      public static function formatOutput(param1:*, param2:Object) : String
      {
         var _loc5_:int = 0;
         var _loc6_:* = null as Array;
         var _loc7_:* = null;
         var _loc3_:String = Std.string(param1);
         if(param2 == null)
         {
            return _loc3_;
         }
         var _loc4_:String = String(param2.fileName) + ":" + int(param2.lineNumber);
         if(param2 != null && param2.customParams != null)
         {
            _loc5_ = 0;
            _loc6_ = param2.customParams;
            while(_loc5_ < int(_loc6_.length))
            {
               _loc7_ = _loc6_[_loc5_];
               _loc5_++;
               _loc3_ += ", " + Std.string(_loc7_);
            }
         }
         return _loc4_ + ": " + _loc3_;
      }
   }
}

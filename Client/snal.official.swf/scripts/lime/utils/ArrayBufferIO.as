package lime.utils
{
   import haxe.io.Bytes;
   
   public class ArrayBufferIO
   {
       
      
      public function ArrayBufferIO()
      {
      }
      
      public static function getInt16(param1:Bytes, param2:int) : int
      {
         var _loc3_:int = int(param1.b[param2]);
         var _loc5_:*;
         var _loc4_:int;
         if(((_loc5_ = (_loc4_ = int(param1.b[param2 + 1])) << 8 | _loc3_) & 32768) != 0)
         {
            return _loc5_ - 65536;
         }
         return _loc5_;
      }
      
      public static function getInt16_BE(param1:Bytes, param2:int) : int
      {
         var _loc3_:int = int(param1.b[param2]);
         var _loc4_:int = int(param1.b[param2 + 1]);
         var _loc5_:*;
         if(((_loc5_ = _loc3_ << 8 | _loc4_) & 32768) != 0)
         {
            return _loc5_ - 65536;
         }
         return _loc5_;
      }
      
      public static function setInt16(param1:Bytes, param2:int, param3:int) : void
      {
         param1.b[param2] = param3 & 255;
         param1.b[param2 + 1] = param3 >> 8 & 255;
      }
      
      public static function setInt16_BE(param1:Bytes, param2:int, param3:int) : void
      {
         param1.b[param2] = param3 >> 8 & 255;
         param1.b[param2 + 1] = param3 & 255;
      }
   }
}

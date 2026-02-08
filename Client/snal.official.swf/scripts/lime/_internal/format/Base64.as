
{
   var _loc4_:* = null as String;
   var _loc5_:int = 0;
   var _loc6_:* = null as Array;
   var _loc7_:* = null as String;
   var _loc1_:Array = [];
   var _loc2_:int = 0;
   var _loc3_:Array = Base64.DICTIONARY;
   §§push(Base64);
   while(_loc2_ < int(_loc3_.length))
   {
      _loc4_ = String(_loc3_[_loc2_]);
      _loc2_++;
      _loc5_ = 0;
      _loc6_ = Base64.DICTIONARY;
      while(_loc5_ < int(_loc6_.length))
      {
         _loc7_ = String(_loc6_[_loc5_]);
         _loc5_++;
         _loc1_.push(_loc4_ + _loc7_);
      }
   }
}

package lime._internal.format
{
   import haxe.crypto.Base64;
   import haxe.io.Bytes;
   
   public class Base64
   {
      
      public static var DICTIONARY:Array;
      
      public static var EXTENDED_DICTIONARY:Array;
       
      
      public function Base64()
      {
      }
      
      public static function decode(param1:String) : Bytes
      {
         return haxe.crypto.Base64.decode(param1);
      }
      
      public static function encode(param1:Bytes) : String
      {
         var _loc10_:* = 0;
         var _loc2_:Array = [];
         var _loc3_:Array = lime._internal.format.Base64.DICTIONARY;
         var _loc4_:Array = lime._internal.format.Base64.EXTENDED_DICTIONARY;
         var _loc5_:int = param1.length;
         var _loc6_:int;
         var _loc7_:* = (_loc6_ = Math.floor(_loc5_ / 3)) * 2;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         while(_loc9_ < _loc7_)
         {
            _loc10_ = int(param1.b[_loc8_]) << 16 | int(param1.b[_loc8_ + 1]) << 8 | int(param1.b[_loc8_ + 2]);
            _loc2_[_loc9_] = String(_loc4_[_loc10_ >> 12 & 4095]);
            _loc2_[_loc9_ + 1] = String(_loc4_[_loc10_ & 4095]);
            _loc8_ += 3;
            _loc9_ += 2;
         }
         switch(_loc5_ - _loc6_ * 3)
         {
            case 1:
               _loc10_ = int(param1.b[_loc8_]) << 16;
               _loc2_[_loc9_] = String(_loc4_[_loc10_ >> 12 & 4095]);
               _loc2_[_loc9_ + 1] = "==";
               break;
            case 2:
               _loc10_ = int(param1.b[_loc8_]) << 16 | int(param1.b[_loc8_ + 1]) << 8;
               _loc2_[_loc9_] = String(_loc4_[_loc10_ >> 12 & 4095]);
               _loc2_[_loc9_ + 1] = String(_loc3_[_loc10_ >> 6 & 63]) + "=";
         }
         return _loc2_.join("");
      }
   }
}

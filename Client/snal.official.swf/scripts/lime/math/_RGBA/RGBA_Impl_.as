
{
   var _loc8_:int = 0;
   var _loc9_:* = null as ArrayBufferView;
   var _loc10_:uint = 0;
   var _loc11_:* = null as Bytes;
   var _loc12_:* = 0;
   var _loc17_:* = null as ArrayBufferView;
   var _loc1_:Bytes = null;
   var _loc2_:Array = null;
   var _loc3_:Vector.<int> = null;
   var _loc4_:ArrayBufferView = null;
   var _loc5_:Object = null;
   var _loc6_:ArrayBufferView = new ArrayBufferView(256,7);
   var _loc7_:int = 0;
   while(_loc7_ < 256)
   {
      _loc8_ = _loc7_++;
      _loc9_ = RGBA_Impl_.__alpha16;
      _loc10_ = uint(int(Math.ceil(_loc8_ * 257.00392156862745)));
      _loc11_ = _loc9_.buffer;
      _loc12_ = _loc9_.byteOffset + _loc8_ * 4;
      _loc11_.b[_loc12_] = _loc10_ & 255;
      _loc11_.b[_loc12_ + 1] = uint(_loc10_ >> 8) & 255;
      _loc11_.b[_loc12_ + 2] = uint(_loc10_ >> 16) & 255;
      _loc11_.b[_loc12_ + 3] = uint(_loc10_ >>> 24) & 255;
   }
   _loc11_ = null;
   var _loc13_:Array = null;
   var _loc14_:Vector.<int> = null;
   _loc9_ = null;
   var _loc15_:Object = null;
   var _loc16_:ArrayBufferView = new ArrayBufferView(511,4);
   _loc7_ = 0;
   while(_loc7_ < 255)
   {
      _loc8_ = _loc7_++;
      (_loc17_ = RGBA_Impl_.__clamp).buffer.b[_loc17_.byteOffset + _loc8_] = _loc8_;
   }
   _loc7_ = 255;
   _loc8_ = 511;
   while(_loc7_ < _loc8_)
   {
      _loc12_ = _loc7_++;
      (_loc17_ = RGBA_Impl_.__clamp).buffer.b[_loc17_.byteOffset + _loc12_] = 255;
   }
}

package lime.math._RGBA
{
   import haxe.io.Bytes;
   import lime.utils.ArrayBufferView;
   
   public final class RGBA_Impl_
   {
      
      public static var __alpha16:ArrayBufferView;
      
      public static var __clamp:ArrayBufferView;
      
      public static var a16:int;
      
      public static var unmult:Number;
       
      
      public function RGBA_Impl_()
      {
      }
      
      public static function _new(param1:int = 0) : int
      {
         return param1;
      }
      
      public static function create(param1:int, param2:int, param3:int, param4:int) : int
      {
         var _loc5_:int;
         var _loc6_:int = _loc5_ = 0;
         return (param1 & 255) << 24 | (param2 & 255) << 16 | (param3 & 255) << 8 | param4 & 255;
      }
      
      public static function multiplyAlpha(param1:int) : void
      {
         var _loc2_:* = null as ArrayBufferView;
         var _loc3_:* = null as Bytes;
         var _loc4_:* = 0;
         if((param1 & 255) == 0)
         {
            if(param1 != 0)
            {
               param1 = 0;
            }
         }
         else if((param1 & 255) != 255)
         {
            _loc2_ = RGBA_Impl_.__alpha16;
            _loc3_ = _loc2_.buffer;
            _loc4_ = _loc2_.byteOffset + (param1 & 255) * 4;
            RGBA_Impl_.a16 = int(_loc3_.b[_loc4_]) | int(_loc3_.b[_loc4_ + 1]) << 8 | int(_loc3_.b[_loc4_ + 2]) << 16 | int(_loc3_.b[_loc4_ + 3]) << 24;
            param1 = ((param1 >> 24 & 255) * RGBA_Impl_.a16 >> 16 & 255) << 24 | ((param1 >> 16 & 255) * RGBA_Impl_.a16 >> 16 & 255) << 16 | ((param1 >> 8 & 255) * RGBA_Impl_.a16 >> 16 & 255) << 8 | param1 & 255 & 255;
         }
      }
      
      public static function readUInt8(param1:int, param2:ArrayBufferView, param3:int, param4:int = 0, param5:Boolean = false) : void
      {
         var _loc6_:* = null as ArrayBufferView;
         var _loc7_:* = null as ArrayBufferView;
         var _loc8_:* = null as ArrayBufferView;
         switch(param4)
         {
            case 0:
               param1 = (int(int(param2.buffer.b[param2.byteOffset + param3])) & 255) << 24 | (int(int(param2.buffer.b[param2.byteOffset + (param3 + 1)])) & 255) << 16 | (int(int(param2.buffer.b[param2.byteOffset + (param3 + 2)])) & 255) << 8 | int(int(param2.buffer.b[param2.byteOffset + (param3 + 3)])) & 255;
               break;
            case 1:
               param1 = (int(int(param2.buffer.b[param2.byteOffset + (param3 + 1)])) & 255) << 24 | (int(int(param2.buffer.b[param2.byteOffset + (param3 + 2)])) & 255) << 16 | (int(int(param2.buffer.b[param2.byteOffset + (param3 + 3)])) & 255) << 8 | int(int(param2.buffer.b[param2.byteOffset + param3])) & 255;
               break;
            case 2:
               param1 = (int(int(param2.buffer.b[param2.byteOffset + (param3 + 2)])) & 255) << 24 | (int(int(param2.buffer.b[param2.byteOffset + (param3 + 1)])) & 255) << 16 | (int(int(param2.buffer.b[param2.byteOffset + param3])) & 255) << 8 | int(int(param2.buffer.b[param2.byteOffset + (param3 + 3)])) & 255;
         }
         if(param5)
         {
            if((param1 & 255) != 0 && (param1 & 255) != 255)
            {
               RGBA_Impl_.unmult = 255 / (param1 & 255);
               _loc6_ = RGBA_Impl_.__clamp;
               _loc7_ = RGBA_Impl_.__clamp;
               _loc8_ = RGBA_Impl_.__clamp;
               param1 = (int(int(_loc6_.buffer.b[_loc6_.byteOffset + int(Math.round((param1 >> 24 & 255) * RGBA_Impl_.unmult))])) & 255) << 24 | (int(int(_loc7_.buffer.b[_loc7_.byteOffset + int(Math.round((param1 >> 16 & 255) * RGBA_Impl_.unmult))])) & 255) << 16 | (int(int(_loc8_.buffer.b[_loc8_.byteOffset + int(Math.round((param1 >> 8 & 255) * RGBA_Impl_.unmult))])) & 255) << 8 | param1 & 255 & 255;
            }
         }
      }
      
      public static function set(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         param1 = (param2 & 255) << 24 | (param3 & 255) << 16 | (param4 & 255) << 8 | param5 & 255;
      }
      
      public static function unmultiplyAlpha(param1:int) : void
      {
         var _loc2_:* = null as ArrayBufferView;
         var _loc3_:* = null as ArrayBufferView;
         var _loc4_:* = null as ArrayBufferView;
         if((param1 & 255) != 0 && (param1 & 255) != 255)
         {
            RGBA_Impl_.unmult = 255 / (param1 & 255);
            _loc2_ = RGBA_Impl_.__clamp;
            _loc3_ = RGBA_Impl_.__clamp;
            _loc4_ = RGBA_Impl_.__clamp;
            param1 = (int(int(_loc2_.buffer.b[_loc2_.byteOffset + int(Math.round((param1 >> 24 & 255) * RGBA_Impl_.unmult))])) & 255) << 24 | (int(int(_loc3_.buffer.b[_loc3_.byteOffset + int(Math.round((param1 >> 16 & 255) * RGBA_Impl_.unmult))])) & 255) << 16 | (int(int(_loc4_.buffer.b[_loc4_.byteOffset + int(Math.round((param1 >> 8 & 255) * RGBA_Impl_.unmult))])) & 255) << 8 | param1 & 255 & 255;
         }
      }
      
      public static function writeUInt8(param1:int, param2:ArrayBufferView, param3:int, param4:int = 0, param5:Boolean = false) : void
      {
         var _loc6_:* = null as ArrayBufferView;
         var _loc7_:* = null as Bytes;
         var _loc8_:* = 0;
         var _loc9_:uint = 0;
         if(param5)
         {
            if((param1 & 255) == 0)
            {
               if(param1 != 0)
               {
                  param1 = 0;
               }
            }
            else if((param1 & 255) != 255)
            {
               _loc7_ = (_loc6_ = RGBA_Impl_.__alpha16).buffer;
               _loc8_ = _loc6_.byteOffset + (param1 & 255) * 4;
               RGBA_Impl_.a16 = int(_loc7_.b[_loc8_]) | int(_loc7_.b[_loc8_ + 1]) << 8 | int(_loc7_.b[_loc8_ + 2]) << 16 | int(_loc7_.b[_loc8_ + 3]) << 24;
               param1 = ((param1 >> 24 & 255) * RGBA_Impl_.a16 >> 16 & 255) << 24 | ((param1 >> 16 & 255) * RGBA_Impl_.a16 >> 16 & 255) << 16 | ((param1 >> 8 & 255) * RGBA_Impl_.a16 >> 16 & 255) << 8 | param1 & 255 & 255;
            }
         }
         switch(param4)
         {
            case 0:
               _loc9_ = uint(param1 >> 24 & 255);
               param2.buffer.b[param2.byteOffset + param3] = _loc9_;
               _loc9_ = uint(param1 >> 16 & 255);
               param2.buffer.b[param2.byteOffset + (param3 + 1)] = _loc9_;
               _loc9_ = uint(param1 >> 8 & 255);
               param2.buffer.b[param2.byteOffset + (param3 + 2)] = _loc9_;
               _loc9_ = uint(param1 & 255);
               param2.buffer.b[param2.byteOffset + (param3 + 3)] = _loc9_;
               break;
            case 1:
               _loc9_ = uint(param1 & 255);
               param2.buffer.b[param2.byteOffset + param3] = _loc9_;
               _loc9_ = uint(param1 >> 24 & 255);
               param2.buffer.b[param2.byteOffset + (param3 + 1)] = _loc9_;
               _loc9_ = uint(param1 >> 16 & 255);
               param2.buffer.b[param2.byteOffset + (param3 + 2)] = _loc9_;
               _loc9_ = uint(param1 >> 8 & 255);
               param2.buffer.b[param2.byteOffset + (param3 + 3)] = _loc9_;
               break;
            case 2:
               _loc9_ = uint(param1 >> 8 & 255);
               param2.buffer.b[param2.byteOffset + param3] = _loc9_;
               _loc9_ = uint(param1 >> 16 & 255);
               param2.buffer.b[param2.byteOffset + (param3 + 1)] = _loc9_;
               _loc9_ = uint(param1 >> 24 & 255);
               param2.buffer.b[param2.byteOffset + (param3 + 2)] = _loc9_;
               _loc9_ = uint(param1 & 255);
               param2.buffer.b[param2.byteOffset + (param3 + 3)] = _loc9_;
         }
      }
      
      public static function __fromARGB(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = _loc2_;
         return (param1 >> 16 & 255 & 255) << 24 | (param1 >> 8 & 255 & 255) << 16 | (param1 & 255 & 255) << 8 | param1 >> 24 & 255 & 255;
      }
      
      public static function __fromBGRA(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = _loc2_;
         return (param1 >> 8 & 255 & 255) << 24 | (param1 >> 16 & 255 & 255) << 16 | (param1 >> 24 & 255 & 255) << 8 | param1 & 255 & 255;
      }
      
      public static function get_a(param1:int) : int
      {
         return param1 & 255;
      }
      
      public static function set_a(param1:int, param2:int) : int
      {
         param1 = (param1 >> 24 & 255 & 255) << 24 | (param1 >> 16 & 255 & 255) << 16 | (param1 >> 8 & 255 & 255) << 8 | param2 & 255;
         return param2;
      }
      
      public static function get_b(param1:int) : int
      {
         return param1 >> 8 & 255;
      }
      
      public static function set_b(param1:int, param2:int) : int
      {
         param1 = (param1 >> 24 & 255 & 255) << 24 | (param1 >> 16 & 255 & 255) << 16 | (param2 & 255) << 8 | param1 & 255 & 255;
         return param2;
      }
      
      public static function get_g(param1:int) : int
      {
         return param1 >> 16 & 255;
      }
      
      public static function set_g(param1:int, param2:int) : int
      {
         param1 = (param1 >> 24 & 255 & 255) << 24 | (param2 & 255) << 16 | (param1 >> 8 & 255 & 255) << 8 | param1 & 255 & 255;
         return param2;
      }
      
      public static function get_r(param1:int) : int
      {
         return param1 >> 24 & 255;
      }
      
      public static function set_r(param1:int, param2:int) : int
      {
         param1 = (param2 & 255) << 24 | (param1 >> 16 & 255 & 255) << 16 | (param1 >> 8 & 255 & 255) << 8 | param1 & 255 & 255;
         return param2;
      }
   }
}

package lime._internal.graphics
{
   import lime.graphics.Image;
   import lime.math.Rectangle;
   import lime.math.Vector2;
   import lime.utils.ArrayBufferView;
   
   public class StackBlur
   {
      
      public static var MUL_TABLE:Array;
      
      public static var SHG_TABLE:Array;
       
      
      public function StackBlur()
      {
      }
      
      public static function blur(param1:Image, param2:Image, param3:Rectangle, param4:Vector2, param5:Number, param6:Number, param7:int) : void
      {
         param1.copyPixels(param2,param3,param4);
         StackBlur.__stackBlurCanvasRGBA(param1,int(param3.width),int(param3.height),param5,param6,param7);
      }
      
      public static function __stackBlurCanvasRGBA(param1:Image, param2:int, param3:int, param4:Number, param5:Number, param6:int) : void
      {
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:* = 0;
         var _loc15_:* = 0;
         var _loc16_:* = 0;
         var _loc17_:* = 0;
         var _loc18_:* = 0;
         var _loc19_:* = 0;
         var _loc20_:* = 0;
         var _loc21_:* = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:Number = NaN;
         var _loc39_:int = 0;
         var _loc40_:* = null as BlurStack;
         var _loc42_:* = null as BlurStack;
         var _loc44_:int = 0;
         var _loc45_:int = 0;
         var _loc46_:int = 0;
         var _loc47_:int = 0;
         var _loc48_:int = 0;
         var _loc49_:int = 0;
         var _loc50_:uint = 0;
         var _loc51_:* = 0;
         var _loc52_:int = 0;
         var _loc53_:int = 0;
         var _loc54_:uint = 0;
         var _loc7_:* = int(Math.round(param4)) >> 1;
         var _loc8_:* = int(Math.round(param5)) >> 1;
         if(StackBlur.MUL_TABLE == null)
         {
            return;
         }
         if(_loc7_ >= int(StackBlur.MUL_TABLE.length))
         {
            _loc7_ = int(StackBlur.MUL_TABLE.length) - 1;
         }
         if(_loc8_ >= int(StackBlur.MUL_TABLE.length))
         {
            _loc8_ = int(StackBlur.MUL_TABLE.length) - 1;
         }
         if(_loc7_ < 0 || _loc8_ < 0)
         {
            return;
         }
         var _loc9_:int;
         if((_loc9_ = param6) < 1)
         {
            _loc9_ = 1;
         }
         if(_loc9_ > 3)
         {
            _loc9_ = 3;
         }
         var _loc10_:ArrayBufferView = param1.get_data();
         var _loc27_:* = _loc7_ + _loc7_ + 1;
         var _loc28_:* = _loc8_ + _loc8_ + 1;
         var _loc29_:int = param2;
         var _loc30_:int = param3;
         var _loc31_:* = _loc29_ - 1;
         var _loc32_:* = _loc30_ - 1;
         var _loc33_:* = _loc7_ + 1;
         var _loc34_:* = _loc8_ + 1;
         var _loc35_:BlurStack;
         var _loc36_:BlurStack = _loc35_ = new BlurStack();
         var _loc37_:int = 1;
         var _loc38_:int = _loc27_;
         while(_loc37_ < _loc38_)
         {
            _loc39_ = _loc37_++;
            _loc36_ = _loc36_.n = new BlurStack();
         }
         _loc36_.n = _loc35_;
         var _loc41_:BlurStack = _loc40_ = new BlurStack();
         _loc37_ = 1;
         _loc38_ = _loc28_;
         while(_loc37_ < _loc38_)
         {
            _loc39_ = _loc37_++;
            _loc41_ = _loc41_.n = new BlurStack();
         }
         _loc41_.n = _loc40_;
         _loc42_ = null;
         _loc37_ = int(StackBlur.MUL_TABLE[_loc7_]);
         _loc38_ = int(StackBlur.SHG_TABLE[_loc7_]);
         _loc39_ = int(StackBlur.MUL_TABLE[_loc8_]);
         var _loc43_:int = int(StackBlur.SHG_TABLE[_loc8_]);
         while(_loc9_ > 0)
         {
            _loc9_--;
            _loc17_ = _loc16_ = 0;
            _loc44_ = _loc37_;
            _loc45_ = _loc38_;
            _loc12_ = _loc30_;
            do
            {
               _loc22_ = int(int(_loc10_.buffer.b[_loc10_.byteOffset + _loc16_]));
               _loc18_ = _loc33_ * _loc22_;
               _loc23_ = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc16_ + 1)]));
               _loc19_ = _loc33_ * _loc23_;
               _loc24_ = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc16_ + 2)]));
               _loc20_ = _loc33_ * _loc24_;
               _loc25_ = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc16_ + 3)]));
               _loc21_ = _loc33_ * _loc25_;
               _loc36_ = _loc35_;
               _loc13_ = _loc33_;
               do
               {
                  _loc36_.r = _loc22_;
                  _loc36_.g = _loc23_;
                  _loc36_.b = _loc24_;
                  _loc36_.a = _loc25_;
                  _loc36_ = _loc36_.n;
                  _loc13_--;
               }
               while(_loc13_ > -1);
               
               _loc46_ = 1;
               _loc47_ = _loc33_;
               while(_loc46_ < _loc47_)
               {
                  _loc48_ = _loc46_++;
                  _loc14_ = _loc16_ + ((_loc31_ < _loc48_ ? _loc31_ : _loc48_) << 2);
                  _loc18_ += _loc36_.r = int(int(_loc10_.buffer.b[_loc10_.byteOffset + _loc14_]));
                  _loc19_ += _loc36_.g = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 1)]));
                  _loc20_ += _loc36_.b = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 2)]));
                  _loc21_ += _loc36_.a = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 3)]));
                  _loc36_ = _loc36_.n;
               }
               _loc42_ = _loc35_;
               _loc46_ = 0;
               _loc47_ = _loc29_;
               while(_loc46_ < _loc47_)
               {
                  _loc48_ = _loc46_++;
                  _loc50_ = uint(_loc18_ * _loc44_ >>> _loc45_);
                  _loc10_.buffer.b[_loc10_.byteOffset + _loc16_++] = _loc50_;
                  _loc50_ = uint(_loc19_ * _loc44_ >>> _loc45_);
                  _loc10_.buffer.b[_loc10_.byteOffset + _loc16_++] = _loc50_;
                  _loc50_ = uint(_loc20_ * _loc44_ >>> _loc45_);
                  _loc10_.buffer.b[_loc10_.byteOffset + _loc16_++] = _loc50_;
                  _loc50_ = uint(_loc21_ * _loc44_ >>> _loc45_);
                  _loc10_.buffer.b[_loc10_.byteOffset + _loc16_++] = _loc50_;
                  _loc14_ = _loc48_ + _loc7_ + 1;
                  _loc14_ = _loc17_ + (_loc14_ < _loc31_ ? _loc14_ : _loc31_) << 2;
                  _loc18_ -= _loc42_.r - (_loc42_.r = int(int(_loc10_.buffer.b[_loc10_.byteOffset + _loc14_])));
                  _loc19_ -= _loc42_.g - (_loc42_.g = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 1)])));
                  _loc20_ -= _loc42_.b - (_loc42_.b = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 2)])));
                  _loc21_ -= _loc42_.a - (_loc42_.a = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 3)])));
                  _loc42_ = _loc42_.n;
               }
               _loc17_ += _loc29_;
               _loc12_--;
            }
            while(_loc12_ > 0);
            
            _loc44_ = _loc39_;
            _loc45_ = _loc43_;
            _loc46_ = 0;
            _loc47_ = _loc29_;
            while(_loc46_ < _loc47_)
            {
               _loc16_ = (_loc48_ = _loc46_++) << 2;
               _loc22_ = int(int(_loc10_.buffer.b[_loc10_.byteOffset + _loc16_]));
               _loc18_ = _loc34_ * _loc22_;
               _loc23_ = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc16_ + 1)]));
               _loc19_ = _loc34_ * _loc23_;
               _loc24_ = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc16_ + 2)]));
               _loc20_ = _loc34_ * _loc24_;
               _loc25_ = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc16_ + 3)]));
               _loc21_ = _loc34_ * _loc25_;
               _loc41_ = _loc40_;
               _loc49_ = 0;
               _loc51_ = _loc34_;
               while(_loc49_ < _loc51_)
               {
                  _loc52_ = _loc49_++;
                  _loc41_.r = _loc22_;
                  _loc41_.g = _loc23_;
                  _loc41_.b = _loc24_;
                  _loc41_.a = _loc25_;
                  _loc41_ = _loc41_.n;
               }
               _loc15_ = _loc29_;
               _loc49_ = 1;
               _loc51_ = _loc8_ + 1;
               while(_loc49_ < _loc51_)
               {
                  _loc52_ = _loc49_++;
                  _loc16_ = _loc15_ + _loc48_ << 2;
                  _loc18_ += _loc41_.r = int(int(_loc10_.buffer.b[_loc10_.byteOffset + _loc16_]));
                  _loc19_ += _loc41_.g = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc16_ + 1)]));
                  _loc20_ += _loc41_.b = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc16_ + 2)]));
                  _loc21_ += _loc41_.a = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc16_ + 3)]));
                  _loc41_ = _loc41_.n;
                  if(_loc52_ < _loc32_)
                  {
                     _loc15_ += _loc29_;
                  }
               }
               _loc16_ = _loc48_;
               _loc42_ = _loc40_;
               if(_loc9_ > 0)
               {
                  _loc49_ = 0;
                  _loc51_ = _loc30_;
                  while(_loc49_ < _loc51_)
                  {
                     _loc52_ = _loc49_++;
                     _loc14_ = _loc16_ << 2;
                     _loc50_ = uint(_loc25_ = _loc21_ * _loc44_ >>> _loc45_);
                     _loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 3)] = _loc50_;
                     if(_loc25_ > 0)
                     {
                        _loc50_ = uint(_loc18_ * _loc44_ >>> _loc45_);
                        _loc10_.buffer.b[_loc10_.byteOffset + _loc14_] = _loc50_;
                        _loc50_ = uint(_loc19_ * _loc44_ >>> _loc45_);
                        _loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 1)] = _loc50_;
                        _loc50_ = uint(_loc20_ * _loc44_ >>> _loc45_);
                        _loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 2)] = _loc50_;
                     }
                     else
                     {
                        _loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 2)] = 0;
                        _loc50_ = 0;
                        _loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 1)] = _loc50_;
                        _loc54_ = _loc50_;
                        _loc10_.buffer.b[_loc10_.byteOffset + _loc14_] = _loc54_;
                     }
                     _loc14_ = _loc52_ + _loc34_;
                     _loc14_ = _loc48_ + (_loc14_ < _loc32_ ? _loc14_ : _loc32_) * _loc29_ << 2;
                     _loc18_ -= _loc42_.r - (_loc42_.r = int(int(_loc10_.buffer.b[_loc10_.byteOffset + _loc14_])));
                     _loc19_ -= _loc42_.g - (_loc42_.g = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 1)])));
                     _loc20_ -= _loc42_.b - (_loc42_.b = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 2)])));
                     _loc21_ -= _loc42_.a - (_loc42_.a = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 3)])));
                     _loc42_ = _loc42_.n;
                     _loc16_ += _loc29_;
                  }
               }
               else
               {
                  _loc49_ = 0;
                  _loc51_ = _loc30_;
                  while(_loc49_ < _loc51_)
                  {
                     _loc52_ = _loc49_++;
                     _loc14_ = _loc16_ << 2;
                     _loc50_ = uint(_loc25_ = _loc21_ * _loc44_ >>> _loc45_);
                     _loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 3)] = _loc50_;
                     if(_loc25_ > 0)
                     {
                        _loc26_ = 255 / _loc25_;
                        _loc22_ = (_loc18_ * _loc44_ >>> _loc45_) * _loc26_;
                        _loc23_ = (_loc19_ * _loc44_ >>> _loc45_) * _loc26_;
                        _loc24_ = (_loc20_ * _loc44_ >>> _loc45_) * _loc26_;
                        _loc50_ = uint(_loc22_ > 255 ? 255 : _loc22_);
                        _loc10_.buffer.b[_loc10_.byteOffset + _loc14_] = _loc50_;
                        _loc50_ = uint(_loc23_ > 255 ? 255 : _loc23_);
                        _loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 1)] = _loc50_;
                        _loc50_ = uint(_loc24_ > 255 ? 255 : _loc24_);
                        _loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 2)] = _loc50_;
                     }
                     else
                     {
                        _loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 2)] = 0;
                        _loc50_ = 0;
                        _loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 1)] = _loc50_;
                        _loc54_ = _loc50_;
                        _loc10_.buffer.b[_loc10_.byteOffset + _loc14_] = _loc54_;
                     }
                     _loc14_ = _loc52_ + _loc34_;
                     _loc14_ = _loc48_ + (_loc14_ < _loc32_ ? _loc14_ : _loc32_) * _loc29_ << 2;
                     _loc18_ -= _loc42_.r - (_loc42_.r = int(int(_loc10_.buffer.b[_loc10_.byteOffset + _loc14_])));
                     _loc19_ -= _loc42_.g - (_loc42_.g = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 1)])));
                     _loc20_ -= _loc42_.b - (_loc42_.b = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 2)])));
                     _loc21_ -= _loc42_.a - (_loc42_.a = int(int(_loc10_.buffer.b[_loc10_.byteOffset + (_loc14_ + 3)])));
                     _loc42_ = _loc42_.n;
                     _loc16_ += _loc29_;
                  }
               }
            }
         }
      }
   }
}

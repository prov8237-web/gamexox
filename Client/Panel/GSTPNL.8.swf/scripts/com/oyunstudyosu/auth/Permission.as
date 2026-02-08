package com.oyunstudyosu.auth
{
   import com.hurlant.util.Base64;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class Permission implements IPermission
   {
       
      
      private var _data:ByteArray;
      
      public function Permission(param1:String = "")
      {
         super();
         if(param1 == "")
         {
            this._data = new ByteArray();
            this._data.endian = Endian.LITTLE_ENDIAN;
         }
         else
         {
            this.value = param1;
         }
      }
      
      public function get value() : String
      {
         return Base64.encodeByteArray(this._data);
      }
      
      public function set value(param1:String) : void
      {
         this._data = Base64.decodeToByteArray(param1);
         this._data.endian = Endian.LITTLE_ENDIAN;
      }
      
      public function get data() : ByteArray
      {
         return this._data;
      }
      
      public function grant(param1:uint) : void
      {
         var _loc2_:uint = Math.ceil(param1 / 8) - 1;
         var _loc3_:int = param1 % 8 - 1;
         while(this._data.length <= _loc2_)
         {
            this._data.writeByte(0);
         }
         if(_loc3_ == -1)
         {
            this._data[_loc2_] |= 1 << 7;
         }
         else
         {
            this._data[_loc2_] |= 1 << _loc3_;
         }
      }
      
      public function deny(param1:uint) : void
      {
         var _loc2_:uint = Math.ceil(param1 / 8) - 1;
         var _loc3_:int = param1 % 8 - 1;
         while(this._data.length <= _loc2_)
         {
            this._data.writeByte(0);
         }
         if(_loc3_ == -1)
         {
            this._data[_loc2_] ^= 1 << 7;
         }
         else
         {
            this._data[_loc2_] ^= 1 << _loc3_;
         }
      }
      
      public function check(param1:uint) : Boolean
      {
         if(this._data.length * 8 < param1)
         {
            return false;
         }
         var _loc2_:uint = Math.ceil(param1 / 8) - 1;
         var _loc3_:int = param1 % 8 - 1;
         var _loc4_:uint = 0;
         if(_loc3_ == -1)
         {
            _loc4_ = uint(1 << 7);
         }
         else
         {
            _loc4_ |= 1 << _loc3_;
         }
         return Boolean(this._data[_loc2_] & _loc4_);
      }
      
      public function grantedIndexes() : Array
      {
         var _loc2_:uint = 0;
         var _loc5_:int = 0;
         var _loc1_:uint = this._data.length;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc5_ = -1;
            while(_loc5_ < 7)
            {
               _loc2_ = 0;
               if(_loc5_ == -1)
               {
                  _loc2_ = uint(1 << 7);
               }
               else
               {
                  _loc2_ |= 1 << _loc5_;
               }
               if(this._data[_loc4_] & _loc2_)
               {
                  _loc3_.push(_loc4_ * 8 + (_loc5_ == -1 ? 8 : _loc5_ + 1));
               }
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
   }
}

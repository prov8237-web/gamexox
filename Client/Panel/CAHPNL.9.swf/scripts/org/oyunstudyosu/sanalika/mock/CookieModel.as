package org.oyunstudyosu.sanalika.mock
{
   import com.oyunstudyosu.enums.UpdateGroups;
   import com.oyunstudyosu.sanalika.interfaces.ICookieModel;
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   
   public class CookieModel implements ICookieModel
   {
       
      
      private var so:SharedObject;
      
      public var data:Object;
      
      public var name:String;
      
      public function CookieModel()
      {
         super();
      }
      
      public function startCheck() : void
      {
         Sanalika.instance.updateModel.getGroup(UpdateGroups.TIMER_10S).addFunction(this.checkSession);
      }
      
      public function stopCheck() : void
      {
         Sanalika.instance.updateModel.getGroup(UpdateGroups.TIMER_10S).removeFunction(this.checkSession);
      }
      
      public function open(param1:String) : Boolean
      {
         var cookieName:String = param1;
         this.name = cookieName;
         try
         {
            this.so = SharedObject.getLocal(this.name);
            this.data = this.so.data;
         }
         catch(error:Error)
         {
            name = null;
            so = null;
         }
         return true;
      }
      
      private function ddf(param1:uint) : String
      {
         if(param1 < 10)
         {
            return "0" + param1;
         }
         return param1 + "";
      }
      
      public function stampDate(param1:String) : void
      {
         var _loc2_:Date = new Date();
         this.write(param1,_loc2_.fullYear + "" + this.ddf(_loc2_.month + 1) + "" + this.ddf(_loc2_.date));
      }
      
      public function checkDate(param1:String) : Boolean
      {
         var _loc2_:Date = new Date();
         var _loc3_:int = _loc2_.fullYear + "" + this.ddf(_loc2_.month + 1) + "" + this.ddf(_loc2_.date) as int;
         if(this.read(param1) as int < _loc3_)
         {
            return true;
         }
         return false;
      }
      
      private function checkSession(param1:Number, param2:Number) : void
      {
      }
      
      public function write(param1:String, param2:Object) : Boolean
      {
         if(this.so == null)
         {
            return false;
         }
         this.data[param1] = param2;
         return this.save();
      }
      
      public function read(param1:String) : Object
      {
         if(this.so == null)
         {
            return null;
         }
         return this.data[param1];
      }
      
      public function clear(param1:String) : Boolean
      {
         if(this.so == null)
         {
            return false;
         }
         this.data[param1] = null;
         return this.save();
      }
      
      private function save() : Boolean
      {
         var _loc1_:Object = null;
         if(this.so == null)
         {
            return false;
         }
         try
         {
            _loc1_ = this.so.flush();
         }
         catch(error:Error)
         {
         }
         return _loc1_ == SharedObjectFlushStatus.FLUSHED;
      }
   }
}

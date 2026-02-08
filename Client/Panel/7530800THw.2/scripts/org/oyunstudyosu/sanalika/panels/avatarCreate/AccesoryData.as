package org.oyunstudyosu.sanalika.panels.avatarCreate
{
   public class AccesoryData
   {
       
      
      public var clip:String;
      
      public var colors:Array;
      
      public var colorIndex:int;
      
      public var place:int;
      
      public function AccesoryData(param1:int, param2:Object)
      {
         super();
         this.colorIndex = -1;
         this.place = param1;
         this.clip = param2.clip;
         this.colors = param2.colors;
         if(this.colors != null)
         {
            this.setColor(9);
         }
      }
      
      public function setColorIndex(param1:int) : void
      {
         this.colorIndex = param1;
      }
      
      public function get def() : String
      {
         if(this.colors != null)
         {
            return this.clip + "_" + this.colors[this.colorIndex];
         }
         return this.clip;
      }
      
      public function setColor(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.colors.length)
         {
            if(this.colors[_loc2_] == param1)
            {
               this.colorIndex = _loc2_;
               return;
            }
            _loc2_++;
         }
         this.colorIndex = 0;
      }
   }
}

package haxe.iterators
{
   import flash.Boot;
   
   public class ArrayKeyValueIterator
   {
       
      
      public var current:int;
      
      public var array:Array;
      
      public function ArrayKeyValueIterator(param1:Array = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         current = 0;
         array = param1;
      }
      
      public function next() : Object
      {
         var _loc1_:int;
         current = (_loc1_ = current) + 1;
         return {
            "value":array[current],
            "key":_loc1_
         };
      }
      
      public function hasNext() : Boolean
      {
         return current < int(array.length);
      }
   }
}

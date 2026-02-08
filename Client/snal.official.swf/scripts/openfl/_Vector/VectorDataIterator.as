package openfl._Vector
{
   import flash.Boot;
   
   public class VectorDataIterator
   {
      
      public static var __meta__:*;
       
      
      public var vectorData:Object;
      
      public var index:int;
      
      public function VectorDataIterator(param1:Object = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         index = 0;
         vectorData = param1;
      }
      
      public function next() : Object
      {
         var _loc1_:int;
         index = (_loc1_ = index) + 1;
         return vectorData[_loc1_];
      }
      
      public function hasNext() : Boolean
      {
         return index < int(vectorData.length);
      }
   }
}

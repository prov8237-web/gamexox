package com.oyunstudyosu.game.partyisland.property
{
   public class CardProperty extends EmptyPartyProperty
   {
       
      
      public function CardProperty()
      {
         super();
      }
      
      override public function execute(param1:String, param2:Object) : void
      {
         executeCard(param1,param2);
      }
      
      private function executeCard(param1:String, param2:Object) : void
      {
         var _loc4_:IPartyProperty = null;
         var _loc3_:Class = PartyPropertyList.get(param2.property);
         if(_loc3_ != null)
         {
            (_loc4_ = new _loc3_()).execute(param1,param2.data);
         }
      }
   }
}

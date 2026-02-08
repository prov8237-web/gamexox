package org.oyunstudyosu.sanalika.panels.profile
{
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.tooltip.TooltipAlign;
   
   public class CardSlot extends Slot
   {
       
      
      private var data:Object;
      
      public function CardSlot()
      {
         super();
      }
      
      public function init(param1:Object, param2:Array) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         this.data = param1;
         Connectr.instance.toolTipModel.addTip(this.container,$("pro_" + param1.clip));
         if(param1.clip == "CARD_DIAMOND_CLUB")
         {
            _loc3_ = ["CARD_GOLD","CARD_DIAMOND","CARD_MUSIC","CARD_GUARD","CARD_GUIDE","CARD_SECURITY","CARD_PAINTER","CARD_JOURNALIST","CARD_PHOTOGRAPHER","CARD_DIRECTOR"];
            _loc4_ = false;
            for each(_loc5_ in param2)
            {
               if(_loc3_.indexOf(_loc5_.clip) != -1)
               {
                  _loc4_ = true;
               }
               if(_loc4_)
               {
                  break;
               }
            }
            if(!_loc4_)
            {
               exclamation = new Exclamation();
               exclamation.x = 36;
               this.addChild(exclamation);
               Connectr.instance.toolTipModel.addTip(exclamation,$("diamondClubWarn"),TooltipAlign.ALIGN_RIGHT);
            }
         }
      }
      
      override public function get clip() : String
      {
         return this.data.clip;
      }
      
      override public function get quantity() : int
      {
         return this.data.quantity;
      }
   }
}

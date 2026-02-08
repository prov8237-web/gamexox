package org.oyunstudyosu.sanalika.panels.smiley
{
   import com.oyunstudyosu.auth.Permission;
   import flash.display.Bitmap;
   
   public class ItemVo
   {
       
      
      public var permission:Permission;
      
      public var key:String;
      
      public var id:int;
      
      public var sorting:int;
      
      public var bitmap:Bitmap = null;
      
      public var ITEM_WIDTH:uint = 30;
      
      public var ITEM_HEIGHT:uint = 30;
      
      public function ItemVo()
      {
         super();
      }
   }
}

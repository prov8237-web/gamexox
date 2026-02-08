package org.oyunstudyosu.sanalika.checkbox
{
   import flash.events.MouseEvent;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   public class CoreCheckBox extends CoreMovieClip
   {
       
      
      private var _selected:Boolean;
      
      public function CoreCheckBox()
      {
         super();
         this.buttonMode = true;
         this.mouseChildren = false;
         this.selected = false;
         this.addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(param1)
         {
            this.gotoAndStop(2);
         }
         else
         {
            this.gotoAndStop(1);
         }
      }
      
      override public function added() : void
      {
      }
      
      override public function removed() : void
      {
      }
      
      protected function clicked() : void
      {
         if(this.selected)
         {
            this.selected = false;
         }
         else
         {
            this.selected = true;
         }
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
         this.clicked();
      }
   }
}

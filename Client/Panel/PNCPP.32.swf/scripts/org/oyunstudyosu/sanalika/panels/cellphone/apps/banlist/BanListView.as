package org.oyunstudyosu.sanalika.panels.cellphone.apps.banlist
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.components.MobileScroll;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import com.oyunstudyosu.utils.TimeConverter;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.banlist.BanListView")]
   public class BanListView extends CoreMovieClip
   {
       
      
      public var txtDescription:TextField;
      
      public var txtHeader:TextField;
      
      private var myItem:BanItem;
      
      private var myListID:Object;
      
      public var headerBg:MovieClip;
      
      public var sHeader:STextField;
      
      public var sDescription:STextField;
      
      public var request:AssetRequest;
      
      private var scrollContainer:MobileScroll;
      
      public function BanListView()
      {
         super();
      }
      
      override public function added() : void
      {
         this.scrollContainer = new MobileScroll();
         this.scrollContainer.y = this.headerBg.height + this.headerBg.y;
         if(this.sHeader == null)
         {
            this.sHeader = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtHeader") as TextField,false);
            this.sDescription = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtDescription") as TextField,false);
         }
         this.addChild(this.scrollContainer);
         this.headerBg.addEventListener(MouseEvent.CLICK,this.closeView);
         this.headerBg.buttonMode = true;
         Connectr.instance.serviceModel.requestData(RequestDataKey.BAN_LIST,{},this.onList);
      }
      
      public function openView(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = (param1.target as BanItem).data;
         this.sHeader.text = $("banType") + ": " + _loc2_.type;
         this.sDescription.multiline = true;
         this.sDescription.mouseEnabled = true;
         this.sDescription.htmlText = "<font color=\'#DD0000\'>" + $("banStartDate") + ": </font>" + "<br>" + TimeConverter.convertTimestampToString(_loc2_.startDate) + "<br>" + "<font color=\'#DD0000\'>" + $("banEndDate") + ": </font>" + "<br>" + TimeConverter.convertTimestampToString(_loc2_.endDate) + "<br>" + "<font color=\'#DD0000\'>" + $("banReason") + ": </font>" + "<br>" + _loc2_.reason + "<br>" + "<font color=\'#DD0000\'>" + $("banNotes") + ":</font> " + "<br>" + _loc2_.notes + "<br>";
         TweenMax.to(this,0.3,{
            "x":-230,
            "ease":Linear.easeOut
         });
      }
      
      public function closeView(param1:MouseEvent = null) : void
      {
         TweenMax.to(this,0.2,{
            "x":0,
            "ease":Linear.easeIn
         });
      }
      
      private function onList(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.BAN_LIST,this.onList);
         this.scrollContainer.disposeItems(this.openView);
         var _loc2_:int = 0;
         while(_loc2_ < param1.bans.length)
         {
            this.myItem = new BanItem();
            this.myItem.data = param1.bans[_loc2_];
            this.myItem.addEventListener(MouseEvent.CLICK,this.openView);
            this.myItem.buttonMode = true;
            this.scrollContainer.listContainer.addChild(this.myItem);
            this.myItem.y = _loc2_ * this.myItem.height + this.headerBg.height;
            _loc2_++;
         }
         this.scrollContainer.init(230,330,2);
         param1 = null;
      }
      
      override public function removed() : void
      {
         this.headerBg.removeEventListener(MouseEvent.CLICK,this.closeView);
         this.scrollContainer.dispose(this.openView);
         this.removeChild(this.scrollContainer);
      }
   }
}

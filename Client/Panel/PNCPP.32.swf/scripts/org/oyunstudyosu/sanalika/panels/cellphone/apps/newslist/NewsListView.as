package org.oyunstudyosu.sanalika.panels.cellphone.apps.newslist
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import com.oyunstudyosu.components.MobileScroll;
   import com.oyunstudyosu.enums.ModuleType;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.StringUtil;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.newslist.NewsListView")]
   public class NewsListView extends CoreMovieClip
   {
       
      
      public var txtDate:TextField;
      
      public var txtDescription:TextField;
      
      public var txtHeader:TextField;
      
      private var newsItem:NewsItem;
      
      private var botClip:MovieClip;
      
      private var botKey:String;
      
      private var myListID:Object;
      
      public var headerBg:MovieClip;
      
      public var sHeader:STextField;
      
      public var sDescription:STextField;
      
      public var sDate:STextField;
      
      public var request:AssetRequest;
      
      public var botContainer:MovieClip;
      
      private var newsRead:Array;
      
      private var scrollContainer:MobileScroll;
      
      public function NewsListView()
      {
         this.newsRead = new Array();
         super();
      }
      
      override public function added() : void
      {
         this.scrollContainer = new MobileScroll();
         this.scrollContainer.y = this.headerBg.height + this.headerBg.y;
         if(this.sHeader == null)
         {
            this.sHeader = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtHeader") as TextField,false);
            this.sDescription = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtDescription") as TextField,true,false);
            this.sDate = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtDate") as TextField,false);
         }
         this.addChild(this.scrollContainer);
         this.headerBg.addEventListener(MouseEvent.CLICK,this.closeView);
         this.headerBg.buttonMode = true;
         this.getList();
      }
      
      private function onError(param1:Object) : void
      {
         this.request.dispose();
      }
      
      private function onLoaded(param1:IAssetRequest) : void
      {
         this.botClip = Connectr.instance.roomModel.botModel.getBotClip(param1.context.applicationDomain,this.botKey);
         if(this.botClip != null)
         {
            this.botContainer.addChild(this.botClip);
         }
         param1.dispose();
      }
      
      public function openView(param1:MouseEvent) : void
      {
         var _loc2_:Object = (param1.target as NewsItem).data;
         (param1.target as NewsItem).statusIndicator.gotoAndStop(2);
         this.sHeader.text = _loc2_.title;
         this.sDate.text = _loc2_.date;
         this.botKey = _loc2_.metaKey;
         this.newsRead.push(_loc2_.date);
         Connectr.instance.cookieModel.write("news",this.newsRead);
         var _loc3_:String = String(Connectr.instance.moduleModel.getPath(this.botKey,ModuleType.BOT));
         this.request = new AssetRequest();
         this.request.context = Connectr.instance.domainModel.assetContext;
         this.request.assetId = _loc3_;
         this.request.loadedFunction = this.onLoaded;
         this.request.errorFunction = this.onError;
         Connectr.instance.assetModel.request(this.request);
         this.sDescription.multiline = true;
         this.sDescription.mouseEnabled = true;
         this.sDescription.htmlText = StringUtil.txt2link(_loc2_.content);
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
         if(this.botClip)
         {
            this.botContainer.removeChild(this.botClip);
            this.botClip = null;
         }
      }
      
      public function getList() : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.NEWS_LIST,{},this.onList);
      }
      
      private function onList(param1:*) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.NEWS_LIST,this.onList);
         this.scrollContainer.disposeItems(this.openView);
         if(Connectr.instance.cookieModel.read("news"))
         {
            this.newsRead = Connectr.instance.cookieModel.read("news");
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.news.length)
         {
            this.newsItem = new NewsItem();
            this.newsItem.data = param1.news[_loc2_];
            this.newsItem.addEventListener(MouseEvent.CLICK,this.openView);
            this.newsItem.buttonMode = true;
            this.scrollContainer.listContainer.addChild(this.newsItem);
            this.newsItem.y = _loc2_ * 30 + 28;
            if(this.newsRead)
            {
               if(this.newsRead.indexOf(param1.news[_loc2_].date) > -1)
               {
                  this.newsItem.statusIndicator.gotoAndStop(2);
               }
            }
            _loc2_++;
         }
         this.scrollContainer.init(230,330,2);
         param1 = null;
      }
      
      override public function removed() : void
      {
         this.headerBg.removeEventListener(MouseEvent.CLICK,this.closeView);
         if(this.botClip)
         {
            this.botContainer.removeChild(this.botClip);
            this.botClip = null;
         }
         this.scrollContainer.dispose(this.openView);
         this.removeChild(this.scrollContainer);
      }
   }
}

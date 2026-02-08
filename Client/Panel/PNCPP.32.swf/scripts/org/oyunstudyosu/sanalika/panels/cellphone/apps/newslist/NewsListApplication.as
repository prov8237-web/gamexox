package org.oyunstudyosu.sanalika.panels.cellphone.apps.newslist
{
   import com.oyunstudyosu.utils.DrawUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import org.oyunstudyosu.sanalika.panels.cellphone.CellPhoneApplication;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.newslist.NewsListApplication")]
   public class NewsListApplication extends CellPhoneApplication
   {
       
      
      private var newsListView:NewsListView;
      
      public var bg:MovieClip;
      
      private var index:int;
      
      private var sceneContainer:Sprite;
      
      private var sceneContainerMask:Sprite;
      
      public function NewsListApplication()
      {
         super();
      }
      
      override public function init() : void
      {
         this.index = this.getChildIndex(this.bg) + 1;
         this.sceneContainer = new Sprite();
         this.addChildAt(this.sceneContainer,this.index);
         this.sceneContainerMask = DrawUtils.getRectangleSprite(228,375,0,1);
         this.addChild(this.sceneContainerMask);
         this.sceneContainer.mask = this.sceneContainerMask;
         this.newsListView = new NewsListView();
         this.sceneContainer.addChild(this.newsListView);
      }
      
      override public function dispose() : void
      {
         if(this.sceneContainer)
         {
            this.removeChild(this.sceneContainer);
            this.removeChild(this.sceneContainerMask);
         }
         this.sceneContainer = null;
         this.sceneContainerMask = null;
         this.newsListView = null;
      }
   }
}

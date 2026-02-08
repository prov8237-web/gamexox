package org.oyunstudyosu.sanalika.mock
{
   import com.bit101.components.ComboBox;
   import com.bit101.components.PushButton;
   import com.oyunstudyosu.panel.IPanel;
   import com.oyunstudyosu.panel.PanelEvent;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.oyunstudyosu.utils.DefinitionUtils;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.System;
   
   public class PanelManager
   {
       
      
      private var popupInstance:IPanel;
      
      public var popupMockHandler:IExtensionMock;
      
      private var loader:Loader;
      
      private var popupComboBox:ComboBox;
      
      private var openPopupButton:PushButton;
      
      private var currentPopupName:String;
      
      private var main:Sprite;
      
      private var appDomain:ApplicationDomain;
      
      public function PanelManager(param1:Sprite)
      {
         super();
         this.main = param1;
         this.popupComboBox = new ComboBox(param1,10,10,"Select panel to open",PanelList.list);
         this.popupComboBox.width = 200;
         this.popupComboBox.numVisibleItems = 20;
         this.openPopupButton = new PushButton(param1,250,10,"Open",this.openPopup);
         this.appDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
         this.currentPopupName = this.popupComboBox.items[0].toString();
         this.currentPopupName = "CampaignPanel";
         this.openPop(this.currentPopupName);
      }
      
      private function openPopup(param1:MouseEvent) : void
      {
         this.currentPopupName = this.popupComboBox.selectedItem.toString();
         trace("openPopup:",this.currentPopupName);
         this.openPop(this.currentPopupName);
      }
      
      private function openPop(param1:String) : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         var _loc2_:LoaderContext = new LoaderContext(false,this.appDomain);
         this.loader.load(new URLRequest("../../sanalika-debug/dynamic/panels/" + param1 + ".swf"),_loc2_);
      }
      
      protected function onError(param1:IOErrorEvent) : void
      {
         this.loader = (param1.target as LoaderInfo).loader;
         trace(param1.text);
         trace("Error loading panel. ");
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
      }
      
      protected function onLoaded(param1:Event) : void
      {
         trace("onloaded");
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         var _loc3_:ApplicationDomain = _loc2_.applicationDomain;
         var _loc4_:Class = DefinitionUtils.getClass(_loc3_,this.currentPopupName);
         var _loc5_:Class = DefinitionUtils.getClass(ApplicationDomain.currentDomain,this.currentPopupName + "Mock");
         if(_loc4_ != null)
         {
            this.popupInstance = new _loc4_();
            if(_loc5_)
            {
               this.popupMockHandler = new _loc5_();
               this.popupInstance.data = this.popupMockHandler.getInitData() as PanelVO;
            }
            else
            {
               trace("MOCK EXPORT NOT FOUND !!!");
            }
            this.main.addChild(this.popupInstance as DisplayObject);
            this.popupInstance.init();
            this.popupInstance.addEventListener(PanelEvent.CLOSE,this.handlePanelClose,false,-1000);
            _loc4_ = null;
         }
         else
         {
            trace("EXPORT NOT FOUND !!!");
         }
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
      }
      
      private function handlePanelClose(param1:PanelEvent) : void
      {
         this.main.removeChild(this.popupInstance as DisplayObject);
         this.popupInstance = null;
         System.gc();
      }
   }
}

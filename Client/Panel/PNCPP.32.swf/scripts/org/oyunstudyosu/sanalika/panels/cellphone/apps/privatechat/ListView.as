package org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat
{
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat.ListView")]
   public class ListView extends CoreMovieClip
   {
       
      
      public var headerTxt:TextField;
      
      public var friendsButton:SimpleButton;
      
      public var chatsButton:SimpleButton;
      
      private var friendsView:FriendsView;
      
      private var groupsView:GroupsView;
      
      public var headerTextField:STextField;
      
      public function ListView()
      {
         super();
      }
      
      override public function added() : void
      {
         if(this.headerTextField == null)
         {
            this.headerTextField = TextFieldManager.convertAsArabicTextField(this.getChildByName("headerTxt") as TextField,false);
         }
         this.friendsView = new FriendsView();
         this.addChild(this.friendsView);
         this.groupsView = new GroupsView();
         this.addChild(this.groupsView);
         this.friendsView.y = this.groupsView.y = 85;
         this.friendsButton.addEventListener(MouseEvent.CLICK,this.friendsButtonClicked);
         this.chatsButton.addEventListener(MouseEvent.CLICK,this.chatsButtonClicked);
         this.chatsButtonClicked();
      }
      
      protected function chatsButtonClicked(param1:MouseEvent = null) : void
      {
         this.friendsButton.alpha = 0.5;
         this.chatsButton.alpha = 1;
         this.friendsView.alpha = 0;
         this.groupsView.alpha = 1;
         this.friendsView.mouseEnabled = this.friendsView.mouseChildren = false;
         this.groupsView.mouseEnabled = this.groupsView.mouseChildren = true;
         this.headerTextField.text = $("Chats");
      }
      
      protected function friendsButtonClicked(param1:MouseEvent = null) : void
      {
         this.friendsButton.alpha = 1;
         this.chatsButton.alpha = 0.5;
         this.friendsView.alpha = 1;
         this.groupsView.alpha = 0;
         this.friendsView.mouseEnabled = this.friendsView.mouseChildren = true;
         this.groupsView.mouseEnabled = this.groupsView.mouseChildren = false;
         this.headerTextField.text = $("Friends");
      }
      
      override public function removed() : void
      {
      }
   }
}

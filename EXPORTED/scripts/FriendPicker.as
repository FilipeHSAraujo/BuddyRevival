package
{
   import flash.display.Sprite;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   
   public class FriendPicker extends Sprite
   {
      
      private static var pages:Dictionary = new Dictionary();
      
      private var userId:String;
      
      private var retryCount:int;
      
      private var loadingMessage:TextField;
      
      private var console:TextField;
      
      public function FriendPicker(param1:String, param2:int, param3:TextField)
      {
         super();
         this.console = param3;
         this.userId = param1;
         FriendsPage.FRIENDS_PER_PAGE = param2;
         loadPage(0);
      }
      
      private function prevPage(param1:int) : void
      {
         showPage(param1);
      }
      
      private function nextPage(param1:int) : void
      {
         showPage(param1);
      }
      
      private function doLoad(param1:int) : void
      {
         var onLoadedPage:Function;
         var holder:Sprite = null;
         var callbackName:String = null;
         var first:int = param1;
         holder = this;
         if(loadingMessage == null)
         {
            loadingMessage = new TextField();
            loadingMessage.autoSize = TextFieldAutoSize.LEFT;
            loadingMessage.background = true;
            loadingMessage.backgroundColor = 15658734;
            loadingMessage.text = MessageBundle.msg("Loading...");
            loadingMessage.setTextFormat(new TextFormat("Arial",11,204));
            loadingMessage.x = 10;
            loadingMessage.y = 10;
         }
         if(!contains(loadingMessage))
         {
            addChild(loadingMessage);
         }
         onLoadedPage = function(param1:Array, param2:int):void
         {
            var label:TextField = null;
            var numFriends:int = 0;
            var next:int = 0;
            var page:FriendsPage = null;
            var friends:Array = param1;
            var totalNumber:int = param2;
            if(totalNumber == 0)
            {
               label = new TextField();
               label.width = 0;
               label.autoSize = TextFieldAutoSize.LEFT;
               label.background = false;
               label.border = false;
               label.selectable = false;
               label.text = MessageBundle.msg("None of your friends have BuddyPoke.");
               label.setTextFormat(new TextFormat("Arial",13,238,true));
               label.x = 0;
               label.y = 0;
               if(contains(loadingMessage))
               {
                  removeChild(loadingMessage);
               }
               holder.addChild(label);
               return;
            }
            try
            {
               numFriends = int(friends.length);
               console.appendText("friends.length " + friends + "\n");
               console.appendText("_____friends.length " + friends.length + "\n");
               if(contains(loadingMessage))
               {
                  removeChild(loadingMessage);
               }
               next = first + FriendsPage.FRIENDS_PER_PAGE;
               if(next >= totalNumber)
               {
                  next = -1;
               }
               page = new FriendsPage(console,first,friends,first - FriendsPage.FRIENDS_PER_PAGE,prevPage,next,nextPage);
               pages[first] = page;
               holder.addChild(page);
            }
            catch(e:*)
            {
               ++retryCount;
               if(retryCount < 3)
               {
                  console.appendText("ERROR loading page of friends\n");
                  doLoad(first);
               }
            }
         };
         if(ExternalInterface.available)
         {
            callbackName = "onLoadedPage" + BuddyPoke.timeStamp();
            ExternalInterface.addCallback(callbackName,onLoadedPage);
            ExternalInterface.call("requestOwnerFriends",callbackName,first,FriendsPage.FRIENDS_PER_PAGE);
         }
      }
      
      private function loadPage(param1:int) : void
      {
         console.text = "\nload friends page: " + param1 + "\n";
         retryCount = 0;
         doLoad(param1);
      }
      
      private function showPage(param1:int) : void
      {
         var _loc2_:int = this.numChildren;
         while(--_loc2_ >= 0)
         {
            removeChildAt(_loc2_);
         }
         var _loc3_:FriendsPage = pages[param1];
         if(_loc3_ != null)
         {
            this.addChild(_loc3_);
            return;
         }
         loadPage(param1);
      }
   }
}


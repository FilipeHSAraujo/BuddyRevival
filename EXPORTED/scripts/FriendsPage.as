package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.BevelFilter;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   import flash.text.*;
   import flash.utils.Dictionary;
   
   public class FriendsPage extends Sprite
   {
      
      public static var FRIENDS_PER_PAGE:int = 24;
      
      private static const FRIENDS_PER_ROW:int = 5;
      
      private var userDict:Dictionary;
      
      private var prev:int;
      
      private var loadQueue:Array;
      
      private var next:int;
      
      private var friends:Array;
      
      private var console:TextField;
      
      private var numFriendsOnPage:int = 0;
      
      public function FriendsPage(param1:TextField, param2:int, param3:Array, param4:int, param5:Function, param6:int, param7:Function)
      {
         var rowCnt:int;
         var x:int;
         var y:int;
         var owner:Sprite = null;
         var friend:* = undefined;
         var s:String = null;
         var userId:String = null;
         var image:String = null;
         var user:OSUser = null;
         var holder:Sprite = null;
         var hilight:Sprite = null;
         var rect:Shape = null;
         var ldr:Loader = null;
         var url:String = null;
         var urlReq:URLRequest = null;
         var nextHolder:Sprite = null;
         var nextTF:TextField = null;
         var prevHolder:Sprite = null;
         var prevTF:TextField = null;
         var console:TextField = param1;
         var first:int = param2;
         var friends:Array = param3;
         var prev:int = param4;
         var prevCallback:Function = param5;
         var next:int = param6;
         var nextCallback:Function = param7;
         userDict = new Dictionary();
         super();
         this.console = console;
         if(friends == null)
         {
            return;
         }
         this.friends = friends;
         this.prev = prev;
         this.next = next;
         console.appendText("\n\nprev " + prev + "\n\n");
         console.appendText("\n\nnext " + next + "\n\n");
         loadQueue = new Array();
         owner = this;
         x = 0;
         y = 0;
         rowCnt = 0;
         for each(friend in friends)
         {
            for(s in friend)
            {
               console.appendText(s + " " + friend[s] + "\n");
            }
            userId = friend.id;
            if(userId == null)
            {
               userId = friend.userId;
            }
            image = friend.icon;
            if(image == null)
            {
               image = friend.image;
            }
            if(image == null)
            {
               image = friend.thumbnailUrl;
            }
            user = new OSUser();
            user.createUser(userId,friend.name,friend.gender,false,false);
            userDict[userId] = user;
            try
            {
               holder = new Sprite();
               holder.mouseChildren = false;
               holder.useHandCursor = true;
               holder.buttonMode = true;
               holder.name = userId;
               holder.graphics.beginFill(15461355);
               holder.graphics.drawRoundRectComplex(0,0,58,58,3,3,3,3);
               holder.graphics.endFill();
               hilight = createHighlight();
               holder.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
               {
                  owner.setChildIndex(DisplayObject(param1.target),owner.numChildren - 1);
                  param1.target.getChildByName("hilight").visible = true;
               });
               holder.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
               {
                  param1.target.getChildByName("hilight").visible = false;
               });
               holder.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
               {
                  owner.dispatchEvent(new SelectedFriendEvent(SelectedFriendEvent.SELECT_FRIEND,userDict[param1.target.name]));
               });
               rect = new Shape();
               rect.graphics.beginFill(16777215);
               rect.graphics.drawRoundRectComplex(0,0,58,58,3,3,3,3);
               rect.graphics.endFill();
               holder.addChild(rect);
               ldr = new Loader();
               ldr.mask = rect;
               ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,resizer);
               url = image;
               try
               {
                  if(url.indexOf(".bmp") < 0)
                  {
                     urlReq = new URLRequest(url);
                     ldr.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
                     ldr.load(urlReq);
                     holder.addChild(ldr);
                  }
               }
               catch(e:*)
               {
               }
               holder.addChild(hilight);
               holder.x = x;
               holder.y = y;
               this.addChild(holder);
            }
            catch(e2:*)
            {
            }
            x += 70;
            rowCnt++;
            if(rowCnt == FRIENDS_PER_ROW)
            {
               rowCnt = 0;
               x = 0;
               y += 70;
            }
         }
         if(rowCnt != 0)
         {
            y += 70;
         }
         if(next > 0)
         {
            nextHolder = new Sprite();
            nextTF = new TextField();
            nextTF.autoSize = TextFieldAutoSize.RIGHT;
            nextTF.width = 0;
            nextTF.x = FRIENDS_PER_ROW * 70 - 15;
            nextTF.y = y;
            nextHolder.addChild(nextTF);
            nextHolder.mouseChildren = false;
            nextHolder.useHandCursor = true;
            nextHolder.buttonMode = true;
            addChild(nextHolder);
            if(nextCallback != null)
            {
               nextHolder.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  nextCallback(next);
               });
            }
            nextTF.text = MessageBundle.msg("Next");
            nextTF.setTextFormat(new TextFormat("Arial",13,204,true,null,true,null,null,TextFormatAlign.RIGHT));
         }
         if(prev >= 0)
         {
            prevHolder = new Sprite();
            prevTF = new TextField();
            prevTF.autoSize = TextFieldAutoSize.LEFT;
            prevTF.width = 0;
            prevTF.x = 5;
            prevTF.y = y;
            prevHolder.addChild(prevTF);
            prevHolder.mouseChildren = false;
            prevHolder.useHandCursor = true;
            prevHolder.buttonMode = true;
            addChild(prevHolder);
            if(prevCallback != null)
            {
               prevHolder.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  prevCallback(prev);
               });
            }
            prevTF.text = MessageBundle.msg("Previous");
            prevTF.setTextFormat(new TextFormat("Arial",13,204,true,null,true,null,null,TextFormatAlign.LEFT));
         }
      }
      
      private function onIOError(param1:Event) : void
      {
      }
      
      private function createHighlight() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.mouseChildren = false;
         _loc1_.visible = false;
         _loc1_.name = "hilight";
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.lineStyle(3,204,1);
         _loc2_.graphics.drawRoundRectComplex(-1,-1,60,60,3,3,3,3);
         _loc1_.addChild(_loc2_);
         _loc1_.filters = [new GlowFilter(16777215,0.6,2,2),new BevelFilter()];
         return _loc1_;
      }
      
      private function resizer(param1:Event) : void
      {
         console.appendText("resizer... \n");
         var _loc2_:Loader = LoaderInfo(param1.target).loader;
         var _loc3_:Number = _loc2_.width;
         var _loc4_:Number = _loc2_.height;
         console.appendText("resizer... " + _loc3_ + " " + _loc4_ + "\n");
         if(_loc3_ > 0 && _loc4_ > 0)
         {
            _loc2_.scaleX = 58 / _loc3_;
            _loc2_.scaleY = 58 / _loc4_;
         }
      }
   }
}


package
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class BulletinPreview extends Sprite
   {
      
      private var buddyPanelShape:Shape;
      
      private var timer:Timer;
      
      private var animToShow:String;
      
      private var buddy1:Buddy;
      
      private var buddyDesc:String;
      
      public function BulletinPreview(param1:String, param2:String)
      {
         var start:Timer;
         var buddyDesc:String = param1;
         var anim:String = param2;
         timer = new Timer(60,0);
         buddyDesc = Buddy.DEFAULT;
         super();
         if(buddyDesc != null && buddyDesc.length > 0)
         {
            this.buddyDesc = buddyDesc;
         }
         animToShow = "pose_joinNow";
         if(anim != null)
         {
            try
            {
               anim = MoodSelectionPanel.getAnimId(anim);
               if(anim != null)
               {
                  animToShow = anim;
               }
            }
            catch(e:*)
            {
            }
         }
         start = new Timer(30,0);
         start.addEventListener(TimerEvent.TIMER,onStart);
         start.start();
      }
      
      private function changeAnim(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = Sprite(param1.target);
         buddy1.selectedAnim = MoodSelectionPanel.getAnimId(_loc2_.name);
      }
      
      private function onLoadedBuddy(param1:Event) : void
      {
         var event:Event = param1;
         if(buddyDesc != null)
         {
            try
            {
               buddy1.deserializeCompressed(buddyDesc);
            }
            catch(e:*)
            {
            }
         }
         stage.frameRate = 12;
         stage.quality = StageQuality.HIGH;
         timer.addEventListener(TimerEvent.TIMER,onEnterFrame,false,-10000,false);
         timer.start();
      }
      
      private function onClicked(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         var request:URLRequest = new URLRequest("http://www.myspace.com/buddypoke");
         try
         {
            navigateToURL(request,"_blank");
         }
         catch(e:*)
         {
         }
      }
      
      protected function onEnterFrame(param1:TimerEvent) : void
      {
         if(buddy1 == null)
         {
            return;
         }
         buddyPanelShape.graphics.clear();
         buddy1.draw(buddyPanelShape.graphics,true);
      }
      
      private function onStart(param1:TimerEvent) : void
      {
         if(stage == null)
         {
            return;
         }
         Timer(param1.target).stop();
         buddyPanelShape = new Shape();
         this.addChild(buddyPanelShape);
         buddy1 = new Buddy(stage);
         buddy1.addEventListener("BUDDY_LOADED",onLoadedBuddy);
         buddy1.loadBin(new BuddyPoke.chickClass() as ByteArray,animToShow,300,240);
      }
   }
}


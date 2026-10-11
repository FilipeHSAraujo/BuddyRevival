package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class BuddyCache
   {
      
      private static var staticInstance:BuddyCache;
      
      private var output:TextField;
      
      private var timer:Timer;
      
      private var buddySharedObject:SharedObject;
      
      public function BuddyCache(param1:TextField, param2:String)
      {
         var output:TextField = param1;
         var containerId:String = param2;
         timer = new Timer(5 * 1000,1);
         super();
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,onSaveTimer);
         this.output = output;
         try
         {
            buddySharedObject = SharedObject.getLocal("buddypoke_" + containerId,"/");
            if(output != null)
            {
               output.appendText("loading cache...\n");
            }
            if(buddySharedObject.data.cache == null)
            {
               if(output != null)
               {
                  output.appendText("cache is null, creating it..\n");
               }
               buddySharedObject.data.cache = new Object();
            }
         }
         catch(e:*)
         {
         }
      }
      
      public static function timeStamp() : int
      {
         var _loc1_:Date = new Date();
         var _loc2_:Number = Date.UTC(_loc1_.getUTCFullYear(),_loc1_.getUTCMonth(),_loc1_.getUTCDate(),_loc1_.getUTCHours(),_loc1_.getUTCMinutes(),_loc1_.getSeconds());
         return int(Math.floor(_loc2_ / 1000));
      }
      
      public static function CreateInstance(param1:TextField, param2:String) : void
      {
         staticInstance = new BuddyCache(param1,param2);
      }
      
      public static function GetInstance() : BuddyCache
      {
         return staticInstance;
      }
      
      public function dump() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(output != null)
         {
            _loc1_ = buddySharedObject.data.cache;
            _loc2_ = 0;
            for(_loc3_ in _loc1_)
            {
               output.appendText(_loc3_ + "    " + _loc1_[_loc3_].ts + " " + this.getBuddy(_loc3_,0) + "\n");
               _loc2_++;
            }
            output.appendText("len " + _loc2_ + "\n");
         }
      }
      
      public function cacheBuddy(param1:String, param2:String, param3:int = 0) : void
      {
         if(param3 == 0)
         {
            param3 = timeStamp();
         }
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeObject({"bd":param2});
         _loc4_.position = 0;
         _loc4_.compress();
         _loc4_.position = 0;
         buddySharedObject.data.cache[param1] = {
            "ts":param3,
            "bdc":_loc4_
         };
         while(buddySharedObject.size > 95000)
         {
            removeOldestItem();
         }
         if(output != null)
         {
            output.appendText("cacheBuddy " + param1 + "    " + buddySharedObject.size + "\n");
         }
         timer.reset();
         timer.start();
      }
      
      public function saveCache() : void
      {
         var flushStatus:String;
         timer.stop();
         timer.reset();
         flushStatus = null;
         try
         {
            flushStatus = buddySharedObject.flush(99000);
            if(output != null)
            {
               output.appendText("saved cache " + buddySharedObject.size + "\n");
            }
         }
         catch(error:*)
         {
            if(output != null)
            {
               output.appendText("error " + error + " \n");
            }
         }
         if(flushStatus != null)
         {
            switch(flushStatus)
            {
               case SharedObjectFlushStatus.PENDING:
                  if(output != null)
                  {
                     output.appendText("Requesting permission to save object\n");
                  }
                  break;
               case SharedObjectFlushStatus.FLUSHED:
                  if(output != null)
                  {
                     output.appendText("Value flushed to disk\n");
                  }
            }
         }
      }
      
      private function onSaveTimer(param1:Event) : void
      {
         saveCache();
      }
      
      public function getBuddy1Hour(param1:String) : String
      {
         return getBuddy(param1,60 * 60);
      }
      
      public function getBuddy20Mins(param1:String) : String
      {
         return getBuddy(param1,60 * 20);
      }
      
      public function getBuddy(param1:String, param2:int) : String
      {
         var _loc3_:* = buddySharedObject.data.cache[param1];
         if(_loc3_ == null || _loc3_["bdc"] == null)
         {
            return null;
         }
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeBytes(_loc3_["bdc"],0,_loc3_["bdc"].length);
         _loc4_.position = 0;
         _loc4_.uncompress();
         _loc4_.position = 0;
         var _loc5_:String = _loc4_.readObject()["bd"];
         if(output != null)
         {
            output.appendText("\n\n Load buddy from cache: " + param1 + "    " + _loc5_ + "\n");
         }
         if(param2 <= 0)
         {
            return _loc5_;
         }
         var _loc6_:int = int(_loc3_["ts"]);
         var _loc7_:int = timeStamp();
         var _loc8_:int = _loc7_ - _loc6_;
         if(output != null)
         {
            output.appendText("timestamp of file in cache for " + param1 + " is " + BuddyPoke.timeStampToLocalDate(_loc6_).toTimeString() + "\n");
            output.appendText("current timestamp is " + BuddyPoke.timeStampToLocalDate(_loc7_).toTimeString() + "\n");
            output.appendText("difference of times " + _loc8_ + "     _____    hours: " + BuddyPoke.timeStampToLocalDate(_loc8_).hours + "  mins: " + BuddyPoke.timeStampToLocalDate(_loc8_).minutes + "\n");
            output.appendText("maxAge " + param2 + "\n");
            output.appendText("timeDiff<maxAge " + (_loc8_ < param2) + "\n");
         }
         if(_loc8_ < param2)
         {
            if(output != null)
            {
               output.appendText("cache for " + param1 + " is new enough to use\n");
            }
            return _loc5_;
         }
         if(output != null)
         {
            output.appendText("cache for " + param1 + " is too old to use\n");
         }
         return null;
      }
      
      public function getBuddy15Mins(param1:String) : String
      {
         return getBuddy(param1,60 * 15);
      }
      
      private function removeOldestItem() : void
      {
         var _loc3_:int = 0;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:String = null;
         var _loc4_:* = buddySharedObject.data.cache;
         for(_loc5_ in _loc4_)
         {
            _loc6_ = _loc4_[_loc5_];
            if(_loc1_ == null || _loc6_.ts < _loc3_)
            {
               _loc2_ = _loc5_;
               _loc1_ = _loc6_;
               _loc3_ = int(_loc6_.ts);
            }
         }
         if(_loc2_ != null)
         {
            if(output != null)
            {
               output.appendText("deleting item from cache " + _loc2_ + "      size " + buddySharedObject.size + "\n");
            }
            delete _loc4_[_loc2_];
            if(output != null)
            {
               output.appendText("deletED item from cache " + _loc2_ + "      size " + buddySharedObject.size + "\n\n\n");
            }
         }
      }
      
      public function getBuddy3Hours(param1:String) : String
      {
         return getBuddy(param1,60 * 60 * 3);
      }
      
      public function getBuddy24Hours(param1:String) : String
      {
         return getBuddy(param1,60 * 60 * 24);
      }
   }
}


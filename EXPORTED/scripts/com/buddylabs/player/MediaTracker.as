package com.buddylabs.player
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.ProgressEvent;
   
   public class MediaTracker implements IEventDispatcher
   {
      
      private var toLoad:Array = new Array();
      
      private var progressEvent:ProgressEvent = null;
      
      private var dispatcher:EventDispatcher;
      
      public function MediaTracker()
      {
         super();
         dispatcher = new EventDispatcher(this);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return dispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return dispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return dispatcher.willTrigger(param1);
      }
      
      private function updateComplete(param1:Event) : void
      {
         if(checkAll(false))
         {
            this.dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         dispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function isErrorAny() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < toLoad.length)
         {
            _loc2_ = Media(toLoad[_loc1_]).check(false);
            if(_loc2_ == Media.ERRORED)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function addMedia(param1:Media) : void
      {
         if(param1 != null)
         {
            param1.addEventListener(Event.COMPLETE,updateComplete);
            param1.addEventListener(ProgressEvent.PROGRESS,updateProgress);
            toLoad.push(param1);
         }
      }
      
      public function clearAll() : void
      {
         if(toLoad != null)
         {
            GCUtil.disposeArray(toLoad,false);
            toLoad = null;
         }
         toLoad = new Array();
      }
      
      private function updateProgress(param1:ProgressEvent) : void
      {
         var _loc6_:Media = null;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         while(_loc5_ < toLoad.length)
         {
            _loc6_ = Media(toLoad[_loc5_]);
            _loc3_ += _loc6_.bytesLoaded;
            _loc4_ += _loc6_.bytesTotal;
            _loc5_++;
         }
         if(progressEvent == null)
         {
            progressEvent = new ProgressEvent(ProgressEvent.PROGRESS,false,false,_loc3_,_loc4_);
         }
         else
         {
            progressEvent.bytesLoaded = _loc3_;
            progressEvent.bytesTotal = _loc4_;
         }
         this.dispatchEvent(progressEvent);
      }
      
      public function checkAll(param1:Boolean) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Boolean = true;
         if(toLoad != null)
         {
            if(toLoad.length == 0)
            {
               this.dispatchEvent(new Event(Event.COMPLETE));
               return _loc2_;
            }
            _loc3_ = 0;
            while(_loc3_ < toLoad.length)
            {
               _loc4_ = Media(toLoad[_loc3_]).check(param1);
               if(_loc4_ == Media.TOLOAD || _loc4_ == Media.LOADING)
               {
                  _loc2_ = false;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         dispatcher.addEventListener(param1,param2,param3,param4);
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Media = null;
         if(toLoad != null)
         {
            _loc1_ = 0;
            while(_loc1_ < toLoad.length)
            {
               _loc2_ = Media(toLoad[_loc1_]);
               _loc2_.abort();
               _loc1_++;
            }
         }
         toLoad = null;
         dispatcher = null;
         progressEvent = null;
      }
   }
}


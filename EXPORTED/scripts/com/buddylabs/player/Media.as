package com.buddylabs.player
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class Media extends EventDispatcher
   {
      
      public static var TOLOAD:int = 0;
      
      public static var LOADING:int = 1;
      
      public static var ABORTED:int = 2;
      
      public static var ERRORED:int = 3;
      
      public static var COMPLETE:int = 4;
      
      private var bytesTotalVal:uint;
      
      internal var state:int;
      
      private var urlVal:String;
      
      protected var loader:URLLoader = new URLLoader();
      
      private var bytesLoadedVal:uint;
      
      public function Media()
      {
         super();
      }
      
      public function check(param1:Boolean) : int
      {
         var urlReq:URLRequest = null;
         var load:Boolean = param1;
         if(state == TOLOAD && load == true && loader != null)
         {
            state = LOADING;
            urlReq = new URLRequest(urlVal);
            loader.addEventListener(Event.COMPLETE,completeHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
            loader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
            try
            {
               loader.load(urlReq);
            }
            catch(error:Error)
            {
               state = ERRORED;
               removeListeners(loader);
            }
         }
         return state;
      }
      
      private function completeHandler(param1:Event) : void
      {
         onLoaded(param1);
         removeListeners(loader);
         if(param1.target is URLLoader)
         {
            URLLoader(param1.target).close();
         }
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         trace("ioErrorHandler Map " + url);
         state = ERRORED;
         dispatchEvent(new Event(Event.COMPLETE));
         removeListeners(loader);
      }
      
      protected function onLoaded(param1:Event) : void
      {
      }
      
      private function progressHandler(param1:ProgressEvent) : void
      {
         bytesLoadedVal = param1.bytesLoaded;
         bytesTotalVal = param1.bytesTotal;
         this.dispatchEvent(param1);
      }
      
      public function get url() : String
      {
         return urlVal;
      }
      
      public function get bytesLoaded() : uint
      {
         return bytesLoadedVal;
      }
      
      public function get bytesTotal() : uint
      {
         return bytesTotalVal;
      }
      
      private function removeListeners(param1:IEventDispatcher) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.hasEventListener(Event.COMPLETE))
         {
            param1.removeEventListener(Event.COMPLETE,completeHandler);
         }
         if(param1.hasEventListener(IOErrorEvent.IO_ERROR))
         {
            param1.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         }
         if(param1.hasEventListener(ProgressEvent.PROGRESS))
         {
            param1.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
         }
      }
      
      public function abort() : void
      {
         if(state == LOADING && loader != null)
         {
            loader.close();
         }
         state = ABORTED;
      }
      
      public function set url(param1:String) : void
      {
         state = TOLOAD;
         urlVal = param1;
         bytesLoadedVal = 0;
         bytesTotalVal = 0;
      }
      
      public function dispose() : void
      {
         if(loader != null)
         {
            removeListeners(loader);
            loader = null;
         }
         urlVal = null;
      }
   }
}


package com.buddylabs.player
{
   import flash.events.Event;
   import flash.net.URLLoaderDataFormat;
   import flash.utils.ByteArray;
   
   public class MediaBinary extends Media
   {
      
      public function MediaBinary(param1:String = null)
      {
         super();
         if(param1 != null)
         {
            this.url = param1;
         }
      }
      
      public function get data() : ByteArray
      {
         return loader.data;
      }
      
      override protected function onLoaded(param1:Event) : void
      {
         state = COMPLETE;
         dispatchEvent(param1);
      }
      
      override public function set url(param1:String) : void
      {
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         super.url = param1;
      }
   }
}


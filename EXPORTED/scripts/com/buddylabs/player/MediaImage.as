package com.buddylabs.player
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.Event;
   
   public class MediaImage extends MediaBinary
   {
      
      private var loaded:Boolean = false;
      
      private var bmd:BitmapData;
      
      private var imageLoader:Loader;
      
      public function MediaImage()
      {
         super();
      }
      
      public function get bitmapData() : BitmapData
      {
         return bmd;
      }
      
      override protected function onLoaded(param1:Event) : void
      {
         if(loader == null)
         {
            return;
         }
         imageLoader = new Loader();
         imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadedImage);
         imageLoader.loadBytes(loader.data);
      }
      
      protected function onLoadedImage(param1:Event) : void
      {
         trace("Loaded Map " + url);
         imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadedImage);
         var _loc2_:Loader = Loader(imageLoader);
         bmd = Bitmap(_loc2_.content).bitmapData;
         loaded = true;
         state = COMPLETE;
         dispatchEvent(param1);
      }
      
      override public function dispose() : void
      {
         if(bmd != null)
         {
            bmd.dispose();
         }
         bmd = null;
         imageLoader = null;
         super.dispose();
      }
   }
}


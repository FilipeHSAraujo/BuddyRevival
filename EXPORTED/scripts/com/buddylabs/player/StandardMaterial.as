package com.buddylabs.player
{
   import flash.display.BitmapData;
   
   public class StandardMaterial extends BaseMaterial
   {
      
      private var media:MediaImage;
      
      public var url:String = null;
      
      public function StandardMaterial()
      {
         super();
      }
      
      override public function init(param1:Context) : void
      {
         if(url != null)
         {
            media = new MediaImage();
            media.url = param1.rootPath + url;
            param1.imageTracker.addMedia(media);
         }
      }
      
      override public function get bitmapData() : BitmapData
      {
         if(media == null)
         {
            return null;
         }
         return media.bitmapData;
      }
      
      override public function dispose() : void
      {
         url = null;
         if(media != null)
         {
            media.dispose();
         }
         media = null;
         super.dispose();
      }
   }
}


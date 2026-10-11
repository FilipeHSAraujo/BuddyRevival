package org.aswing.image.png
{
   import flash.display.BitmapData;
   
   public interface EncodeStrategy
   {
      
      function encode(param1:BitmapData, param2:AsPngEncoder) : void;
   }
}


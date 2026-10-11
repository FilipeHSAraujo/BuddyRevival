package org.aswing.image.png
{
   import flash.utils.ByteArray;
   
   public interface Chunk
   {
      
      function getType() : uint;
      
      function getData() : ByteArray;
   }
}


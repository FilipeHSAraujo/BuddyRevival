package org.aswing.image.png
{
   import flash.utils.ByteArray;
   
   public class IEND implements Chunk
   {
      
      public function IEND()
      {
         super();
      }
      
      public function getType() : uint
      {
         return 1229278788;
      }
      
      public function getData() : ByteArray
      {
         return null;
      }
   }
}


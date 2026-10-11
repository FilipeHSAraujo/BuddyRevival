package org.aswing.image.png
{
   import flash.utils.ByteArray;
   
   public class PLTE implements Chunk
   {
      
      private var data:ByteArray;
      
      public function PLTE(param1:ByteArray)
      {
         super();
         this.data = param1;
      }
      
      public function getType() : uint
      {
         return 1347179589;
      }
      
      public function getData() : ByteArray
      {
         return data;
      }
   }
}


package org.aswing.image.png
{
   import flash.utils.ByteArray;
   
   public class IDAT implements Chunk
   {
      
      private var data:ByteArray;
      
      public function IDAT(param1:ByteArray)
      {
         super();
         this.data = param1;
      }
      
      public function getType() : uint
      {
         return 1229209940;
      }
      
      public function getData() : ByteArray
      {
         return data;
      }
   }
}


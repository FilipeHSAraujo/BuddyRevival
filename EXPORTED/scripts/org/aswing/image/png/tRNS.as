package org.aswing.image.png
{
   import flash.utils.ByteArray;
   
   public class tRNS implements Chunk
   {
      
      private var data:ByteArray;
      
      public function tRNS(param1:ByteArray)
      {
         super();
         this.data = param1;
      }
      
      public function getType() : uint
      {
         return 1951551059;
      }
      
      public function getData() : ByteArray
      {
         return data;
      }
   }
}


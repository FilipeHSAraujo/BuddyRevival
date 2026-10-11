package org.aswing.image.png
{
   import flash.display.BitmapData;
   
   public class EncodeStrategyBase implements EncodeStrategy
   {
      
      protected var trns:tRNS;
      
      protected var idats:Array;
      
      protected var ihdr:IHDR;
      
      protected var plte:PLTE;
      
      public function EncodeStrategyBase()
      {
         super();
         idats = new Array();
      }
      
      protected function writeChunks(param1:BitmapData, param2:AsPngEncoder) : void
      {
         writeChunk(param2,getIHDR());
         writeChunk(param2,getPLTE());
         writeChunk(param2,gettRNS());
         var _loc3_:Array = getIDATs();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            writeChunk(param2,_loc3_[_loc4_]);
            _loc4_++;
         }
      }
      
      protected function writeChunk(param1:AsPngEncoder, param2:Chunk) : void
      {
         param1.writeChunk(param2);
      }
      
      public function getIDATs() : Array
      {
         return idats;
      }
      
      public function getIHDR() : IHDR
      {
         return ihdr;
      }
      
      protected function buildChunks(param1:BitmapData, param2:AsPngEncoder) : void
      {
         throw new PngError("Subclass should overrid this method!");
      }
      
      public function gettRNS() : tRNS
      {
         return trns;
      }
      
      public function getPLTE() : PLTE
      {
         return plte;
      }
      
      public function encode(param1:BitmapData, param2:AsPngEncoder) : void
      {
         buildChunks(param1,param2);
         writeChunks(param1,param2);
      }
   }
}


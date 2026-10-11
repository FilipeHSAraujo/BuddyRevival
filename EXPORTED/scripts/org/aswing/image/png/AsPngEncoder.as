package org.aswing.image.png
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   
   public class AsPngEncoder extends Sprite
   {
      
      private static var crcTable:Array;
      
      private var png:ByteArray;
      
      public function AsPngEncoder()
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super();
         if(crcTable == null)
         {
            crcTable = [];
            _loc1_ = 0;
            while(_loc1_ < 256)
            {
               _loc2_ = _loc1_;
               _loc3_ = 0;
               while(_loc3_ < 8)
               {
                  if(_loc2_ & 1)
                  {
                     _loc2_ = uint(uint(3988292384) ^ uint(_loc2_ >>> 1));
                  }
                  else
                  {
                     _loc2_ = uint(_loc2_ >>> 1);
                  }
                  _loc3_++;
               }
               crcTable[_loc1_] = _loc2_;
               _loc1_++;
            }
         }
      }
      
      protected function writeSignature() : void
      {
         png.writeUnsignedInt(2303741511);
         png.writeUnsignedInt(218765834);
      }
      
      internal function writeChunk(param1:Chunk) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:ByteArray = param1.getData();
         var _loc3_:uint = param1.getType();
         var _loc4_:uint = 0;
         if(_loc2_ != null)
         {
            _loc4_ = _loc2_.length;
         }
         png.writeUnsignedInt(_loc4_);
         var _loc5_:uint = png.position;
         png.writeUnsignedInt(_loc3_);
         if(_loc2_ != null)
         {
            png.writeBytes(_loc2_);
         }
         var _loc6_:uint = png.position;
         png.position = _loc5_;
         var _loc7_:uint = 4294967295;
         var _loc8_:uint = _loc6_ - _loc5_;
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc7_ = uint(crcTable[(_loc7_ ^ png.readUnsignedByte()) & 0xFF] ^ _loc7_ >>> 8);
            _loc9_++;
         }
         _loc7_ = uint(_loc7_ ^ uint(4294967295));
         png.position = _loc6_;
         png.writeUnsignedInt(_loc7_);
      }
      
      public function encode(param1:BitmapData, param2:EncodeStrategy) : ByteArray
      {
         png = new ByteArray();
         writeSignature();
         param2.encode(param1,this);
         writeChunk(new IEND());
         return png;
      }
   }
}


package com.buddylabs.player
{
   import flash.utils.ByteArray;
   
   public class BitStream
   {
      
      public static var READ:int = 1;
      
      public static var WRITE:int = 2;
      
      private var _direction:int;
      
      private var ba_pattern:Array = [127,63,31,15,7,3,1];
      
      private var _curPos:int;
      
      private var _bitBuffer:int;
      
      private var _baseStream:ByteArray;
      
      public function BitStream(param1:ByteArray, param2:int)
      {
         super();
         if(param1 != null)
         {
            param1.position = 0;
         }
         _direction = param2;
         _baseStream = param1;
         _bitBuffer = 0;
         _curPos = 0;
      }
      
      public function dispose() : void
      {
         if(_baseStream != null)
         {
            _baseStream.length = 0;
         }
         _baseStream = null;
      }
      
      public function readBits(param1:int) : int
      {
         var _loc2_:* = 0;
         param1--;
         var _loc3_:int = 0;
         while(_loc3_ <= param1)
         {
            _loc2_ |= readBit() << param1 - _loc3_;
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function writeShort(param1:int) : void
      {
         byteAlign();
         _baseStream.writeShort(param1);
      }
      
      public function writeBits(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            writeBit(param1 >> param2 - _loc3_ - 1 & 1);
            _loc3_++;
         }
      }
      
      public function get data() : ByteArray
      {
         return _baseStream;
      }
      
      public function readShort() : int
      {
         byteAlign();
         return _baseStream.readShort();
      }
      
      public function writeBit(param1:int) : void
      {
         _bitBuffer |= param1 << 7 - _curPos;
         if(++_curPos == 8)
         {
            _baseStream.writeByte(_bitBuffer);
            _bitBuffer = 0;
            _curPos = 0;
         }
      }
      
      public function close() : void
      {
         if(_direction == WRITE && _curPos != 0)
         {
            _baseStream.writeByte(_bitBuffer);
         }
         _baseStream.position = 0;
      }
      
      public function writeByte(param1:int) : void
      {
         byteAlign();
         _baseStream.writeByte(param1);
      }
      
      public function readBit() : int
      {
         var _loc1_:int = 0;
         if(_curPos == 0)
         {
            _bitBuffer = _baseStream.readUnsignedByte();
         }
         _loc1_ = (1 << 7 - _curPos & _bitBuffer) > 0 ? 1 : 0;
         _curPos = (_curPos + 1) % 8;
         return _loc1_;
      }
      
      public function byteAlign() : void
      {
         if(_curPos == 0)
         {
            return;
         }
         if(_direction == WRITE)
         {
            _bitBuffer |= ba_pattern[_curPos - 1];
         }
         if(_direction == WRITE)
         {
            _baseStream.writeByte(_bitBuffer);
         }
         _curPos = 0;
      }
      
      public function readByte() : int
      {
         byteAlign();
         return _baseStream.readByte();
      }
      
      public function writeInt(param1:int) : void
      {
         byteAlign();
         _baseStream.writeInt(param1);
      }
   }
}


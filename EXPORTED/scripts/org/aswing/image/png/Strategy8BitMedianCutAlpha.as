package org.aswing.image.png
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class Strategy8BitMedianCutAlpha extends EncodeStrategyBase
   {
      
      private var alphaWeight:int;
      
      private var colorNumber:int;
      
      public function Strategy8BitMedianCutAlpha(param1:int = 256, param2:int = 1)
      {
         super();
         this.colorNumber = param1;
         this.alphaWeight = param2;
         if(param1 > 256 || param1 < 1)
         {
            throw new PngError("Color Number should be [1, 256]");
         }
         if(param2 < 1 || param2 > 256)
         {
            throw new PngError("Alpha weight should be [1, 256]");
         }
      }
      
      private function getIndexInQueue(param1:Array, param2:uint) : int
      {
         var _loc6_:Block = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = Block.NUM_DIM * 8;
         var _loc5_:int = 0;
         while(true)
         {
            if(_loc5_ >= _loc3_)
            {
               throw new PngError("Can\'t found index!!");
            }
            _loc6_ = param1[_loc5_];
            _loc7_ = _loc6_.maxCorner;
            _loc8_ = _loc6_.minCorner;
            _loc9_ = true;
            _loc10_ = 0;
            while(_loc10_ < _loc4_)
            {
               _loc11_ = uint(255 << _loc10_);
               _loc12_ = uint(param2 & _loc11_);
               _loc13_ = uint(_loc7_ & _loc11_);
               _loc14_ = uint(_loc8_ & _loc11_);
               if(_loc12_ < _loc14_ || _loc12_ > _loc13_)
               {
                  _loc9_ = false;
                  break;
               }
               _loc10_ += 8;
            }
            if(_loc9_)
            {
               break;
            }
            _loc5_++;
         }
         return _loc5_;
      }
      
      override protected function buildChunks(param1:BitmapData, param2:AsPngEncoder) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc13_:* = undefined;
         var _loc14_:Block = null;
         var _loc15_:Array = null;
         var _loc18_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:Array = null;
         var _loc23_:uint = 0;
         var _loc24_:* = undefined;
         var _loc3_:int = param1.width;
         var _loc4_:int = param1.height;
         var _loc5_:* = 0;
         _loc8_ = getTimer();
         var _loc9_:ByteArray = param1.getPixels(new Rectangle(0,0,_loc3_,_loc4_));
         _loc9_.position = 0;
         var _loc10_:int = _loc3_ * _loc4_;
         var _loc11_:Array = new Array();
         var _loc12_:Array = new Array();
         _loc8_ = getTimer();
         _loc5_ = _loc10_ - 1;
         while(_loc5_ >= 0)
         {
            _loc21_ = _loc9_.readUnsignedInt();
            _loc12_[int(_loc21_)] = _loc21_;
            _loc5_--;
         }
         _loc8_ = getTimer();
         for each(_loc13_ in _loc12_)
         {
            _loc11_.push(_loc13_);
         }
         _loc8_ = getTimer();
         _loc14_ = new Block(_loc11_,alphaWeight);
         _loc15_ = new Array();
         _loc15_.push(_loc14_);
         while(_loc15_.length < colorNumber)
         {
            _loc14_ = _loc15_.pop();
            if(_loc14_.maxSideLength <= 1)
            {
               _loc15_.push(_loc14_);
               break;
            }
            _loc22_ = _loc14_.splite();
            addToQueue(_loc15_,_loc22_[0]);
            addToQueue(_loc15_,_loc22_[1]);
         }
         _loc8_ = getTimer();
         ihdr = new IHDR(_loc3_,_loc4_,IHDR.ByteDepth_8,IHDR.CT_IndexedColor);
         var _loc16_:ByteArray = new ByteArray();
         var _loc17_:ByteArray = new ByteArray();
         _loc10_ = int(_loc15_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc10_)
         {
            _loc14_ = _loc15_[_loc5_];
            _loc18_ = _loc14_.publishColor;
            _loc16_.writeByte((_loc18_ & 0xFF0000) >>> 16);
            _loc16_.writeByte((_loc18_ & 0xFF00) >>> 8);
            _loc16_.writeByte(_loc18_ & 0xFF);
            _loc17_.writeByte(_loc18_ >>> 24);
            _loc5_++;
         }
         plte = new PLTE(_loc16_);
         trns = new tRNS(_loc17_);
         _loc8_ = getTimer();
         var _loc19_:ByteArray = new ByteArray();
         _loc5_ = 0;
         _loc9_.position = 0;
         var _loc20_:Array = new Array();
         _loc7_ = 0;
         while(_loc7_ < _loc4_)
         {
            _loc19_.writeByte(0);
            _loc6_ = 0;
            while(_loc6_ < _loc3_)
            {
               _loc23_ = _loc9_.readUnsignedInt();
               _loc24_ = _loc20_[int(_loc23_)];
               if(_loc24_ !== undefined)
               {
                  _loc19_.writeByte(int(_loc24_));
               }
               else
               {
                  _loc24_ = getIndexInQueue(_loc15_,_loc23_);
                  _loc20_[int(_loc23_)] = _loc24_;
                  _loc19_.writeByte(int(_loc24_));
               }
               _loc5_++;
               _loc6_++;
            }
            _loc7_++;
         }
         _loc8_ = getTimer();
         _loc19_.compress();
         idats = [new IDAT(_loc19_)];
      }
      
      private function addToQueue(param1:Array, param2:Block) : void
      {
         var _loc3_:uint = param2.maxSideLength;
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc3_ < param1[_loc5_].maxSideLength)
            {
               param1.splice(_loc5_,0,param2);
               return;
            }
            _loc5_++;
         }
         param1.push(param2);
      }
      
      public function toString() : String
      {
         return "8-bit Adaptive Indexed(alpha color " + colorNumber + ")";
      }
   }
}

class Block
{
   
   public static const NUM_DIM:int = 4;
   
   public var maxSideLength:uint;
   
   private var points:Array;
   
   public var minCorner:uint;
   
   public var publishColor:uint;
   
   private var alphaWeight:int;
   
   public var maxCorner:uint;
   
   private var maxSideLengthOffset:uint;
   
   public var midCorner:uint;
   
   public function Block(param1:Array, param2:int, param3:Boolean = false, param4:uint = 0, param5:uint = 0)
   {
      var _loc7_:uint = 0;
      var _loc8_:uint = 0;
      var _loc9_:uint = 0;
      var _loc10_:uint = 0;
      var _loc11_:uint = 0;
      super();
      this.points = param1;
      this.alphaWeight = param2;
      if(param1.length < 1)
      {
         throw new Error("points.length < 1");
      }
      if(param3)
      {
         minCorner = param4;
         maxCorner = param5;
      }
      else
      {
         minCorner = minDim(param1);
         maxCorner = maxDim(param1);
      }
      maxSideLengthOffset = 0;
      maxSideLength = 0;
      midCorner = 0;
      publishColor = 0;
      var _loc6_:int = 0;
      while(_loc6_ < NUM_DIM)
      {
         _loc7_ = _loc6_ * 8;
         _loc8_ = uint(255 << _loc7_);
         _loc9_ = uint((minCorner & _loc8_) >>> _loc7_);
         _loc10_ = uint((maxCorner & _loc8_) >>> _loc7_);
         midCorner |= uint((_loc9_ + _loc10_) / 2) << _loc7_;
         if(_loc6_ < 3)
         {
            publishColor |= uint((_loc9_ + _loc10_) / 2) << _loc7_;
         }
         else if(_loc9_ != 0)
         {
            if(_loc10_ == 255)
            {
               publishColor |= 4278190080;
            }
            else
            {
               publishColor |= uint((_loc9_ + _loc10_) / 2) << _loc7_;
            }
         }
         _loc11_ = uint(uint((maxCorner & _loc8_) >>> _loc7_) - uint((minCorner & _loc8_) >>> _loc7_));
         if(_loc6_ == 3)
         {
            if(_loc11_ > maxSideLength * param2)
            {
               maxSideLengthOffset = _loc7_;
               maxSideLength = _loc11_;
            }
         }
         else if(_loc11_ > maxSideLength)
         {
            maxSideLengthOffset = _loc7_;
            maxSideLength = _loc11_;
         }
         _loc6_++;
      }
   }
   
   private function maxDim(param1:Array) : uint
   {
      var _loc7_:uint = 0;
      var _loc2_:uint = uint(param1[0]);
      var _loc3_:uint = uint(_loc2_ & 0xFF000000);
      var _loc4_:uint = uint(_loc2_ & 0xFF0000);
      var _loc5_:uint = uint(_loc2_ & 0xFF00);
      var _loc6_:uint = uint(_loc2_ & 0xFF);
      var _loc8_:int = int(param1.length);
      var _loc9_:int = 1;
      while(_loc9_ < _loc8_)
      {
         _loc2_ = uint(param1[_loc9_]);
         _loc7_ = uint(_loc2_ & 0xFF000000);
         if(_loc7_ > _loc3_)
         {
            _loc3_ = _loc7_;
         }
         _loc7_ = uint(_loc2_ & 0xFF0000);
         if(_loc7_ > _loc4_)
         {
            _loc4_ = _loc7_;
         }
         _loc7_ = uint(_loc2_ & 0xFF00);
         if(_loc7_ > _loc5_)
         {
            _loc5_ = _loc7_;
         }
         _loc7_ = uint(_loc2_ & 0xFF);
         if(_loc7_ > _loc6_)
         {
            _loc6_ = _loc7_;
         }
         _loc9_++;
      }
      return _loc3_ | _loc4_ | _loc5_ | _loc6_;
   }
   
   private function minDim(param1:Array) : uint
   {
      var _loc7_:uint = 0;
      var _loc2_:uint = uint(param1[0]);
      var _loc3_:uint = uint(_loc2_ & 0xFF000000);
      var _loc4_:uint = uint(_loc2_ & 0xFF0000);
      var _loc5_:uint = uint(_loc2_ & 0xFF00);
      var _loc6_:uint = uint(_loc2_ & 0xFF);
      var _loc8_:int = int(param1.length);
      var _loc9_:int = 1;
      while(_loc9_ < _loc8_)
      {
         _loc2_ = uint(param1[_loc9_]);
         _loc7_ = uint(_loc2_ & 0xFF000000);
         if(_loc7_ < _loc3_)
         {
            _loc3_ = _loc7_;
         }
         _loc7_ = uint(_loc2_ & 0xFF0000);
         if(_loc7_ < _loc4_)
         {
            _loc4_ = _loc7_;
         }
         _loc7_ = uint(_loc2_ & 0xFF00);
         if(_loc7_ < _loc5_)
         {
            _loc5_ = _loc7_;
         }
         _loc7_ = uint(_loc2_ & 0xFF);
         if(_loc7_ < _loc6_)
         {
            _loc6_ = _loc7_;
         }
         _loc9_++;
      }
      return _loc3_ | _loc4_ | _loc5_ | _loc6_;
   }
   
   public function splite() : Array
   {
      var _loc6_:uint = 0;
      var _loc23_:uint = 0;
      if(maxSideLength <= 1)
      {
         trace("Error maxSideLength = 1 can\'t splite!!!");
      }
      var _loc1_:uint = uint(maxSideLengthOffset);
      var _loc2_:uint = uint(255 << _loc1_);
      var _loc3_:Array = new Array();
      var _loc4_:Array = new Array();
      var _loc5_:uint = uint(midCorner & _loc2_);
      var _loc7_:uint = uint.MAX_VALUE;
      var _loc8_:uint = uint.MAX_VALUE;
      var _loc9_:uint = uint.MAX_VALUE;
      var _loc10_:uint = uint.MAX_VALUE;
      var _loc11_:uint = 0;
      var _loc12_:uint = 0;
      var _loc13_:uint = 0;
      var _loc14_:uint = 0;
      var _loc15_:uint = uint.MAX_VALUE;
      var _loc16_:uint = uint.MAX_VALUE;
      var _loc17_:uint = uint.MAX_VALUE;
      var _loc18_:uint = uint.MAX_VALUE;
      var _loc19_:uint = 0;
      var _loc20_:uint = 0;
      var _loc21_:uint = 0;
      var _loc22_:uint = 0;
      var _loc24_:int = int(points.length);
      var _loc25_:int = 0;
      while(_loc25_ < _loc24_)
      {
         _loc6_ = uint(points[_loc25_]);
         if(uint(_loc6_ & _loc2_) <= _loc5_)
         {
            _loc23_ = uint(_loc6_ & 0xFF000000);
            if(_loc23_ < _loc7_)
            {
               _loc7_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF0000);
            if(_loc23_ < _loc8_)
            {
               _loc8_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF00);
            if(_loc23_ < _loc9_)
            {
               _loc9_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF);
            if(_loc23_ < _loc10_)
            {
               _loc10_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF000000);
            if(_loc23_ > _loc11_)
            {
               _loc11_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF0000);
            if(_loc23_ > _loc12_)
            {
               _loc12_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF00);
            if(_loc23_ > _loc13_)
            {
               _loc13_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF);
            if(_loc23_ > _loc14_)
            {
               _loc14_ = _loc23_;
            }
            _loc3_.push(_loc6_);
         }
         else
         {
            _loc23_ = uint(_loc6_ & 0xFF000000);
            if(_loc23_ < _loc15_)
            {
               _loc15_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF0000);
            if(_loc23_ < _loc16_)
            {
               _loc16_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF00);
            if(_loc23_ < _loc17_)
            {
               _loc17_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF);
            if(_loc23_ < _loc18_)
            {
               _loc18_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF000000);
            if(_loc23_ > _loc19_)
            {
               _loc19_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF0000);
            if(_loc23_ > _loc20_)
            {
               _loc20_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF00);
            if(_loc23_ > _loc21_)
            {
               _loc21_ = _loc23_;
            }
            _loc23_ = uint(_loc6_ & 0xFF);
            if(_loc23_ > _loc22_)
            {
               _loc22_ = _loc23_;
            }
            _loc4_.push(_loc6_);
         }
         _loc25_++;
      }
      var _loc26_:uint = uint(_loc7_ | _loc8_ | _loc9_ | _loc10_);
      var _loc27_:uint = uint(_loc15_ | _loc16_ | _loc17_ | _loc18_);
      var _loc28_:uint = uint(_loc11_ | _loc12_ | _loc13_ | _loc14_);
      var _loc29_:uint = uint(_loc19_ | _loc20_ | _loc21_ | _loc22_);
      return [new Block(_loc3_,alphaWeight,true,_loc26_,_loc28_),new Block(_loc4_,alphaWeight,true,_loc27_,_loc29_)];
   }
}

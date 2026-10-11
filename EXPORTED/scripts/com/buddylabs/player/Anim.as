package com.buddylabs.player
{
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class Anim extends BaseObj
   {
      
      private static var SQRT3:Number = Math.sqrt(3);
      
      private static var SQRT3OVER4:Number = Math.sqrt(3) / 4;
      
      private static var SQRT3MINUS2OVER4:Number = (Math.sqrt(3) - 2) / 4;
      
      private static var SQRT3MINUS1OVERSQRT2:Number = (Math.sqrt(3) - 1) / Math.sqrt(2);
      
      private static var SQRT3PLUS1OVERSQRT2:Number = (Math.sqrt(3) + 1) / Math.sqrt(2);
      
      public var poses:Array;
      
      private var decoded:Boolean = false;
      
      public var highBits:int;
      
      internal var startTime:Number = 0;
      
      public var controllers:Array = new Array();
      
      public var end:int;
      
      public var start:int;
      
      public var loop:Boolean = true;
      
      public var frames:ByteArray;
      
      public var fps:int;
      
      public var position:String;
      
      public var current:int;
      
      public function Anim()
      {
         super();
      }
      
      private static function nextPowerOfTwo(param1:int) : int
      {
         if(param1 == 1)
         {
            return 0;
         }
         if(param1 == 2)
         {
            return 1;
         }
         if(param1 <= 4)
         {
            return 2;
         }
         if(param1 <= 8)
         {
            return 3;
         }
         if(param1 <= 16)
         {
            return 4;
         }
         if(param1 <= 32)
         {
            return 5;
         }
         if(param1 <= 64)
         {
            return 6;
         }
         if(param1 <= 128)
         {
            return 7;
         }
         if(param1 <= 256)
         {
            return 8;
         }
         if(param1 <= 512)
         {
            return 9;
         }
         if(param1 <= 1024)
         {
            return 10;
         }
         if(param1 <= 2048)
         {
            return 11;
         }
         if(param1 <= 4096)
         {
            return 12;
         }
         if(param1 <= 8192)
         {
            return 13;
         }
         if(param1 <= 16384)
         {
            return 14;
         }
         if(param1 <= 32768)
         {
            return 15;
         }
         if(param1 <= 65536)
         {
            return 16;
         }
         if(param1 <= 131072)
         {
            return 17;
         }
         if(param1 <= 262144)
         {
            return 18;
         }
         if(param1 <= 524288)
         {
            return 19;
         }
         if(param1 <= 1048576)
         {
            return 20;
         }
         if(param1 <= 2097152)
         {
            return 21;
         }
         if(param1 <= 4194304)
         {
            return 22;
         }
         return -1;
      }
      
      private static function inverseDaubechiesTransform(param1:Array, param2:int) : void
      {
         var _loc5_:int = 0;
         var _loc3_:Array = new Array(param2 / 2);
         var _loc4_:Array = new Array(param2 / 2);
         _loc5_ = 0;
         while(_loc5_ < param2 / 2)
         {
            _loc4_[_loc5_] = param1[_loc5_ + param2 / 2] / SQRT3PLUS1OVERSQRT2;
            _loc3_[_loc5_] = param1[_loc5_] / SQRT3MINUS1OVERSQRT2;
            _loc5_++;
         }
         _loc3_[param2 / 2 - 1] += _loc4_[0];
         _loc5_ = 0;
         while(_loc5_ < param2 / 2 - 1)
         {
            _loc3_[_loc5_] += _loc4_[_loc5_ + 1];
            _loc5_++;
         }
         _loc5_ = 1;
         while(_loc5_ < param2 / 2)
         {
            param1[2 * _loc5_ + 1] = _loc4_[_loc5_] + SQRT3MINUS2OVER4 * _loc3_[_loc5_ - 1] + SQRT3OVER4 * _loc3_[_loc5_];
            _loc5_++;
         }
         param1[1] = _loc4_[0] + SQRT3OVER4 * _loc3_[0] + SQRT3MINUS2OVER4 * _loc3_[param2 / 2 - 1];
         _loc5_ = 0;
         while(_loc5_ < param2 / 2)
         {
            param1[2 * _loc5_] = _loc3_[_loc5_] - SQRT3 * param1[2 * _loc5_ + 1];
            _loc5_++;
         }
      }
      
      public function drawFrame(param1:Context, param2:uint) : void
      {
         current = start + param2;
         if(current > end)
         {
            current = end;
         }
         draw(param1);
      }
      
      public function get time() : int
      {
         return getTimer() - startTime;
      }
      
      public function step(param1:Context, param2:Boolean) : Boolean
      {
         var _loc3_:Number = NaN;
         if(startTime == 0)
         {
            startTime = getTimer();
         }
         if(param2)
         {
            _loc3_ = (getTimer() - startTime) / 1000;
            current = int(_loc3_ * fps + start + 0.499);
            if(current > end)
            {
               if(!loop)
               {
                  return false;
               }
               current = (current - start) % (end - start) + start;
            }
            if(frames != null && frames.length == end - start + 1)
            {
               current = frames[current - start];
            }
         }
         draw(param1);
         return true;
      }
      
      override public function draw(param1:Context) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.scene.hideProps();
         if(controllers != null)
         {
            _loc2_ = controllers.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               controllers[_loc3_].animate(this,param1);
               _loc3_++;
            }
         }
      }
      
      public function decompress() : void
      {
         init(null);
      }
      
      public function goToFraction(param1:Number) : void
      {
         current = int((end - start) * param1) + start;
      }
      
      public function reset() : void
      {
         startTime = getTimer();
         current = start;
      }
      
      override public function init(param1:Context) : void
      {
         var _loc2_:Controller = null;
         if(controllers != null)
         {
            for each(_loc2_ in controllers)
            {
               _loc2_.init(param1);
            }
         }
      }
      
      public function get length() : uint
      {
         return end - start + 1;
      }
      
      public function currentFrame() : int
      {
         if(startTime == 0)
         {
            startTime = getTimer();
         }
         var _loc1_:Number = (getTimer() - startTime) / 1000;
         current = int(_loc1_ * fps + start + 0.499);
         if(frames != null && frames.length == end - start + 1)
         {
            current = frames[current - start];
         }
         return current;
      }
      
      public function decode(param1:AnimLibrary) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc21_:Controller = null;
         var _loc22_:Array = null;
         var _loc23_:uint = 0;
         var _loc24_:Array = null;
         var _loc25_:Array = null;
         var _loc26_:* = 0;
         var _loc27_:Array = null;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Wv = null;
         var _loc33_:Array = null;
         var _loc34_:Array = null;
         var _loc35_:Array = null;
         var _loc36_:Array = null;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:Number = NaN;
         var _loc46_:Number = NaN;
         if(decoded)
         {
            return;
         }
         decoded = true;
         var _loc9_:Array = param1.targets;
         var _loc10_:Array = param1.channels;
         var _loc11_:ByteArray = param1.bounds;
         _loc11_.position = 0;
         var _loc12_:Number = _loc11_.readFloat();
         var _loc13_:Number = _loc11_.readFloat();
         var _loc14_:Number = _loc11_.readFloat();
         var _loc15_:Number = _loc11_.readFloat();
         var _loc16_:Number = _loc11_.readFloat();
         var _loc17_:Number = _loc11_.readFloat();
         var _loc18_:Anim = this;
         var _loc19_:int = _loc18_.end - _loc18_.start + 1;
         var _loc20_:int = _loc18_.highBits;
         for each(_loc21_ in _loc18_.controllers)
         {
            _loc21_.target = _loc9_[_loc21_.target];
            if(_loc21_.mat != null)
            {
               if(_loc21_.mat is ByteArray)
               {
                  _loc22_ = new Array(_loc21_.mat.bytesAvailable);
                  _loc23_ = _loc22_.length;
                  _loc2_ = 0;
                  while(_loc2_ < _loc23_)
                  {
                     _loc22_[_loc2_] = _loc21_.mat.readUnsignedByte();
                     _loc2_++;
                  }
                  _loc21_.mat = _loc22_;
                  _loc21_.matLength = _loc22_.length;
               }
            }
            if(_loc21_.pos != null)
            {
               if(_loc21_.pos is ByteArray)
               {
                  _loc24_ = new Array(_loc21_.pos.bytesAvailable / 2);
                  _loc23_ = _loc24_.length;
                  _loc2_ = 0;
                  while(_loc2_ < _loc23_)
                  {
                     _loc24_[_loc2_] = (_loc21_.pos.readShort() & 0xFFFF) / 65535 * (_loc13_ - _loc12_) + _loc12_;
                     _loc24_[_loc2_ + 1] = (_loc21_.pos.readShort() & 0xFFFF) / 65535 * (_loc15_ - _loc14_) + _loc14_;
                     _loc24_[_loc2_ + 2] = (_loc21_.pos.readShort() & 0xFFFF) / 65535 * (_loc17_ - _loc16_) + _loc16_;
                     _loc2_ += 3;
                  }
                  _loc21_.pos.position = 0;
                  _loc21_.pos.length = 0;
                  _loc21_.pos = null;
                  _loc21_.pos = _loc24_;
                  _loc21_.posLength = _loc24_.length;
               }
            }
            if(_loc21_.weight != null)
            {
               _loc21_.channel = _loc10_[_loc21_.channel];
               if(_loc21_.weight is ByteArray)
               {
                  _loc25_ = new Array(_loc19_);
                  _loc26_ = 1 << nextPowerOfTwo(_loc19_);
                  _loc27_ = new Array(_loc26_);
                  _loc21_.weight.position = 0;
                  _loc28_ = Number(_loc21_.weight.readShort() & 0xFFFF);
                  _loc29_ = Number(_loc21_.weight.readShort() & 0xFFFF);
                  _loc2_ = 0;
                  while(_loc21_.weight.bytesAvailable > 0)
                  {
                     if(_loc2_ < _loc20_)
                     {
                        _loc27_[_loc2_] = _loc21_.weight.readShort() / _loc28_;
                     }
                     else
                     {
                        _loc27_[_loc2_] = _loc21_.weight.readByte() / _loc29_;
                     }
                     _loc2_++;
                  }
                  while(_loc2_ < _loc26_)
                  {
                     _loc27_[_loc2_] = 0;
                     _loc2_++;
                  }
                  reconstructDaubechies(_loc27_,_loc26_);
                  _loc25_[0] = _loc27_[0];
                  _loc2_ = 1;
                  while(_loc2_ < _loc25_.length)
                  {
                     _loc25_[_loc2_] = _loc27_[_loc2_] + _loc25_[_loc2_ - 1];
                     _loc2_++;
                  }
                  _loc21_.weight = _loc25_;
                  _loc21_.weightLength = _loc25_.length;
               }
            }
            if(_loc21_.vis != null)
            {
               if(_loc21_.vis is ByteArray)
               {
                  _loc21_.visLength = _loc21_.vis.length;
               }
            }
            if(_loc21_.rot != null)
            {
               if(_loc21_.rot is ByteArray)
               {
                  _loc5_ = _loc21_.rot.readShort() / (65535 / 2);
                  _loc6_ = _loc21_.rot.readShort() / (65535 / 2);
                  _loc7_ = _loc21_.rot.readShort() / (65535 / 2);
                  _loc8_ = _loc21_.rot.readShort() / (65535 / 2);
                  _loc30_ = Math.sqrt(_loc8_ * _loc8_ + _loc5_ * _loc5_ + _loc6_ * _loc6_ + _loc7_ * _loc7_);
                  _loc8_ /= _loc30_;
                  _loc5_ /= _loc30_;
                  _loc6_ /= _loc30_;
                  _loc7_ /= _loc30_;
                  _loc46_ = 2 * Math.acos(_loc8_);
                  _loc31_ = Math.sqrt(1 - _loc8_ * _loc8_);
                  if(_loc31_ < 0.001)
                  {
                     _loc43_ = _loc5_;
                     _loc44_ = _loc6_;
                     _loc45_ = _loc7_;
                  }
                  else
                  {
                     _loc43_ = _loc5_ / _loc31_;
                     _loc44_ = _loc6_ / _loc31_;
                     _loc45_ = _loc7_ / _loc31_;
                  }
                  _loc21_.rot = new Array(4);
                  _loc21_.rot[0] = _loc43_;
                  _loc21_.rot[1] = _loc44_;
                  _loc21_.rot[2] = _loc45_;
                  _loc21_.rot[3] = _loc46_;
               }
               else if(_loc21_.rot is Wv)
               {
                  _loc32_ = Wv(_loc21_.rot);
                  _loc33_ = new Array(_loc19_ * 4);
                  _loc26_ = 1 << nextPowerOfTwo(_loc19_);
                  _loc34_ = new Array(_loc26_);
                  _loc35_ = new Array(_loc26_);
                  _loc36_ = new Array(_loc26_);
                  _loc27_ = new Array(_loc26_);
                  _loc37_ = Number(_loc32_.x.readShort() & 0xFFFF);
                  _loc38_ = Number(_loc32_.x.readShort() & 0xFFFF);
                  _loc39_ = Number(_loc32_.y.readShort() & 0xFFFF);
                  _loc40_ = Number(_loc32_.y.readShort() & 0xFFFF);
                  _loc41_ = Number(_loc32_.z.readShort() & 0xFFFF);
                  _loc42_ = Number(_loc32_.z.readShort() & 0xFFFF);
                  _loc28_ = Number(_loc32_.w.readShort() & 0xFFFF);
                  _loc29_ = Number(_loc32_.w.readShort() & 0xFFFF);
                  _loc2_ = 0;
                  while(_loc32_.x.bytesAvailable)
                  {
                     if(_loc2_ < _loc20_)
                     {
                        _loc34_[_loc2_] = _loc32_.x.readShort() / _loc37_;
                     }
                     else
                     {
                        _loc34_[_loc2_] = _loc32_.x.readByte() / _loc38_;
                     }
                     _loc2_++;
                  }
                  while(_loc2_ < _loc26_)
                  {
                     _loc34_[_loc2_] = 0;
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc32_.y.bytesAvailable)
                  {
                     if(_loc2_ < _loc20_)
                     {
                        _loc35_[_loc2_] = _loc32_.y.readShort() / _loc39_;
                     }
                     else
                     {
                        _loc35_[_loc2_] = _loc32_.y.readByte() / _loc40_;
                     }
                     _loc2_++;
                  }
                  while(_loc2_ < _loc26_)
                  {
                     _loc35_[_loc2_] = 0;
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc32_.z.bytesAvailable)
                  {
                     if(_loc2_ < _loc20_)
                     {
                        _loc36_[_loc2_] = _loc32_.z.readShort() / _loc41_;
                     }
                     else
                     {
                        _loc36_[_loc2_] = _loc32_.z.readByte() / _loc42_;
                     }
                     _loc2_++;
                  }
                  while(_loc2_ < _loc26_)
                  {
                     _loc36_[_loc2_] = 0;
                     _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc32_.w.bytesAvailable)
                  {
                     if(_loc2_ < _loc20_)
                     {
                        _loc27_[_loc2_] = _loc32_.w.readShort() / _loc28_;
                     }
                     else
                     {
                        _loc27_[_loc2_] = _loc32_.w.readByte() / _loc29_;
                     }
                     _loc2_++;
                  }
                  while(_loc2_ < _loc26_)
                  {
                     _loc27_[_loc2_] = 0;
                     _loc2_++;
                  }
                  _loc32_.dispose();
                  _loc32_ = null;
                  _loc21_.rot = null;
                  reconstructDaubechies(_loc34_,_loc26_);
                  reconstructDaubechies(_loc35_,_loc26_);
                  reconstructDaubechies(_loc36_,_loc26_);
                  reconstructDaubechies(_loc27_,_loc26_);
                  _loc4_ = 0;
                  _loc23_ = _loc33_.length;
                  _loc2_ = 0;
                  while(_loc2_ < _loc23_)
                  {
                     _loc33_[_loc2_] = _loc34_[_loc4_];
                     _loc33_[_loc2_ + 1] = _loc35_[_loc4_];
                     _loc33_[_loc2_ + 2] = _loc36_[_loc4_];
                     _loc33_[_loc2_ + 3] = _loc27_[_loc4_];
                     _loc4_++;
                     _loc2_ += 4;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < _loc23_)
                  {
                     _loc5_ = Number(_loc33_[_loc2_]);
                     _loc6_ = Number(_loc33_[_loc2_ + 1]);
                     _loc7_ = Number(_loc33_[_loc2_ + 2]);
                     _loc8_ = Number(_loc33_[_loc2_ + 3]);
                     _loc30_ = Math.sqrt(_loc8_ * _loc8_ + _loc5_ * _loc5_ + _loc6_ * _loc6_ + _loc7_ * _loc7_);
                     _loc8_ /= _loc30_;
                     _loc5_ /= _loc30_;
                     _loc6_ /= _loc30_;
                     _loc7_ /= _loc30_;
                     _loc46_ = 2 * Math.acos(_loc8_);
                     _loc31_ = Math.sqrt(1 - _loc8_ * _loc8_);
                     if(_loc31_ < 0.001)
                     {
                        _loc43_ = 1;
                        _loc44_ = 0;
                        _loc45_ = 0;
                     }
                     else
                     {
                        _loc43_ = _loc5_ / _loc31_;
                        _loc44_ = _loc6_ / _loc31_;
                        _loc45_ = _loc7_ / _loc31_;
                     }
                     _loc33_[_loc2_] = _loc43_;
                     _loc33_[_loc2_ + 1] = _loc44_;
                     _loc33_[_loc2_ + 2] = _loc45_;
                     _loc33_[_loc2_ + 3] = _loc46_;
                     _loc2_ += 4;
                  }
                  _loc21_.rot = _loc33_;
                  _loc21_.rotLength = _loc33_.length;
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         GCUtil.disposeArray(controllers,true);
         controllers = null;
         GCUtil.disposeArray(poses,true);
         poses = null;
         if(frames != null)
         {
            frames.length = 0;
         }
         frames = null;
         super.dispose();
      }
      
      internal function set controller(param1:BaseObj) : void
      {
         controllers.push(param1);
      }
      
      private function reconstructDaubechies(param1:Array, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1.length != param2)
         {
            _loc3_ = _loc4_ = param1.length;
            while(_loc3_ < param2)
            {
               param1.push(0);
               _loc3_++;
            }
         }
         _loc3_ = 4;
         while(_loc3_ <= param2)
         {
            inverseDaubechiesTransform(param1,_loc3_);
            _loc3_ *= 2;
         }
      }
      
      public function convertToPoseList(param1:Context, param2:Node) : void
      {
         var _loc3_:int = int(length);
         poses = new Array(_loc3_);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            drawFrame(param1,_loc4_);
            poses[_loc4_] = Pose.generateFromNode(param2);
            _loc4_++;
         }
      }
   }
}


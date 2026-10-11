package com.buddylabs.player
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class SceneUtil
   {
      
      public function SceneUtil()
      {
         super();
      }
      
      public static function encodeFloatArray(param1:Array) : ByteArray
      {
         var _loc3_:Number = NaN;
         var _loc2_:ByteArray = new ByteArray();
         for each(_loc3_ in param1)
         {
            _loc2_.writeFloat(_loc3_);
         }
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function encodeVector3(param1:Vector3) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeFloat(param1.x);
         _loc2_.writeFloat(param1.y);
         _loc2_.writeFloat(param1.z);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function encodeAxisAngle(param1:AxisAngle) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeFloat(param1.x);
         _loc2_.writeFloat(param1.y);
         _loc2_.writeFloat(param1.z);
         _loc2_.writeFloat(param1.angle);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      private static function setSliderTargetValue(param1:XML, param2:Node, param3:Number, param4:Dictionary) : void
      {
         var _loc5_:* = null;
         var _loc20_:BaseObj = null;
         var _loc21_:Node = null;
         var _loc22_:Vector3 = null;
         var _loc23_:Object = null;
         var _loc24_:AxisAngle = null;
         var _loc25_:Object = null;
         var _loc26_:Vector3 = null;
         var _loc27_:Object = null;
         var _loc28_:Number = NaN;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:Object = null;
         var _loc6_:String = param1.@target;
         if(_loc6_ == null || _loc6_.length < 1)
         {
            return;
         }
         var _loc7_:String = param1.@local;
         var _loc8_:* = false;
         if(_loc7_ != null && _loc7_.length > 0)
         {
            _loc8_ = _loc7_ == "true";
         }
         param2.deformPos = null;
         param2.deformRot = null;
         param2.deformScale = null;
         param2.parentDeformScale = null;
         var _loc9_:Array = param2.children;
         if(_loc9_ != null && _loc9_.length > 0)
         {
            for each(_loc20_ in _loc9_)
            {
               if(_loc20_ is Node)
               {
                  _loc21_ = Node(_loc20_);
                  _loc21_.parentDeformScale = null;
               }
            }
         }
         var _loc10_:Array = strToNumArray(param1.@posx);
         var _loc11_:Array = strToNumArray(param1.@posy);
         var _loc12_:Array = strToNumArray(param1.@posz);
         if(_loc10_ != null && _loc11_ != null && _loc12_ != null && _loc10_.length == 3 && _loc11_.length == 3 && _loc12_.length == 3)
         {
            _loc22_ = null;
            if(param3 == 0)
            {
               _loc22_ = new Vector3(_loc10_[1],_loc11_[1],_loc12_[1]);
            }
            else if(param3 > 0)
            {
               _loc22_ = new Vector3(_loc10_[1] + (_loc10_[2] - _loc10_[1]) * param3 / 100,_loc11_[1] + (_loc11_[2] - _loc11_[1]) * param3 / 100,_loc12_[1] + (_loc12_[2] - _loc12_[1]) * param3 / 100);
            }
            else if(param3 < 0)
            {
               _loc22_ = new Vector3(_loc10_[0] - (_loc10_[0] - _loc10_[1]) * (100 + param3) / 100,_loc11_[0] - (_loc11_[0] - _loc11_[1]) * (100 + param3) / 100,_loc12_[0] - (_loc12_[0] - _loc12_[1]) * (100 + param3) / 100);
            }
            _loc5_ = _loc6_ + "_pos";
            if(param4[_loc5_] == null)
            {
               param4[_loc5_] = {
                  "node":param2,
                  "field":"deformPos",
                  "data":_loc22_
               };
            }
            else
            {
               _loc23_ = param4[_loc5_];
               _loc23_.data.x = _loc23_.data.x + _loc22_.x;
               _loc23_.data.y += _loc22_.y;
               _loc23_.data.z += _loc22_.z;
            }
         }
         var _loc13_:Array = strToNumArray(param1.@axis);
         var _loc14_:Array = strToNumArray(param1.@angle);
         if(_loc13_ != null && _loc14_ != null && _loc13_.length == 3 && _loc14_.length == 3)
         {
            _loc24_ = null;
            if(param3 == 0)
            {
               _loc24_ = new AxisAngle(_loc13_[0],_loc13_[1],_loc13_[2],_loc14_[1]);
            }
            else if(param3 > 0)
            {
               _loc24_ = new AxisAngle(_loc13_[0],_loc13_[1],_loc13_[2],_loc14_[1] + (_loc14_[2] - _loc14_[1]) * param3 / 100);
            }
            else if(param3 < 0)
            {
               _loc24_ = new AxisAngle(_loc13_[0],_loc13_[1],_loc13_[2],_loc14_[0] - (_loc14_[0] - _loc14_[1]) * (100 + param3) / 100);
            }
            _loc5_ = _loc6_ + "_rot";
            if(param4[_loc5_] == null)
            {
               param4[_loc5_] = {
                  "node":param2,
                  "field":"deformRot",
                  "data":_loc24_
               };
            }
            else
            {
               _loc25_ = param4[_loc5_];
               _loc25_.data.x = _loc25_.data.x + _loc24_.x;
               _loc25_.data.y += _loc24_.y;
               _loc25_.data.z += _loc24_.z;
               _loc25_.data.angle += _loc24_.angle;
            }
         }
         var _loc15_:Array = strToNumArray(param1.@scalex);
         var _loc16_:Array = strToNumArray(param1.@scaley);
         var _loc17_:Array = strToNumArray(param1.@scalez);
         if(_loc15_ != null && _loc16_ != null && _loc16_ != null && _loc15_.length == 3 && _loc16_.length == 3 && _loc17_.length == 3)
         {
            _loc26_ = null;
            if(param3 == 0)
            {
               _loc26_ = new Vector3(_loc15_[1],_loc16_[1],_loc17_[1]);
            }
            else if(param3 > 0)
            {
               _loc26_ = new Vector3(_loc15_[1] + (_loc15_[2] - _loc15_[1]) * param3 / 100,_loc16_[1] + (_loc16_[2] - _loc16_[1]) * param3 / 100,_loc17_[1] + (_loc17_[2] - _loc17_[1]) * param3 / 100);
            }
            else if(param3 < 0)
            {
               _loc26_ = new Vector3(_loc15_[0] - (_loc15_[0] - _loc15_[1]) * (100 + param3) / 100,_loc16_[0] - (_loc16_[0] - _loc16_[1]) * (100 + param3) / 100,_loc17_[0] - (_loc17_[0] - _loc17_[1]) * (100 + param3) / 100);
            }
            _loc5_ = _loc6_ + "_deformScale";
            if(param4[_loc5_] == null)
            {
               param4[_loc5_] = {
                  "node":param2,
                  "field":"deformScale",
                  "data":_loc26_,
                  "local":_loc8_
               };
            }
            else
            {
               _loc27_ = param4[_loc5_];
               _loc27_.data.x = _loc27_.data.x * _loc26_.x;
               _loc27_.data.y *= _loc26_.y;
               _loc27_.data.z *= _loc26_.z;
            }
         }
         var _loc18_:String = param1.@channel;
         var _loc19_:Array = strToNumArray(param1.@value);
         if(_loc18_ != null && _loc18_.length > 0 && _loc19_.length == 3)
         {
            _loc28_ = 0;
            if(param3 == 0)
            {
               _loc28_ = Number(_loc19_[1]);
            }
            else if(param3 > 0)
            {
               _loc28_ = _loc19_[1] + (_loc19_[2] - _loc19_[1]) * param3 / 100;
            }
            else if(param3 < 0)
            {
               _loc28_ = _loc19_[0] - (_loc19_[0] - _loc19_[1]) * (100 + param3) / 100;
            }
            if(param2.mesh != null && param2.mesh.modifier != null && param2.mesh.modifier.channels != null)
            {
               _loc29_ = int(param2.mesh.modifier.channels.indexOf(_loc18_));
               _loc5_ = _loc6_ + "_weights_" + _loc29_;
               if(param4[_loc5_] == null)
               {
                  _loc30_ = 1;
                  param4[_loc5_] = {
                     "node":param2.mesh.modifier,
                     "field":"weights",
                     "index":_loc29_,
                     "data":_loc28_,
                     "count":_loc30_
                  };
               }
               else
               {
                  _loc31_ = param4[_loc5_];
                  _loc31_.data += _loc28_;
                  ++_loc31_.count;
               }
            }
         }
      }
      
      public static function findMovieClip(param1:DisplayObject, param2:String) : DisplayObject
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObject = null;
         if(param1 == null)
         {
            return null;
         }
         if(param1.name == param2)
         {
            return param1;
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc3_ = DisplayObjectContainer(param1);
            _loc4_ = _loc3_.numChildren;
            while(--_loc4_ >= 0)
            {
               _loc5_ = _loc3_.getChildAt(_loc4_);
               _loc6_ = findMovieClip(_loc5_,param2);
               if(_loc6_ != null)
               {
                  return _loc6_;
               }
            }
         }
         return null;
      }
      
      public static function readStringVector3(param1:String) : Vector3
      {
         var _loc2_:Array = param1.split(" ");
         return new Vector3(Number(_loc2_[0]),Number(_loc2_[1]),Number(_loc2_[2]));
      }
      
      public static function rndIntStr() : String
      {
         return int(Math.round(Math.random() * int.MAX_VALUE)).toString(16);
      }
      
      public static function readStringAxisAngle(param1:String) : AxisAngle
      {
         var _loc2_:Array = param1.split(" ");
         return new AxisAngle(Number(_loc2_[0]),Number(_loc2_[1]),Number(_loc2_[2]),Number(_loc2_[2]));
      }
      
      public static function randomInt(param1:int, param2:int = -1) : int
      {
         if(param2 == -1)
         {
            return Math.floor(Math.random() * (param1 + 0.9999));
         }
         var _loc3_:int = Math.floor(Math.random() * (param1 - 1 + 0.9999));
         if(_loc3_ == param2)
         {
            _loc3_ = (_loc3_ + 1) % (param1 + 1);
         }
         return _loc3_;
      }
      
      public static function readStringArrayFromString(param1:String) : Array
      {
         return param1.split(" ");
      }
      
      public static function readIntArray(param1:ByteArray) : Array
      {
         param1.position = 0;
         var _loc2_:Array = new Array(param1.length / 4);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = param1.readUnsignedInt();
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function setSliders(param1:XMLList, param2:Scene) : void
      {
         var _loc4_:Node = null;
         var _loc5_:XML = null;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:XMLList = null;
         var _loc10_:XML = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc14_:Vector3 = null;
         var _loc15_:BaseObj = null;
         var _loc16_:Node = null;
         var _loc3_:Dictionary = new Dictionary();
         for each(_loc5_ in param1)
         {
            _loc7_ = _loc5_.@value;
            _loc8_ = 0;
            if(_loc7_ != null && _loc7_.length > 0)
            {
               _loc8_ = Number(_loc7_);
            }
            _loc9_ = _loc5_.sliderTarget;
            for each(_loc10_ in _loc9_)
            {
               _loc4_ = Node(param2.getNodeByName(_loc10_.@target));
               if(_loc4_ != null)
               {
                  setSliderTargetValue(_loc10_,_loc4_,_loc8_,_loc3_);
               }
            }
         }
         for each(_loc6_ in _loc3_)
         {
            if(_loc6_ != null && _loc6_.node != null && _loc6_.field != null)
            {
               if(_loc6_.node is Modifier)
               {
                  _loc11_ = _loc6_.node[_loc6_.field];
                  _loc12_ = int(_loc6_.index);
                  _loc11_[_loc12_] = _loc6_.data / _loc6_.count;
               }
               else
               {
                  _loc6_.node[_loc6_.field] = _loc6_.data;
                  if(_loc6_.field == "deformScale")
                  {
                     if(_loc6_.local == true)
                     {
                        _loc4_ = _loc6_.node;
                        _loc13_ = _loc4_.children;
                        if(_loc13_ != null && _loc13_.length > 0)
                        {
                           _loc14_ = new Vector3(1 / _loc6_.data.x,1 / _loc6_.data.y,1 / _loc6_.data.z);
                           for each(_loc15_ in _loc13_)
                           {
                              if(_loc15_ is Node && _loc14_.x != 0)
                              {
                                 _loc16_ = Node(_loc15_);
                                 _loc16_.parentDeformScale = _loc14_;
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public static function stopAllMovieClips(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         if(param1 == null)
         {
            return;
         }
         if(param1 is MovieClip)
         {
            MovieClip(param1).stop();
         }
         var _loc2_:int = param1.numChildren;
         while(--_loc2_ >= 0)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            if(_loc3_ is DisplayObjectContainer)
            {
               stopAllMovieClips(DisplayObjectContainer(_loc3_));
            }
         }
      }
      
      public static function readFloatArray(param1:ByteArray) : Array
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Array = new Array(param1.bytesAvailable / 4);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = param1.readFloat();
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function readNumberArrayFromString(param1:String) : Array
      {
         var _loc2_:Array = param1.split(" ");
         var _loc3_:uint = _loc2_.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_[_loc4_] = Number(_loc2_[_loc4_]);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function readVector3(param1:ByteArray) : Vector3
      {
         return new Vector3(param1.readFloat(),param1.readFloat(),param1.readFloat());
      }
      
      public static function readIntArrayFromString(param1:String) : Array
      {
         var _loc2_:Array = param1.split(" ");
         var _loc3_:uint = _loc2_.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_[_loc4_] = int(_loc2_[_loc4_]);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function readAxisAngle(param1:ByteArray) : AxisAngle
      {
         return new AxisAngle(param1.readFloat(),param1.readFloat(),param1.readFloat(),param1.readFloat());
      }
      
      public static function advanceMovieClipsToFrame(param1:DisplayObjectContainer, param2:int) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:DisplayObject = null;
         if(param1 == null)
         {
            return;
         }
         if(param1 is MovieClip)
         {
            _loc4_ = MovieClip(param1);
            _loc4_.gotoAndStop(param2);
         }
         var _loc3_:int = param1.numChildren;
         while(--_loc3_ >= 0)
         {
            _loc5_ = param1.getChildAt(_loc3_);
            if(_loc5_ is DisplayObjectContainer)
            {
               advanceMovieClipsToFrame(DisplayObjectContainer(_loc5_),param2);
            }
         }
      }
      
      private static function strToNumArray(param1:String) : Array
      {
         if(param1 == null || param1.length < 1)
         {
            return null;
         }
         var _loc2_:Array = param1.split(" ");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = Number(_loc2_[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
   }
}


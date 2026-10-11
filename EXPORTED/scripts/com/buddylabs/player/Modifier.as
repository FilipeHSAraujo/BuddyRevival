package com.buddylabs.player
{
   import flash.utils.Dictionary;
   
   public class Modifier extends BaseObj
   {
      
      private var modVerts:Array;
      
      public var weights:Array;
      
      internal var skinToBoneMat:Array;
      
      private var weightsCache:Array;
      
      internal var numBones:Array;
      
      private var morphedVerts:Array;
      
      internal var boneToSkinMat:Array;
      
      public var channels:Array;
      
      private var offset:Array;
      
      private var firstCalcOffset:Boolean = true;
      
      internal var boneWeight:Array;
      
      public var ebc:ModifierEBC;
      
      public var numTargets:int;
      
      internal var boneIndex:Array;
      
      internal var boneRef:Array;
      
      internal var hasSkin:Boolean;
      
      internal var delta:Array;
      
      internal var hasMorpher:Boolean;
      
      public function Modifier()
      {
         super();
      }
      
      override public function dispose() : void
      {
         if(ebc != null)
         {
            ebc.dispose();
         }
         ebc = null;
         GCUtil.disposeArray(delta,false);
         delta = null;
         GCUtil.disposeArray(weights,false);
         weights = null;
         GCUtil.disposeArray(channels,false);
         channels = null;
         GCUtil.disposeArray(weightsCache,false);
         weightsCache = null;
         GCUtil.disposeArray(numBones,false);
         numBones = null;
         GCUtil.disposeArray(boneIndex,false);
         boneIndex = null;
         GCUtil.disposeArray(boneWeight,false);
         boneWeight = null;
         GCUtil.disposeArray(boneRef,true);
         boneRef = null;
         GCUtil.disposeArray(skinToBoneMat,false);
         skinToBoneMat = null;
         GCUtil.disposeArray(boneToSkinMat,false);
         boneToSkinMat = null;
         GCUtil.disposeArray(morphedVerts,false);
         morphedVerts = null;
         GCUtil.disposeArray(modVerts,false);
         modVerts = null;
         GCUtil.disposeArray(offset,false);
         offset = null;
      }
      
      internal function modifyVerts(param1:Context, param2:Mesh) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Vector3 = null;
         var _loc7_:Vector3 = null;
         var _loc8_:Vector3 = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:* = 0;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         var _loc24_:uint = 0;
         var _loc25_:uint = 0;
         var _loc26_:GLMatrix = null;
         var _loc27_:GLMatrix = null;
         var _loc28_:uint = 0;
         var _loc29_:uint = 0;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:uint = 0;
         var _loc35_:uint = 0;
         var _loc36_:int = 0;
         var _loc3_:Array = param2.verts;
         if(!hasSkin && !hasMorpher)
         {
            return;
         }
         var _loc9_:uint = _loc3_.length;
         if(morphedVerts == null || morphedVerts.length != _loc3_.length)
         {
            morphedVerts = new Array(_loc9_);
            modVerts = new Array(_loc9_);
            _loc4_ = 0;
            while(_loc4_ < _loc9_)
            {
               morphedVerts[_loc4_] = new Vector3();
               modVerts[_loc4_] = new Vector3();
               _loc4_++;
            }
         }
         var _loc14_:Boolean = false;
         var _loc15_:uint = _loc3_.length;
         if(hasMorpher)
         {
            _loc16_ = weights.length;
            if(weightsCache != null)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc16_)
               {
                  if(weights[_loc4_] != weightsCache[_loc4_])
                  {
                     _loc14_ = true;
                  }
                  weightsCache[_loc4_] = weights[_loc4_];
                  _loc4_++;
               }
            }
            else
            {
               _loc14_ = true;
               weightsCache = new Array(_loc16_);
               _loc4_ = 0;
               while(_loc4_ < _loc16_)
               {
                  weightsCache[_loc4_] = weights[_loc4_];
                  _loc4_++;
               }
            }
            if(!hasSkin && !_loc14_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc15_)
               {
                  _loc7_ = modVerts[_loc4_];
                  _loc8_ = morphedVerts[_loc4_];
                  _loc7_.x = _loc8_.x;
                  _loc7_.y = _loc8_.y;
                  _loc7_.z = _loc8_.z;
                  _loc4_++;
               }
               param2.mverts = modVerts;
               return;
            }
            if(_loc14_)
            {
               _loc17_ = morphedVerts.length;
               _loc4_ = 0;
               while(_loc4_ < _loc17_)
               {
                  _loc7_ = morphedVerts[_loc4_];
                  _loc8_ = _loc3_[_loc4_];
                  _loc7_.x = _loc8_.x;
                  _loc7_.y = _loc8_.y;
                  _loc7_.z = _loc8_.z;
                  _loc4_++;
               }
               _loc19_ = int(channels.length);
               _loc20_ = 0;
               _loc18_ = 0;
               while(_loc18_ < _loc19_)
               {
                  _loc13_ = Number(weights[_loc18_]);
                  if(!(_loc13_ > -0.01 && _loc13_ < 0.01))
                  {
                     if(_loc13_ > 0.99 && _loc13_ < 1.01)
                     {
                        _loc4_ = 0;
                        while(_loc4_ < _loc17_)
                        {
                           _loc6_ = morphedVerts[_loc4_++];
                           _loc6_.x += delta[_loc20_++];
                           _loc6_.y += delta[_loc20_++];
                           _loc6_.z += delta[_loc20_++];
                        }
                     }
                     else if(_loc13_ < -0.99 && _loc13_ > -1.01)
                     {
                        _loc4_ = 0;
                        while(_loc4_ < _loc17_)
                        {
                           _loc6_ = morphedVerts[_loc4_++];
                           _loc6_.x -= delta[_loc20_++];
                           _loc6_.y -= delta[_loc20_++];
                           _loc6_.z -= delta[_loc20_++];
                        }
                     }
                     else
                     {
                        _loc4_ = 0;
                        while(_loc4_ < _loc17_)
                        {
                           _loc6_ = morphedVerts[_loc4_++];
                           _loc6_.x += delta[_loc20_++] * _loc13_;
                           _loc6_.y += delta[_loc20_++] * _loc13_;
                           _loc6_.z += delta[_loc20_++] * _loc13_;
                        }
                     }
                  }
                  else
                  {
                     _loc20_ += _loc15_ * 3;
                  }
                  _loc18_++;
               }
            }
            if(!hasSkin)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc15_)
               {
                  _loc7_ = modVerts[_loc4_];
                  _loc8_ = morphedVerts[_loc4_];
                  _loc7_.x = _loc8_.x;
                  _loc7_.y = _loc8_.y;
                  _loc7_.z = _loc8_.z;
                  _loc4_++;
               }
               param2.mverts = modVerts;
               return;
            }
         }
         if(hasSkin)
         {
            _loc22_ = 0;
            _loc23_ = 0;
            _loc24_ = 0;
            _loc25_ = 0;
            _loc28_ = boneRef.length;
            _loc4_ = 0;
            while(_loc4_ < _loc28_)
            {
               if(boneRef[_loc4_] != null)
               {
                  boneRef[_loc4_].localToWorldTransform.copyTo(boneToSkinMat[_loc4_]);
               }
               _loc4_++;
            }
            if(firstCalcOffset || hasMorpher)
            {
               firstCalcOffset = false;
               if(hasMorpher)
               {
                  if(_loc14_)
                  {
                     _loc4_ = 0;
                     while(_loc4_ < _loc9_)
                     {
                        _loc6_ = morphedVerts[_loc24_++];
                        _loc10_ = _loc6_.x;
                        _loc11_ = _loc6_.y;
                        _loc12_ = _loc6_.z;
                        _loc35_ = uint(numBones[_loc4_]);
                        _loc21_ = 0;
                        while(_loc21_ < _loc35_)
                        {
                           _loc23_ = uint(boneIndex[_loc22_++]);
                           _loc26_ = skinToBoneMat[_loc23_];
                           _loc6_ = offset[_loc25_++];
                           _loc6_.x = _loc26_.m0 * _loc10_ + _loc26_.m4 * _loc11_ + _loc26_.m8 * _loc12_ + _loc26_.m12;
                           _loc6_.y = _loc26_.m1 * _loc10_ + _loc26_.m5 * _loc11_ + _loc26_.m9 * _loc12_ + _loc26_.m13;
                           _loc6_.z = _loc26_.m2 * _loc10_ + _loc26_.m6 * _loc11_ + _loc26_.m10 * _loc12_ + _loc26_.m14;
                           _loc21_++;
                        }
                        _loc4_++;
                     }
                  }
               }
               else
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc9_)
                  {
                     _loc6_ = _loc3_[_loc24_++];
                     _loc10_ = _loc6_.x;
                     _loc11_ = _loc6_.y;
                     _loc12_ = _loc6_.z;
                     _loc35_ = uint(numBones[_loc4_]);
                     _loc21_ = 0;
                     while(_loc21_ < _loc35_)
                     {
                        _loc23_ = uint(boneIndex[_loc22_++]);
                        _loc26_ = skinToBoneMat[_loc23_];
                        _loc6_ = offset[_loc25_++];
                        _loc6_.x = _loc26_.m0 * _loc10_ + _loc26_.m4 * _loc11_ + _loc26_.m8 * _loc12_ + _loc26_.m12;
                        _loc6_.y = _loc26_.m1 * _loc10_ + _loc26_.m5 * _loc11_ + _loc26_.m9 * _loc12_ + _loc26_.m13;
                        _loc6_.z = _loc26_.m2 * _loc10_ + _loc26_.m6 * _loc11_ + _loc26_.m10 * _loc12_ + _loc26_.m14;
                        _loc21_++;
                     }
                     _loc4_++;
                  }
               }
            }
            _loc24_ = 0;
            _loc25_ = 0;
            _loc29_ = 0;
            _loc22_ = 0;
            _loc34_ = numBones.length;
            _loc4_ = 0;
            while(_loc4_ < _loc34_)
            {
               _loc36_ = int(numBones[_loc4_]);
               if(_loc36_ == 1)
               {
                  _loc26_ = boneToSkinMat[boneIndex[_loc22_++]];
                  _loc29_++;
                  _loc6_ = offset[_loc25_++];
                  _loc10_ = _loc6_.x;
                  _loc11_ = _loc6_.y;
                  _loc12_ = _loc6_.z;
                  _loc6_ = modVerts[_loc24_++];
                  _loc6_.x = _loc26_.m0 * _loc10_ + _loc26_.m4 * _loc11_ + _loc26_.m8 * _loc12_ + _loc26_.m12;
                  _loc6_.y = _loc26_.m1 * _loc10_ + _loc26_.m5 * _loc11_ + _loc26_.m9 * _loc12_ + _loc26_.m13;
                  _loc6_.z = _loc26_.m2 * _loc10_ + _loc26_.m6 * _loc11_ + _loc26_.m10 * _loc12_ + _loc26_.m14;
               }
               else if(_loc36_ == 2)
               {
                  _loc26_ = boneToSkinMat[boneIndex[_loc22_++]];
                  _loc13_ = Number(boneWeight[_loc29_++]);
                  _loc7_ = offset[_loc25_++];
                  _loc10_ = _loc7_.x;
                  _loc11_ = _loc7_.y;
                  _loc12_ = _loc7_.z;
                  _loc27_ = boneToSkinMat[boneIndex[_loc22_++]];
                  _loc33_ = Number(boneWeight[_loc29_++]);
                  _loc8_ = offset[_loc25_++];
                  _loc30_ = _loc8_.x;
                  _loc31_ = _loc8_.y;
                  _loc32_ = _loc8_.z;
                  _loc6_ = modVerts[_loc24_++];
                  _loc6_.x = (_loc26_.m0 * _loc10_ + _loc26_.m4 * _loc11_ + _loc26_.m8 * _loc12_ + _loc26_.m12) * _loc13_ + (_loc27_.m0 * _loc30_ + _loc27_.m4 * _loc31_ + _loc27_.m8 * _loc32_ + _loc27_.m12) * _loc33_;
                  _loc6_.y = (_loc26_.m1 * _loc10_ + _loc26_.m5 * _loc11_ + _loc26_.m9 * _loc12_ + _loc26_.m13) * _loc13_ + (_loc27_.m1 * _loc30_ + _loc27_.m5 * _loc31_ + _loc27_.m9 * _loc32_ + _loc27_.m13) * _loc33_;
                  _loc6_.z = (_loc26_.m2 * _loc10_ + _loc26_.m6 * _loc11_ + _loc26_.m10 * _loc12_ + _loc26_.m14) * _loc13_ + (_loc27_.m2 * _loc30_ + _loc27_.m6 * _loc31_ + _loc27_.m10 * _loc32_ + _loc27_.m14) * _loc33_;
               }
               else if(_loc36_ > 2)
               {
                  _loc26_ = boneToSkinMat[boneIndex[_loc22_]];
                  _loc13_ = Number(boneWeight[_loc29_++]);
                  _loc6_ = offset[_loc25_++];
                  _loc10_ = _loc6_.x;
                  _loc11_ = _loc6_.y;
                  _loc12_ = _loc6_.z;
                  _loc8_ = modVerts[_loc24_];
                  _loc8_.x = (_loc26_.m0 * _loc10_ + _loc26_.m4 * _loc11_ + _loc26_.m8 * _loc12_ + _loc26_.m12) * _loc13_;
                  _loc8_.y = (_loc26_.m1 * _loc10_ + _loc26_.m5 * _loc11_ + _loc26_.m9 * _loc12_ + _loc26_.m13) * _loc13_;
                  _loc8_.z = (_loc26_.m2 * _loc10_ + _loc26_.m6 * _loc11_ + _loc26_.m10 * _loc12_ + _loc26_.m14) * _loc13_;
                  _loc22_++;
                  _loc21_ = 1;
                  while(_loc21_ < _loc36_)
                  {
                     _loc26_ = boneToSkinMat[boneIndex[_loc22_++]];
                     _loc13_ = Number(boneWeight[_loc29_++]);
                     _loc6_ = offset[_loc25_++];
                     _loc10_ = _loc6_.x;
                     _loc11_ = _loc6_.y;
                     _loc12_ = _loc6_.z;
                     _loc8_.x += (_loc26_.m0 * _loc10_ + _loc26_.m4 * _loc11_ + _loc26_.m8 * _loc12_ + _loc26_.m12) * _loc13_;
                     _loc8_.y += (_loc26_.m1 * _loc10_ + _loc26_.m5 * _loc11_ + _loc26_.m9 * _loc12_ + _loc26_.m13) * _loc13_;
                     _loc8_.z += (_loc26_.m2 * _loc10_ + _loc26_.m6 * _loc11_ + _loc26_.m10 * _loc12_ + _loc26_.m14) * _loc13_;
                     _loc21_++;
                  }
                  _loc24_++;
               }
               _loc4_++;
            }
         }
         param2.mverts = modVerts;
      }
      
      internal function initMod(param1:Context, param2:uint, param3:Array) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:uint = 0;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         if(numTargets > 0 && delta != null && channels != null)
         {
            hasMorpher = true;
            _loc6_ = channels.length;
            weights = new Array(_loc6_);
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               weights[_loc4_] = 0;
               _loc4_++;
            }
         }
         if(param3 != null && hasMorpher)
         {
            _loc7_ = new Array(param2 * 3 * numTargets);
            _loc8_ = param3.length;
            _loc10_ = 0;
            _loc11_ = 0;
            _loc4_ = 0;
            while(_loc4_ < numTargets)
            {
               _loc9_ = 0;
               _loc5_ = 0;
               while(_loc5_ < _loc8_)
               {
                  if(param3[_loc9_++])
                  {
                     var _loc20_:*;
                     _loc7_[_loc20_ = _loc11_++] = delta[_loc10_++];
                     var _loc21_:*;
                     _loc7_[_loc21_ = _loc11_++] = delta[_loc10_++];
                     var _loc22_:*;
                     _loc7_[_loc22_ = _loc11_++] = delta[_loc10_++];
                  }
                  else
                  {
                     _loc10_ += 3;
                  }
                  _loc5_++;
               }
               _loc4_++;
            }
            delta = _loc7_;
         }
         if(numBones != null && boneIndex != null && boneWeight != null)
         {
            hasSkin = true;
            if(param3 != null)
            {
               _loc15_ = new Array();
               _loc16_ = new Array();
               _loc17_ = new Array();
               _loc18_ = 0;
               _loc19_ = 0;
               _loc4_ = 0;
               while(_loc4_ < numBones.length)
               {
                  _loc12_ = int(numBones[_loc4_]);
                  if(param3[_loc4_])
                  {
                     _loc15_.push(_loc12_);
                     _loc5_ = 0;
                     while(_loc5_ < _loc12_)
                     {
                        _loc16_.push(boneIndex[_loc18_++]);
                        _loc5_++;
                     }
                     _loc5_ = 0;
                     while(_loc5_ < _loc12_)
                     {
                        _loc17_.push(boneWeight[_loc19_++]);
                        _loc5_++;
                     }
                  }
                  else
                  {
                     _loc18_ += _loc12_;
                     _loc19_ += _loc12_;
                  }
                  _loc4_++;
               }
               numBones = _loc15_;
               boneIndex = _loc16_;
               boneWeight = _loc17_;
            }
            _loc13_ = 0;
            _loc4_ = 0;
            while(_loc4_ < boneIndex.length)
            {
               if(boneIndex[_loc4_] > _loc13_)
               {
                  _loc13_ = int(boneIndex[_loc4_]);
               }
               _loc4_++;
            }
            boneRef = new Array(_loc13_);
            skinToBoneMat = new Array(_loc13_);
            boneToSkinMat = new Array(_loc13_);
            _loc4_ = 0;
            while(_loc4_ < boneIndex.length)
            {
               if(boneRef[boneIndex[_loc4_]] == null)
               {
                  boneRef[boneIndex[_loc4_]] = Node(param1.scene.getBoneByIndex(boneIndex[_loc4_]));
                  skinToBoneMat[boneIndex[_loc4_]] = new GLMatrix();
                  boneToSkinMat[boneIndex[_loc4_]] = new GLMatrix();
               }
               _loc4_++;
            }
            offset = new Array(boneIndex.length);
            _loc14_ = offset.length;
            _loc4_ = 0;
            while(_loc4_ < _loc14_)
            {
               offset[_loc4_] = new Vector3();
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < boneRef.length)
            {
               if(boneRef[_loc4_] != null)
               {
                  boneRef[_loc4_].invInitialTransform.copyTo(skinToBoneMat[_loc4_]);
               }
               _loc4_++;
            }
         }
      }
      
      internal function setAndCollapseTargets(param1:Array, param2:Array, param3:Array) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc19_:uint = 0;
         var _loc20_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Dictionary = new Dictionary();
         var _loc9_:uint = channels.length;
         _loc4_ = 0;
         while(_loc4_ < _loc9_)
         {
            _loc6_ = channels[_loc4_];
            _loc8_[_loc6_] = _loc4_;
            if(_loc6_.indexOf("HdProp_") != 0)
            {
               _loc7_++;
            }
            _loc4_++;
         }
         var _loc10_:uint = param2.length;
         var _loc11_:uint = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc10_)
         {
            _loc19_ = _loc8_[param2[_loc4_]] * param1.length;
            _loc20_ = Number(param3[_loc4_]);
            _loc5_ = 0;
            while(_loc5_ < _loc11_)
            {
               var _loc21_:*;
               param1[_loc21_ = _loc5_++] = param1[_loc21_] + delta[_loc19_++] * _loc20_;
               var _loc22_:*;
               param1[_loc22_ = _loc5_++] = param1[_loc22_] + delta[_loc19_++] * _loc20_;
               var _loc23_:*;
               param1[_loc23_ = _loc5_++] = param1[_loc23_] + delta[_loc19_++] * _loc20_;
            }
            _loc4_++;
         }
         var _loc12_:Array = new Array(_loc7_);
         var _loc13_:Array = new Array(_loc7_);
         var _loc14_:uint = delta.length / numTargets;
         var _loc15_:Array = new Array(_loc14_ * _loc7_);
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         _loc4_ = 0;
         while(_loc4_ < numTargets)
         {
            _loc6_ = channels[_loc4_];
            if(_loc6_.indexOf("HdProp_") != 0)
            {
               _loc12_[_loc16_] = _loc6_;
               _loc13_[_loc16_] = weights[_loc4_];
               _loc5_ = 0;
               while(_loc5_ < _loc14_)
               {
                  _loc15_[_loc21_ = _loc18_++] = delta[_loc17_++];
                  _loc5_++;
               }
               _loc16_++;
            }
            else
            {
               _loc17_ += _loc14_;
            }
            _loc4_++;
         }
         channels = _loc12_;
         weights = _loc13_;
         delta = _loc15_;
         numTargets = _loc7_;
         _loc8_ = null;
      }
   }
}


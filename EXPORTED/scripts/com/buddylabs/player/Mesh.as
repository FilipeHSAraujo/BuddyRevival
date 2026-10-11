package com.buddylabs.player
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class Mesh extends BaseObj
   {
      
      internal var cullAllIndex:int;
      
      private var updateTextureBmd:Boolean = false;
      
      private var M:GLMatrix = new GLMatrix();
      
      private var screenVerts:Array = null;
      
      public var numFaces:int;
      
      public var dummyVerts:Array = null;
      
      internal var mverts:Array = null;
      
      public var modifier:Modifier;
      
      internal var verts:Array = null;
      
      public var ebc:MeshEBC;
      
      public var localZDepthOffset:Number;
      
      public var screenZDepthOffset:Number;
      
      private var triangles:Array;
      
      internal var mapVerts:Array = null;
      
      internal var inited:Boolean = false;
      
      private var firstPass:Boolean = true;
      
      internal var cull:Array = null;
      
      internal var faces:Array = null;
      
      public var numVerts:int;
      
      public var material:BaseMaterial;
      
      public function Mesh()
      {
         super();
      }
      
      private function initArrayToVector() : void
      {
         var _loc1_:Triangle = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc4_:BitmapData = Material(material).bitmapData;
         var _loc5_:Number = _loc4_.width - 1;
         var _loc6_:Number = _loc4_.height - 1;
         screenVerts = new Array(numVerts);
         _loc2_ = 0;
         while(_loc2_ < numVerts)
         {
            screenVerts[_loc2_] = new Vector3();
            _loc2_++;
         }
         _loc3_ = 0;
         var _loc7_:Array = new Array(numVerts);
         _loc2_ = 0;
         while(_loc2_ < numVerts)
         {
            _loc7_[_loc2_] = new Vector3(verts[_loc3_++],verts[_loc3_++],verts[_loc3_++]);
            _loc2_++;
         }
         this.verts = _loc7_;
         triangles = new Array(numFaces);
         var _loc8_:uint = 0;
         _loc2_ = 0;
         _loc8_ = 0;
         while(_loc8_ < faces.length)
         {
            _loc9_ = uint(faces[_loc8_++]);
            _loc10_ = uint(faces[_loc8_++]);
            _loc11_ = uint(faces[_loc8_++]);
            _loc12_ = _loc9_ / 3;
            _loc13_ = _loc10_ / 3;
            _loc14_ = _loc11_ / 3;
            _loc1_ = new Triangle();
            _loc1_.local_v0 = _loc7_[_loc12_];
            _loc1_.screen_v0 = screenVerts[_loc12_];
            _loc1_.local_v1 = _loc7_[_loc14_];
            _loc1_.screen_v1 = screenVerts[_loc14_];
            _loc1_.local_v2 = _loc7_[_loc13_];
            _loc1_.screen_v2 = screenVerts[_loc13_];
            _loc15_ = mapVerts[_loc9_] * _loc5_;
            _loc16_ = _loc6_ - mapVerts[_loc9_ + 1] * _loc6_;
            _loc17_ = mapVerts[_loc10_] * _loc5_;
            _loc18_ = _loc6_ - mapVerts[_loc10_ + 1] * _loc6_;
            _loc19_ = mapVerts[_loc11_] * _loc5_;
            _loc20_ = _loc6_ - mapVerts[_loc11_ + 1] * _loc6_;
            _loc1_.UVMat = new Matrix(_loc19_ - _loc15_,_loc20_ - _loc16_,_loc17_ - _loc15_,_loc18_ - _loc16_,_loc15_,_loc16_);
            _loc1_.UVMat.invert();
            _loc1_.bmd = _loc4_;
            triangles[_loc2_] = _loc1_;
            _loc2_++;
         }
      }
      
      override public function draw(param1:Context) : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Triangle = null;
         if(!inited)
         {
            init(param1);
         }
         if(faces == null || verts == null)
         {
            return;
         }
         if(param1.scene.cull != null && cull == null && cullAllIndex >= 0 && Boolean(param1.scene.cull[cullAllIndex]))
         {
            return;
         }
         if(updateTextureBmd && triangles != null)
         {
            updateTextureBmd = false;
            _loc2_ = Material(material).bitmapData;
            for each(_loc3_ in triangles)
            {
               _loc3_.bmd = _loc2_;
            }
         }
         renderNormal(param1);
      }
      
      override public function dispose() : void
      {
         if(material != null)
         {
            material.dispose();
         }
         material = null;
         if(modifier != null)
         {
            modifier.dispose();
         }
         modifier = null;
         GCUtil.disposeArray(dummyVerts,false);
         dummyVerts = null;
         GCUtil.disposeArray(faces,false);
         faces = null;
         GCUtil.disposeArray(verts,false);
         verts = null;
         GCUtil.disposeArray(mapVerts,false);
         mapVerts = null;
         GCUtil.disposeArray(cull,false);
         cull = null;
         GCUtil.disposeArray(screenVerts,false);
         screenVerts = null;
         GCUtil.disposeArray(mverts,false);
         mverts = null;
         M = null;
         GCUtil.disposeArray(triangles,true);
         triangles = null;
      }
      
      private function renderNormal(param1:Context) : void
      {
         var _loc3_:Triangle = null;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc30_:Boolean = false;
         var _loc31_:Vector3 = null;
         var _loc32_:Vector3 = null;
         var _loc33_:Vector3 = null;
         var _loc34_:Vector3 = null;
         var _loc35_:Vector3 = null;
         var _loc2_:BitmapData = material == null ? null : Material(material).bitmapData;
         if(_loc2_ == null)
         {
            return;
         }
         if(firstPass)
         {
            firstPass = false;
            initArrayToVector();
         }
         var _loc4_:Array = param1.scene.cull;
         var _loc5_:Boolean = _loc4_ == null || cull == null;
         var _loc6_:Boolean = _loc4_ != null && cull != null;
         if(_loc6_)
         {
            _loc30_ = false;
            _loc7_ = 0;
            while(_loc7_ < numFaces)
            {
               _loc3_ = triangles[_loc7_];
               if(!_loc4_[cull[_loc7_]])
               {
                  _loc30_ = true;
                  break;
               }
               _loc7_++;
            }
            if(!_loc30_)
            {
               return;
            }
         }
         param1.hproj.copyTo(M);
         M.glMultMatrix(param1.hview);
         if(modifier == null || modifier != null && modifier.hasSkin == false)
         {
            M.glMultMatrix(param1.hworld);
         }
         mverts = verts;
         if(modifier != null)
         {
            modifier.modifyVerts(param1,this);
         }
         var _loc12_:Number = param1.width * 0.5;
         var _loc13_:Number = param1.height * 0.5;
         var _loc14_:Number = -_loc13_;
         var _loc15_:Number = M.m0 * _loc12_;
         var _loc16_:Number = M.m1 * _loc14_;
         var _loc17_:Number = M.m2;
         var _loc18_:Number = M.m4 * _loc12_;
         var _loc19_:Number = M.m5 * _loc14_;
         var _loc20_:Number = M.m6;
         var _loc21_:Number = M.m8 * _loc12_;
         var _loc22_:Number = M.m9 * _loc14_;
         var _loc23_:Number = M.m10;
         var _loc24_:Number = M.m12 * _loc12_;
         var _loc25_:Number = M.m13 * _loc14_;
         var _loc26_:Number = M.m14;
         _loc7_ = 0;
         while(_loc7_ < numVerts)
         {
            _loc31_ = mverts[_loc7_];
            _loc32_ = screenVerts[_loc7_];
            _loc8_ = _loc31_.x;
            _loc9_ = _loc31_.y;
            _loc10_ = _loc31_.z;
            _loc32_.z = _loc17_ * _loc8_ + _loc20_ * _loc9_ + _loc23_ * _loc10_ + _loc26_;
            _loc32_.x = (_loc15_ * _loc8_ + _loc18_ * _loc9_ + _loc21_ * _loc10_ + _loc24_) / _loc32_.z + _loc12_;
            _loc32_.y = (_loc16_ * _loc8_ + _loc19_ * _loc9_ + _loc22_ * _loc10_ + _loc25_) / _loc32_.z + _loc13_;
            _loc7_++;
         }
         var _loc27_:uint = param1.visibleTriCount;
         var _loc28_:Array = param1.visibleTriList;
         if(_loc27_ + numFaces >= _loc28_.length)
         {
            _loc28_.length += numFaces;
         }
         var _loc29_:Number = 0;
         if(!isNaN(localZDepthOffset) && localZDepthOffset != 0)
         {
            param1.hview.copyTo(M);
            M.glMultMatrix(param1.hworld);
            _loc29_ = M.m10 * localZDepthOffset;
         }
         else
         {
            _loc29_ = 0;
         }
         if(!isNaN(screenZDepthOffset))
         {
            _loc29_ += screenZDepthOffset;
         }
         _loc7_ = 0;
         while(_loc7_ < numFaces)
         {
            _loc3_ = triangles[_loc7_];
            if(_loc5_ || !(_loc6_ && _loc4_[cull[_loc7_]]))
            {
               _loc33_ = _loc3_.screen_v0;
               _loc34_ = _loc3_.screen_v1;
               _loc35_ = _loc3_.screen_v2;
               if((_loc34_.x - _loc33_.x) * (_loc35_.y - _loc33_.y) - (_loc35_.x - _loc33_.x) * (_loc34_.y - _loc33_.y) > -1)
               {
                  _loc3_.farz = Math.max(_loc33_.z + _loc29_,_loc34_.z + _loc29_,_loc35_.z + _loc29_);
                  var _loc36_:*;
                  _loc28_[_loc36_ = _loc27_++] = _loc3_;
               }
            }
            _loc7_++;
         }
         param1.visibleTriCount = _loc27_;
      }
      
      public function updateTextures() : void
      {
         updateTextureBmd = true;
      }
      
      override public function init(param1:Context) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         var _loc10_:* = false;
         var _loc11_:Boolean = false;
         var _loc12_:Array = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:Array = null;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         if(ebc == null)
         {
            return;
         }
         var _loc2_:EBDecompression = new EBDecompression();
         _loc2_.decompressMesh(this);
         _loc2_.dispose();
         _loc2_ = null;
         if(ebc != null)
         {
            ebc.dispose();
         }
         ebc = null;
         if(faces == null || verts == null || mapVerts == null)
         {
            return;
         }
         var _loc5_:uint = faces.length;
         var _loc6_:Array = null;
         if(param1.scene.config != null && param1.scene.config.cull != null)
         {
            _loc8_ = 0;
            _loc6_ = new Array(numVerts);
            _loc3_ = 0;
            while(_loc3_ < numVerts)
            {
               _loc6_[_loc3_] = false;
               _loc3_++;
            }
            _loc9_ = param1.scene.cull;
            _loc10_ = _loc9_ == null;
            _loc11_ = _loc9_ != null && cull != null;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               if(_loc10_ || !(_loc11_ && _loc9_[cull[_loc8_]]))
               {
                  _loc6_[faces[_loc3_++]] = true;
                  _loc6_[faces[_loc3_++]] = true;
                  _loc6_[faces[_loc3_++]] = true;
               }
               else
               {
                  var _loc21_:*;
                  faces[_loc21_ = _loc3_++] = -1;
                  var _loc22_:*;
                  faces[_loc22_ = _loc3_++] = -1;
                  var _loc23_:*;
                  faces[_loc23_ = _loc3_++] = -1;
               }
               _loc8_++;
            }
            if(dummyVerts != null)
            {
               _loc14_ = dummyVerts.length;
               _loc4_ = 0;
               while(_loc4_ < _loc14_)
               {
                  _loc6_[dummyVerts[_loc4_]] = false;
                  _loc4_++;
               }
               _loc3_ = 0;
               while(_loc3_ < _loc5_)
               {
                  if(_loc6_[faces[_loc3_]] == false)
                  {
                     faces[_loc3_] = -1;
                  }
                  _loc3_++;
               }
               dummyVerts = null;
            }
            _loc8_ = 0;
            _loc12_ = new Array(numVerts);
            _loc3_ = 0;
            while(_loc3_ < numVerts)
            {
               _loc12_[_loc3_] = _loc6_[_loc3_] ? _loc8_++ : -1;
               _loc3_++;
            }
            _loc13_ = _loc8_;
            if(_loc13_ == numVerts)
            {
               _loc6_ = null;
            }
            else
            {
               _loc15_ = new Array(_loc13_);
               _loc16_ = new Array(_loc13_);
               _loc8_ = 0;
               _loc4_ = 0;
               _loc3_ = 0;
               while(_loc3_ < numVerts)
               {
                  if(_loc6_[_loc3_])
                  {
                     _loc15_[_loc8_] = verts[_loc4_];
                     _loc15_[_loc8_ + 1] = verts[_loc4_ + 1];
                     _loc15_[_loc8_ + 2] = verts[_loc4_ + 2];
                     _loc16_[_loc21_ = _loc8_++] = mapVerts[_loc4_++];
                     _loc16_[_loc22_ = _loc8_++] = mapVerts[_loc4_++];
                     _loc16_[_loc23_ = _loc8_++] = mapVerts[_loc4_++];
                  }
                  else
                  {
                     _loc4_ += 3;
                  }
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < _loc5_)
               {
                  if(faces[_loc3_] != -1)
                  {
                     faces[_loc3_] = _loc12_[faces[_loc3_]] * 3;
                  }
                  _loc3_++;
               }
               trace("deleted Verts " + (numVerts - _loc13_));
               numVerts = _loc13_;
               verts = _loc15_;
               mapVerts = _loc16_;
               cull = null;
            }
         }
         if(dummyVerts != null && dummyVerts.length > 0 && faces != null)
         {
            _loc14_ = dummyVerts.length;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc14_)
               {
                  if(faces[_loc3_] == dummyVerts[_loc4_])
                  {
                     faces[_loc3_] = -1;
                  }
                  _loc4_++;
               }
               if(faces[_loc3_] != -1)
               {
                  faces[_loc3_] *= 3;
               }
               _loc3_++;
            }
         }
         var _loc7_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            if(faces[_loc3_] != -1 && faces[_loc3_ + 1] != -1 && faces[_loc3_ + 2] != -1)
            {
               _loc7_++;
            }
            _loc3_ += 3;
         }
         if(_loc7_ != numFaces)
         {
            _loc17_ = new Array(_loc7_ * 3);
            _loc18_ = null;
            if(this.cull != null && cull.length == numFaces)
            {
               _loc18_ = new Array(_loc7_);
            }
            _loc4_ = 0;
            _loc19_ = 0;
            _loc20_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               if(faces[_loc3_] != -1 && faces[_loc3_ + 1] != -1 && faces[_loc3_ + 2] != -1)
               {
                  _loc17_[_loc21_ = _loc4_++] = faces[_loc3_];
                  _loc17_[_loc22_ = _loc4_++] = faces[_loc3_ + 1];
                  _loc17_[_loc23_ = _loc4_++] = faces[_loc3_ + 2];
                  if(_loc18_ != null)
                  {
                     var _loc24_:*;
                     _loc18_[_loc24_ = _loc20_++] = cull[_loc19_++];
                  }
               }
               else
               {
                  _loc19_++;
               }
               _loc3_ += 3;
            }
            faces = _loc17_;
            numFaces = _loc7_;
            cull = _loc18_;
         }
         if(modifier != null)
         {
            modifier.initMod(param1,numVerts,_loc6_);
         }
         _loc3_ = 0;
         while(_loc3_ < faces.length)
         {
            if(faces[_loc3_] >= verts.length || isNaN(faces[_loc3_]))
            {
               faces[_loc3_] = -1;
            }
            _loc3_++;
         }
         inited = true;
      }
   }
}


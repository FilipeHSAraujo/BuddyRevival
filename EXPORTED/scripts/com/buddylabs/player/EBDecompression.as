package com.buddylabs.player
{
   public class EBDecompression
   {
      
      private var A:int = 0;
      
      private var C:Array;
      
      private var G:Array;
      
      private var H:Array;
      
      private var M:Array;
      
      private var N:int;
      
      private var O:Array;
      
      private var triCullRegion:Array;
      
      private var T:int;
      
      private var U:Array;
      
      private var V:Array;
      
      private var cullmin:int;
      
      private var G_in:Array;
      
      private var quantcull:BitStream;
      
      private var quantcullbits:int;
      
      private var hasCulling:Boolean;
      
      public function EBDecompression()
      {
         super();
      }
      
      private function decompressConnectivity(param1:int) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         loop0:
         while(true)
         {
            if(this.hasCulling)
            {
               triCullRegion[T] = quantcull.readBits(quantcullbits) + cullmin;
            }
            ++T;
            _loc2_ = 3;
            _loc3_ = _loc2_ * T;
            O[param1] = _loc3_;
            O[_loc3_] = param1;
            V[_loc3_ + 1] = V[prevEdge(param1)];
            V[_loc3_ + 2] = V[nextEdge(param1)];
            param1 = nextEdge(O[param1]);
            switch(C[T - 1])
            {
               case "C":
                  O[nextEdge(param1)] = -1;
                  V[_loc3_] = ++N;
                  break;
               case "L":
                  O[nextEdge(param1)] = -2;
                  if(!checkHandle(nextEdge(param1)))
                  {
                     zip(nextEdge(param1));
                  }
                  break;
               case "R":
                  O[param1] = -2;
                  checkHandle(param1);
                  param1 = nextEdge(param1);
                  break;
               case "S":
                  decompressConnectivity(param1);
                  param1 = nextEdge(param1);
                  if(O[param1] >= 0)
                  {
                     break loop0;
                  }
                  break;
               case "E":
                  O[param1] = -2;
                  O[nextEdge(param1)] = -2;
                  checkHandle(param1);
                  _loc4_ = checkHandle(nextEdge(param1));
                  if(_loc4_ == false)
                  {
                     zip(nextEdge(param1));
                  }
                  return;
            }
         }
      }
      
      private function readCler(param1:BitStream) : String
      {
         var _loc2_:int = param1.readBit();
         if(_loc2_ == 0)
         {
            return "C";
         }
         _loc2_ = param1.readBits(2);
         switch(_loc2_)
         {
            case 2:
               return "L";
            case 3:
               return "E";
            case 1:
               return "R";
            case 0:
               return "S";
            default:
               return "C";
         }
      }
      
      private function nextEdge(param1:int) : int
      {
         var _loc2_:int = 3;
         var _loc3_:int = param1 / _loc2_;
         var _loc4_:int = param1 + int(1);
         return int(_loc2_ * _loc3_) + int(_loc4_ % _loc2_);
      }
      
      public function dispose() : void
      {
         GCUtil.disposeArray(O,false);
         O = null;
         V = null;
         triCullRegion = null;
         quantcull = null;
         GCUtil.disposeArray(M,false);
         M = null;
         GCUtil.disposeArray(U,false);
         U = null;
         GCUtil.disposeArray(H,false);
         H = null;
         GCUtil.disposeArray(C,false);
         C = null;
         GCUtil.disposeArray(G_in,true);
         G_in = null;
         GCUtil.disposeArray(G,true);
         G = null;
      }
      
      private function zip(param1:int) : void
      {
         var _loc2_:int = nextEdge(param1);
         while(O[_loc2_] >= 0 && O[_loc2_] != param1)
         {
            _loc2_ = nextEdge(O[_loc2_]);
         }
         if(O[_loc2_] != -1)
         {
            return;
         }
         O[param1] = _loc2_;
         O[_loc2_] = param1;
         var _loc3_:int = nextEdge(param1);
         var _loc4_:int = int(V[nextEdge(_loc2_)]);
         V[nextEdge(_loc3_)] = _loc4_;
         while(O[_loc3_] >= 0 && _loc3_ != _loc2_)
         {
            _loc3_ = nextEdge(O[_loc3_]);
            V[nextEdge(_loc3_)] = _loc4_;
         }
         param1 = prevEdge(param1);
         while(O[param1] >= 0 && param1 != _loc2_)
         {
            param1 = prevEdge(O[param1]);
         }
         if(O[param1] == -2)
         {
            zip(param1);
         }
      }
      
      private function checkHandle(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         if(A >= H.length || param1 != H[A + 1])
         {
            return false;
         }
         O[param1] = H[A];
         O[H[A]] = param1;
         _loc2_ = prevEdge(param1);
         while(O[_loc2_] >= 0 && _loc2_ != H[A])
         {
            _loc2_ = prevEdge(O[_loc2_]);
         }
         if(O[_loc2_] == -2)
         {
            zip(_loc2_);
         }
         _loc2_ = prevEdge(O[param1]);
         while(O[_loc2_] >= 0 && _loc2_ != param1)
         {
            _loc2_ = prevEdge(O[_loc2_]);
         }
         if(O[_loc2_] == -2)
         {
            zip(_loc2_);
         }
         A += 2;
         return true;
      }
      
      private function e2T(param1:int) : int
      {
         var _loc2_:int = 3;
         return int(param1 / _loc2_);
      }
      
      private function leftTri(param1:int, param2:Array) : int
      {
         return param2[nextEdge(nextEdge(param1))];
      }
      
      private function rightTri(param1:int, param2:Array) : int
      {
         return param2[nextEdge(param1)];
      }
      
      public function decompressMesh(param1:Mesh) : void
      {
         var _loc4_:ModifierEBC = null;
         var _loc6_:* = 0;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc36_:BitStream = null;
         var _loc54_:int = 0;
         var _loc55_:* = 0;
         var _loc56_:int = 0;
         var _loc57_:int = 0;
         var _loc58_:int = 0;
         var _loc59_:int = 0;
         var _loc60_:Array = null;
         var _loc61_:int = 0;
         var _loc62_:* = 0;
         var _loc63_:* = 0;
         var _loc64_:Array = null;
         var _loc65_:Array = null;
         var _loc66_:Array = null;
         if(param1.ebc == null)
         {
            return;
         }
         var _loc2_:MeshEBC = param1.ebc;
         var _loc3_:Modifier = param1.modifier;
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.ebc;
         }
         var _loc5_:* = _loc4_ != null;
         hasCulling = _loc2_.cull != null;
         if(hasCulling)
         {
            quantcull = new BitStream(_loc2_.cull,BitStream.READ);
         }
         cullmin = _loc2_.cullMin;
         if(hasCulling == false)
         {
            param1.cullAllIndex = cullmin;
         }
         quantcullbits = _loc2_.numCullBits;
         G_in = new Array(param1.numVerts);
         G = new Array(param1.numVerts);
         var _loc7_:Number = _loc2_.bounds.readFloat();
         var _loc8_:Number = _loc2_.bounds.readFloat();
         var _loc9_:Number = _loc2_.bounds.readFloat();
         var _loc10_:Number = _loc2_.bounds.readFloat();
         var _loc11_:Number = _loc2_.bounds.readFloat();
         var _loc12_:Number = _loc2_.bounds.readFloat();
         var _loc13_:Number = _loc2_.mapBounds.readFloat();
         var _loc14_:Number = _loc2_.mapBounds.readFloat();
         var _loc15_:Number = _loc2_.mapBounds.readFloat();
         var _loc16_:Number = _loc2_.mapBounds.readFloat();
         var _loc17_:Number = (1 << _loc2_.vertBits) - 1;
         var _loc18_:Number = _loc5_ ? (1 << _loc4_.deltaBits) - 1 : 0;
         var _loc19_:Number = _loc5_ ? (1 << _loc4_.skinBits) - 1 : 0;
         var _loc20_:Number = (1 << _loc2_.mapVertBits) - 1;
         var _loc21_:Number = (_loc10_ - _loc7_) / _loc17_;
         var _loc22_:Number = (_loc11_ - _loc8_) / _loc17_;
         var _loc23_:Number = (_loc12_ - _loc9_) / _loc17_;
         var _loc24_:Number = (_loc15_ - _loc13_) / _loc20_;
         var _loc25_:Number = (_loc16_ - _loc14_) / _loc20_;
         var _loc35_:BitStream = null;
         if(_loc5_)
         {
            _loc35_ = new BitStream(_loc4_.delta,BitStream.READ);
            if(_loc4_.deltaBounds != null && _loc35_ != null)
            {
               _loc26_ = _loc4_.deltaBounds.readFloat();
               _loc27_ = _loc4_.deltaBounds.readFloat();
               _loc28_ = _loc4_.deltaBounds.readFloat();
               _loc29_ = _loc4_.deltaBounds.readFloat();
               _loc30_ = _loc4_.deltaBounds.readFloat();
               _loc31_ = _loc4_.deltaBounds.readFloat();
               _loc32_ = (_loc29_ - _loc26_) / _loc18_;
               _loc33_ = (_loc30_ - _loc27_) / _loc18_;
               _loc34_ = (_loc31_ - _loc28_) / _loc18_;
            }
         }
         var _loc37_:Boolean = _loc4_ != null && _loc4_.skin != null;
         if(_loc5_ && _loc37_)
         {
            _loc36_ = new BitStream(_loc4_.skin,BitStream.READ);
         }
         var _loc38_:BitStream = new BitStream(_loc2_.verts,BitStream.READ);
         var _loc39_:BitStream = new BitStream(_loc2_.mapVerts,BitStream.READ);
         var _loc40_:int = 0;
         if(param1.modifier != null && param1.modifier.channels != null)
         {
            _loc40_ = int(param1.modifier.channels.length);
         }
         _loc54_ = 0;
         while(_loc54_ < param1.numVerts)
         {
            G_in[_loc54_] = new Coord3D();
            G_in[_loc54_].x = _loc38_.readBits(_loc2_.vertBits) * _loc21_ + _loc7_;
            G_in[_loc54_].y = _loc38_.readBits(_loc2_.vertBits) * _loc22_ + _loc8_;
            G_in[_loc54_].z = _loc38_.readBits(_loc2_.vertBits) * _loc23_ + _loc9_;
            G_in[_loc54_].u = _loc39_.readBits(_loc2_.mapVertBits) * _loc24_ + _loc13_;
            G_in[_loc54_].v = _loc39_.readBits(_loc2_.mapVertBits) * _loc25_ + _loc14_;
            if(_loc35_ != null)
            {
               G_in[_loc54_].morphDeltas = new Array(_loc40_ * 3);
               G_in[_loc54_].morphChannel = new Array();
               _loc55_ = 0;
               _loc56_ = 0;
               while(_loc56_ < _loc40_)
               {
                  if(_loc35_.readBit() == 0)
                  {
                     var _loc67_:*;
                     G_in[_loc54_].morphDeltas[_loc67_ = _loc55_++] = 0;
                     var _loc68_:*;
                     G_in[_loc54_].morphDeltas[_loc68_ = _loc55_++] = 0;
                     var _loc69_:*;
                     G_in[_loc54_].morphDeltas[_loc69_ = _loc55_++] = 0;
                  }
                  else
                  {
                     G_in[_loc54_].morphDeltas[_loc67_ = _loc55_++] = _loc35_.readBits(_loc4_.deltaBits) * _loc32_ + _loc26_;
                     G_in[_loc54_].morphDeltas[_loc68_ = _loc55_++] = _loc35_.readBits(_loc4_.deltaBits) * _loc33_ + _loc27_;
                     G_in[_loc54_].morphDeltas[_loc69_ = _loc55_++] = _loc35_.readBits(_loc4_.deltaBits) * _loc34_ + _loc28_;
                  }
                  _loc56_++;
               }
            }
            if(_loc37_)
            {
               G_in[_loc54_].numBones = _loc36_.readBits(_loc4_.nbpvb);
               G_in[_loc54_].boneIndex = new Array(G_in[_loc54_].numBones);
               G_in[_loc54_].boneWeight = new Array(G_in[_loc54_].numBones);
               _loc57_ = 0;
               while(_loc57_ < G_in[_loc54_].numBones)
               {
                  G_in[_loc54_].boneIndex[_loc57_] = _loc36_.readBits(_loc4_.nbib);
                  G_in[_loc54_].boneWeight[_loc57_] = 1;
                  _loc57_++;
               }
               _loc36_.byteAlign();
               if(G_in[_loc54_].numBones > 1)
               {
                  _loc57_ = 0;
                  while(_loc57_ < G_in[_loc54_].numBones)
                  {
                     G_in[_loc54_].boneWeight[_loc57_] = _loc36_.readBits(_loc4_.skinBits) / _loc19_;
                     _loc57_++;
                  }
               }
               _loc36_.byteAlign();
            }
            G[_loc54_] = G_in[_loc54_];
            _loc54_++;
         }
         H = new Array();
         if(_loc2_.handles != null)
         {
            while(_loc2_.handles.bytesAvailable > 0)
            {
               H.push(_loc2_.handles.readInt());
            }
            H.position = 0;
         }
         var _loc41_:int = param1.numFaces;
         var _loc42_:int = param1.numVerts;
         V = new Array(3 * _loc41_);
         O = new Array(3 * _loc41_);
         _loc54_ = 0;
         while(_loc54_ < 3 * _loc41_)
         {
            O[_loc54_] = -3;
            V[_loc54_] = 0;
            _loc54_++;
         }
         U = new Array(_loc41_);
         M = new Array(_loc42_);
         _loc54_ = 0;
         while(_loc54_ < _loc41_)
         {
            U[_loc54_] = 0;
            _loc54_++;
         }
         _loc54_ = 0;
         while(_loc54_ < _loc42_)
         {
            M[_loc54_] = 0;
            _loc54_++;
         }
         if(hasCulling)
         {
            triCullRegion = new Array(_loc41_);
            _loc54_ = 0;
            while(_loc54_ < _loc41_)
            {
               triCullRegion[_loc54_] = 0;
               _loc54_++;
            }
         }
         var _loc43_:Array = new Array();
         while(_loc2_.numFaces1st.bytesAvailable > 0)
         {
            _loc43_.push(_loc2_.numFaces1st.readInt());
         }
         _loc43_.position = 0;
         var _loc44_:int = int(_loc43_.length);
         var _loc45_:Array = new Array();
         while(_loc2_.numClers.bytesAvailable > 0)
         {
            _loc45_.push(_loc2_.numClers.readInt());
         }
         _loc45_.position = 0;
         var _loc46_:int = 0;
         _loc54_ = 0;
         while(_loc54_ < _loc44_)
         {
            _loc46_ += _loc43_[_loc54_] - 2 + 1 + _loc45_[_loc54_] + 1;
            _loc54_++;
         }
         C = new Array(_loc46_);
         var _loc47_:int = 0;
         N = 0;
         var _loc48_:int = 0;
         var _loc49_:int = 0;
         var _loc50_:* = 0;
         var _loc51_:BitStream = new BitStream(_loc2_.clers,BitStream.READ);
         _loc47_ = 0;
         while(_loc47_ < _loc44_)
         {
            _loc58_ = int(_loc43_[_loc47_]);
            _loc59_ = int(_loc45_[_loc47_]);
            _loc6_ = 0;
            while(_loc6_ < O.length)
            {
               if(O[_loc6_] == -3)
               {
                  _loc48_ = _loc6_;
                  break;
               }
               _loc6_++;
            }
            _loc54_ = 0;
            _loc54_ = 0;
            while(_loc54_ < _loc58_ - 2)
            {
               C[_loc49_] = "C";
               _loc49_++;
               _loc54_++;
            }
            C[_loc49_] = "R";
            _loc49_++;
            _loc50_ = 0;
            while(_loc50_ < _loc59_)
            {
               C[_loc49_] = readCler(_loc51_);
               _loc49_++;
               _loc50_++;
            }
            _loc49_++;
            N += 2;
            V[0 + _loc48_] = N - 2;
            V[1 + _loc48_] = N;
            V[2 + _loc48_] = N - 1;
            O[0 + _loc48_] = -1;
            O[1 + _loc48_] = -1;
            decompressConnectivity(_loc48_ + 2);
            if(this.hasCulling)
            {
               triCullRegion[T] = quantcull.readBits(quantcullbits) + cullmin;
            }
            ++N;
            ++T;
            _loc47_++;
         }
         G[0] = G_in[V[0]];
         M[0] = 1;
         G[1] = G_in[V[2]];
         M[1] = 1;
         G[2] = G_in[V[1]];
         M[2] = 1;
         N = 2;
         U[0] = 1;
         decompressVertices(O[2]);
         if(_loc40_ > 0)
         {
            _loc6_ = 0;
            _loc60_ = new Array(_loc42_ * 3 * _loc40_);
            _loc50_ = 0;
            _loc56_ = 0;
            while(_loc56_ < _loc40_)
            {
               _loc54_ = 0;
               while(_loc54_ < _loc42_)
               {
                  _loc60_[_loc67_ = _loc6_++] = G[_loc54_].morphDeltas[_loc50_];
                  _loc60_[_loc68_ = _loc6_++] = G[_loc54_].morphDeltas[_loc50_ + 1];
                  _loc60_[_loc69_ = _loc6_++] = G[_loc54_].morphDeltas[_loc50_ + 2];
                  _loc54_++;
               }
               _loc50_ += 3;
               _loc56_++;
            }
            param1.modifier.delta = _loc60_;
            param1.modifier.numTargets = _loc40_;
            param1.modifier.hasMorpher = true;
         }
         if(_loc37_)
         {
            _loc61_ = _loc42_;
            _loc62_ = 0;
            _loc63_ = 0;
            _loc54_ = 0;
            while(_loc54_ < _loc42_)
            {
               _loc62_ += G[_loc54_].boneIndex.length;
               if(G[_loc54_].boneIndex.length > 1)
               {
                  _loc63_ += G[_loc54_].boneWeight.length;
               }
               _loc54_++;
            }
            _loc64_ = new Array(_loc61_);
            _loc65_ = new Array(_loc62_);
            _loc66_ = new Array(_loc63_);
            _loc61_ = 0;
            _loc62_ = 0;
            _loc63_ = 0;
            _loc54_ = 0;
            while(_loc54_ < _loc42_)
            {
               _loc64_[_loc54_] = int(G[_loc54_].numBones);
               _loc6_ = 0;
               while(_loc6_ < G[_loc54_].boneIndex.length)
               {
                  _loc65_[_loc67_ = _loc62_++] = int(G[_loc54_].boneIndex[_loc6_]);
                  _loc6_++;
               }
               _loc6_ = 0;
               while(_loc6_ < G[_loc54_].boneIndex.length)
               {
                  _loc66_[_loc67_ = _loc63_++] = Number(G[_loc54_].boneWeight[_loc6_]);
                  _loc6_++;
               }
               _loc54_++;
            }
            param1.modifier.boneIndex = _loc65_;
            param1.modifier.boneWeight = _loc66_;
            param1.modifier.numBones = _loc64_;
            param1.modifier.hasSkin = true;
         }
         _loc50_ = 0;
         _loc6_ = 0;
         var _loc52_:Array = new Array(_loc42_ * 3);
         var _loc53_:Array = new Array(_loc42_ * 3);
         _loc54_ = 0;
         while(_loc54_ < _loc42_)
         {
            _loc52_[_loc67_ = _loc50_++] = G[_loc54_].x;
            _loc52_[_loc68_ = _loc50_++] = G[_loc54_].y;
            _loc52_[_loc69_ = _loc50_++] = G[_loc54_].z;
            var _loc70_:*;
            _loc53_[_loc70_ = _loc6_++] = G[_loc54_].u;
            var _loc71_:*;
            _loc53_[_loc71_ = _loc6_++] = G[_loc54_].v;
            var _loc72_:*;
            _loc53_[_loc72_ = _loc6_++] = 0;
            _loc54_++;
         }
         param1.verts = _loc52_;
         param1.faces = V;
         param1.mapVerts = _loc53_;
         if(hasCulling)
         {
            param1.cull = triCullRegion;
         }
      }
      
      private function prevEdge(param1:int) : int
      {
         return nextEdge(nextEdge(param1));
      }
      
      private function decompressVertices(param1:int) : void
      {
         var _loc2_:* = undefined;
         while(true)
         {
            U[e2T(param1)] = 1;
            _loc2_ = V[param1];
            if(M[_loc2_] == 0)
            {
               ++N;
               G[N] = G_in[_loc2_];
               M[_loc2_] = 1;
               param1 = rightTri(param1,O);
            }
            else if(U[e2T(rightTri(param1,O))] == 1)
            {
               if(U[e2T(leftTri(param1,O))] == 1)
               {
                  break;
               }
               param1 = leftTri(param1,O);
            }
            else if(U[e2T(leftTri(param1,O))] == 1)
            {
               param1 = rightTri(param1,O);
            }
            else
            {
               decompressVertices(rightTri(param1,O));
               param1 = leftTri(param1,O);
               if(U[e2T(param1)] > 0)
               {
                  return;
               }
            }
         }
      }
   }
}


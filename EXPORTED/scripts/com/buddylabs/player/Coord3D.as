package com.buddylabs.player
{
   internal class Coord3D
   {
      
      internal var morphDeltas:Array;
      
      internal var numBones:int;
      
      internal var boneWeight:Array;
      
      internal var boneIndex:Array;
      
      internal var u:Number;
      
      internal var v:Number;
      
      internal var x:Number;
      
      internal var y:Number;
      
      internal var z:Number;
      
      internal var morphChannel:Array;
      
      public function Coord3D()
      {
         super();
      }
      
      public function dispose() : void
      {
         GCUtil.disposeArray(morphChannel,false);
         morphChannel = null;
         GCUtil.disposeArray(morphDeltas,false);
         morphDeltas = null;
         numBones = null;
         GCUtil.disposeArray(boneIndex,false);
         boneIndex = null;
         GCUtil.disposeArray(boneWeight,false);
         boneWeight = null;
      }
   }
}


package com.buddylabs.player
{
   public class Pose
   {
      
      public var nodes:Array;
      
      public var rootNode:Node;
      
      public function Pose(param1:Node)
      {
         super();
         this.rootNode = param1;
         nodes = new Array();
      }
      
      public static function add(param1:Pose, param2:Pose, param3:Pose) : void
      {
         var _loc4_:uint = param1.nodes.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            PoseNode.add(param1.nodes[_loc5_],param2.nodes[_loc5_],param3.nodes[_loc5_]);
            _loc5_++;
         }
      }
      
      public static function generateDelta(param1:Context, param2:Pose, param3:Anim, param4:uint) : Pose
      {
         param3.drawFrame(param1,param4);
         var _loc5_:Pose = new Pose(param2.rootNode);
         collectNodeTransforms(_loc5_,param2.rootNode);
         subtract(_loc5_,param2,_loc5_);
         return _loc5_;
      }
      
      public static function subtract(param1:Pose, param2:Pose, param3:Pose) : void
      {
         var _loc4_:uint = param1.nodes.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            PoseNode.subtract(param1.nodes[_loc5_],param2.nodes[_loc5_],param3.nodes[_loc5_]);
            _loc5_++;
         }
      }
      
      public static function generate(param1:Context, param2:Anim, param3:uint, param4:Node) : Pose
      {
         param2.drawFrame(param1,param3);
         var _loc5_:Pose = new Pose(param4);
         collectNodeTransforms(_loc5_,param4);
         return _loc5_;
      }
      
      public static function lerp(param1:Pose, param2:Pose, param3:Number, param4:Pose) : void
      {
         var _loc5_:uint = param1.nodes.length;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            PoseNode.lerp(param3,param1.nodes[_loc6_],param2.nodes[_loc6_],param4.nodes[_loc6_]);
            _loc6_++;
         }
      }
      
      public static function generateFromNode(param1:Node) : Pose
      {
         var _loc2_:Pose = new Pose(param1);
         collectNodeTransforms(_loc2_,param1);
         return _loc2_;
      }
      
      public static function scale(param1:Number, param2:Pose, param3:Pose) : void
      {
         var _loc4_:uint = param2.nodes.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            PoseNode.scale(param1,param2.nodes[_loc5_],param3.nodes[_loc5_]);
            _loc5_++;
         }
      }
      
      private static function collectNodeTransforms(param1:Pose, param2:Node) : void
      {
         var _loc3_:BaseObj = null;
         if(param2 == null)
         {
            return;
         }
         param1.nodes.push(new PoseNode(param2));
         if(param2.children != null)
         {
            for each(_loc3_ in param2.children)
            {
               if(_loc3_ is Node)
               {
                  collectNodeTransforms(param1,Node(_loc3_));
               }
            }
         }
      }
      
      private function applyTransform(param1:Node, param2:uint) : uint
      {
         var _loc3_:BaseObj = null;
         nodes[param2++].copyToNode(param1);
         if(param1.children != null)
         {
            for each(_loc3_ in param1.children)
            {
               if(_loc3_ is Node)
               {
                  param2 = applyTransform(Node(_loc3_),param2);
               }
            }
         }
         return param2;
      }
      
      public function cacheCurrentTransform(param1:Node, param2:uint = 0) : uint
      {
         var _loc3_:BaseObj = null;
         nodes[param2++].copyFromNode(param1);
         if(param1.children != null)
         {
            for each(_loc3_ in param1.children)
            {
               if(_loc3_ is Node)
               {
                  param2 = cacheCurrentTransform(Node(_loc3_),param2);
               }
            }
         }
         return param2;
      }
      
      public function clone() : Pose
      {
         var _loc1_:Pose = new Pose(rootNode);
         var _loc2_:uint = nodes.length;
         _loc1_.nodes = new Array(_loc2_);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_.nodes[_loc3_] = nodes[_loc3_].clone();
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function showPose() : void
      {
         applyTransform(rootNode,0);
      }
      
      public function dispose() : void
      {
         rootNode = null;
         GCUtil.disposeArray(nodes,false);
         nodes = null;
      }
   }
}


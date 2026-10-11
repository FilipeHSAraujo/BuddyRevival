package com.buddylabs.player
{
   import flash.utils.Dictionary;
   
   public class Scene extends Node
   {
      
      internal var cull:Array;
      
      internal var config:BinBuddy;
      
      internal var cullDict:Dictionary;
      
      public var backgroundColor:uint;
      
      public var cullRegions:Array;
      
      public var bones:Array;
      
      public var props:Array;
      
      internal var propDict:Dictionary;
      
      internal var nodeMap:Dictionary;
      
      public function Scene()
      {
         super();
      }
      
      override public function draw(param1:Context) : void
      {
         var _loc2_:Scene = param1.scene;
         param1.scene = this;
         super.draw(param1);
         param1.scene = _loc2_;
      }
      
      public function hideProps() : void
      {
         var _loc1_:Node = null;
         if(propDict != null)
         {
            for each(_loc1_ in propDict)
            {
               if(_loc1_ != null)
               {
                  _loc1_.visible = false;
               }
            }
         }
      }
      
      override public function init(param1:Context) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Node = null;
         if(cullRegions != null && (cull == null || cullRegions.length != cull.length))
         {
            cull = new Array(cullRegions.length);
            cullDict = new Dictionary();
            _loc2_ = 0;
            while(_loc2_ < cull.length)
            {
               cull[_loc2_] = false;
               cullDict[cullRegions[_loc2_]] = _loc2_;
               _loc2_++;
            }
            if(config != null && config.cull != null)
            {
               for each(_loc3_ in config.cull)
               {
                  cullByName(_loc3_);
               }
            }
         }
         if(isNaN(backgroundColor))
         {
            backgroundColor = 16777215;
         }
         super.init(param1);
         if(props != null)
         {
            propDict = new Dictionary();
            for each(_loc4_ in props)
            {
               _loc5_ = Node(getNodeByName(_loc4_));
               if(_loc5_ != null)
               {
                  propDict[_loc4_] = _loc5_;
               }
            }
         }
      }
      
      public function cullByName(param1:String) : void
      {
         if(cullRegions == null || cull == null)
         {
            return;
         }
         var _loc2_:int = int(cullDict[param1]);
         cull[_loc2_] = true;
      }
      
      public function getNodeByName(param1:String) : BaseObj
      {
         return nodeMap[param1];
      }
      
      override public function dispose() : void
      {
         GCUtil.disposeArray(cullRegions,false);
         cullRegions = null;
         GCUtil.disposeArray(bones,false);
         bones = null;
         GCUtil.disposeArray(props,false);
         bones = null;
         GCUtil.disposeArray(cull,false);
         cull = null;
         GCUtil.disposeDictionary(cullDict);
         cullDict = null;
         GCUtil.disposeDictionary(nodeMap);
         nodeMap = null;
         config = null;
         super.dispose();
      }
      
      public function resetCulling() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < cull.length)
         {
            cull[_loc1_] = false;
            _loc1_++;
         }
      }
      
      internal function getBoneByIndex(param1:int) : BaseObj
      {
         return getNodeByName(bones[param1]);
      }
      
      override public function addChild(param1:BaseObj) : void
      {
         super.addChild(param1);
         if(param1.name != null)
         {
            nodeMap[param1.name] = param1;
         }
      }
   }
}


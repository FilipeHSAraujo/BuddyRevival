package com.buddylabs.player
{
   import flash.utils.Dictionary;
   
   public class BinBuddy
   {
      
      public var morph:Array;
      
      internal var xformsDict:Dictionary;
      
      internal var visibleDict:Dictionary;
      
      public var cull:Array;
      
      public var xforms:Array;
      
      public var visible:Array;
      
      internal var morphDict:Dictionary;
      
      public function BinBuddy()
      {
         super();
      }
      
      public function dispose() : void
      {
         GCUtil.disposeDictionary(visibleDict);
         visibleDict = null;
         GCUtil.disposeDictionary(xformsDict);
         xformsDict = null;
         GCUtil.disposeDictionary(morphDict);
         morphDict = null;
         visible = null;
         cull = null;
         xforms = null;
         morph = null;
      }
      
      internal function init() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(visible != null)
         {
            visibleDict = new Dictionary();
            for each(_loc1_ in visible)
            {
               visibleDict[_loc1_] = _loc1_;
            }
         }
         if(xforms != null)
         {
            xformsDict = new Dictionary();
            for each(_loc2_ in xforms)
            {
               xformsDict[_loc2_.node] = _loc2_;
            }
         }
         if(morph != null)
         {
            morphDict = new Dictionary();
            for each(_loc3_ in morph)
            {
               morphDict[_loc3_.node] = _loc3_;
            }
         }
      }
   }
}


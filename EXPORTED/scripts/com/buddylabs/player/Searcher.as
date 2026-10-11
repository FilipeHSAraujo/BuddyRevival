package com.buddylabs.player
{
   public class Searcher
   {
      
      public function Searcher()
      {
         super();
      }
      
      private static function searchByType(param1:Class, param2:BaseObj) : BaseObj
      {
         var _loc4_:int = 0;
         var _loc5_:BaseObj = null;
         if(param2 == null)
         {
            return null;
         }
         if(param2 is param1)
         {
            return param2;
         }
         if(!(param2 is Node))
         {
            return null;
         }
         var _loc3_:Node = param2 as Node;
         if(_loc3_.children != null)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.children.length)
            {
               _loc5_ = searchByType(param1,_loc3_.children[_loc4_]);
               if(_loc5_ != null)
               {
                  return _loc5_;
               }
               _loc4_++;
            }
         }
         return null;
      }
      
      public static function findWithType(param1:Class, param2:BaseObj) : BaseObj
      {
         if(param2 == null)
         {
            return null;
         }
         return searchByType(param1,param2);
      }
      
      public static function searchAllByType(param1:Class, param2:BaseObj, param3:Array) : void
      {
         var _loc5_:int = 0;
         if(param2 == null)
         {
            return;
         }
         if(param2 is param1)
         {
            param3.push(param2);
         }
         if(!(param2 is Node))
         {
            return;
         }
         var _loc4_:Node = param2 as Node;
         if(_loc4_.children != null)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.children.length)
            {
               searchAllByType(param1,_loc4_.children[_loc5_],param3);
               _loc5_++;
            }
         }
      }
   }
}


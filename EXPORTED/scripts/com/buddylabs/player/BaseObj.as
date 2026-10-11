package com.buddylabs.player
{
   public class BaseObj implements Disposable
   {
      
      public var name:String;
      
      public function BaseObj()
      {
         super();
      }
      
      public function init(param1:Context) : void
      {
         if(name != null)
         {
            param1.scene.nodeMap[name] = this;
         }
      }
      
      public function draw(param1:Context) : void
      {
      }
      
      public function dispose() : void
      {
         name = null;
      }
   }
}


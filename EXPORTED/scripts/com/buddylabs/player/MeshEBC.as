package com.buddylabs.player
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.ByteArray;
   import mx.events.PropertyChangeEvent;
   
   public class MeshEBC implements IEventDispatcher
   {
      
      private var _1914871689numClers:ByteArray;
      
      private var _495217022numFaces1st:ByteArray;
      
      private var _1985296937vertBits:int;
      
      private var _3065202cull:ByteArray;
      
      private var _692803403handles:ByteArray;
      
      private var _1383205195bounds:ByteArray;
      
      private var _421663537mapBounds:ByteArray;
      
      private var _1621734227mapVertBits:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _112097634verts:ByteArray;
      
      private var _595755202numCullBits:int;
      
      private var _94746717clers:ByteArray;
      
      private var _170319206mapVerts:ByteArray;
      
      private var _1121196928cullMin:int;
      
      public function MeshEBC()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get cullMin() : int
      {
         return this._1121196928cullMin;
      }
      
      [Bindable(event="propertyChange")]
      public function get numFaces1st() : ByteArray
      {
         return this._495217022numFaces1st;
      }
      
      public function set numFaces1st(param1:ByteArray) : void
      {
         var _loc2_:Object = this._495217022numFaces1st;
         if(_loc2_ !== param1)
         {
            this._495217022numFaces1st = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"numFaces1st",_loc2_,param1));
         }
      }
      
      public function set cullMin(param1:int) : void
      {
         var _loc2_:Object = this._1121196928cullMin;
         if(_loc2_ !== param1)
         {
            this._1121196928cullMin = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cullMin",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return _bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set handles(param1:ByteArray) : void
      {
         var _loc2_:Object = this._692803403handles;
         if(_loc2_ !== param1)
         {
            this._692803403handles = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"handles",_loc2_,param1));
         }
      }
      
      public function dispose() : void
      {
         clers = null;
         numClers = null;
         handles = null;
         verts = null;
         bounds = null;
         numFaces1st = null;
         mapBounds = null;
         mapVerts = null;
         cull = null;
      }
      
      public function set mapVertBits(param1:int) : void
      {
         var _loc2_:Object = this._1621734227mapVertBits;
         if(_loc2_ !== param1)
         {
            this._1621734227mapVertBits = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapVertBits",_loc2_,param1));
         }
      }
      
      public function set vertBits(param1:int) : void
      {
         var _loc2_:Object = this._1985296937vertBits;
         if(_loc2_ !== param1)
         {
            this._1985296937vertBits = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"vertBits",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapBounds() : ByteArray
      {
         return this._421663537mapBounds;
      }
      
      [Bindable(event="propertyChange")]
      public function get bounds() : ByteArray
      {
         return this._1383205195bounds;
      }
      
      public function set clers(param1:ByteArray) : void
      {
         var _loc2_:Object = this._94746717clers;
         if(_loc2_ !== param1)
         {
            this._94746717clers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clers",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return _bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set verts(param1:ByteArray) : void
      {
         var _loc2_:Object = this._112097634verts;
         if(_loc2_ !== param1)
         {
            this._112097634verts = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verts",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         _bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get handles() : ByteArray
      {
         return this._692803403handles;
      }
      
      public function set mapVerts(param1:ByteArray) : void
      {
         var _loc2_:Object = this._170319206mapVerts;
         if(_loc2_ !== param1)
         {
            this._170319206mapVerts = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapVerts",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get numCullBits() : int
      {
         return this._595755202numCullBits;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapVertBits() : int
      {
         return this._1621734227mapVertBits;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         _bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get vertBits() : int
      {
         return this._1985296937vertBits;
      }
      
      [Bindable(event="propertyChange")]
      public function get clers() : ByteArray
      {
         return this._94746717clers;
      }
      
      [Bindable(event="propertyChange")]
      public function get verts() : ByteArray
      {
         return this._112097634verts;
      }
      
      public function set cull(param1:ByteArray) : void
      {
         var _loc2_:Object = this._3065202cull;
         if(_loc2_ !== param1)
         {
            this._3065202cull = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cull",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapVerts() : ByteArray
      {
         return this._170319206mapVerts;
      }
      
      public function set mapBounds(param1:ByteArray) : void
      {
         var _loc2_:Object = this._421663537mapBounds;
         if(_loc2_ !== param1)
         {
            this._421663537mapBounds = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapBounds",_loc2_,param1));
         }
      }
      
      public function set bounds(param1:ByteArray) : void
      {
         var _loc2_:Object = this._1383205195bounds;
         if(_loc2_ !== param1)
         {
            this._1383205195bounds = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bounds",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cull() : ByteArray
      {
         return this._3065202cull;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return _bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get numClers() : ByteArray
      {
         return this._1914871689numClers;
      }
      
      public function set numCullBits(param1:int) : void
      {
         var _loc2_:Object = this._595755202numCullBits;
         if(_loc2_ !== param1)
         {
            this._595755202numCullBits = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"numCullBits",_loc2_,param1));
         }
      }
      
      public function set numClers(param1:ByteArray) : void
      {
         var _loc2_:Object = this._1914871689numClers;
         if(_loc2_ !== param1)
         {
            this._1914871689numClers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"numClers",_loc2_,param1));
         }
      }
   }
}


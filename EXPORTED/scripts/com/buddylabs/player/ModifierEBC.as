package com.buddylabs.player
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.ByteArray;
   import mx.events.PropertyChangeEvent;
   
   public class ModifierEBC implements IEventDispatcher
   {
      
      private var _2143057955skinBits:int;
      
      private var _104618216nbpvb:int;
      
      private var _52148446deltaBits:int;
      
      private var _3374541nbib:int;
      
      private var _95468472delta:ByteArray;
      
      private var _3532157skin:ByteArray;
      
      private var _1419381619deltaBounds:ByteArray;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ModifierEBC()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return _bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         _bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get deltaBounds() : ByteArray
      {
         return this._1419381619deltaBounds;
      }
      
      public function set nbpvb(param1:int) : void
      {
         var _loc2_:Object = this._104618216nbpvb;
         if(_loc2_ !== param1)
         {
            this._104618216nbpvb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nbpvb",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get nbib() : int
      {
         return this._3374541nbib;
      }
      
      public function set skinBits(param1:int) : void
      {
         var _loc2_:Object = this._2143057955skinBits;
         if(_loc2_ !== param1)
         {
            this._2143057955skinBits = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skinBits",_loc2_,param1));
         }
      }
      
      public function set deltaBounds(param1:ByteArray) : void
      {
         var _loc2_:Object = this._1419381619deltaBounds;
         if(_loc2_ !== param1)
         {
            this._1419381619deltaBounds = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deltaBounds",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         _bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get deltaBits() : int
      {
         return this._52148446deltaBits;
      }
      
      public function dispose() : void
      {
         delta = null;
         deltaBounds = null;
         skin = null;
      }
      
      [Bindable(event="propertyChange")]
      public function get nbpvb() : int
      {
         return this._104618216nbpvb;
      }
      
      public function set nbib(param1:int) : void
      {
         var _loc2_:Object = this._3374541nbib;
         if(_loc2_ !== param1)
         {
            this._3374541nbib = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nbib",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get skinBits() : int
      {
         return this._2143057955skinBits;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return _bindingEventDispatcher.willTrigger(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return _bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set delta(param1:ByteArray) : void
      {
         var _loc2_:Object = this._95468472delta;
         if(_loc2_ !== param1)
         {
            this._95468472delta = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"delta",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get delta() : ByteArray
      {
         return this._95468472delta;
      }
      
      public function set skin(param1:ByteArray) : void
      {
         var _loc2_:Object = this._3532157skin;
         if(_loc2_ !== param1)
         {
            this._3532157skin = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skin",_loc2_,param1));
         }
      }
      
      public function set deltaBits(param1:int) : void
      {
         var _loc2_:Object = this._52148446deltaBits;
         if(_loc2_ !== param1)
         {
            this._52148446deltaBits = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deltaBits",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get skin() : ByteArray
      {
         return this._3532157skin;
      }
   }
}


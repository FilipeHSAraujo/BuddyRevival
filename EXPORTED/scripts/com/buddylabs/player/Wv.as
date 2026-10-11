package com.buddylabs.player
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.ByteArray;
   import mx.events.PropertyChangeEvent;
   
   public class Wv implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _122z:ByteArray;
      
      private var _120x:ByteArray;
      
      private var _119w:ByteArray;
      
      private var _121y:ByteArray;
      
      public function Wv()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get z() : ByteArray
      {
         return this._122z;
      }
      
      public function set z(param1:ByteArray) : void
      {
         var _loc2_:Object = this._122z;
         if(_loc2_ !== param1)
         {
            this._122z = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"z",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return _bindingEventDispatcher.willTrigger(param1);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return _bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         _bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         _bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispose() : void
      {
         x = null;
         y = null;
         z = null;
         w = null;
      }
      
      public function set w(param1:ByteArray) : void
      {
         var _loc2_:Object = this._119w;
         if(_loc2_ !== param1)
         {
            this._119w = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"w",_loc2_,param1));
         }
      }
      
      public function set x(param1:ByteArray) : void
      {
         var _loc2_:Object = this._120x;
         if(_loc2_ !== param1)
         {
            this._120x = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"x",_loc2_,param1));
         }
      }
      
      public function set y(param1:ByteArray) : void
      {
         var _loc2_:Object = this._121y;
         if(_loc2_ !== param1)
         {
            this._121y = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"y",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return _bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get w() : ByteArray
      {
         return this._119w;
      }
      
      [Bindable(event="propertyChange")]
      public function get x() : ByteArray
      {
         return this._120x;
      }
      
      [Bindable(event="propertyChange")]
      public function get y() : ByteArray
      {
         return this._121y;
      }
   }
}


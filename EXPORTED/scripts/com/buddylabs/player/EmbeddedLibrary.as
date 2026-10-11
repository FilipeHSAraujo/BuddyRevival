package com.buddylabs.player
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.system.LoaderContext;
   
   public class EmbeddedLibrary extends Sprite implements SymbolLibrary
   {
      
      private var loader:Loader = new Loader();
      
      private var libraryIsReady:Boolean = false;
      
      public function EmbeddedLibrary()
      {
         super();
      }
      
      public function getBitmapData(param1:String) : BitmapData
      {
         if(loader.contentLoaderInfo.applicationDomain.hasDefinition(param1))
         {
            return new (Class(loader.contentLoaderInfo.applicationDomain.getDefinition(param1)))(0,0);
         }
         return null;
      }
      
      public function getSymbol(param1:String) : DisplayObject
      {
         if(loader.contentLoaderInfo.applicationDomain.hasDefinition(param1))
         {
            return new (Class(loader.contentLoaderInfo.applicationDomain.getDefinition(param1)))();
         }
         return null;
      }
      
      protected function onLoadedLibrary(param1:Event) : void
      {
         loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadedLibrary);
         libraryIsReady = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function load(param1:Class, param2:Function) : void
      {
         addEventListener(Event.COMPLETE,param2);
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadedLibrary);
         var _loc3_:LoaderContext = new LoaderContext();
         if("allowLoadBytesCodeExecution" in _loc3_)
         {
            _loc3_["allowLoadBytesCodeExecution"] = true;
         }
         loader.loadBytes(new param1(),_loc3_);
      }
      
      public function dispose() : void
      {
         if(loader != null)
         {
            try
            {
               loader.unload();
            }
            catch(e:ErrorEvent)
            {
            }
         }
         loader = null;
      }
   }
}


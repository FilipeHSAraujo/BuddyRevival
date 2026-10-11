package com.buddylabs.player
{
   import flash.events.Event;
   import flash.net.registerClassAlias;
   
   public class MediaObject extends MediaBinary
   {
      
      public var object:Object;
      
      public function MediaObject(param1:String = null)
      {
         super();
         registerClassAlias("AL",AnimLibrary);
         registerClassAlias("An",Anim);
         registerClassAlias("BB",BinBuddy);
         registerClassAlias("Bo",Bone);
         registerClassAlias("Ca",Camera);
         registerClassAlias("Co",Controller);
         registerClassAlias("Ma",Map);
         registerClassAlias("Me",Mesh);
         registerClassAlias("MeC",MeshEBC);
         registerClassAlias("Mo",Modifier);
         registerClassAlias("MoC",ModifierEBC);
         registerClassAlias("No",Node);
         registerClassAlias("Sc",Scene);
         registerClassAlias("SM",StandardMaterial);
         registerClassAlias("WD",Wv);
         if(param1 != null)
         {
            this.url = param1;
         }
      }
      
      override protected function onLoaded(param1:Event) : void
      {
         loader.data.uncompress();
         loader.data.position = 0;
         object = loader.data.readObject();
         loader.data = null;
         loader = null;
         state = COMPLETE;
         dispatchEvent(param1);
      }
      
      override public function dispose() : void
      {
         object = null;
         super.dispose();
      }
   }
}


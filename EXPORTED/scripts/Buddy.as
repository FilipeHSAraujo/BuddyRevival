package
{
   import com.adobe.serialization.json.JSON;
   import com.buddylabs.player.*;
   import fl.controls.*;
   import fl.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class Buddy extends SceneObject
   {
      
      public static const DEFAULT:String = "eNo1UUluwzAMvPUhOudQeQnSPEdSYAWWYcJ0AxRBH9Bfl8voNOSQIoejj7/vd6glh/twCUlxvIR6nOEeowZKTBKQMJ_KQnxZPnRCglkClg7t5GyFrJ3C5yoYjYgoDLYk04h8Mnz8nEB9IDseDIJ9EtNuOdNhajfUt9Qxu_o5O7G0jn7WtqJx1XNlA1cnuLpmbvG08yTQllGjQaibBS6DdOpVES0EbwgXU/eGuje8Pn3_2i85TRBTBuIF2wsJEqQnSK_J3O7kShvyhpzhPjMmcgSvZotZXEAUSCoj8snzinqFkjIDr6ijv/pv8Q7rdl2oDTtBwk74h6W9_ge8XOZyRJu2HLrl9x_zjKUt";
      
      private var prevDeserializeStr:String = null;
      
      public function Buddy(param1:Stage)
      {
         super(param1);
      }
      
      private static function serialize(param1:SceneObject) : String
      {
         var anop:XML = null;
         var result:String = null;
         var name:String = null;
         var kids:XMLList = null;
         var subop:XML = null;
         var sid:String = null;
         var type:String = null;
         var path:String = null;
         var pathA:Array = null;
         var texture:XML = null;
         var layer:XML = null;
         var color:String = null;
         var colorOptionArray:Array = null;
         var colorIndex:uint = 0;
         var textureIndex:int = 0;
         var item:XML = null;
         var visible:Boolean = false;
         var items:XMLList = null;
         var numOptions:int = 0;
         var bmps:Array = null;
         var selected:int = 0;
         var i:int = 0;
         var vis:String = null;
         var buddy:SceneObject = param1;
         var catalogXML:XML = buddy.catalogXML;
         var ops:XMLList = CustomizationPanel.options.option;
         var matlib:MediaLibrary = buddy.materialLibrary;
         var ser:Array = [];
         for each(anop in ops)
         {
            name = anop.@name;
            kids = anop.children();
            for each(subop in kids)
            {
               sid = subop.@id;
               type = subop.name();
               path = subop.@path;
               pathA = path.split(";");
               if("color" == type)
               {
                  texture = catalogXML.materialOptions[0].materialOption.(@name == pathA[0]).material.(@name = pathA[1]).layer.(@name == pathA[2]).texture.(@symbol == pathA[3])[0];
                  layer = texture.parent();
                  color = texture.@color;
                  if(color != null && color.length > 0)
                  {
                     colorOptionArray = buddy.materialLibrary.getColorTintOption(color);
                     if(colorOptionArray != null && colorOptionArray.length > 1)
                     {
                        layer.@colorIndex = texture.@colorSelection;
                        colorIndex = uint(layer.@colorIndex);
                        ser.push("\"" + sid + "\":" + colorIndex);
                     }
                  }
               }
               else if("texture" == type)
               {
                  layer = catalogXML.materialOptions[0].materialOption.(@name == pathA[0]).material.(@name = pathA[1]).layer.(@name == pathA[2])[0];
                  if(layer != null)
                  {
                     textureIndex = int(layer.@textureIndex);
                     if(isNaN(textureIndex))
                     {
                        textureIndex = 0;
                     }
                     ser.push("\"" + sid + "\":" + textureIndex);
                  }
               }
               else if("item" == type)
               {
                  item = catalogXML.group[0].categories[0].itemCategory.(@name == pathA[0]).item.(@name == pathA[1])[0];
                  if(item != null)
                  {
                     visible = "true" == item.@visible;
                     ser.push("\"" + sid + "\":" + (visible ? "1" : "0"));
                  }
               }
               else if("itemGroup" == type)
               {
                  items = catalogXML.group[0].categories[0].itemCategory.(@name == pathA[0]).item.(hasOwnProperty("@visGroup")).(@visGroup == pathA[1]);
                  numOptions = int(items.length());
                  bmps = new Array();
                  selected = 0;
                  i = 0;
                  while(i < numOptions)
                  {
                     vis = items[i].@visible;
                     if("true" == vis)
                     {
                        selected = i;
                     }
                     i++;
                  }
                  ser.push("\"" + sid + "\":" + selected);
               }
            }
         }
         result = "{" + ser.join(",") + "}";
         return result;
      }
      
      private static function deserialize(param1:SceneObject, param2:*) : void
      {
         var anop:XML = null;
         var name:String = null;
         var kids:XMLList = null;
         var subop:XML = null;
         var sid:String = null;
         var serVal:String = null;
         var type:String = null;
         var path:String = null;
         var pathA:Array = null;
         var texture:XML = null;
         var layer:XML = null;
         var color:String = null;
         var colorOptionArray:Array = null;
         var item:XML = null;
         var items:XMLList = null;
         var numOptions:int = 0;
         var selected:int = 0;
         var serIndex:int = 0;
         var i:int = 0;
         var buddy:SceneObject = param1;
         var ser:* = param2;
         var catalogXML:XML = buddy.catalogXML;
         var ops:XMLList = CustomizationPanel.options.option;
         var matlib:MediaLibrary = buddy.materialLibrary;
         for each(anop in ops)
         {
            name = anop.@name;
            kids = anop.children();
            for each(subop in kids)
            {
               sid = subop.@id;
               serVal = ser[sid];
               if(serVal != null)
               {
                  type = subop.name();
                  path = subop.@path;
                  pathA = path.split(";");
                  if("color" == type)
                  {
                     texture = catalogXML.materialOptions[0].materialOption.(@name == pathA[0]).material.(@name = pathA[1]).layer.(@name == pathA[2]).texture.(@symbol == pathA[3])[0];
                     layer = texture.parent();
                     color = texture.@color;
                     if(color != null && color.length > 0)
                     {
                        colorOptionArray = buddy.materialLibrary.getColorTintOption(color);
                        if(colorOptionArray != null && colorOptionArray.length > 1)
                        {
                           layer.@colorIndex = serVal;
                           texture.@colorSelection = serVal;
                        }
                     }
                  }
                  else if("texture" == type)
                  {
                     layer = catalogXML.materialOptions[0].materialOption.(@name == pathA[0]).material.(@name = pathA[1]).layer.(@name == pathA[2])[0];
                     layer.@textureIndex = serVal;
                  }
                  else if("item" == type)
                  {
                     item = catalogXML.group[0].categories[0].itemCategory.(@name == pathA[0]).item.(@name == pathA[1])[0];
                     item.@visible = serVal == "1" ? "true" : "false";
                  }
                  else if("itemGroup" == type)
                  {
                     items = catalogXML.group[0].categories[0].itemCategory.(@name == pathA[0]).item.(hasOwnProperty("@visGroup")).(@visGroup == pathA[1]);
                     numOptions = int(items.length());
                     selected = 0;
                     serIndex = int(serVal);
                     i = 0;
                     while(i < numOptions)
                     {
                        items[i].@visible = i == serIndex ? "true" : "false";
                        i++;
                     }
                  }
               }
            }
         }
      }
      
      public function deserializeCompressed(param1:String) : void
      {
         var arr:ByteArray = null;
         var ser:String = null;
         var obj:* = undefined;
         var comp:String = param1;
         if(comp == null || comp.length < 1)
         {
            comp = DEFAULT;
         }
         if(prevDeserializeStr == comp)
         {
            return;
         }
         prevDeserializeStr = comp;
         arr = Base64.decodeToByteArray(Buddy.DEFAULT);
         arr.position = 0;
         arr.uncompress();
         arr.position = 0;
         ser = arr.readObject();
         obj = com.adobe.serialization.json.JSON.decode(ser);
         deserialize(this,obj);
         if(comp != Buddy.DEFAULT)
         {
            try
            {
               arr = Base64.decodeToByteArray(comp);
               arr.position = 0;
               arr.uncompress();
               arr.position = 0;
               ser = arr.readObject();
               obj = com.adobe.serialization.json.JSON.decode(ser);
               deserialize(this,obj);
            }
            catch(e:*)
            {
            }
         }
         this.player.updateTextures(this.catalogXML,this.materialLibrary);
         this.player.setVisibleGeometry(this.catalogXML);
         this.context.scene.hideProps();
      }
      
      public function serializeCompressed() : String
      {
         var _loc1_:String = serialize(this);
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(_loc1_);
         _loc2_.position = 0;
         _loc2_.compress();
         _loc2_.position = 0;
         return Base64.encodeByteArray(_loc2_);
      }
      
      public function resetToDefault() : void
      {
         deserializeCompressed(DEFAULT);
      }
   }
}


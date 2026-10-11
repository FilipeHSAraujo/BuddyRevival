package
{
   import fl.controls.TexturePicker;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BTexturePicker extends TexturePicker
   {
      
      private var _trackName:String;
      
      private var _data:*;
      
      public function BTexturePicker(param1:*, param2:String = null)
      {
         this._data = param1;
         this._trackName = param2;
         super();
      }
      
      override protected function positionPalette() : void
      {
         var _loc1_:Point = swatchButton.localToGlobal(new Point(0,0));
         var _loc2_:Number = getStyleValue("backgroundPadding") as Number;
         var _loc3_:Rectangle = palette.getBounds(palette);
         if(_loc1_.x + _loc3_.width > stage.stageWidth)
         {
            palette.x = _loc1_.x - _loc3_.width << 0;
         }
         else
         {
            palette.x = _loc1_.x + swatchButton.width + _loc2_ << 0;
            if(palette.x + _loc3_.width > stage.stageWidth - 2)
            {
               palette.x = stage.stageWidth - _loc3_.width - 2 << 0;
            }
         }
         palette.y = Math.max(0,Math.min(_loc1_.y,stage.stageHeight - _loc3_.height - 2)) << 0;
      }
      
      public function get trackName() : String
      {
         return _trackName;
      }
      
      public function get data() : *
      {
         return _data;
      }
   }
}


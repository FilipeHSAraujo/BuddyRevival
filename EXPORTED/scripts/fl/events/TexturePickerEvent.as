package fl.events
{
   import flash.events.Event;
   
   public class TexturePickerEvent extends Event
   {
      
      public static const ITEM_ROLL_OUT:String = "itemRollOut";
      
      public static const ITEM_ROLL_OVER:String = "itemRollOver";
      
      public static const ENTER:String = "enter";
      
      public static const CHANGE:String = "change";
      
      protected var _imageIndex:uint;
      
      public function TexturePickerEvent(param1:String, param2:uint)
      {
         super(param1,true);
         _imageIndex = param2;
      }
      
      override public function toString() : String
      {
         return formatToString("TexturePickerEvent","type","bubbles","cancelable","imageIndex");
      }
      
      public function get imageIndex() : uint
      {
         return _imageIndex;
      }
      
      override public function clone() : Event
      {
         return new TexturePickerEvent(type,imageIndex);
      }
   }
}


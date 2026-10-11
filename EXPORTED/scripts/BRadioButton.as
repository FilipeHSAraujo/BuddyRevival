package
{
   import fl.controls.RadioButton;
   
   public class BRadioButton extends RadioButton
   {
      
      private var _data:*;
      
      public function BRadioButton(param1:*)
      {
         this._data = param1;
         super();
      }
      
      public function get data() : *
      {
         return _data;
      }
   }
}


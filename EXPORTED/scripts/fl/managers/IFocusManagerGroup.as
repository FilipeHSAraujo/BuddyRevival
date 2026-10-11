package fl.managers
{
   public interface IFocusManagerGroup
   {
      
      function set groupName(param1:String) : void;
      
      function set selected(param1:Boolean) : void;
      
      function get groupName() : String;
      
      function get selected() : Boolean;
   }
}


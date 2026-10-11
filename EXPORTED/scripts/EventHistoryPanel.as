package
{
   import fl.containers.ScrollPane;
   import fl.controls.ScrollPolicy;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   
   public class EventHistoryPanel extends Sprite
   {
      
      private var eventItems:Array;
      
      private var eventItemWidth:Number = 200;
      
      private var aSp:ScrollPane = new ScrollPane();
      
      public function EventHistoryPanel(param1:int, param2:int, param3:int, param4:int)
      {
         super();
         this.x = param1;
         this.y = param2;
         var _loc5_:int = param3;
         var _loc6_:int = param4;
         eventItemWidth = param3 - 30;
         var _loc7_:Sprite = new Sprite();
         _loc7_.graphics.lineStyle(1,13421772,0.5);
         _loc7_.graphics.beginFill(16777215,0.5);
         _loc7_.graphics.drawRect(0,0,_loc5_,_loc6_);
         _loc7_.graphics.endFill();
         aSp.setSize(_loc5_ - 10,_loc6_ - 10);
         aSp.move(5,5);
         aSp.verticalScrollPolicy = ScrollPolicy.ON;
         aSp.horizontalScrollPolicy = ScrollPolicy.OFF;
         _loc7_.addChild(aSp);
         this.addChild(_loc7_);
      }
      
      internal function get events() : Array
      {
         return eventItems;
      }
      
      private function onSelectedItem(param1:Event) : void
      {
         var _loc3_:EventItem = null;
         var _loc2_:EventItem = EventItem(param1.target);
         if(eventItems != null)
         {
            for each(_loc3_ in eventItems)
            {
               _loc3_.selected = false;
            }
         }
         _loc2_.selected = true;
      }
      
      internal function showEvents(param1:String, param2:*, param3:Function, param4:Dictionary) : void
      {
         var _loc10_:* = undefined;
         var _loc11_:EventItem = null;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         var _loc14_:Sprite = null;
         var _loc15_:TextField = null;
         var _loc16_:Number = NaN;
         var _loc17_:TextField = null;
         eventItems = [];
         var _loc5_:String = null;
         var _loc6_:Sprite = new Sprite();
         var _loc7_:Number = 0;
         var _loc8_:Number = 3;
         _loc6_.graphics.lineStyle(0,16777215,0.05);
         _loc6_.graphics.moveTo(0,0);
         _loc6_.graphics.lineTo(20,0);
         var _loc9_:Boolean = true;
         for each(_loc10_ in param2)
         {
            _loc11_ = new EventItem(param1,_loc10_,_loc9_,param4,eventItemWidth);
            _loc11_.addEventListener(MouseEvent.CLICK,onSelectedItem);
            _loc11_.addEventListener(MouseEvent.CLICK,param3);
            _loc9_ = false;
            _loc12_ = _loc11_.getBounds(_loc11_).height;
            eventItems.push(_loc11_);
            _loc13_ = _loc11_.dateString;
            if(_loc5_ != _loc13_)
            {
               trace("-----------");
               _loc14_ = new Sprite();
               _loc15_ = new TextField();
               _loc15_.autoSize = TextFieldAutoSize.LEFT;
               _loc15_.background = false;
               _loc15_.border = false;
               _loc15_.text = MessageBundle.msg(_loc11_.dayOfWeek);
               _loc15_.setTextFormat(new TextFormat("Arial",11,4019299,true));
               _loc14_.addChild(_loc15_);
               _loc16_ = _loc14_.getBounds(_loc14_).right;
               _loc17_ = new TextField();
               _loc17_.autoSize = TextFieldAutoSize.LEFT;
               _loc17_.background = false;
               _loc17_.border = false;
               _loc17_.text = " " + _loc11_.dayOfMonth + " " + MessageBundle.msg(_loc11_.month) + ", " + MessageBundle.msg(_loc11_.year);
               _loc17_.setTextFormat(new TextFormat("Arial",11,7829367,true));
               _loc17_.x = _loc16_ - 2;
               _loc14_.addChild(_loc17_);
               _loc14_.y = _loc8_ + 2;
               _loc6_.addChild(_loc14_);
               _loc6_.graphics.lineStyle(0,14803425,1);
               _loc6_.graphics.moveTo(2,_loc8_ + 18);
               _loc6_.graphics.lineTo(eventItemWidth,_loc8_ + 18);
               _loc8_ += 26;
            }
            _loc5_ = _loc13_;
            _loc11_.y = _loc8_;
            _loc6_.addChild(_loc11_);
            _loc8_ += _loc12_ + 3;
         }
         _loc6_.graphics.lineStyle(0,16777215,0.05);
         _loc6_.graphics.moveTo(0,_loc8_);
         _loc6_.graphics.lineTo(20,_loc8_);
         aSp.source = _loc6_;
         aSp.verticalScrollPolicy = _loc8_ > aSp.height ? ScrollPolicy.ON : ScrollPolicy.OFF;
      }
      
      internal function scrollToTop() : void
      {
         if(aSp != null)
         {
            aSp.verticalScrollPosition = 0;
         }
      }
   }
}


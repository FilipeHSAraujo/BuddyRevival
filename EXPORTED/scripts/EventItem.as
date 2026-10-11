package
{
   import fl.controls.*;
   import fl.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class EventItem extends Sprite
   {
      
      private static var today:Date = new Date();
      
      public var month:String;
      
      private const DaysOfWeek:Array;
      
      public var animId:String;
      
      private const HIDDEN_USER:String = "[Error loading user name]";
      
      public var isMoodChange:Boolean;
      
      private const Months:Array;
      
      public var fromUser:String;
      
      public var dateString:String;
      
      public var dayOfWeek:String;
      
      public var toUser:String;
      
      public var dayOfMonth:Number;
      
      private var eventHighlight:Shape;
      
      public var year:String;
      
      public function EventItem(param1:String, param2:*, param3:Boolean, param4:Dictionary, param5:Number)
      {
         var _loc7_:DisplayObject = null;
         var _loc18_:* = undefined;
         var _loc19_:String = null;
         DaysOfWeek = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
         Months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
         eventHighlight = new Shape();
         super();
         animId = param2.a;
         fromUser = param2["fr"];
         toUser = param2["to"];
         var _loc6_:String = "";
         isMoodChange = animId.indexOf("m_") == 0;
         if(toUser == null)
         {
            toUser = param1;
         }
         if(fromUser == null)
         {
            fromUser = param1;
         }
         var _loc8_:* = param4[fromUser];
         var _loc9_:String = _loc8_ != null ? _loc8_.userName : HIDDEN_USER;
         var _loc10_:Boolean = _loc8_ != null ? Boolean(_loc8_.userIsFemale) : false;
         if(isMoodChange)
         {
            _loc7_ = MoodSelectionPanel.getIcon(animId);
            _loc6_ = MoodSelectionPanel.getEventHistory(animId,_loc9_,null,_loc10_);
         }
         else
         {
            _loc7_ = PokeSelectionPanel.getIcon(animId);
            _loc18_ = param4[toUser];
            _loc19_ = _loc18_ != null ? _loc18_.userName : HIDDEN_USER;
            _loc6_ = PokeSelectionPanel.getEventHistory(animId,_loc9_,_loc19_);
         }
         addChild(eventHighlight);
         var _loc11_:Sprite = new Sprite();
         if(_loc7_ != null)
         {
            _loc11_.addChild(_loc7_);
         }
         _loc11_.buttonMode = true;
         _loc11_.useHandCursor = true;
         var _loc12_:int = int(param2.t);
         var _loc13_:Date = BuddyPoke.timeStampToLocalDate(_loc12_);
         dayOfMonth = _loc13_.getDate();
         dateString = _loc13_.toDateString();
         dayOfWeek = DaysOfWeek[_loc13_.day];
         month = Months[_loc13_.month];
         year = _loc13_.fullYear.toString();
         if(today.getDate() == dayOfMonth && today.month == _loc13_.month && today.fullYear == _loc13_.fullYear)
         {
            dayOfWeek = "Today";
         }
         var _loc14_:Number = 0;
         _loc11_.x = 5;
         addChild(_loc11_);
         mouseChildren = false;
         useHandCursor = true;
         buttonMode = true;
         var _loc15_:Sprite = new Sprite();
         var _loc16_:TextField = new TextField();
         _loc16_.autoSize = TextFieldAutoSize.LEFT;
         _loc16_.width = param5 - 32;
         _loc16_.background = false;
         _loc16_.border = false;
         _loc16_.selectable = false;
         _loc16_.htmlText = _loc6_;
         _loc16_.multiline = true;
         _loc16_.wordWrap = true;
         _loc16_.setTextFormat(new TextFormat("Arial",11,13209,true));
         _loc15_.addChild(_loc16_);
         _loc15_.x = _loc11_.x + 20;
         _loc15_.y = _loc11_.y;
         addChild(_loc15_);
         var _loc17_:Number = _loc15_.getBounds(_loc15_).height + 2;
         graphics.lineStyle(undefined,0);
         graphics.beginFill(16775639,0);
         graphics.drawRoundRectComplex(16,-2,param5 + 2,_loc17_,4,3,3,3);
         graphics.endFill();
         eventHighlight.graphics.lineStyle(0,14862370,1);
         eventHighlight.graphics.beginFill(16119285,1);
         eventHighlight.graphics.drawRoundRectComplex(1,-2,param5 - 3,_loc17_,4,3,3,3);
         eventHighlight.graphics.endFill();
         eventHighlight.visible = param3;
         _loc11_.y = (_loc17_ - 16) * 0.5 - 2;
      }
      
      public function get selected() : Boolean
      {
         return eventHighlight.visible;
      }
      
      public function set selected(param1:Boolean) : void
      {
         eventHighlight.visible = param1;
      }
   }
}


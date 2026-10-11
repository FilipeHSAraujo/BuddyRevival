package
{
   import com.buddylabs.player.*;
   import events.PokeEvent;
   import fl.containers.ScrollPane;
   import fl.controls.*;
   import fl.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class PokeSelectionPanel extends Sprite
   {
      
      public static var TWO_COLS:Boolean = false;
      
      public static var COL_OFFSET:Number = 0;
      
      public static const Anims:XML = <anims def="standBreathe">

<anim id="bhug" name="bear hug" action="bear&#10;hugged" desc="Give % a bear hug" hist="%1 gave %2 a bear hug" a0="bearHug1" a1="bearHug2" snap="80" pronoun="you"/>
<anim id="hug" name="hug" action="hugged" desc="Give % a hug" hist="%1 gave %2 a hug" a0="hug1" a1="hug2" snap="40" pronoun="you"/>

<anim id="bkss" name="blow kiss" action="blew a&#10;kiss at" desc="Blow a kiss at %" hist="%1 blew a kiss at %2" a0="blowKiss1" a1="blowKiss2" snap="45" pronoun="you"/>
<anim id="kiss" name="kiss" action="kissed" desc="Kiss %" hist="%1 kissed %2" a0="kiss1" a1="kiss2" snap="80" pronoun="you"/>
<anim id="ckss" name="cheek kiss" action="kissed on&#10;the cheek" desc="Give % a kiss on the cheek" hist="%1 kissed %2 on the cheek" a0="kissCheek1" a1="kissCheek2" snap="66" pronoun="you"/>
<anim id="rose" name="give a rose" action="gave a&#10;rose" desc="Give % a rose" hist="%1 gave a rose to %2" a0="rose1" a1="rose2" snap="37" pronoun="you"/>
<anim id="nose" name="rub noses" action="rubbed&#10;noses" desc="Rub noses with %" hist="%1 rubbed noses with %2" a0="rubNoses1" a1="rubNoses2" snap="55" pronoun="you"/>
<anim id="hlhd" name="hold hands" action="held&#10;hands" desc="Hold hands with %" hist="%1 held hands with %2" a0="holdHands1" a1="holdHands2" snap="80" pronoun="you"/>

<anim id="goss" name="gossip" action="gossiped " desc="Gossip with %" hist="%1 gossiped with %2" a0="gossip1" a1="gossip2" snap="80" pronoun="you"/>
<anim id="cele" name="celebrate" action="celebrated" desc="Celebrate with %" hist="%1 celebrated with %2" a0="celebrate1" a1="celebrate2" snap="18" pronoun="you"/>
<anim id="gfve" name="gimme five" action="high five" desc="High five %" hist="%1 gave %2 a high five" a0="gimmeFive1" a1="gimmeFive2" snap="69" pronoun="you"/>
<anim id="hten" name="high ten" action="high ten" desc="High ten %" hist="%1 gave %2 a high ten" a0="highTen1" a1="highTen2" snap="35" pronoun="you"/>
<anim id="hshk" name="handshake" action="shook hands" desc="Shake hands with %" hist="%1 shook hands with %2" a0="handshake1" a1="handshake2" snap="80" pronoun="you"/>
<anim id="hhug" name="handshake hug" action="handshake&#10;hugged" desc="Give % a handshake hug" hist="%1 gave %2 a handshake hug" a0="handshakeHug1" a1="handshakeHug2" snap="90" pronoun="you"/>
<anim id="cake" name="patty cake" action="played&#10;patty cake" desc="Play patty cake with %" hist="%1 played patty cake with %2" a0="pattyCakes1" a1="pattyCakes2" snap="38" pronoun="you"/>
<anim id="tick" name="tickle" action="tickled" desc="Tickle %" hist="%1 tickled %2" a0="tickle1" a1="tickle2" snap="65" pronoun="you"/>
<anim id="wave" name="wave" action="waved at" desc="Wave at %" hist="%1 waved at %2" a0="waveAt1" a1="waveAt2" snap="80" pronoun="you"/>

<anim id="bhps" name="bump hips" action="bumped&#10;hips" desc="Bump hips with %" hist="%1 bumped hips with %2" a0="hipBump1" a1="hipBump2" snap="15" pronoun="you"/>
<anim id="idol" name="idolize" action="idolized" desc="Idolize %" hist="%1 idolized %2" a0="idolize1" a1="idolize2" snap="24" pronoun="you"/>
<anim id="kick" name="kick" action="kicked" desc="Give % a kick" hist="%1 kicked %2" a0="kick1" a1="kick2" snap="31" pronoun="you"/>
<anim id="mock" name="mock" action="mocked" desc="Mock %" hist="%1 mocked %2" a0="mock1" a1="mock2" snap="45" pronoun="you"/>
<anim id="poke" name="poke" action="poked" desc="Give % a poke" hist="%1 poked %2" a0="poke1" a1="poke2" snap="28" pronoun="you"/>
<anim id="pnch" name="punch" action="punched" desc="Punch %" hist="%1 punched %2" a0="punch1" a1="punch2" snap="29" pronoun="you"/>
<anim id="sbtt" name="slap butt" action="slapped" desc="Slap %'s butt" hist="%1 slapped %2's butt" a0="slapButt1" a1="slapButt2" snap="30" pronoun="your"/>
<anim id="sfce" name="slap face" action="slapped" desc="Slap %'s face" hist="%1 slapped %2's face" a0="slapFace1" a1="slapFace2" snap="37" pronoun="your"/>



<anim id="swrd" name="sword fight" action="fought" desc="Fight %" hist="%1 fought %2" a0="swordA1" a1="swordA2" snap="37" pronoun="you"/>

<anim id="jam1" name="rock out" action="rocked out" desc="Rock out with %" hist="%1 and %2 rocked out" a0="jamA1" a1="jamA2" snap="37" pronoun="you"/>
<anim id="jam2" name="rock stars" action="rock stars" desc="Rock out with %" hist="%1 and %2 are rock stars" a0="jamB1" a1="jamB2" snap="37" pronoun="you"/>


</anims>;
      
      private var _selected:String = null;
      
      private var aSp:ScrollPane = new ScrollPane();
      
      public function PokeSelectionPanel(param1:int, param2:int, param3:int, param4:int)
      {
         super();
         this.x = param1;
         this.y = param2;
         var _loc5_:int = param3;
         var _loc6_:int = param4;
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
      
      public static function getEventHistory(param1:String, param2:String = null, param3:String = null, param4:String = null, param5:String = null) : String
      {
         var hist:String = null;
         var pokeId:String = param1;
         var name1:String = param2;
         var name2:String = param3;
         var url1:String = param4;
         var url2:String = param5;
         hist = Anims.anim.(@id == pokeId).@hist;
         if(name1 == null)
         {
            return hist;
         }
         hist = MessageBundle.msg(hist);
         if(name2 == null)
         {
            hist = hist.replace("%2\'s","%2");
            name2 = Anims.anim.(@id == pokeId).@pronoun;
         }
         if(url1 != null && url2 != null)
         {
            hist = hist.replace("%1","<a href=\'" + url1 + "\'>" + name1 + "</a>");
            hist = hist.replace("%2","<a href=\'" + url2 + "\'>" + name2 + "</a>");
            return hist;
         }
         hist = hist.replace("%1",name1);
         hist = hist.replace("%2",name2);
         return hist;
      }
      
      public static function getDesc(param1:String) : String
      {
         var pokeId:String = param1;
         return MessageBundle.msg(Anims.anim.(@id == pokeId).@desc);
      }
      
      public static function getName(param1:String) : String
      {
         var pokeId:String = param1;
         return MessageBundle.msg(Anims.anim.(@id == pokeId).@name);
      }
      
      public static function getEventIconUrl(param1:String) : String
      {
         var a0:String = null;
         var pokeId:String = param1;
         a0 = Anims.anim.(@id == pokeId).@a0;
         a0 = "anim_" + a0.replace("1","");
         return Icons.baseIconUrl + a0 + ".gif";
      }
      
      public static function getIcon(param1:String) : DisplayObject
      {
         var a0:String = null;
         var cl:Class = null;
         var pokeId:String = param1;
         a0 = Anims.anim.(@id == pokeId).@a0;
         a0 = "anim_" + a0.replace("1","");
         cl = Icons[a0 + "Class"];
         if(cl == null)
         {
            return null;
         }
         return new cl();
      }
      
      private function onSelectedPoke(param1:MouseEvent) : void
      {
         var _loc2_:BRadioButton = BRadioButton(param1.target);
         var _loc3_:String = _loc2_.data;
         _selected = _loc3_;
         dispatchEvent(new PokeEvent(PokeEvent.SELECT_POKE,_loc3_));
      }
      
      internal function loadPokes(param1:SceneObject) : void
      {
         var _loc11_:XML = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:BRadioButton = null;
         var _loc16_:Class = null;
         var _loc17_:Label = null;
         var _loc18_:DisplayObject = null;
         var _loc2_:Sprite = new Sprite();
         var _loc3_:int = 15;
         var _loc4_:int = 82;
         var _loc5_:int = 10 + COL_OFFSET;
         var _loc6_:Boolean = true;
         var _loc7_:XMLList = Anims.anim;
         var _loc8_:int = 0;
         var _loc9_:int = TWO_COLS ? 2 : 1;
         var _loc10_:int = 0;
         for each(_loc11_ in _loc7_)
         {
            _loc12_ = _loc11_.@id;
            _loc13_ = _loc11_.@name;
            _loc14_ = _loc11_.@a0;
            _loc15_ = new BRadioButton(_loc12_);
            _loc15_.groupName = "poke_group";
            _loc15_.label = "";
            _loc15_.selected = _loc6_;
            _loc6_ = false;
            _loc15_.addEventListener(MouseEvent.CLICK,onSelectedPoke);
            _loc15_.x = _loc5_ + _loc10_;
            _loc15_.y = _loc3_;
            _loc15_.width = 20;
            _loc15_.height = 20;
            _loc2_.addChild(_loc15_);
            _loc16_ = Icons["anim_" + _loc14_.replace("1","") + "Class"];
            if(_loc16_ != null)
            {
               _loc18_ = new _loc16_();
               if(_loc18_ != null)
               {
                  _loc18_.x = _loc5_ + 27 + _loc10_;
                  _loc18_.y = _loc3_ + 2;
                  _loc2_.addChild(_loc18_);
               }
            }
            _loc17_ = new Label();
            _loc17_.htmlText = "<font face=\'Arial\' color=\'#222222\' size=\'12px\'>" + MessageBundle.msg(_loc13_) + "</font>";
            _loc17_.x = _loc5_ + 51 + _loc10_;
            _loc17_.y = _loc3_ + 2;
            _loc17_.textField.autoSize = TextFieldAutoSize.LEFT;
            _loc17_.height = 20;
            _loc2_.addChild(_loc17_);
            _loc8_++;
            _loc10_ += 180;
            if(_loc8_ == _loc9_)
            {
               _loc3_ += 28;
               _loc8_ = 0;
               _loc10_ = 0;
            }
         }
         aSp.source = _loc2_;
      }
      
      public function get animsXML() : XML
      {
         return Anims;
      }
      
      internal function get selected() : String
      {
         if(_selected != null)
         {
            return _selected;
         }
         return Anims.anim[0].@id;
      }
   }
}


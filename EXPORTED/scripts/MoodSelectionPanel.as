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
   
   public class MoodSelectionPanel extends Sprite
   {
      
      public static const ERROR_MOOD_ID:String = "m_rjct";
      
      public static const POKE_FRIEND_SELECTOR_ID:String = "m_bonc";
      
      public static var TWO_COLS:Boolean = false;
      
      public static var COL_OFFSET:Number = 0;
      
      public static const Moods:XML = <moods>
  <mood id="m_hppy" name="happy" desc="% is happy" hist="% is feeling happy" a0="mood_happy" icon="mood_happy"/>
  <mood id="m_bshf" name="bashful" desc="% is bashful" hist="% is feeling bashful" a0="mood_bashful" icon="mood_bashful"/>
  <mood id="m_nluv" name="in love" desc="% is in love" hist="% is in love" a0="mood_inLove" icon="mood_inLove"/>
  <mood id="m_lkfl" name="looking for love" desc="% is looking for love" hist="% is looking for love" a0="mood_lookingForLove" icon="mood_lookingForLove"/>  
  <mood id="m_gigl" name="giggly" desc="% is feeling giggly" hist="% is feeling giggly" a0="mood_giggle" icon="mood_giggly"/>
  <mood id="m_bonc" name="bouncy" desc="% is bouncy" hist="% is feeling bouncy" a0="mood_gonnaSoarNow" icon="mood_bouncy"/>
  <mood id="m_exci" name="excited" desc="% is excited" hist="% is feeling excited" a0="celebrate1" icon="anim_celebrate"/>

  <mood id="m_hope" name="hopeful" desc="% is hopeful" hist="% is feeling hopeful" a0="pose_joinNow" icon="mood_hopeful"/>
  <mood id="m_medt" name="meditating" desc="% is meditating" hist="% is meditating" a0="mood_meditative" icon="mood_meditative"/>
  <mood id="m_sexy" name="sexy" desc="% is sexy" hist="% is sexy" a0="pose_stand_model" icon="mood_sexy"/>
  <mood id="m_lkgd" name="looking good" desc="% is looking good" hist="% is looking good" a0="pose_contra_lookFeet" icon="mood_lookingGood"/>
  <mood id="m_ostm" name="overstimulated" desc="% is overstimulated" hist="% is feeling overstimulated" a0="pose_contra_attention" icon="mood_overstimulated"/>
  <mood id="m_fab" name="fabulous" desc="% is fabulous" hist="% is feeling fabulous" a0="pose_contra_bow" icon="mood_fabulous"/>
  <mood id="m_fit" name="fit" desc="% is fit" hist="% is feeling fit" a0="pose_stand_stretch" icon="anim_kick"/>
  <mood id="m_sens" name="sensational" desc="% is sensational" hist="% is feeling sensational" a0="pose_contra_canCan" icon="mood_fabulous"/>

  <mood id="m_frsk" name="frisky" desc="% is frisky" hist="% is feeling frisky" a0="blowKiss1" icon="anim_blowKiss"/>
  <mood id="m_smit" name="smitten" desc="% is smitten" hist="% is feeling smitten" a0="idolize1" icon="mood_happy"/>
  <mood id="m_chky" name="cheeky" desc="% is cheeky" hist="% is feeling cheeky" a0="mock1" icon="mood_sexy"/>
  <mood id="m_hpcu" name="happy to see you" desc="% is happy to see you" hist="% is happy to see you" a0="waveAt1" icon="anim_waveAt"/>
  <mood id="m_ttth" name="talk to the hand" desc="% is talk to the hand!" hist="% is talk to the hand!" a0="mood_talkToHand" icon="anim_gimmeFive"/>
  <mood id="m_flyn" name="flying high" desc="% is flying high" hist="% is flying high" a0="mood_flying" icon="mood_flying"/>

  <mood id="m_tire" name="tired" desc="% is tired" hist="% is feeling tired" a0="mood_tired" icon="mood_tired"/>
  <mood id="m_drng" name="dreaming" desc="% is dreaming" hist="% is dreaming" a0="mood_dreaming" icon="mood_dreaming"/>  
  <mood id="m_slpg" name="sleeping" desc="% is sleeping" hist="% is sleeping" a0="mood_sleeping" icon="mood_sleeping"/>  
  <mood id="m_bord" name="bored" desc="% is bored" hist="% is bored" a0="mood_bored" icon="mood_bored"/>

  <mood id="m_impa" name="impatient" desc="% is feeling impatient" hist="% is feeling impatient" a0="mood_impatient" icon="mood_impatient"/>  
  <mood id="m_conf" name="confused" desc="% is feeling confused" hist="% is feeling confused" a0="mood_confused" icon="mood_confused"/>  

  <mood id="m_cryn" name="crying" desc="% is crying" hist="% is crying" a0="mood_cry" icon="mood_sad"/>
  <mood id="m_terr" name="terrified" desc="% is terrified" hist="% is terrified" a0="mood_terrified" icon="mood_terrified"/>
  <mood id="m_sad" name="sad" desc="% is sad" hist="% is feeling sad" a0="mood_sad" icon="mood_sad"/>
  <mood id="m_rjct" name="rejected" desc="% is rejected" hist="% is feeling rejected" a0="mock2" icon="mood_sad"/>
  <mood id="m_angr" name="angry" desc="% is angry" hist="% is feeling angry" a0="mood_angry" icon="mood_angry"/>
  <mood id="m_evil" name="evil" desc="% is feeling evil" hist="% is feeling evil" a0="mood_evil" icon="mood_evil"/>
  <mood id="m_snky" name="sneaky" desc="% is feeling sneaky" hist="% is feeling sneaky" a0="mood_sneaky" icon="mood_sneaky"/>  
  <mood id="m_zomb" name="a zombie" desc="% is feeling like a zombie" hist="% is feeling like a zombie" a0="mood_zombie" icon="mood_zombie"/>
  <mood id="m_kfkd" name="Kung Fu Kid" desc="% is Kung Fu Kid" hist="% is the Kung Fu Kid" a0="kick1" icon="mood_kungFuKid"/>


<mood id="m_swrd" name="Sword Master" desc="% is a Sword Master" hist="% is a Sword Master" a0="mood_swordTwirl" icon="mood_swordTwirl"/>  
<mood id="m_jam1" name="Rock Star" desc="% is a Rock Star" hist="% is a Rock Star" a0="jamA1" icon="anim_jamA"/>
<mood id="m_jam2" name="Guitar Vigilante" desc="% is a Guitar Vigilante" hist="% is a Guitar Vigilante" a0="jamB2" icon="anim_jamB"/>



  
</moods>;
      
      private var _selected:String = null;
      
      private var aSp:ScrollPane = new ScrollPane();
      
      public function MoodSelectionPanel(param1:int, param2:int, param3:int, param4:int)
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
      
      public static function getAnimId(param1:String) : String
      {
         var mood:XML = null;
         var moodId:String = param1;
         mood = Moods.mood.(@id == moodId)[0];
         if(mood == null)
         {
            return null;
         }
         return mood.@a0;
      }
      
      public static function getDesc(param1:String, param2:Boolean) : String
      {
         var moodId:String = param1;
         var userIsFemale:Boolean = param2;
         return MessageBundle.msg(Moods.mood.(@id == moodId).@desc,userIsFemale);
      }
      
      public static function getIcon(param1:String) : DisplayObject
      {
         var icon:String = null;
         var cl:Class = null;
         var moodId:String = param1;
         icon = Moods.mood.(@id == moodId).@icon;
         cl = Icons[icon + "Class"];
         if(cl == null)
         {
            return null;
         }
         return new cl();
      }
      
      public static function getEventHistory(param1:String, param2:String = null, param3:String = null, param4:Boolean = false) : String
      {
         var hist:String = null;
         var moodId:String = param1;
         var name:String = param2;
         var url:String = param3;
         var userIsFemale:Boolean = param4;
         hist = Moods.mood.(@id == moodId).@hist;
         hist = MessageBundle.msg(hist,userIsFemale);
         if(name == null)
         {
            return hist;
         }
         if(url != null)
         {
            hist.replace("%","<a href=\'" + url + "\'>" + name + "</a>");
            return hist;
         }
         hist = hist.replace("%",name);
         return hist;
      }
      
      public static function getEventIconUrl(param1:String) : String
      {
         var icon:String = null;
         var moodId:String = param1;
         icon = Moods.mood.(@id == moodId).@icon;
         return Icons.baseIconUrl + icon + ".gif";
      }
      
      private function onSelectedMood(param1:MouseEvent) : void
      {
         var _loc2_:BRadioButton = BRadioButton(param1.target);
         var _loc3_:String = _loc2_.data;
         _selected = _loc3_;
         dispatchEvent(new PokeEvent(PokeEvent.SELECT_POKE,_loc3_));
      }
      
      public function get moodsXML() : XML
      {
         return Moods;
      }
      
      internal function loadMoods(param1:SceneObject, param2:BuddyPokeUser) : void
      {
         var _loc13_:XML = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:BRadioButton = null;
         var _loc18_:String = null;
         var _loc19_:Class = null;
         var _loc20_:Label = null;
         var _loc21_:DisplayObject = null;
         var _loc3_:Sprite = new Sprite();
         var _loc4_:int = 15;
         var _loc5_:int = 82;
         var _loc6_:int = 10 + COL_OFFSET;
         var _loc7_:Boolean = true;
         var _loc8_:XMLList = Moods.mood;
         var _loc9_:int = 0;
         var _loc10_:int = TWO_COLS ? 2 : 1;
         var _loc11_:int = 0;
         var _loc12_:Boolean = param2 == null ? false : param2.userIsFemale;
         for each(_loc13_ in _loc8_)
         {
            _loc14_ = _loc13_.@id;
            _loc15_ = _loc13_.@name;
            _loc16_ = _loc13_.@a0;
            _loc17_ = new BRadioButton(_loc14_);
            _loc17_.groupName = "mood_group";
            _loc17_.label = "";
            _loc17_.selected = _loc7_;
            _loc7_ = false;
            _loc17_.addEventListener(MouseEvent.CLICK,onSelectedMood);
            _loc17_.x = _loc6_ + _loc11_;
            _loc17_.y = _loc4_;
            _loc17_.width = 20;
            _loc17_.height = 20;
            _loc3_.addChild(_loc17_);
            _loc18_ = _loc13_.@icon;
            _loc19_ = Icons[_loc18_ + "Class"];
            if(_loc19_ != null)
            {
               _loc21_ = new _loc19_();
               if(_loc21_ != null)
               {
                  _loc21_.x = _loc6_ + 27 + _loc11_;
                  _loc21_.y = _loc4_ + 2;
                  _loc3_.addChild(_loc21_);
               }
            }
            _loc20_ = new Label();
            _loc20_.htmlText = "<font face=\'Arial\' color=\'#222222\' size=\'12px\'>" + MessageBundle.msg(_loc15_,_loc12_) + "</font>";
            _loc20_.x = _loc6_ + 51 + _loc11_;
            _loc20_.y = _loc4_ + 2;
            _loc20_.textField.autoSize = TextFieldAutoSize.LEFT;
            _loc20_.height = 20;
            _loc3_.addChild(_loc20_);
            _loc9_++;
            _loc11_ += 180;
            if(_loc9_ == _loc10_)
            {
               _loc4_ += 28;
               _loc9_ = 0;
               _loc11_ = 0;
            }
         }
         aSp.source = _loc3_;
      }
      
      internal function get selected() : String
      {
         if(_selected != null)
         {
            return _selected;
         }
         return Moods.mood[0].@id;
      }
   }
}


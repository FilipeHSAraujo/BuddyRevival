package
{
   import com.adobe.serialization.json.JSON;
   import com.buddylabs.player.*;
   import events.PokeEvent;
   import fl.controls.*;
   import fl.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.filters.ConvolutionFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   import gadgets.io.*;
   import org.aswing.image.png.AsPngEncoder;
   import org.aswing.image.png.Strategy8BitMedianCutAlpha;
   
   public class BuddyPokeOS extends BuddyPoke
   {
      
      public static var OPEN_SOCIAL_MODE:String = "opensocial_surface";
      
      private var savePokeHolder:Sprite;
      
      private var SHOW_HEADER:Boolean = false;
      
      private var viewer:OSUser;
      
      private var userData:*;
      
      private var pokeFriendHolder:Sprite;
      
      private var pokeEventsUI:Sprite;
      
      private const SAVING_POKE_ERROR:String = "We\'re sorry, there was an error saving your poke.";
      
      private var pokeBackLink:Sprite;
      
      private var pokeTitleTextField:TextField;
      
      private var HOLDER_PADDING:Number = 6;
      
      private var moodSelectionHolder:Sprite;
      
      private var eventHistorySelectionHolder:Sprite;
      
      private var canvasBackgroundClass:Class;
      
      private var saveMoodRetryCount:int = 0;
      
      private var savePokeRetryCount:int = 0;
      
      private var owner:OSUser;
      
      private var shareBuddyHolder:Sprite;
      
      private var userDictionary:Dictionary;
      
      private var domain:String;
      
      private var viewerUserContent:String;
      
      private var saveAppearanceHolder:Sprite;
      
      private var viewerId:String;
      
      private var saveMoodEpoch:int;
      
      private const BASE_URL:String = "http://buddypokeapp.appspot.com/";
      
      private var saveMoodHolder:Sprite;
      
      private var selectedMoodId:String = "m_hppy";
      
      private const SAVING_APPEARANCE_ERROR:String = "We\'re sorry, there was an error saving your appearance.";
      
      private const SAVING_MOOD_ERROR:String = "We\'re sorry, there was an error saving your mood.";
      
      private var buddyPanelScale:Sprite;
      
      private var NUMBER_ROWS:int = 2;
      
      private var selectedPokeId:String = "bhug";
      
      private var HEADER_HEIGHT:Number = 70;
      
      private var loadingMessage:TextField;
      
      private var pokeLink:Sprite;
      
      private const MAX_NUM_RETRY:int = 1;
      
      private var HOLDER_POSITION_X:Number = 0;
      
      private var HOLDER_POSITION_Y:Number;
      
      private var SELECTION_PANEL_WIDTH:Number = 400;
      
      private var shareAnimPicker:BTexturePicker;
      
      private const HIDDEN_USER:String = "[Error loading user name]";
      
      private var appearanceSelectionHolder:Sprite;
      
      private var pokeFromUser:OSUser;
      
      private var viewerSig:String;
      
      private var lastPokedFromUserId:String;
      
      private var errorMessageHolder:Sprite;
      
      private var saveBuddyRetryCount:int = 0;
      
      private var savePokeEpoch:int;
      
      private var shareBuddyCodeTextField:TextField;
      
      private var loadEventUsersRetryCount:int = 0;
      
      private var ACTION_LINK_Y:Number = 180;
      
      private var pokeSelectionHolder:Sprite;
      
      private var saveIconRetryCount:int = 0;
      
      private var eventHistoryPanel:EventHistoryPanel;
      
      private var CONTAINER_ID:String = "orkut";
      
      private const LOADING_PROFILE_ERROR:String = "We\'re sorry, there was an error loading your buddy.";
      
      private var viewerRetryCnt:int;
      
      private var showingEvent:EventItem = null;
      
      private var HOLDER_POSITION_OFFSET:Number = 10;
      
      private const LOADING_YOUR_ERROR:String = "We\'re sorry, there was an error loading your buddy.";
      
      private var viewerPolicy:String;
      
      private var pokeToUser:OSUser;
      
      private var saveAppearanceRetryCount:int = 0;
      
      private var pokeBackHolder:Sprite;
      
      private var iconDictionary:Dictionary;
      
      private var pokeFriendsPageHolder:Sprite;
      
      private var canvasBackgroundLib:EmbeddedLibrary;
      
      public function BuddyPokeOS()
      {
         var paramObj:Object = null;
         var buddy:String = null;
         var anim:String = null;
         var s:String = null;
         var dummy1:* = undefined;
         var dummy2:* = undefined;
         HOLDER_POSITION_Y = 236 + 50 + 50;
         userDictionary = new Dictionary();
         iconDictionary = new Dictionary();
         buddyPanelScale = new Sprite();
         canvasBackgroundClass = BuddyPokeOS_canvasBackgroundClass;
         savePokeEpoch = timeStamp();
         pokeTitleTextField = new TextField();
         saveMoodEpoch = timeStamp();
         super();
         paramObj = LoaderInfo(this.root.loaderInfo).parameters;
         domain = paramObj["opensocial_domain"];
         if(domain != null)
         {
            if(domain.indexOf("hi5") >= 0)
            {
               OSUser.domain = "hi5.com";
               CONTAINER_ID = "hi5";
               Security.loadPolicyFile("http://www.a.hi5modules.com/crossdomain.xml");
               Security.loadPolicyFile("http://api.hi5.com/crossdomain.xml");
            }
            else if(domain.indexOf("orkut") >= 0)
            {
               OSUser.domain = "orkut.com";
               CONTAINER_ID = "orkut";
            }
            else if(domain.indexOf("netlog") >= 0)
            {
               OSUser.domain = "netlog.com";
               CONTAINER_ID = "netlog";
            }
            else if(domain.indexOf("myspace") >= 0)
            {
               domain = "myspace.com";
               OSUser.domain = "myspace.com";
               CONTAINER_ID = "myspace";
               Security.allowDomain("*");
               Security.loadPolicyFile("http://api.msappspace.com/crossdomain.xml");
               Security.loadPolicyFile("http://api.myspace.com/crossdomain.xml");
            }
         }
         initStageConsole();
         try
         {
            paramObj = LoaderInfo(this.root.loaderInfo).parameters;
            MessageBundle.init(paramObj["locale"]);
         }
         catch(e:*)
         {
         }
         if(paramObj["opensocial_surface"] != null && (paramObj["opensocial_surface"].indexOf("comment") >= 0 || paramObj["opensocial_surface"].indexOf("bulletin") >= 0))
         {
            buddy = paramObj["buddy"];
            anim = paramObj["anim"];
            this.addChild(new BulletinPreview(buddy,anim));
            return;
         }
         OSUser.console = console;
         SHOW_HEADER = false;
         if(SHOW_HEADER == false)
         {
            HOLDER_POSITION_Y = 236 + 50 + 50 - (HEADER_HEIGHT - 20);
            HEADER_HEIGHT = 0;
            HOLDER_POSITION_OFFSET = 10;
            ACTION_LINK_Y = 175;
         }
         console.y = HEADER_HEIGHT + 17;
         try
         {
            console.appendText("domain " + domain + "\n");
            for(s in paramObj)
            {
               console.appendText(s + " " + paramObj[s] + "\n");
            }
         }
         catch(error:Error)
         {
            console.appendText("error with params\n");
         }
         runLocal = null == paramObj["opensocial_surface"];
         if(runLocal)
         {
            CONTAINER_ID = "orkut";
            domain = "orkut.com";
            BuddyCache.CreateInstance(console,"local_hi5");
            console.appendText("runLocal\n");
            buddyPanelWidth = 346;
            buddyPanelHeight = 260;
            STAGE_WIDTH = 450;
            if(CONTAINER_ID == "netlog")
            {
               STAGE_WIDTH = 340;
               NUMBER_ROWS = 1;
               SELECTION_PANEL_WIDTH = 324;
            }
            HOLDER_POSITION_X = (STAGE_WIDTH - SELECTION_PANEL_WIDTH) * 0.5;
            viewerIsOwner = true;
            dummy1 = "{\"buddy\":\"" + Buddy.DEFAULT + "\",\"data\":{\"history\":[{\"a\":\"m_bshf\",\"t\":\"1207958396\",\"b\":\"\"},{\"a\":\"m_bonc\",\"t\":\"1207958256\",\"b\":\"\"},{\"a\":\"m_bshf\",\"t\":\"1207950328\",\"b\":\"\"},{\"a\":\"m_hppy\",\"t\":\"1207875927\",\"b\":\"\"},{\"a\":\"m_hpcu\",\"t\":\"1207875659\",\"b\":\"\"},{\"a\":\"gfve\",\"to\":\"364374213\",\"t\":\"1207875659\",\"b\":\"\"},{\"a\":\"hug\",\"fr\":\"364374213\",\"t\":\"1207875659\",\"b\":\"\"}]},\"pokeCnt\":\"0\",\"recCnt\":\"0\"}";
            dummy2 = "{\"buddy\":\"\",\"data\":{\"history\":[]},\"pokeCnt\":\"0\",\"recCnt\":\"0\"}";
            owner = new OSUser();
            owner.createDummy("93320646","&#39;Dave&#39;","male",dummy1);
            userDictionary[owner.userId] = owner;
            viewer = new OSUser();
            viewer.createDummy("364374213","Karen","female",dummy2);
            userDictionary[viewer.userId] = viewer;
            pokeFromUser = viewer;
            pokeToUser = owner;
            this.addChild(console);
            if(onHomePage)
            {
               onProfilePage = true;
            }
            initBuddy();
         }
         else
         {
            try
            {
               Security.allowDomain("*");
            }
            catch(e:*)
            {
            }
            try
            {
               Security.allowInsecureDomain("*");
            }
            catch(e:*)
            {
            }
            try
            {
               if(CONTAINER_ID == "myspace")
               {
                  BuddyCache.CreateInstance(console,"ms");
               }
               else
               {
                  BuddyCache.CreateInstance(console,"live");
               }
            }
            catch(e:*)
            {
            }
            if(getOpenSocialSurface() == "canvas")
            {
               if(CONTAINER_ID == "hi5")
               {
                  this.root.x = 225;
               }
               else if(CONTAINER_ID == "orkut")
               {
                  this.root.x = 185;
               }
               else if(CONTAINER_ID == "netlog")
               {
                  this.root.x = 75 + 60;
               }
               else if(CONTAINER_ID == "myspace")
               {
                  this.root.x = 255;
               }
               console.appendText("root.x " + root.x + "\n");
               loadCanvasBackground();
            }
            else if(CONTAINER_ID == "myspace")
            {
               NUMBER_ROWS = 1;
               if(getOpenSocialSurface() == "home")
               {
                  SELECTION_PANEL_WIDTH = 270;
               }
               else
               {
                  SELECTION_PANEL_WIDTH = 290;
               }
            }
            else if(getOpenSocialSurface() == "home" && CONTAINER_ID == "netlog")
            {
               STAGE_WIDTH = 340;
               NUMBER_ROWS = 1;
               SELECTION_PANEL_WIDTH = 324;
            }
            initGadget();
         }
      }
      
      internal function onSaveBuddyRequestError(param1:Event) : void
      {
         console.text = "onSaveBuddyRequestError\n";
      }
      
      private function gaTrackError(param1:String) : void
      {
         var id:String = null;
         var err:String = param1;
         if(CONTAINER_ID == "myspace")
         {
            return;
         }
         try
         {
            id = replaceNums(CONTAINER_ID);
            err = replaceNums(err);
            if(ExternalInterface.available)
            {
               ExternalInterface.call("_IG_Analytics","UA-4053252-1","/gadget/buddypoke/" + id + "/error/" + err);
            }
         }
         catch(e:*)
         {
         }
      }
      
      private function unescHtml(param1:String) : String
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            return param1;
         }
         var _loc3_:* = {
            "&lt;":"<",
            "&gt;":">",
            "&amp;":"&",
            "&quot;":"\""
         };
         for(_loc2_ in _loc3_)
         {
            param1 = param1.replace(new RegExp(_loc2_,"g"),_loc3_[_loc2_]);
         }
         return param1;
      }
      
      private function createPokeUI() : void
      {
         var pokeId:String;
         var title:String = null;
         var savingPokeLink:Sprite = null;
         var savingPokeProgress:MovieClip = null;
         var w:Number = NaN;
         var desc:String = null;
         var pokeDesc:String = null;
         hideUIPanels();
         paused = false;
         if(pokeSelectionHolder == null)
         {
            pokeSelectionHolder = new Sprite();
            PokeSelectionPanel.TWO_COLS = NUMBER_ROWS == 2;
            PokeSelectionPanel.COL_OFFSET = 8;
            pokeSelectionPanel = new PokeSelectionPanel(0,20,SELECTION_PANEL_WIDTH,150);
            pokeSelectionPanel.addEventListener(PokeEvent.SELECT_POKE,onSelectedPoke);
            pokeSelectionPanel.loadPokes(buddy1);
            pokeSelectionHolder.addChild(pokeSelectionPanel);
            w = pokeSelectionHolder.getBounds(pokeSelectionHolder).width;
            pokeSelectionHolder.x = HOLDER_POSITION_X;
            pokeSelectionHolder.y = HOLDER_POSITION_Y;
            drawHolderBackground(pokeSelectionHolder,SELECTION_PANEL_WIDTH,150);
            pokeTitleTextField.width = SELECTION_PANEL_WIDTH;
            pokeTitleTextField.height = 20;
            pokeTitleTextField.wordWrap = false;
            pokeTitleTextField.multiline = false;
            pokeTitleTextField.background = false;
            pokeTitleTextField.border = false;
            title = MessageBundle.msg("What would you like to do to, %?");
            title = title.replace("%",pokeToUser.userName);
            pokeTitleTextField.htmlText = title;
            pokeTitleTextField.setTextFormat(new TextFormat("Arial",11,4019299,true));
            pokeTitleTextField.x = 2;
            pokeSelectionHolder.addChild(pokeTitleTextField);
            desc = PokeSelectionPanel.Anims.anim[0].@desc;
            desc = MessageBundle.msg(desc,this.owner.userIsFemale);
            desc = desc.replace("%",pokeToUser.userName);
            pokeLink = createLink(desc,238,12,true,TextFieldAutoSize.CENTER,true,true);
            pokeLink.addEventListener(MouseEvent.CLICK,onSavePoke);
            pokeLink.x = 0.5 * SELECTION_PANEL_WIDTH;
            pokeLink.y = ACTION_LINK_Y;
            pokeSelectionHolder.addChild(pokeLink);
            savingPokeLink = createLink(MessageBundle.msg("Saving your poke..."),238,15,false,TextFieldAutoSize.CENTER,false);
            savingPokeLink.x = 0.5 * 266;
            savingPokeLink.y = 30;
            savePokeHolder = new Sprite();
            savePokeHolder.graphics.lineStyle(0,14862370,1);
            savePokeHolder.graphics.beginFill(16775639,1);
            savePokeHolder.graphics.drawRect(0,0,266,100);
            savePokeHolder.graphics.endFill();
            w = savePokeHolder.getBounds(savePokeHolder).width;
            savingPokeProgress = new UploadProgress();
            savingPokeProgress.x = (w - 28) * 0.5;
            savingPokeProgress.y = 60;
            savePokeHolder.addChild(savingPokeProgress);
            savePokeHolder.x = 0.5 * (STAGE_WIDTH - w);
            savePokeHolder.y = HOLDER_POSITION_Y + HOLDER_POSITION_OFFSET;
            savePokeHolder.addChild(savingPokeLink);
         }
         title = MessageBundle.msg("What would you like to do to, %?");
         title = title.replace("%",pokeToUser.userName);
         pokeTitleTextField.htmlText = title;
         pokeTitleTextField.setTextFormat(new TextFormat("Arial",11,4019299,true));
         pokeId = pokeSelectionPanel.selected;
         selectedPokeId = pokeId;
         try
         {
            if(pokeLink != null)
            {
               pokeDesc = PokeSelectionPanel.Anims.anim.(@id == pokeId).@desc;
               pokeDesc = MessageBundle.msg(pokeDesc,this.owner.userIsFemale);
               TextField(pokeLink.getChildAt(0)).htmlText = pokeDesc.replace("%",pokeToUser.userName);
            }
         }
         catch(e:*)
         {
         }
         buddy1.deserializeCompressed(pokeFromUser.buddyDesc);
         buddy2.deserializeCompressed(pokeToUser.buddyDesc);
         showPoke(pokeId,null,null);
         addChild(pokeSelectionHolder);
         stage.dispatchEvent(new Event(Event.RENDER));
      }
      
      private function logServerErrorResp(param1:*) : *
      {
      }
      
      private function createShareUI() : void
      {
         var placeHolder:Sprite = null;
         var label:TextField = null;
         var defaultMood:String = null;
         var yoffset:int = 0;
         var selAnim:DisplayObject = null;
         var textField:TextField = null;
         var tfWrapper:Sprite = null;
         var doneLink:Sprite = null;
         var moods:XMLList = null;
         var numMoods:int = 0;
         var m_hpcu:XML = null;
         var moodIndex:int = 0;
         var bmps:Array = null;
         var i:int = 0;
         var bmd:BitmapData = null;
         var icon:DisplayObject = null;
         var selectionPanelWidth:Number = 268;
         if(shareBuddyHolder == null)
         {
            shareBuddyHolder = new Sprite();
            drawHolderBackground(shareBuddyHolder,SELECTION_PANEL_WIDTH,180 + 25);
            shareBuddyHolder.x = HOLDER_POSITION_X;
            shareBuddyHolder.y = HOLDER_POSITION_Y;
            placeHolder = new Sprite();
            placeHolder.x = 55;
            shareBuddyHolder.addChild(placeHolder);
            label = new TextField();
            label.autoSize = TextFieldAutoSize.LEFT;
            label.background = false;
            label.border = false;
            label.selectable = false;
            if(CONTAINER_ID == "hi5" || CONTAINER_ID == "myspace")
            {
               label.text = MessageBundle.msg("Add a COMMENT to a friend\'s page:");
               label.setTextFormat(new TextFormat("Arial",13,5415884,true));
            }
            else if(CONTAINER_ID == "orkut")
            {
               label.text = MessageBundle.msg("Add your Buddy to a friend\'s scrapbook:");
               label.setTextFormat(new TextFormat("Arial",13,157596,true));
            }
            label.x = 10;
            label.y = 10;
            placeHolder.addChild(label);
            defaultMood = "m_hpcu";
            yoffset = 4;
            selAnim = createInstructionStep(MessageBundle.msg("1. Select an animation:"),11,10,35 + yoffset);
            placeHolder.addChild(selAnim);
            placeHolder.addChild(createInstructionStep(MessageBundle.msg("2. Copy your HTML code below"),11,10,60 + yoffset));
            textField = new TextField();
            textField.width = 220;
            textField.height = 20;
            textField.background = true;
            textField.backgroundColor = 16777215;
            textField.border = true;
            textField.borderColor = 460551;
            textField.multiline = false;
            textField.wordWrap = false;
            shareBuddyCodeTextField = textField;
            textField.text = createAddCommentTags(defaultMood);
            textField.addEventListener(MouseEvent.CLICK,onClickedBuddyShareCode);
            tfWrapper = new Sprite();
            tfWrapper.addChild(textField);
            tfWrapper.x = 25;
            tfWrapper.y = 80 + yoffset;
            placeHolder.addChild(tfWrapper);
            if(CONTAINER_ID == "hi5" || CONTAINER_ID == "myspace")
            {
               placeHolder.addChild(createInstructionStep(MessageBundle.msg("3. Go to your friend\'s profile page"),11,10,110 + yoffset));
               placeHolder.addChild(createInstructionStep(MessageBundle.msg("4. Click \'Add Comment\'. Paste the HTML code."),11,10,135 + yoffset));
            }
            else if(CONTAINER_ID == "orkut")
            {
               placeHolder.addChild(createInstructionStep(MessageBundle.msg("3. Go to your friend\'s scrapbook"),11,10,110 + yoffset));
               placeHolder.addChild(createInstructionStep(MessageBundle.msg("4. Paste the HTML code. Click \'post scrap\'."),11,10,135 + yoffset));
            }
            doneLink = createLink(MessageBundle.msg("Done"),238,13,true,TextFieldAutoSize.CENTER,true);
            doneLink.addEventListener(MouseEvent.CLICK,onDoneShare);
            doneLink.x = 0.5 * selectionPanelWidth;
            doneLink.y = ACTION_LINK_Y - 10;
            placeHolder.addChild(doneLink);
            moods = MoodSelectionPanel.Moods.mood;
            numMoods = int(moods.length());
            m_hpcu = moods.(@id == defaultMood)[0];
            moodIndex = int(m_hpcu.childIndex());
            this.showMood(defaultMood);
            bmps = new Array();
            i = 0;
            while(i < numMoods)
            {
               bmd = new BitmapData(16,16,false,16777215);
               icon = MoodSelectionPanel.getIcon(moods[i].@id);
               if(icon != null)
               {
                  bmd.draw(icon);
               }
               bmps[i] = new Bitmap(bmd);
               i++;
            }
            shareAnimPicker = new BTexturePicker(null);
            shareAnimPicker.width = 21;
            shareAnimPicker.height = 21;
            shareAnimPicker.bitmaps = bmps;
            shareAnimPicker.selectedColor = moodIndex;
            shareAnimPicker.x = 170;
            shareAnimPicker.y = 35 + yoffset;
            placeHolder.addChild(shareAnimPicker);
            shareAnimPicker.addEventListener(TexturePickerEvent.CHANGE,onShareAnimHandler);
            shareAnimPicker.setSharedStyle("columnCount",5);
            shareAnimPicker.setSharedStyle("swatchWidth",16);
            shareAnimPicker.setSharedStyle("swatchHeight",16);
         }
         else
         {
            onShareAnimHandler();
         }
         shareBuddyHolder.visible = true;
         addChild(shareBuddyHolder);
      }
      
      private function loadBuddies() : void
      {
         console.appendText("loadBuddies...\n");
         pokeFromUser = viewer;
         pokeToUser = owner;
         if(viewerIsOwner)
         {
            owner = viewer;
            if(owner != null && viewer != null)
            {
               if(CONTAINER_ID == "orkut" && owner.userId == "05889220392208221562" && viewer.userId == "05889220392208221562")
               {
                  this.addChildAt(console,0);
               }
               else if(CONTAINER_ID == "hi5" && owner.userId == "219778953" && viewer.userId == "219778953")
               {
                  console.alpha = 0.6;
                  this.addChildAt(console,0);
               }
               else if(CONTAINER_ID == "netlog" && owner.userId == "46335934" && viewer.userId == "46335934")
               {
                  this.addChildAt(console,0);
               }
               else if(CONTAINER_ID == "myspace" && owner.userId == "93320646" && viewer.userId == "93320646")
               {
                  this.addChildAt(console,0);
               }
            }
            viewer.loadBuddy(onLoadedViewerBuddy);
         }
         else
         {
            owner.loadBuddy(onLoadedOwnerBuddy);
         }
      }
      
      private function gaTrackAction(param1:String) : void
      {
         var id:String = null;
         var event:String = param1;
         if(CONTAINER_ID == "myspace")
         {
            return;
         }
         try
         {
            id = replaceNums(CONTAINER_ID);
            event = replaceNums(event);
            if(ExternalInterface.available)
            {
               ExternalInterface.call("_IG_Analytics","UA-4053252-1","/gadget/buddypoke/" + id + "/action/" + event);
            }
         }
         catch(e:*)
         {
         }
      }
      
      private function onCloseError(param1:Event) : void
      {
         this.createEventsUI(owner);
         this.showLastSelectedEvent();
      }
      
      protected function onSaveBuddy(param1:Event) : void
      {
         paused = true;
         var _loc2_:String = buddy1.serializeCompressed();
         saveBuddyConfiguration(_loc2_);
      }
      
      protected function saveBuddyConfiguration(param1:String, param2:BitmapData = null, param3:BitmapData = null) : void
      {
         var jsonStr:String;
         var saveAppDataAppearance:Function;
         var saveAppDataRetryCount:int;
         var save:Function;
         var jsonResp:*;
         var png:ByteArray = null;
         var saveToS3:Boolean = false;
         var onSavedToAppDataAppearance:Function = null;
         var savedToAppSpot:Function = null;
         var buddy:String = param1;
         var screenShot:BitmapData = param2;
         var icon:BitmapData = param3;
         hideUIPanels();
         paused = true;
         if(saveAppearanceHolder != null && !contains(saveAppearanceHolder))
         {
            addChild(saveAppearanceHolder);
         }
         png = generateIcon();
         saveToS3 = true;
         buddy = buddy1.serializeCompressed();
         jsonResp = {};
         jsonStr = "";
         if(owner != null)
         {
            owner.buddyDesc = buddy;
            console.appendText("set owner\'s buddy desc, " + owner.userId + ", set " + (owner.buddyDesc == buddy) + " \n");
         }
         saveAppDataRetryCount = 0;
         onSavedToAppDataAppearance = function(param1:Boolean):void
         {
            var _loc2_:BuddyCache = null;
            console.appendText("\n\nonSavedToAppData... hadError: " + param1 + "\n\n");
            if(param1)
            {
               if(saveAppearanceRetryCount < 3)
               {
                  ++saveAppearanceRetryCount;
                  saveAppDataAppearance();
                  return;
               }
               gaTrackError("error saving to app data for appearance");
               showServerError(SAVING_APPEARANCE_ERROR,"appearance");
               return;
            }
            _loc2_ = BuddyCache.GetInstance();
            if(_loc2_ != null)
            {
               viewer.cacheBuddy(viewerUserContent);
               _loc2_.saveCache();
            }
            onSavedBuddy();
         };
         saveAppDataAppearance = function(param1:String):void
         {
            saveAppearanceRetryCount = 0;
            console.appendText("\n\nsaveAppData... " + param1 + "\n\n");
            var _loc2_:String = "onSavedToAppData" + BuddyPoke.timeStamp();
            ExternalInterface.addCallback(_loc2_,onSavedToAppDataAppearance);
            ExternalInterface.call("newUpdateBuddyAppData",_loc2_,"bdpkbd",param1);
         };
         savedToAppSpot = function(param1:String):void
         {
            var obj:* = undefined;
            var result:String = null;
            var json:String = null;
            var pngp:String = null;
            var pngsig:String = null;
            var savedAppS3:Function = null;
            var errorAppS3:Function = null;
            var data:String = param1;
            console.appendText("\nSaved appearance to app spot:\n" + data + "\n");
            if(data != null && data.indexOf("Over Quota") >= 0)
            {
               gaTrackError("app engine over quota for appearance");
               showServerError(SAVING_APPEARANCE_ERROR,"appearance");
               return;
            }
            try
            {
               obj = com.adobe.serialization.json.JSON.decode(data);
               result = obj["result"];
               json = unescHtml(obj["viewer"].json);
               if(png != null)
               {
                  console.appendText("\nhas an icon to save..\n");
                  try
                  {
                     pngp = obj["pngp"];
                     pngsig = obj["pngsig"];
                     if(pngp != null && pngsig != null)
                     {
                        saveIconRetryCount = 0;
                        console.appendText("\nsaveIconToAmazonS3..\n");
                        saveIconToAmazonS3(png,pngp,pngsig);
                     }
                  }
                  catch(e:*)
                  {
                     console.appendText("\nerror saving icon " + e.toString() + "\n");
                  }
               }
               else
               {
                  console.appendText("\nNO icon to save..\n");
               }
               viewerUserContent = json;
               if(saveToS3)
               {
                  viewerId = viewer.userId;
                  viewerPolicy = obj["viewer"].s3p;
                  if(viewerPolicy == null)
                  {
                     saveToS3 = false;
                  }
                  else
                  {
                     viewerSig = obj["viewer"].s3s;
                     viewerRetryCnt = 0;
                     savedAppS3 = function(param1:*):void
                     {
                        console.appendText("SAVED appearance to s3 - success\n");
                        saveAppDataAppearance(viewerUserContent);
                     };
                     errorAppS3 = function(param1:*):void
                     {
                        console.appendText("ERROR appearance to s3 - success\n");
                        ++viewerRetryCnt;
                        if(viewerRetryCnt < 2)
                        {
                           console.appendText("retry..\n");
                           saveAvatarToS3(viewerId,viewerUserContent,viewerPolicy,viewerSig,savedAppS3,errorAppS3);
                        }
                        else
                        {
                           gaTrackError("sthree error saving appearance");
                           showServerError(SAVING_APPEARANCE_ERROR,"appearance");
                        }
                     };
                     console.appendText("\n\nsave appearance to s3..\n");
                     saveAvatarToS3(viewerId,viewerUserContent,viewerPolicy,viewerSig,savedAppS3,errorAppS3);
                  }
               }
               if(!saveToS3)
               {
                  saveAppDataAppearance(json);
               }
            }
            catch(e:*)
            {
               if(saveAppearanceRetryCount < MAX_NUM_RETRY)
               {
                  ++saveAppearanceRetryCount;
                  saveBuddyConfiguration(buddy,screenShot,icon);
                  return;
               }
               gaTrackError("exception error saving appearance");
               showServerError(SAVING_APPEARANCE_ERROR,"appearance");
               return;
            }
         };
         save = function():void
         {
            console.appendText("Saving appearance to buddypoke server!\n");
            var _loc1_:* = BASE_URL + "save";
            var _loc2_:String = "savedToAppSpot" + BuddyPoke.timeStamp();
            ExternalInterface.addCallback(_loc2_,savedToAppSpot);
            var _loc3_:* = {};
            _loc3_[RequestParameters.METHOD] = MethodType.POST;
            _loc3_[RequestParameters.CONTENT_TYPE] = ContentType.TEXT;
            _loc3_[RequestParameters.AUTHORIZATION] = AuthorizationType.SIGNED;
            _loc3_[RequestParameters.POST_DATA] = "buddy=" + buddy;
            if(saveToS3)
            {
               _loc3_[RequestParameters.POST_DATA] += "&s3=1";
            }
            if("05889220392208221562" == owner.userId)
            {
               _loc3_[RequestParameters.POST_DATA] += "&prof=1";
            }
            makeRequest(_loc1_,_loc2_,_loc3_);
         };
         if(this.runLocal)
         {
            console.text = buddy;
            onSavedBuddy();
         }
         else
         {
            save();
         }
      }
      
      override protected function showPoke(param1:String, param2:String, param3:String) : void
      {
         if(pokeBackHolder != null && contains(pokeBackHolder))
         {
            removeChild(pokeBackHolder);
         }
         if(param2 != null && param3 != null && viewerIsOwner && owner != null)
         {
            if(param2 != owner.userId && getUser(param2) != null && getUser(param2).userName != HIDDEN_USER)
            {
               lastPokedFromUserId = param2;
               if(pokeBackHolder != null && !contains(pokeBackHolder))
               {
                  TextField(pokeBackLink.getChildAt(0)).htmlText = MessageBundle.msg("poke") + " " + getUser(param2).userName;
                  addChild(pokeBackHolder);
               }
            }
            else if(param2 == owner.userId && param3 != owner.userId && getUser(param3) != null && getUser(param3).userName != HIDDEN_USER)
            {
               lastPokedFromUserId = param3;
               if(pokeBackHolder != null && !contains(pokeBackHolder))
               {
                  TextField(pokeBackLink.getChildAt(0)).htmlText = MessageBundle.msg("poke") + " " + getUser(param3).userName;
                  addChild(pokeBackHolder);
               }
            }
         }
         super.showPoke(param1,param2,param3);
      }
      
      public function onPokeLink(param1:Event) : void
      {
         showPokeFriendSelector();
      }
      
      private function loadedUserInfo() : void
      {
         var _loc5_:* = undefined;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc1_:Array = owner.buddyHistory;
         if(_loc1_ == null)
         {
            initBuddy();
            return;
         }
         var _loc2_:String = owner.userId;
         var _loc3_:String = viewer == null ? null : viewer.userId;
         var _loc4_:Dictionary = new Dictionary();
         for each(_loc5_ in _loc1_)
         {
            _loc9_ = _loc5_["fr"];
            _loc10_ = _loc5_["to"];
            if(_loc9_ != null && _loc9_.length > 0 && !(_loc9_ == _loc2_ || _loc9_ == _loc3_))
            {
               _loc4_[_loc9_] = _loc9_;
            }
            if(_loc10_ != null && _loc10_.length > 0 && !(_loc10_ == _loc2_ || _loc10_ == _loc3_))
            {
               _loc4_[_loc10_] = _loc10_;
            }
         }
         console.appendText("\n\n---------\npreload user info for event list\n");
         _loc6_ = new Array();
         for(_loc7_ in _loc4_)
         {
            console.appendText("load user " + _loc7_ + "\n");
            if(_loc7_ != null && _loc7_ != "null")
            {
               _loc6_.push(_loc7_);
            }
         }
         if(owner != null && owner.userId != null && owner.userId != "null")
         {
            _loc6_.push(owner.userId);
         }
         var _loc8_:int = int(_loc6_.length);
         console.appendText("numUsersToLoad " + _loc8_ + "\n");
         if(_loc8_ <= 1)
         {
            initBuddy();
            return;
         }
         loadEventUsers(_loc6_);
      }
      
      private function getUser(param1:String) : OSUser
      {
         var _loc2_:OSUser = userDictionary[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new OSUser();
            _loc2_.createDummy(param1,HIDDEN_USER,"male","{\"buddy\":\"" + Buddy.DEFAULT + "\",\"data\":{\"history\":[]}}");
            userDictionary[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function onProfileCustomizeLink(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:TextField = null;
         var _loc4_:Sprite = null;
         var _loc5_:Sprite = null;
         saveAppearanceRetryCount = 0;
         paused = false;
         showingMood = false;
         customizing = true;
         if(buddy1 != null && owner != null)
         {
            buddy1.deserializeCompressed(owner.buddyDesc);
         }
         hideUIPanels();
         initExamineCamera();
         if(appearanceSelectionHolder == null)
         {
            CustomizationPanel.tracker = gaTrackCustomization;
            customizationPanel = new CustomizationPanel(0,20,SELECTION_PANEL_WIDTH,150,4);
            appearanceSelectionHolder = new Sprite();
            drawHolderBackground(appearanceSelectionHolder,SELECTION_PANEL_WIDTH,180 + 25);
            _loc2_ = appearanceSelectionHolder.getBounds(appearanceSelectionHolder).width;
            appearanceSelectionHolder.x = HOLDER_POSITION_X;
            appearanceSelectionHolder.y = HOLDER_POSITION_Y;
            _loc3_ = new TextField();
            _loc3_.autoSize = TextFieldAutoSize.LEFT;
            _loc3_.background = false;
            _loc3_.border = false;
            _loc3_.text = MessageBundle.msg("Customize your appearance:");
            _loc3_.setTextFormat(new TextFormat("Arial",11,4019299,true));
            _loc3_.x = 2;
            appearanceSelectionHolder.addChild(_loc3_);
            appearanceSelectionHolder.addChild(customizationPanel);
            customizationPanel.visible = true;
            customizationPanel.loadOptions(buddy1);
            saveChangesLink = createLink(MessageBundle.msg("Save your changes"),238,13,true,TextFieldAutoSize.CENTER,true,true);
            saveChangesLink.addEventListener(MouseEvent.CLICK,onSaveBuddy);
            saveChangesLink.x = 0.5 * SELECTION_PANEL_WIDTH;
            saveChangesLink.y = ACTION_LINK_Y;
            appearanceSelectionHolder.addChild(saveChangesLink);
            _loc4_ = createLink(MessageBundle.msg("Saving your appearance..."),238,15,false,TextFieldAutoSize.CENTER,false);
            _loc4_.x = 0.5 * 268;
            _loc4_.y = 30;
            saveAppearanceHolder = new Sprite();
            saveAppearanceHolder.graphics.lineStyle(0,14862370,1);
            saveAppearanceHolder.graphics.beginFill(16775639,1);
            saveAppearanceHolder.graphics.drawRect(0,0,266,100);
            saveAppearanceHolder.graphics.endFill();
            _loc2_ = saveAppearanceHolder.getBounds(saveAppearanceHolder).width;
            _loc5_ = new UploadProgress();
            _loc5_.x = (_loc2_ - 28) * 0.5;
            _loc5_.y = 60;
            saveAppearanceHolder.addChild(_loc5_);
            saveAppearanceHolder.x = 0.5 * (STAGE_WIDTH - _loc2_);
            saveAppearanceHolder.y = HOLDER_POSITION_Y + HOLDER_POSITION_OFFSET;
            saveAppearanceHolder.addChild(_loc4_);
         }
         customizationPanel.initAnim(buddy1);
         appearanceSelectionHolder.visible = true;
         addChild(appearanceSelectionHolder);
         stage.dispatchEvent(new Event(Event.RENDER));
         gaTrack("link/customize");
      }
      
      private function createPokeOnFriendsPageUI() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TextField = null;
         if(pokeFriendsPageHolder == null)
         {
            pokeFriendsPageHolder = new Sprite();
            _loc1_ = new Sprite();
            _loc1_.addEventListener(MouseEvent.CLICK,onPokeFriendLink);
            _loc2_ = createPokeBackTextField();
            _loc2_.htmlText = "poke " + owner.userName;
            _loc1_.addChild(_loc2_);
            _loc1_.mouseChildren = false;
            _loc1_.useHandCursor = true;
            _loc1_.buttonMode = true;
            pokeFriendsPageHolder.addChild(_loc1_);
         }
         if(pokeFriendsPageHolder != null && !contains(pokeFriendsPageHolder))
         {
            addChild(pokeFriendsPageHolder);
         }
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         console.appendText("Checking JavaScript status...\n");
         if(gadgetReady() == true)
         {
            Timer(param1.target).stop();
            console.appendText("JavaScript is ready.\n");
            startGadget();
         }
      }
      
      private function showEventItem(param1:EventItem) : void
      {
         var fromUser:OSUser = null;
         var toUser:OSUser = null;
         var loadedFromBuddy:Function = null;
         var loadedToBuddy:Function = null;
         var ev:EventItem = param1;
         paused = true;
         lastPokedFromUserId = null;
         showingMood = false;
         customizing = false;
         showingEvent = ev;
         if(showingEvent.isMoodChange)
         {
            if(runLocal)
            {
               this.showMood(showingEvent.animId);
            }
            else
            {
               fromUser = getUser(showingEvent.fromUser);
               if(buddy1 != null && fromUser != null)
               {
                  buddy1.deserializeCompressed(fromUser.buddyDesc);
               }
               this.showMood(showingEvent.animId);
            }
         }
         else if(runLocal)
         {
            showPoke(showingEvent.animId,ev.fromUser,ev.toUser);
         }
         else
         {
            fromUser = getUser(showingEvent.fromUser);
            toUser = getUser(showingEvent.toUser);
            if(fromUser.loadedBuddy == false)
            {
               loadedFromBuddy = function(param1:OSUser):void
               {
                  showEventItem(ev);
               };
               fromUser.loadBuddy(loadedFromBuddy);
            }
            else if(toUser.loadedBuddy == false)
            {
               loadedToBuddy = function(param1:OSUser):void
               {
                  showEventItem(ev);
               };
               toUser.loadBuddy(loadedToBuddy);
            }
            else
            {
               buddy1.deserializeCompressed(fromUser.buddyDesc);
               buddy2.deserializeCompressed(toUser.buddyDesc);
               showPoke(showingEvent.animId,showingEvent.fromUser,showingEvent.toUser);
            }
         }
      }
      
      private function saveAvatarToS3(param1:String, param2:String, param3:String, param4:String, param5:Function, param6:Function) : void
      {
         AmazonS3CrossDomain.loadPolicyFile();
         var _loc7_:ByteArray = new ByteArray();
         _loc7_.writeUTFBytes(param2);
         var _loc8_:UploadToS3 = new UploadToS3(console);
         _loc8_.addEventListener(UploadToS3Event.S3COMPLETE,param5);
         _loc8_.addEventListener(UploadToS3Event.S3ERROR,param6);
         var _loc9_:String = "13G614B23FZHBNXRJJG2";
         _loc8_.uploadFileToAmazon("http://buddypoke.s3.amazonaws.com",domain + "/" + param1 + "/" + param1,"public-read","text/plain",_loc9_,param3,param4,param1,_loc7_,null,null,"public,max-age=3600");
      }
      
      protected function onSelectedPoke(param1:PokeEvent) : void
      {
         var desc:String = null;
         var event:PokeEvent = param1;
         if(pokeToUser == null)
         {
            pokeToUser = owner;
         }
         savePokeEpoch = BuddyPoke.timeStamp();
         savePokeRetryCount = 0;
         selectedPokeId = event.pokeId;
         if(pokeLink != null)
         {
            desc = MessageBundle.msg(PokeSelectionPanel.Anims.anim.(@id == event.pokeId).@desc);
            desc = desc.replace("%",pokeToUser.userName);
            TextField(pokeLink.getChildAt(0)).htmlText = desc;
         }
         showPoke(event.pokeId,null,null);
      }
      
      private function showLastSelectedEvent() : void
      {
         if(showingEvent != null)
         {
            showEventItem(showingEvent);
         }
         else
         {
            showMostRecentEvent();
         }
         paused = false;
      }
      
      private function initBuddyProfilePage() : void
      {
         var buddyPanelWrapper:Sprite;
         try
         {
            ExternalInterface.call("hideLoadingImage");
         }
         catch(e:*)
         {
         }
         console.appendText("\n-----------------------\ninitBuddyProfilePage\n");
         console.appendText("viewerIsOwner " + viewerIsOwner + "\n");
         if(this.viewerIsOwner || this.runLocal)
         {
            createOwnProfileToolBar((this.STAGE_WIDTH - this.SELECTION_PANEL_WIDTH) * 0.5,SHOW_HEADER ? HEADER_HEIGHT : 0);
         }
         loadingMessage = new TextField();
         loadingMessage.autoSize = TextFieldAutoSize.LEFT;
         loadingMessage.background = true;
         loadingMessage.backgroundColor = 15658734;
         loadingMessage.border = false;
         loadingMessage.text = MessageBundle.msg("Loading...");
         loadingMessage.setTextFormat(new TextFormat("Arial",10,8888780,true));
         loadingMessage.x = HOLDER_POSITION_X;
         loadingMessage.y = 30 + (this.SHOW_HEADER ? HEADER_HEIGHT : 0);
         addChild(loadingMessage);
         buddyPanelPicker.graphics.lineStyle(undefined,0);
         buddyPanelPicker.graphics.beginFill(16711680,0);
         buddyPanelPicker.graphics.drawRect(-50,0,buddyPanelWidth + 100,buddyPanelHeight - 25);
         buddyPanelPicker.graphics.endFill();
         buddyPanelPicker.useHandCursor = true;
         buddyPanelPicker.buttonMode = true;
         buddyPanelPicker.addEventListener(MouseEvent.MOUSE_MOVE,onExamineMouseMove);
         buddyPanelPicker.addEventListener(MouseEvent.MOUSE_UP,onExamineMouseUp);
         buddyPanelPicker.addEventListener(MouseEvent.MOUSE_DOWN,onExamineMouseDown);
         buddyPanelPicker.addEventListener(MouseEvent.MOUSE_OUT,onExamineMouseLeave);
         this.addEventListener(MouseEvent.MOUSE_OUT,onExamineMouseLeave);
         buddyPanelHolder.x = -buddyPanelWidth * 0.5;
         buddyPanelHolder.y = -buddyPanelHeight * 0.5 + 17;
         buddyPanelShape = new Sprite();
         buddyPanelShape.mouseChildren = false;
         buddyPanelHolder.addChild(buddyPanelShape);
         buddyPanelScale.addChild(buddyPanelHolder);
         buddyPanelWrapper = new Sprite();
         buddyPanelWrapper.x = (STAGE_WIDTH - this.buddyPanelWidth) * 0.5 + buddyPanelWidth * 0.5;
         buddyPanelWrapper.y = (this.SHOW_HEADER ? HEADER_HEIGHT : 20) + buddyPanelHeight * 0.5;
         buddyPanelWrapper.addChild(buddyPanelScale);
         addChild(buddyPanelWrapper);
         loadBlankSetting();
      }
      
      private function onDoneShare(param1:Event) : void
      {
         paused = false;
         hideUIPanels();
         this.createEventsUI(owner);
         this.showLastSelectedEvent();
      }
      
      private function showPokeFriendSelector() : void
      {
         var _loc2_:TextField = null;
         var _loc3_:FriendPicker = null;
         var _loc4_:Number = NaN;
         hideUIPanels();
         var _loc1_:Number = 266;
         if(pokeFriendHolder == null)
         {
            pokeFriendHolder = new Sprite();
            drawHolderBackground(pokeFriendHolder,SELECTION_PANEL_WIDTH,150);
            _loc2_ = new TextField();
            _loc2_.autoSize = TextFieldAutoSize.LEFT;
            _loc2_.background = false;
            _loc2_.border = false;
            _loc2_.text = MessageBundle.msg("Select a friend to BuddyPoke:");
            _loc2_.setTextFormat(new TextFormat("Arial",12,4019299,true));
            _loc2_.x = 2;
            pokeFriendHolder.addChild(_loc2_);
            _loc3_ = new FriendPicker(viewer.userId,10,console);
            _loc3_.addEventListener(SelectedFriendEvent.SELECT_FRIEND,onSelectedPokeFriend);
            _loc3_.x = 15;
            _loc3_.y = 30;
            pokeFriendHolder.addChild(_loc3_);
            _loc4_ = pokeFriendHolder.getBounds(pokeFriendHolder).width;
            pokeFriendHolder.x = HOLDER_POSITION_X;
            pokeFriendHolder.y = HOLDER_POSITION_Y;
         }
         addChild(pokeFriendHolder);
         this.paused = true;
         if(buddy1 != null && owner != null)
         {
            buddy1.deserializeCompressed(owner.buddyDesc);
         }
         this.showMood(MoodSelectionPanel.POKE_FRIEND_SELECTOR_ID);
         this.paused = false;
      }
      
      private function onLoadedViewerBuddy(param1:OSUser) : void
      {
         loadedUserInfo();
      }
      
      private function replaceNums(param1:String) : String
      {
         param1 = param1.replace("0","zero");
         param1 = param1.replace("1","one");
         param1 = param1.replace("2","two");
         param1 = param1.replace("3","three");
         param1 = param1.replace("4","four");
         param1 = param1.replace("5","five");
         param1 = param1.replace("6","six");
         param1 = param1.replace("7","seven");
         param1 = param1.replace("8","eight");
         return param1.replace("9","nine");
      }
      
      private function onClosePokeStandin(param1:Event) : void
      {
         this.createEventsUI(owner);
         this.showLastSelectedEvent();
      }
      
      public function onMoodLink(param1:Event) : void
      {
         createMoodUI();
         gaTrack("link/mood");
      }
      
      private function gaTrack(param1:String) : void
      {
         var id:String = null;
         var link:String = param1;
         if(CONTAINER_ID == "myspace")
         {
            return;
         }
         try
         {
            id = replaceNums(CONTAINER_ID);
            link = replaceNums(link);
            if(ExternalInterface.available)
            {
               ExternalInterface.call("_IG_Analytics","UA-4053252-1","/gadget/buddypoke/" + id + "/" + link);
            }
         }
         catch(e:*)
         {
         }
      }
      
      private function createEventsUI(param1:OSUser) : void
      {
         var _loc3_:* = null;
         var _loc4_:Number = NaN;
         showingMood = false;
         customizing = false;
         hideUIPanels();
         var _loc2_:Array = null;
         _loc2_ = param1.buddyHistory;
         if(_loc2_ == null || _loc2_.length == 0)
         {
            _loc3_ = "[{\"a\":\"m_hpcu\",\"fr\":\"" + param1.userId + "\",\"t\":\"" + BuddyPoke.timeStamp() + "\",\"b\":\"\"}]";
            _loc2_ = com.adobe.serialization.json.JSON.decode(_loc3_);
            param1.buddyHistory = _loc2_;
         }
         if(eventHistorySelectionHolder == null)
         {
            eventHistorySelectionHolder = new Sprite();
            drawHolderBackground(eventHistorySelectionHolder,SELECTION_PANEL_WIDTH,180 + 25);
            _loc4_ = (STAGE_WIDTH - SELECTION_PANEL_WIDTH) * 0.5;
            eventHistoryPanel = new EventHistoryPanel(0,0,SELECTION_PANEL_WIDTH,180 + 15);
            eventHistoryPanel.showEvents(owner.userId,_loc2_,onShowEventItem,userDictionary);
            eventHistorySelectionHolder.x = HOLDER_POSITION_X;
            eventHistorySelectionHolder.addChild(eventHistoryPanel);
            eventHistorySelectionHolder.y = HOLDER_POSITION_Y;
         }
         addChild(eventHistorySelectionHolder);
         pokeEventsUI = eventHistorySelectionHolder;
      }
      
      private function onShareAnimHandler(param1:TexturePickerEvent = null) : void
      {
         var _loc2_:String = MoodSelectionPanel.Moods.mood[shareAnimPicker.selectedColor].@id;
         this.showMood(_loc2_);
         if(shareBuddyCodeTextField != null)
         {
            shareBuddyCodeTextField.text = createAddCommentTags(_loc2_);
         }
      }
      
      private function logServerError(param1:String, param2:String) : *
      {
      }
      
      private function onShowEventItem(param1:Event) : void
      {
         showEventItem(EventItem(param1.target));
      }
      
      private function maskBkg(param1:String, param2:Number) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         var _loc4_:MovieClip = canvasBackgroundLib.getSymbol(param1) as MovieClip;
         _loc3_.addChild(_loc4_);
         var _loc5_:Sprite = new Sprite();
         _loc5_.graphics.beginFill(16777215);
         _loc5_.graphics.drawRect(param2,0,240,500);
         _loc3_.addChild(_loc5_);
         _loc4_.mask = _loc5_;
         return _loc3_;
      }
      
      private function gadgetReady() : Boolean
      {
         if(!ExternalInterface.available)
         {
            return false;
         }
         return true == ExternalInterface.call("getGadgetReady");
      }
      
      private function showMostRecentEvent() : void
      {
         showingMood = false;
         customizing = false;
         var _loc1_:Array = eventHistoryPanel.events;
         if(_loc1_ != null && _loc1_.length > 0)
         {
            showEventItem(_loc1_[0]);
         }
         eventHistoryPanel.scrollToTop();
         paused = false;
      }
      
      private function gaTrackCustomization(param1:String) : void
      {
         var id:String = null;
         var event:String = param1;
         if(CONTAINER_ID == "myspace")
         {
            return;
         }
         if(event == null)
         {
            return;
         }
         event = event.replace("\'","");
         try
         {
            id = replaceNums(CONTAINER_ID);
            event = replaceNums(event);
         }
         catch(e:*)
         {
         }
      }
      
      private function createPokeBackUI() : void
      {
         var _loc1_:TextField = null;
         if(pokeBackHolder == null)
         {
            pokeBackHolder = new Sprite();
            pokeBackLink = new Sprite();
            pokeBackLink.addEventListener(MouseEvent.CLICK,onPokeBackLink);
            _loc1_ = createPokeBackTextField();
            pokeBackLink.addChild(_loc1_);
            pokeBackLink.mouseChildren = false;
            pokeBackLink.useHandCursor = true;
            pokeBackLink.buttonMode = true;
            pokeBackHolder.addChild(pokeBackLink);
            _loc1_.text = MessageBundle.msg("poke back");
         }
      }
      
      private function onSelectedPokeFriend(param1:SelectedFriendEvent) : void
      {
         var _loc2_:OSUser = OSUser(param1.user);
         if(userDictionary[_loc2_.userId] == null)
         {
            userDictionary[_loc2_.userId] = _loc2_;
         }
         pokeFromUser = owner;
         pokeToUser = _loc2_;
         if(!_loc2_.loadedBuddy)
         {
            _loc2_.loadBuddy(pokeUser);
         }
         else
         {
            createPokeUI();
         }
      }
      
      protected function createOwnProfileToolBar(param1:Number, param2:Number) : void
      {
         var _loc9_:String = null;
         var _loc10_:Sprite = null;
         var _loc3_:Sprite = new Sprite();
         _loc3_.x = param1 - 6;
         _loc3_.y = param2;
         var _loc4_:int = SELECTION_PANEL_WIDTH + 12;
         _loc3_.graphics.lineStyle(1,11780048);
         _loc3_.graphics.beginFill(15529471,1);
         _loc3_.graphics.drawRoundRectComplex(0,0,_loc4_,18,4,4,4,4);
         _loc3_.graphics.endFill();
         _loc3_.filters = [new DropShadowFilter(2,45,0,0.2,3,3,1,2)];
         var _loc5_:* = SELECTION_PANEL_WIDTH < 300;
         var _loc6_:Sprite = createLink(MessageBundle.msg(_loc5_ ? "Poke" : "Poke a Friend"),157596,12,true,TextFieldAutoSize.LEFT,false,false);
         _loc6_.addEventListener(MouseEvent.CLICK,onPokeLink);
         var _loc7_:Sprite = createLink(MessageBundle.msg(_loc5_ ? "Mood" : "Change Mood"),157596,12,true,TextFieldAutoSize.LEFT,false,false);
         _loc7_.addEventListener(MouseEvent.CLICK,onMoodLink);
         var _loc8_:Sprite = createLink(MessageBundle.msg(_loc5_ ? "Appearance" : "Customize Appearance"),157596,12,true,TextFieldAutoSize.LEFT,false,false);
         _loc8_.addEventListener(MouseEvent.CLICK,onProfileCustomizeLink);
         if(CONTAINER_ID == "hi5" || CONTAINER_ID == "myspace")
         {
            _loc9_ = MessageBundle.msg("Comments");
         }
         else if(CONTAINER_ID == "orkut")
         {
            _loc9_ = MessageBundle.msg("Scrapbook");
         }
         if(_loc9_ != null)
         {
            _loc10_ = createLink(_loc9_,157596,12,true,TextFieldAutoSize.LEFT,false);
            _loc10_.addEventListener(MouseEvent.CLICK,onShareLink);
         }
         var _loc11_:Sprite = createLink("|",4473924,11,false,TextFieldAutoSize.LEFT,false);
         var _loc12_:Sprite = createLink("|",4473924,11,false,TextFieldAutoSize.LEFT,false);
         var _loc13_:Sprite = createLink("|",4473924,11,false,TextFieldAutoSize.LEFT,false);
         var _loc14_:Sprite = null;
         if(CONTAINER_ID == "hi5" || CONTAINER_ID == "netlog" || _loc10_ == null)
         {
            _loc14_ = createLinkSet([_loc7_,_loc12_,_loc8_,_loc11_,_loc6_],2,false);
         }
         else if(CONTAINER_ID == "orkut" || CONTAINER_ID == "myspace")
         {
            _loc14_ = createLinkSet([_loc7_,_loc12_,_loc8_,_loc11_,_loc6_,_loc13_,_loc10_],2,false);
         }
         _loc14_.x = 5;
         _loc3_.addChild(_loc14_);
         addChild(_loc3_);
      }
      
      private function onSavedMood(param1:Event = null) : void
      {
         var hist:String = null;
         var iconUrl:String = null;
         var event:Event = param1;
         hideUIPanels();
         if(pokeEventsUI != null && !contains(pokeEventsUI))
         {
            addChild(pokeEventsUI);
         }
         else if(pokeEventsUI == null)
         {
            createEventsUI(owner);
         }
         showingMood = false;
         customizing = false;
         addEventToHistory({
            "a":selectedMoodId,
            "fr":owner.userId,
            "t":BuddyPoke.timeStamp(),
            "b":""
         });
         showMostRecentEvent();
         if(CONTAINER_ID == "orkut" || CONTAINER_ID == "hi5")
         {
            try
            {
               if(CONTAINER_ID == "orkut")
               {
                  hist = MoodSelectionPanel.getEventHistory(selectedMoodId,"",null);
               }
               else
               {
                  hist = MoodSelectionPanel.getEventHistory(selectedMoodId,owner.userName,owner.userWebUri) + " on <a href=\'/friend/apps/displayAppCanvas.do?appId=8527\'>BuddyPoke</a>.";
               }
               iconUrl = MoodSelectionPanel.getEventIconUrl(selectedMoodId);
               iconUrl = ExternalInterface.call("getFlashProxyUrl",iconUrl);
               ExternalInterface.call("createActivity",hist,iconUrl);
            }
            catch(e:*)
            {
            }
            gaTrackAction("play/mood/" + selectedMoodId);
         }
      }
      
      private function pokeUser(param1:OSUser) : void
      {
         createPokeUI();
      }
      
      private function loadEventUsers(param1:Array) : void
      {
         var onLoadedFriends:Function;
         var callbackName:String;
         var usersToLoad:Array = param1;
         console.appendText("loadEventUsers(usersToLoad:Array)\n\n");
         onLoadedFriends = function(param1:*):void
         {
            var numUsers:int;
            var i:int;
            var aUser:* = undefined;
            var hi5User:OSUser = null;
            var data:* = param1;
            console.appendText("HERE onLoadedFriends... data==null  " + (data == null) + "\n\n");
            if(data == null)
            {
               if(loadEventUsersRetryCount < MAX_NUM_RETRY)
               {
                  ++loadEventUsersRetryCount;
                  console.appendText("RETRY " + loadEventUsersRetryCount + " onLoadedFriends...\n\n");
                  loadEventUsers(usersToLoad);
                  return;
               }
               try
               {
                  ExternalInterface.call("hideLoadingImage");
               }
               catch(e:*)
               {
               }
               initBuddy();
               return;
            }
            numUsers = int(data.length);
            i = 0;
            while(i < numUsers)
            {
               aUser = data[i];
               if(userDictionary[aUser.id] == null)
               {
                  console.appendText("user " + i + ".." + aUser.id + "  " + aUser.name + "\n\n");
                  hi5User = new OSUser();
                  hi5User.createUser(aUser.id,aUser.name,aUser.gender,false,false);
                  userDictionary[hi5User.userId] = hi5User;
               }
               i++;
            }
            initBuddy();
         };
         callbackName = "onLoadedFriends" + BuddyPoke.timeStamp();
         ExternalInterface.addCallback(callbackName,onLoadedFriends);
         ExternalInterface.call("requestFriendsArrayID",callbackName,usersToLoad);
      }
      
      private function saveIconToAmazonS3(param1:ByteArray, param2:String, param3:String) : void
      {
         var upload:UploadToS3;
         var onSavedIconToS3Error:Function;
         var cacheControl:String;
         var onSavedIconToS3:Function;
         var AWS:String;
         var dec:String = null;
         var png:ByteArray = param1;
         var pngp:String = param2;
         var pngsig:String = param3;
         console.appendText("saveIconToAmazonS3...\n");
         onSavedIconToS3 = function(param1:UploadToS3Event):void
         {
            console.appendText("saveIconToAmazonS3 success\n");
         };
         onSavedIconToS3Error = function(param1:UploadToS3Event):void
         {
            console.appendText("saveIconToAmazonS3 failed\n");
            ++saveIconRetryCount;
            if(saveIconRetryCount < 2)
            {
               saveIconToAmazonS3(png,pngp,pngsig);
            }
         };
         upload = new UploadToS3(console);
         upload.addEventListener(UploadToS3Event.S3COMPLETE,onSavedIconToS3);
         upload.addEventListener(UploadToS3Event.S3ERROR,onSavedIconToS3Error);
         cacheControl = null;
         try
         {
            dec = Base64.decode(pngp);
            if(dec.indexOf("Cache") >= 0)
            {
               cacheControl = "public,max-age=259200";
            }
         }
         catch(e:*)
         {
         }
         AWS = "13G614B23FZHBNXRJJG2";
         upload.uploadFileToAmazon("http://buddypoke.s3.amazonaws.com",domain + "/" + owner.userId + "/icons.png","public-read","image/png",AWS,pngp,pngsig,owner.userId,png,null,null,cacheControl);
      }
      
      private function addEventToHistory(param1:*) : void
      {
         owner.addEventToHistory(param1);
         eventHistoryPanel.showEvents(owner.userId,owner.buddyHistory,onShowEventItem,userDictionary);
      }
      
      private function renderIcon(param1:Buddy = null, param2:int = 75, param3:int = 75) : BitmapData
      {
         var closeUp:*;
         var oldCamera:* = undefined;
         var bmd:BitmapData = null;
         var oldq:* = undefined;
         var tempShape:Shape = null;
         var mat:Matrix = null;
         var s:Number = NaN;
         var copy:BitmapData = null;
         var matrix:Array = null;
         var buddy:Buddy = param1;
         var bw:int = param2;
         var bh:int = param3;
         if(buddy == null)
         {
            buddy = buddy1;
         }
         closeUp = buddy.player.scene.getNodeByName("Camera_CloseUp");
         oldCamera = buddy.context.camera;
         buddy.context.camera = closeUp;
         buddy.selectedAnim = "pose_contra";
         try
         {
            bmd = new BitmapData(bw,bh,true,16777215);
            oldq = stage.quality;
            stage.quality = StageQuality.BEST;
            tempShape = new Shape();
            tempShape.graphics.clear();
            buddy.drawFrame(tempShape.graphics,210);
            buddy.context.camera = oldCamera;
            mat = new Matrix();
            mat.translate(-buddyPanelWidth * 0.5,-buddyPanelHeight * 0.5);
            s = bw / buddyPanelWidth;
            mat.scale(s * 1.23,s * 1.23);
            mat.translate(bw * 0.5,bh * 0.5);
            mat.translate(0,6);
            bmd.draw(tempShape,mat,null,null,null,false);
            stage.quality = oldq;
            copy = bmd.clone();
            matrix = [-0.125,-0.125,-0.125,-0.125,2,-0.125,-0.125,-0.125,-0.125];
            bmd.applyFilter(bmd,bmd.rect,new Point(0,0),new ConvolutionFilter(3,3,matrix,1));
            bmd.draw(copy,null,new ColorTransform(1,1,1,0.5),"layer");
            return bmd;
         }
         catch(e:*)
         {
            buddy.context.camera = oldCamera;
         }
         return null;
      }
      
      internal function setBrillo(param1:*, param2:*) : *
      {
         var _loc3_:ColorTransform = new ColorTransform();
         var _loc4_:Transform = new Transform(param1);
         _loc3_.redMultiplier = _loc3_.greenMultiplier = _loc3_.blueMultiplier = 1 - Math.abs(param2);
         _loc3_.redOffset = _loc3_.greenOffset = _loc3_.blueOffset = param2 > 0 ? param2 * 256 : 0;
         _loc4_.colorTransform = _loc3_;
      }
      
      private function showServerError(param1:String, param2:String) : void
      {
         var _loc4_:TextField = null;
         param1 = MessageBundle.msg(param1);
         hideUIPanels();
         errorMessageHolder = new Sprite();
         errorMessageHolder.graphics.lineStyle(0,14862370,1);
         errorMessageHolder.graphics.beginFill(16775639,1);
         errorMessageHolder.graphics.drawRect(0,0,266,160);
         errorMessageHolder.graphics.endFill();
         var _loc3_:Sprite = new Sprite();
         _loc4_ = new TextField();
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         _loc4_.background = false;
         _loc4_.border = false;
         _loc4_.selectable = false;
         _loc4_.text = MessageBundle.msg("BuddyPoke is undergoing maintenance.");
         _loc4_.setTextFormat(new TextFormat("Arial",13,238,true));
         _loc4_.x = 25;
         _loc4_.y = 17;
         _loc3_.addChild(_loc4_);
         var _loc5_:TextField = new TextField();
         var _loc6_:TextFormat = new TextFormat();
         _loc6_.font = "_sans";
         _loc6_.color = 0;
         _loc6_.size = 12;
         _loc6_.align = TextFormatAlign.LEFT;
         _loc4_ = new TextField();
         _loc4_.width = 244;
         _loc4_.selectable = false;
         _loc4_.multiline = true;
         _loc4_.wordWrap = true;
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         _loc4_.antiAliasType = AntiAliasType.ADVANCED;
         _loc4_.defaultTextFormat = _loc6_;
         _loc4_.setTextFormat(_loc6_);
         _loc4_.text = param1 + "\n\n" + MessageBundle.msg("Please come back later. Thank you.");
         _loc4_.x = 16;
         _loc4_.y = 50;
         _loc3_.addChild(_loc4_);
         errorMessageHolder.addChild(_loc3_);
         errorMessageHolder.x = (SELECTION_PANEL_WIDTH - errorMessageHolder.getBounds(errorMessageHolder).width) * 0.5;
         var _loc7_:Sprite = createLink(MessageBundle.msg("Close"),238,13,true,TextFieldAutoSize.CENTER,true);
         _loc7_.addEventListener(MouseEvent.CLICK,onCloseError);
         _loc7_.x = 0.5 * 266;
         _loc7_.y = ACTION_LINK_Y;
         errorMessageHolder.addChild(_loc7_);
         var _loc8_:Number = errorMessageHolder.getBounds(errorMessageHolder).width;
         errorMessageHolder.x = 0.5 * (STAGE_WIDTH - _loc8_);
         errorMessageHolder.y = HOLDER_POSITION_Y + HOLDER_POSITION_OFFSET;
         addChild(errorMessageHolder);
         this.paused = true;
         if(buddy1 != null && owner != null)
         {
            buddy1.deserializeCompressed(owner.buddyDesc);
         }
         this.showMood(MoodSelectionPanel.ERROR_MOOD_ID);
         this.paused = false;
      }
      
      private function startGadget() : void
      {
         var _loc4_:String = null;
         console.appendText("startGadget\n");
         userData = ExternalInterface.call("initFlashUserObj");
         var _loc1_:* = userData.view;
         var _loc2_:String = _loc1_.viewName;
         var _loc3_:Boolean = Boolean(_loc1_.onlyVisible);
         onProfilePage = "profile" == _loc2_;
         console.appendText("\nonProfilePage " + onProfilePage + " " + _loc2_ + "\n\n");
         _loc4_ = getOpenSocialSurface();
         onProfilePage = _loc4_.indexOf("profile") >= 0;
         onHomePage = false;
         _loc4_ = getOpenSocialSurface();
         if(CONTAINER_ID == "myspace" && _loc4_ != "canvas")
         {
            if(_loc4_ == "home")
            {
               SELECTION_PANEL_WIDTH = 290 - 10;
               buddyPanelWidth = 346;
               buddyPanelHeight = 260;
               STAGE_WIDTH = 290;
            }
            else
            {
               SELECTION_PANEL_WIDTH = 300 - 10;
               buddyPanelWidth = 346;
               buddyPanelHeight = 260;
               STAGE_WIDTH = 300;
            }
         }
         else if(_loc4_ == "profile" && CONTAINER_ID == "netlog")
         {
            buddyPanelWidth = 346;
            buddyPanelHeight = 260;
            STAGE_WIDTH = 340;
            NUMBER_ROWS = 1;
            SELECTION_PANEL_WIDTH = 324;
         }
         else
         {
            buddyPanelWidth = 346;
            buddyPanelHeight = 260;
            STAGE_WIDTH = 450;
         }
         HOLDER_POSITION_X = (STAGE_WIDTH - SELECTION_PANEL_WIDTH) * 0.5;
         var _loc5_:* = userData.owner;
         var _loc6_:* = userData.viewer;
         var _loc7_:Array = userData.ownerFriends;
         console.appendText(_loc5_.id + " " + _loc5_.name + " " + _loc5_.gender + " " + _loc5_.profile + " " + _loc5_.icon + "\n");
         viewerIsOwner = true;
         owner = new OSUser();
         owner.createUser(_loc5_.id,_loc5_.name,_loc5_.gender,true,false);
         userDictionary[owner.userId] = owner;
         pokeToUser = owner;
         pokeFromUser = owner;
         if(_loc6_ == null)
         {
            viewerAndOwnerAreFriends = false;
            viewerIsOwner = false;
            viewerHasApp = false;
            viewer = null;
            loadBuddies();
         }
         else
         {
            if(_loc6_.id == owner.userId)
            {
               viewer = owner;
            }
            else
            {
               viewer = new OSUser();
               viewer.createUser(_loc6_.id,_loc6_.name,_loc6_.gender,false,true);
               userDictionary[viewer.userId] = viewer;
               pokeFromUser = viewer;
               viewerIsOwner = owner.userId != null && viewer != null && viewer.userId != null && owner.userId == viewer.userId;
               viewerHasApp = true;
               userDictionary[viewer.userId] = viewer;
               viewerAndOwnerAreFriends = viewerIsOwner == false;
            }
            loadBuddies();
         }
      }
      
      public function onShareLink(param1:Event) : void
      {
         if(buddy1 == null)
         {
            return;
         }
         if(buddy1 != null && owner != null)
         {
            buddy1.deserializeCompressed(owner.buddyDesc);
         }
         hideUIPanels();
         createShareUI();
         paused = false;
         gaTrack("link/share");
      }
      
      private function drawHolderBackground(param1:Sprite, param2:Number, param3:Number) : void
      {
         param3 = 180 + 15;
         var _loc4_:Number = this.HOLDER_PADDING;
         if(domain != null && domain.indexOf("hi5") >= 0 && "canvas" != getOpenSocialSurface())
         {
            param1.graphics.lineStyle(1,11780048);
            param1.graphics.beginFill(16383231,1);
            param1.graphics.drawRoundRectComplex(-_loc4_,-_loc4_,param2 + 2 * _loc4_,param3 + 2 * _loc4_,6,6,6,6);
            param1.filters = [new DropShadowFilter(2,45,0,0.2,3,3,1,2)];
            param1.alpha = 0.9;
         }
         else
         {
            param1.graphics.lineStyle(1,11780048);
            param1.graphics.beginFill(16383231,1);
            param1.graphics.drawRoundRectComplex(-_loc4_,-_loc4_,param2 + 2 * _loc4_,param3 + 2 * _loc4_,6,6,6,6);
            param1.filters = [new DropShadowFilter(2,45,0,0.2,3,3,1,2)];
         }
      }
      
      private function onMood(param1:Event = null) : void
      {
         var onLoad:Function;
         var saveToS3:Boolean = false;
         var url:String = null;
         var callbackName:String = null;
         var params:* = undefined;
         var event:Event = param1;
         paused = true;
         hideUIPanels();
         if(saveMoodHolder != null && !contains(saveMoodHolder))
         {
            addChild(saveMoodHolder);
         }
         saveToS3 = true;
         onLoad = function(param1:String):void
         {
            var obj:*;
            var json:String;
            var result:String;
            var savedAppS3:Function = null;
            var errorAppS3:Function = null;
            var data:String = param1;
            if(data != null && data.indexOf("Over Quota") >= 0)
            {
               gaTrackError("app engine over quota saving mood");
               showServerError(SAVING_MOOD_ERROR,"mood");
               return;
            }
            if(data == null)
            {
               console.text = "Make request failed...";
               if(saveMoodRetryCount < 0)
               {
                  ++saveMoodRetryCount;
                  onMood();
                  return;
               }
               gaTrackError("app engine null response for mood");
               showServerError(SAVING_MOOD_ERROR,"mood");
               return;
            }
            console.text = data;
            obj = com.adobe.serialization.json.JSON.decode(data);
            result = obj["result"];
            if("err" == result)
            {
               gaTrackError("err response from app engine saving mood");
               showServerError(SAVING_MOOD_ERROR,"mood");
               return;
            }
            json = unescHtml(obj["viewer"].json);
            if(saveToS3)
            {
               viewerId = viewer.userId;
               viewerUserContent = json;
               viewerPolicy = obj["viewer"].s3p;
               if(viewerPolicy == null)
               {
                  saveToS3 = false;
               }
               else
               {
                  viewerSig = obj["viewer"].s3s;
                  viewerRetryCnt = 0;
                  savedAppS3 = function(param1:*):void
                  {
                     console.appendText("SAVED mood to s3 - success\n");
                     onSavedMood();
                     viewer.saveBuddy(viewerUserContent);
                  };
                  errorAppS3 = function(param1:*):void
                  {
                     console.appendText("ERROR mood to s3 - success\n");
                     ++viewerRetryCnt;
                     if(viewerRetryCnt < 2)
                     {
                        console.appendText("retry..\n");
                        saveAvatarToS3(viewerId,viewerUserContent,viewerPolicy,viewerSig,savedAppS3,errorAppS3);
                     }
                     else
                     {
                        gaTrackError("sthree error saving mood");
                        showServerError(SAVING_MOOD_ERROR,"mood");
                     }
                  };
                  console.appendText("\n\nsave mood to s3..\n");
                  saveAvatarToS3(viewerId,viewerUserContent,viewerPolicy,viewerSig,savedAppS3,errorAppS3);
               }
            }
            if(saveToS3 == false)
            {
               onSavedMood();
               viewer.saveBuddy(json);
            }
         };
         if(this.runLocal)
         {
            onSavedMood();
         }
         else
         {
            url = BASE_URL + "mood";
            callbackName = "onLoad" + BuddyPoke.timeStamp();
            ExternalInterface.addCallback(callbackName,onLoad);
            params = {};
            params[RequestParameters.METHOD] = MethodType.POST;
            params[RequestParameters.CONTENT_TYPE] = ContentType.TEXT;
            params[RequestParameters.AUTHORIZATION] = AuthorizationType.SIGNED;
            params[RequestParameters.POST_DATA] = "mood=" + selectedMoodId + "&epoch=" + saveMoodEpoch;
            if(saveToS3)
            {
               params[RequestParameters.POST_DATA] += "&s3=1";
            }
            if("05889220392208221562" == owner.userId)
            {
               params[RequestParameters.POST_DATA] += "&prof=1";
            }
            makeRequest(url,callbackName,params);
         }
      }
      
      private function initGadget() : void
      {
         var readyTimer:Timer = null;
         if(ExternalInterface.available)
         {
            try
            {
               if(gadgetReady())
               {
                  console.appendText("JavaScript is ready.\n");
                  startGadget();
               }
               else
               {
                  console.appendText("JavaScript is not ready, creating timer.\n");
                  readyTimer = new Timer(100,0);
                  readyTimer.addEventListener(TimerEvent.TIMER,timerHandler);
                  readyTimer.start();
               }
            }
            catch(error:SecurityError)
            {
               console.alpha = 0.1;
               this.addChild(console);
               console.appendText("A SecurityError occurred: " + error.message + "\n");
            }
            catch(error:Error)
            {
               console.alpha = 0.1;
               this.addChild(console);
               console.appendText("An Error occurred: " + error.message + "\n");
            }
         }
         else
         {
            console.alpha = 0.1;
            this.addChild(console);
            console.appendText("External interface is not available for this container.");
            readyTimer = new Timer(100,0);
            readyTimer.addEventListener(TimerEvent.TIMER,timerHandler);
            readyTimer.start();
         }
      }
      
      override protected function onPreFirstRender() : void
      {
         if(buddy1 != null && owner != null)
         {
            console.appendText("\n\nowner.buddyDesc:\n" + owner.buddyDesc + "\n");
            buddy1.deserializeCompressed(owner.buddyDesc);
         }
         if(this.runLocal && buddy2 != null && viewer != null)
         {
            console.appendText("\n\nowner.buddyDesc:\n" + viewer.buddyDesc + "\n");
            buddy2.deserializeCompressed(viewer.buddyDesc);
         }
         if(loadingMessage != null && contains(loadingMessage))
         {
            removeChild(loadingMessage);
         }
         this.createPokeBackUI();
         this.createEventsUI(owner);
         if(!viewerIsOwner && viewerHasApp && viewerAndOwnerAreFriends)
         {
            this.showMostRecentEvent();
            createPokeOnFriendsPageUI();
         }
         else if(getOpenSocialSurface() == "canvas" && viewerIsOwner && (owner.buddyDesc == null || owner.buddyDesc.length < 1))
         {
            onProfileCustomizeLink(null);
         }
         else
         {
            this.showMostRecentEvent();
         }
      }
      
      private function onLoadedCanvasBackground(param1:Event) : void
      {
         var _loc2_:Sprite = maskBkg("clip_left",0);
         var _loc3_:Sprite = maskBkg("clip_right",10);
         _loc2_.alpha = 0.8;
         _loc3_.alpha = 0.8;
         var _loc4_:Number = SELECTION_PANEL_WIDTH + 2 * HOLDER_PADDING;
         var _loc5_:Number = _loc4_ * 0.5;
         _loc2_.x = -250;
         _loc3_.x = 450;
         addChildAt(_loc2_,0);
         addChildAt(_loc3_,1);
      }
      
      private function generateIcon(param1:Buddy = null, param2:int = 75, param3:int = 75) : ByteArray
      {
         var bmd:BitmapData = null;
         var encoder:AsPngEncoder = null;
         var buddy:Buddy = param1;
         var bw:int = param2;
         var bh:int = param3;
         try
         {
            bmd = renderIcon(buddy,bw,bh);
            encoder = new AsPngEncoder();
            return encoder.encode(bmd,new Strategy8BitMedianCutAlpha());
         }
         catch(e:*)
         {
         }
         return null;
      }
      
      override protected function showMood(param1:String) : void
      {
         if(pokeBackHolder != null && contains(pokeBackHolder))
         {
            removeChild(pokeBackHolder);
         }
         super.showMood(param1);
      }
      
      private function initBuddy() : void
      {
         initBuddyProfilePage();
      }
      
      private function getOpenSocialSurface() : String
      {
         var _loc1_:String = LoaderInfo(this.root.loaderInfo).parameters[OPEN_SOCIAL_MODE];
         if(_loc1_ == null)
         {
            _loc1_ = "canvas";
         }
         return _loc1_;
      }
      
      private function onSavedPoke(param1:Event = null) : void
      {
         var iconUrl:String = null;
         var hist:String = null;
         var notif:String = null;
         var pokeBack:String = null;
         var activityIcon:String = null;
         var actionStr:String = null;
         var act:String = null;
         var event:Event = param1;
         hideUIPanels();
         if(pokeEventsUI != null && !contains(pokeEventsUI))
         {
            addChild(pokeEventsUI);
         }
         else if(pokeEventsUI == null)
         {
            this.createEventsUI(owner);
         }
         showingMood = false;
         customizing = false;
         addEventToHistory({
            "a":selectedPokeId,
            "fr":pokeFromUser.userId,
            "to":pokeToUser.userId,
            "t":BuddyPoke.timeStamp(),
            "b":""
         });
         showMostRecentEvent();
         if(CONTAINER_ID == "orkut" || CONTAINER_ID == "hi5")
         {
            if(ExternalInterface.available)
            {
               iconUrl = PokeSelectionPanel.getEventIconUrl(selectedPokeId);
               iconUrl = ExternalInterface.call("getFlashProxyUrl",iconUrl);
               hist = PokeSelectionPanel.getEventHistory(selectedPokeId,pokeFromUser.userName,pokeToUser.userName,pokeFromUser.userWebUri,pokeToUser.userWebUri);
               try
               {
                  if(CONTAINER_ID == "orkut")
                  {
                     notif = PokeSelectionPanel.getEventHistory(selectedPokeId,pokeFromUser.userName,null,pokeFromUser.userWebUri,pokeToUser.userWebUri);
                     pokeBack = "<a href=\'http://www.orkut.com/Application.aspx?appId=43931632273\'>Click to BuddyPoke back!</a>";
                     ExternalInterface.call("notifyFriend",pokeToUser.userId,"Someone BuddyPoked you!","<img src=\'" + iconUrl + "\'/> " + notif + ". " + pokeBack);
                  }
                  else if(CONTAINER_ID == "hi5")
                  {
                     ExternalInterface.call("notifyFriend",pokeToUser.userId,"Someone BuddyPoked you!","Someone BuddyPoked you! <a href=\'/friend/apps/displayAppCanvas.do?appId=8527\'>Click here to find out who!</a>");
                  }
               }
               catch(e:*)
               {
               }
               try
               {
                  activityIcon = "http://buddypoke.s3.amazonaws.com/actions/en-US/" + selectedPokeId + ".png";
                  actionStr = PokeSelectionPanel.getName(selectedPokeId).toLowerCase() + "!";
                  if(CONTAINER_ID == "orkut")
                  {
                     try
                     {
                        act = PokeSelectionPanel.getEventHistory(selectedPokeId,"",pokeToUser.userName,pokeFromUser.userWebUri,pokeToUser.userWebUri);
                        console.appendText("\n\ncreatePokeActivity " + act + " " + pokeFromUser.userId + " " + activityIcon + " " + pokeToUser.userId + " " + actionStr + "\n");
                        ExternalInterface.call("createPokeActivity",act,pokeFromUser.userId,activityIcon,pokeToUser.userId,actionStr);
                        console.appendText("ok\n\n");
                     }
                     catch(ce:*)
                     {
                     }
                  }
                  else if(CONTAINER_ID == "netlog")
                  {
                     try
                     {
                        act = PokeSelectionPanel.getEventHistory(selectedPokeId,"",pokeToUser.userName,pokeFromUser.userWebUri,pokeToUser.userWebUri);
                        console.appendText("\n\ncreatePokeActivity " + act + " " + pokeFromUser.userId + " " + activityIcon + " " + pokeToUser.userId + " " + actionStr + "\n");
                        ExternalInterface.call("createPokeActivity",act,pokeFromUser.userId,activityIcon,pokeToUser.userId,actionStr);
                        console.appendText("ok\n\n");
                     }
                     catch(ce:*)
                     {
                     }
                  }
                  else if(CONTAINER_ID == "hi5")
                  {
                     act = PokeSelectionPanel.getEventHistory(selectedPokeId,pokeFromUser.userName,pokeToUser.userName,pokeFromUser.userWebUri,pokeToUser.userWebUri) + " using <a href=\'/friend/apps/displayAppCanvas.do?appId=8527\'>BuddyPoke!</a>";
                     console.appendText("\n\ncreatePokeActivity " + act + " " + pokeFromUser.userId + " " + activityIcon + " " + pokeToUser.userId + " " + actionStr + "\n");
                     ExternalInterface.call("createPokeActivity",act,pokeFromUser.userId,activityIcon,pokeToUser.userId,actionStr);
                     console.appendText("ok\n\n");
                  }
               }
               catch(e:*)
               {
               }
            }
            gaTrackAction("play/poke/" + selectedPokeId);
         }
      }
      
      private function onClickedBuddyShareCode(param1:MouseEvent) : void
      {
         var _loc2_:TextField = TextField(param1.target);
         _loc2_.setSelection(0,_loc2_.text.length);
      }
      
      private function onSelectedMood(param1:PokeEvent) : void
      {
         saveMoodEpoch = timeStamp();
         saveMoodRetryCount = 0;
         selectedMoodId = param1.pokeId;
         showMood(param1.pokeId);
      }
      
      private function loadCanvasBackground() : void
      {
         canvasBackgroundLib = new EmbeddedLibrary();
         canvasBackgroundLib.load(canvasBackgroundClass,onLoadedCanvasBackground);
      }
      
      private function onSavePoke(param1:Event = null) : void
      {
         var onLoad:Function;
         var saveToS3:Boolean = false;
         var url:String = null;
         var params:Object = null;
         var callbackName:String = null;
         var event:Event = param1;
         paused = true;
         if(pokeToUser == null)
         {
            pokeToUser = owner;
         }
         hideUIPanels();
         if(savePokeHolder != null && !contains(savePokeHolder))
         {
            addChild(savePokeHolder);
         }
         saveToS3 = true;
         onLoad = function(param1:String):void
         {
            var obj:* = undefined;
            var result:String = null;
            var json:String = null;
            var fromId:String = null;
            var fromUserContent:String = null;
            var fromPolicy:String = null;
            var fromSig:String = null;
            var fromRetryCnt:int = 0;
            var savedFromUser:Function = null;
            var errorFromUser:Function = null;
            var toId:String = null;
            var toUserContent:String = null;
            var toPolicy:String = null;
            var toSig:String = null;
            var toRetryCnt:int = 0;
            var savedToUser:Function = null;
            var errorToUser:Function = null;
            var data:String = param1;
            try
            {
               if(data != null && data.indexOf("Over Quota") >= 0)
               {
                  gaTrackError("app engine over quota saving appearance");
                  showServerError(SAVING_POKE_ERROR,"poke");
                  return;
               }
               console.text = data;
               obj = com.adobe.serialization.json.JSON.decode(data);
               result = obj["result"];
               console.text = data;
               json = unescHtml(obj["fromUser"].json);
               pokeFromUser.saveBuddy(json);
               if(saveToS3)
               {
                  fromId = pokeFromUser.userId;
                  fromUserContent = json;
                  fromPolicy = obj["fromUser"].s3p;
                  if(fromPolicy == null)
                  {
                     saveToS3 = false;
                  }
                  else
                  {
                     fromSig = obj["fromUser"].s3s;
                     fromRetryCnt = 0;
                     savedFromUser = function(param1:*):void
                     {
                        console.appendText("SAVED fromUser avatar to s3 - success\n");
                        onSavedPoke();
                     };
                     errorFromUser = function(param1:*):void
                     {
                        console.appendText("ERROR fromUser avatar to s3 - success\n");
                        ++fromRetryCnt;
                        if(fromRetryCnt < 2)
                        {
                           console.appendText("retry..\n");
                           saveAvatarToS3(fromId,fromUserContent,fromPolicy,fromSig,savedFromUser,errorFromUser);
                        }
                        else
                        {
                           gaTrackError("sthree error saving poke");
                           showServerError(SAVING_POKE_ERROR,"poke");
                        }
                     };
                     console.appendText("\n\nsave fromUser avatar to s3..\n");
                     saveAvatarToS3(fromId,fromUserContent,fromPolicy,fromSig,savedFromUser,errorFromUser);
                  }
               }
               json = unescHtml(obj["toUser"].json);
               pokeToUser.saveBuddy(json);
               if(saveToS3)
               {
                  toId = pokeToUser.userId;
                  toUserContent = json;
                  toPolicy = obj["toUser"].s3p;
                  if(toPolicy == null)
                  {
                     saveToS3 = false;
                  }
                  toSig = obj["toUser"].s3s;
                  toRetryCnt = 0;
                  savedToUser = function(param1:*):void
                  {
                     console.appendText("SAVED toUser avatar to s3 - success\n");
                  };
                  errorToUser = function(param1:*):void
                  {
                     ++toRetryCnt;
                     console.appendText("ERROR toUser avatar to s3 - success\n");
                     if(toRetryCnt < 2)
                     {
                        console.appendText("retry..\n");
                        saveAvatarToS3(toId,toUserContent,toPolicy,toSig,savedToUser,errorToUser);
                     }
                     else
                     {
                        gaTrackError("sthree error saving poke");
                        showServerError(SAVING_POKE_ERROR,"poke");
                     }
                  };
                  console.appendText("\n\nsave toUser avatar to s3..\n");
                  saveAvatarToS3(toId,toUserContent,toPolicy,toSig,savedToUser,errorToUser);
               }
               if(!saveToS3)
               {
                  onSavedPoke();
               }
            }
            catch(e:*)
            {
               console.text = "Make request failed...";
               if(savePokeRetryCount < MAX_NUM_RETRY)
               {
                  ++savePokeRetryCount;
                  onSavePoke();
                  return;
               }
               gaTrackError("sthree exception error saving poke");
               showServerError(SAVING_POKE_ERROR,"poke");
               return;
            }
         };
         if(this.runLocal)
         {
            onSavedPoke();
         }
         else
         {
            url = BASE_URL + "poke";
            params = {};
            callbackName = "onLoad" + BuddyPoke.timeStamp();
            ExternalInterface.addCallback(callbackName,onLoad);
            params[RequestParameters.METHOD] = MethodType.POST;
            params[RequestParameters.CONTENT_TYPE] = ContentType.TEXT;
            params[RequestParameters.AUTHORIZATION] = AuthorizationType.SIGNED;
            params[RequestParameters.POST_DATA] = "poke=" + selectedPokeId + "&fromUser=" + pokeFromUser.userId + "&toUser=" + pokeToUser.userId + "&epoch=" + savePokeEpoch;
            if(saveToS3)
            {
               params[RequestParameters.POST_DATA] += "&s3=1";
            }
            if("05889220392208221562" == owner.userId)
            {
               params[RequestParameters.POST_DATA] += "&prof=1";
            }
            makeRequest(url,callbackName,params);
         }
      }
      
      private function onLoadedOwnerBuddy(param1:OSUser) : void
      {
         if(viewer == null || viewer.userError)
         {
            loadedUserInfo();
         }
         else
         {
            viewer.loadBuddy(onLoadedViewerBuddy);
         }
      }
      
      private function onSavedBuddy(param1:Event = null) : void
      {
         console.appendText("\n\nonSavedBuddy \n");
         hideUIPanels();
         if(pokeEventsUI != null && !contains(pokeEventsUI))
         {
            addChild(pokeEventsUI);
         }
         showLastSelectedEvent();
      }
      
      private function onPokeBackLink(param1:Event) : void
      {
         if(lastPokedFromUserId == null)
         {
            return;
         }
         pokeFromUser = owner;
         pokeToUser = getUser(lastPokedFromUserId);
         createPokeUI();
         gaTrack("link/pokeback");
      }
      
      private function createAddCommentTags(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = root.loaderInfo.loaderURL;
         if(CONTAINER_ID == "myspace")
         {
            return "<center><br/><a href=\"http://www.myspace.com/buddypoke\"><b>You&#39;ve been BuddyPoked!</b></a><br/><object width=\"300\" height=\"250\" data=\"" + _loc2_ + "\" allownetworking=\"internal\" allowscriptaccess=\"never\" type=\"application/x-shockwave-flash\"><param value=\"never\" name=\"allowScriptAccess\"/><param value=\"internal\" name=\"allowNetworking\"/><param value=\"transparent\" name=\"wmode\"/><param value=\"" + _loc2_ + "\" name=\"movie\"/><param value=\"opensocial_surface=bulletin&anim=" + param1 + "&buddy=" + owner.buddyDesc + "\" name=\"flashvars\"/></object><br/><a href=\"http://www.myspace.com/buddypoke\"><b>Get your own SUPER COOL Buddy NOW!</b></a><br/><br/></center>";
         }
         if(CONTAINER_ID == "hi5")
         {
            _loc3_ = "http://hi5.com/friend/apps/entry/buddypoke.s3.amazonaws.com/hi5.xml?view=preview&from=gallery&";
         }
         else if(CONTAINER_ID == "orkut")
         {
            return "<a href=\"http://orkut.com/Application.aspx?appId=43931632273\">Get your own BuddyPoke!</a><embed height=\"250\" width=\"300\" flashvars=\"opensocial_surface=comment&anim=" + param1 + "&buddy=" + owner.buddyDesc + "\" type=\"application/x-shockwave-flash\" src=\"" + _loc2_ + "\" wmode=\"transparent\"/>";
         }
         return "<div><center><br/><embed align=\"middle\" height=\"250px\" width=\"300px\" flashvars=\"opensocial_surface=comment&anim=" + param1 + "&buddy=" + owner.buddyDesc + "\" wmode=\"transparent\" salign=\"l\" scale=\"noscale\" quality=\"high\" type=\"application/x-shockwave-flash\" src=\"" + _loc2_ + "\" allowscriptaccess=\"never\"/><br/><a href=\"" + _loc3_ + "\"><b>Get your own SUPER COOL BuddyPoke!</b></a><br/></center></div>";
      }
      
      private function createInstructionStep(param1:String, param2:int, param3:Number, param4:Number) : TextField
      {
         var _loc5_:TextField = new TextField();
         var _loc6_:TextFormat = new TextFormat();
         _loc6_.font = "_sans";
         _loc6_.color = 0;
         _loc6_.size = 12;
         _loc6_.align = TextFormatAlign.LEFT;
         var _loc7_:TextField = new TextField();
         _loc7_.width = 280;
         _loc7_.selectable = false;
         _loc7_.multiline = true;
         _loc7_.wordWrap = true;
         _loc7_.autoSize = TextFieldAutoSize.LEFT;
         _loc7_.antiAliasType = AntiAliasType.ADVANCED;
         _loc7_.defaultTextFormat = _loc6_;
         _loc7_.setTextFormat(_loc6_);
         _loc7_.htmlText = param1;
         _loc7_.x = param3;
         _loc7_.y = param4;
         return _loc7_;
      }
      
      private function createMoodUI() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Number = NaN;
         var _loc6_:TextField = null;
         paused = false;
         customizing = false;
         showingMood = true;
         if(buddy1 != null && owner != null)
         {
            buddy1.deserializeCompressed(owner.buddyDesc);
         }
         hideUIPanels();
         if(moodSelectionHolder == null)
         {
            moodSelectionHolder = new Sprite();
            drawHolderBackground(moodSelectionHolder,SELECTION_PANEL_WIDTH,180 + 25);
            _loc5_ = moodSelectionHolder.getBounds(moodSelectionHolder).width;
            moodSelectionHolder.x = HOLDER_POSITION_X;
            moodSelectionHolder.y = HOLDER_POSITION_Y;
            _loc6_ = new TextField();
            _loc6_.autoSize = TextFieldAutoSize.LEFT;
            _loc6_.background = false;
            _loc6_.border = false;
            _loc6_.htmlText = MessageBundle.msg("How are you feeling today?");
            _loc6_.setTextFormat(new TextFormat("Arial",11,4019299,true));
            _loc6_.x = 2;
            moodSelectionHolder.addChild(_loc6_);
            MoodSelectionPanel.TWO_COLS = NUMBER_ROWS == 2;
            MoodSelectionPanel.COL_OFFSET = 8;
            moodSelectionPanel = new MoodSelectionPanel(0,20,SELECTION_PANEL_WIDTH,150);
            moodSelectionPanel.addEventListener(PokeEvent.SELECT_POKE,onSelectedMood);
            moodSelectionPanel.loadMoods(buddy1,this.owner);
            moodSelectionHolder.addChild(moodSelectionPanel);
            moodSelectionPanel.visible = true;
            _loc2_ = createLink(MessageBundle.msg("Change your mood"),238,13,true,TextFieldAutoSize.CENTER,true,true);
            _loc2_.addEventListener(MouseEvent.CLICK,onMood);
            _loc2_.x = 0.5 * SELECTION_PANEL_WIDTH;
            _loc2_.y = ACTION_LINK_Y;
            moodSelectionHolder.addChild(_loc2_);
            _loc3_ = createLink(MessageBundle.msg("Saving your mood change..."),238,15,false,TextFieldAutoSize.CENTER,false);
            _loc3_.x = 0.5 * 268;
            _loc3_.y = 30;
            saveMoodHolder = new Sprite();
            saveMoodHolder.graphics.lineStyle(0,14862370,1);
            saveMoodHolder.graphics.beginFill(16775639,1);
            saveMoodHolder.graphics.drawRect(0,0,266,100);
            saveMoodHolder.graphics.endFill();
            _loc5_ = saveMoodHolder.getBounds(saveMoodHolder).width;
            _loc4_ = new UploadProgress();
            _loc4_.x = (_loc5_ - 28) * 0.5;
            _loc4_.y = 60;
            saveMoodHolder.addChild(_loc4_);
            saveMoodHolder.x = 0.5 * (STAGE_WIDTH - _loc5_);
            saveMoodHolder.y = HOLDER_POSITION_Y + HOLDER_POSITION_OFFSET;
            saveMoodHolder.addChild(_loc3_);
         }
         var _loc1_:String = moodSelectionPanel.selected;
         selectedMoodId = _loc1_;
         showMood(_loc1_);
         addChild(moodSelectionHolder);
         stage.dispatchEvent(new Event(Event.RENDER));
      }
      
      private function onPokeFriendLink(param1:Event) : void
      {
         pokeFromUser = viewer;
         pokeToUser = owner;
         createPokeUI();
         gaTrack("link/pokefriend");
      }
      
      private function createPokeBackTextField() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.width = 0;
         _loc1_.autoSize = TextFieldAutoSize.RIGHT;
         _loc1_.selectable = false;
         _loc1_.filters = [new GlowFilter(16777215,0.95,3,3,8,3)];
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.font = "tahoma,verdana,arial,sans-serif";
         _loc2_.align = TextFormatAlign.RIGHT;
         _loc2_.size = 11;
         _loc2_.color = 13209;
         _loc2_.bold = true;
         _loc2_.underline = true;
         _loc1_.defaultTextFormat = _loc2_;
         _loc1_.setTextFormat(_loc2_);
         _loc1_.y = buddyPanelHeight;
         _loc1_.x = (STAGE_WIDTH - SELECTION_PANEL_WIDTH) * 0.5 + SELECTION_PANEL_WIDTH;
         return _loc1_;
      }
      
      private function hideUIPanels() : void
      {
         try
         {
            buddy1.context.camera = Camera(buddy1.context.scene.getNodeByName("Camera_Long"));
         }
         catch(e:*)
         {
         }
         if(buddyPanelHolder != null && buddyPanelPicker != null && buddyPanelHolder.contains(buddyPanelPicker))
         {
            buddyPanelHolder.removeChild(buddyPanelPicker);
         }
         if(pokeFriendsPageHolder != null && contains(pokeFriendsPageHolder))
         {
            removeChild(pokeFriendsPageHolder);
         }
         if(pokeBackHolder != null && contains(pokeBackHolder))
         {
            removeChild(pokeBackHolder);
         }
         if(pokeFriendHolder != null && contains(pokeFriendHolder))
         {
            removeChild(pokeFriendHolder);
         }
         if(errorMessageHolder != null && contains(errorMessageHolder))
         {
            removeChild(errorMessageHolder);
         }
         if(shareBuddyHolder != null && contains(shareBuddyHolder))
         {
            removeChild(shareBuddyHolder);
         }
         if(pokeSelectionHolder != null && contains(pokeSelectionHolder))
         {
            removeChild(pokeSelectionHolder);
         }
         if(savePokeHolder != null && contains(savePokeHolder))
         {
            removeChild(savePokeHolder);
         }
         if(appearanceSelectionHolder != null && contains(appearanceSelectionHolder))
         {
            removeChild(appearanceSelectionHolder);
         }
         if(saveAppearanceHolder != null && contains(saveAppearanceHolder))
         {
            removeChild(saveAppearanceHolder);
         }
         if(moodSelectionHolder != null && contains(moodSelectionHolder))
         {
            removeChild(moodSelectionHolder);
         }
         if(saveMoodHolder != null && contains(saveMoodHolder))
         {
            removeChild(saveMoodHolder);
         }
         if(pokeEventsUI != null && contains(pokeEventsUI))
         {
            removeChild(pokeEventsUI);
         }
      }
      
      private function blah() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.width = 0;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.selectable = false;
         _loc1_.filters = [new GlowFilter(16777215,0.95,3,3,8,3)];
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.font = "tahoma,verdana,arial,sans-serif";
         _loc2_.align = TextFormatAlign.LEFT;
         _loc2_.size = 11;
         _loc2_.color = 13209;
         _loc2_.bold = false;
         _loc2_.underline = false;
         _loc1_.defaultTextFormat = _loc2_;
         _loc1_.setTextFormat(_loc2_);
         return _loc1_;
      }
   }
}


package ui.core {
	
	import flash.geom.*;
	
	import onyx.constants.*;
	import onyx.core.*;
	import onyx.file.*;
	import onyx.plugin.*;
	
	import ui.controls.*;
	import ui.states.*;
	import ui.window.*;
	
	public final class Settings {
		
		/**
		 * 	@private
		 * 	Parses the settings
		 */
		public static function apply():void {
			
			var init:XML		= xml.init[0];
			var core:XMLList	= xml.core;
			var list:XMLList;
			
			// check for startup folder
			if (init.hasOwnProperty('startupFolder')) {
				STARTUP_PATH		= init.startupFolder;
				Browser.ROOT_DIR	= STARTUP_PATH + init.videoFolder;
			}
			
			// set default core settings
			if (core.hasOwnProperty('render')) {
				
				list = core.render;
				
				if (list.hasOwnProperty('bitmapData')) {
					BITMAP_WIDTH	= list.bitmapData.width;
					BITMAP_HEIGHT	= list.bitmapData.height;
					BITMAP_RECT		= new Rectangle(0, 0, BITMAP_WIDTH, BITMAP_HEIGHT);
				}
				
				if (list.hasOwnProperty('quality')) {
					STAGE.quality = list.quality;
				}
			}

			// add custom order for blendmodes
			if (core.hasOwnProperty('blendModes')) {
				
				list = core.blendModes;

				// remove all previous blend modes
				while (BLEND_MODES.length) {
					BLEND_MODES.pop();
				}
				
				// make new blend modes
				for each (var mode:XML in list.*) {
					BLEND_MODES.push(String(mode.name()));
				}
				
			}
			
			var uiXML:XMLList	= xml.ui;
			
			if (uiXML.hasOwnProperty('swatch')) {
				list = uiXML.swatch;
				
				try {
					var colors:Array = [];
					for each (var color:uint in list.*) {
						colors.push(color);
					}
					ColorPicker.registerSwatch(colors);
				} catch (e:Error) {
					Console.error(e);
				}
				
			}
			
			// stored keys
			if (uiXML.hasOwnProperty('keys')) {
				
				list = uiXML.keys;
				
				// map keys
				for each (var key:XML in list.*) {
					
					
					
					try {
						KeyListenerState.registerKey(key.@code, Macro.getDefinition(key.toString()));
					} catch (e:Error) {
						Console.error(e);
					}

				}
			}
			
			// parse states
			if (uiXML.hasOwnProperty('states')) {

				// set the startup window state
				// startupWindowState = uiXML.states.@['startup-state'];
				
				list = uiXML.states;
				for each (var stateXML:XML in list.*) {
					var windows:Array		= [];

					for each (var regXML:XML in stateXML.windows.*) {
						
						switch (regXML.name().toString()) {
							case 'window':
								windows.push(new WindowStateReg(String(regXML.toString()), regXML.@x, regXML.@y));
								break;
						}
					}

					WindowState.register(new WindowState(String(stateXML.name), windows));
				}
				
			}
		}
		
		public static var xml:XML	= 
			<settings>
				<!-- META DATA -->
				<metadata>
					<version>3.0.5</version>
				</metadata>
				
				<!-- INITIALIZATION SETTINGS -->
				<init>
				</init>
				
				<!-- CORE SETTINGS FOR RENDERING -->
				<core>
			
					<render>
						<!-- the width / height of bitmaps -->
						<bitmapData>
							<width>320</width>
							<height>240</height>
						</bitmapData>
					</render>
					
					<!-- midi settings -->
					<midi>
						<enabled>false</enabled>
					</midi>
					
					<!-- custom ordering of blendmodes for blendmode controls -->
					<blendModes>
						<normal/>
						<lighten/>
						<darken/>
						<overlay/>
						<hardlight/>
						<multiply/>
						<screen/>
						<add/>
						<subtract/>
						<difference/>
						<invert/>
					</blendModes>
					
				</core>
				
				<!-- UI STATES -->
				<ui>
				
					<!-- LOCATION OF THE PREVIEW WINDOW -->
					<preview>
						<display>auto</display>
						<x>0</x>
						<y>0</y>
					</preview>
					
					<!-- COLOR SWATCH SETTINGS -->
					<swatch>
						<color>0x000000</color>
						<color>0x1c1c1c</color>
						<color>0x383838</color>
						<color>0x555555</color>
						<color>0x717171</color>
						<color>0x8d8d8d</color>
						<color>0xaaaaaa</color>
						<color>0xc6c6c6</color>
						<color>0xe2e2e2</color>
						<color>0xffffff</color>
					</swatch>
					
					<keys>
						<!-- BASE UI MACROS -->
						<key code="37">SELECTLAYERPREVIOUS</key>
						<key code="39">SELECTLAYERNEXT</key>
						<key code="49">SELECTLAYER0</key>
						<key code="50">SELECTLAYER1</key>
						<key code="51">SELECTLAYER2</key>
						<key code="52">SELECTLAYER3</key>
						<key code="53">SELECTLAYER4</key>
						<key code="81">SELECTPAGE0</key>
						<key code="87">SELECTPAGE1</key>
						<key code="69">SELECTPAGE2</key>
						<key code="38">SELECTFILTERUP</key>
						<key code="40">SELECTFILTERDOWN</key>
						
						<key code="90">MUTELAYER0</key>
						<key code="88">MUTELAYER1</key>
						<key code="67">MUTELAYER2</key>
						<key code="86">MUTELAYER3</key>
						<key code="66">MUTELAYER4</key>
			
						<key code="188">CYCLEBLENDUP</key>
						<key code="190">CYCLEBLENDDOWN</key>
						<key code="191">RESETLAYER</key>
			
						<!-- CUSTOM MACROS -->
						<key code="112">ECHO DISPLAY</key>
						<key code="113">SLOW DOWN LAYERS</key>
						<key code="114">SPEED UP LAYERS</key>
						<key code="115">BUFFER DISPLAY</key>
						<key code="116">RANDOM BLEND</key>
						<key code="117">DISPLAY CONTRAST</key>
						<key code="118">RANDOM MOVESCALE</key>
						<key code="119">RANDOM FRAMEMACRO</key>
						<key code="120">RESETALL</key>
						<key code="122">FRAMERATE DECREASE</key>
						<key code="123">FRAMERATE INCREASE</key>
					</keys>
					
					<!-- THE DIFFERENT INTERFACE STATES -->
					<states startup-state="DEFAULT">
						 <!-- SEQUENCE -->
						 <state>
						 	<name>SEQUENCE</name>
						 	<windows>
								<window x="6" y="318">FILE BROWSER</window>
						 		<window x="4" y="4">SEQUENCE</window>
								<window x="412" y="318">FILTERS</window>
						 	</windows>
						 </state>
					</states>
				</ui>
			</settings>;
	}
}
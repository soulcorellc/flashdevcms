package com.flashcms 
{
	import com.flashcms.site.Footer;
	import com.flashcms.site.Header;
	import flash.display.MovieClip;
	import com.flashcms.site.Background;
	import com.flashcms.data.XMLLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import com.flashcms.layout.StageManager;
	import gs.TweenMax;
	/**
	* ...
	* @author David Barrios
	*/
	public class Shell extends MovieClip
	{
		private var oBackground:Background;
		private var oXMLLoader:XMLLoader;
		private var oXMLMainLoader:XMLLoader;
		private var urlConfiguration:String = "./admin/xml/site/configuration.xml";
		private var oXML:XML;
		private var oMainXML:XML;
		private var themes:XMLList;
		private var configuration:XMLList;
		private var oHeader:Header;
		private var oFooter:Footer;
		private var xURLs:XMLList;
		/**
		 * 
		 */
		public function Shell() 
		{
			init();
			
		}
		/**
		 * 
		 */
		private function init()
		{
			oHeader = new Header();
			oFooter = new Footer;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			oXMLLoader = new XMLLoader(urlConfiguration, onConfiguration, onError);
		}
		/**
		 * 
		 */
		private function createBackground()
		{
			oBackground = new Background(0x003366, stage.stageWidth, stage.stageHeight);
			stage.addEventListener(Event.RESIZE, onStageResize);
			addChild(oBackground);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onConfiguration(event:Event)
		{
			oXML = XML(event.target.data);
			xURLs = oXML.urls;
			oXMLMainLoader = new XMLLoader(getURL("main", "core"), onMainData, null, null, { option:"getconfiguration" } );
		}
		/**
		 * 
		 * @param	e
		 */
		private function onMainData(event:Event)
		{
			oMainXML=XML(event.target.data);
			//themes = new XMLList(oXML.themes);
			configuration = XMLList(oMainXML.configuration);
			createBackground();
			initModule(oHeader,0x006699);
			initModule(oFooter, 0x006699);
			trace("jeder "+configuration.(property == "headerheight").val);
			oHeader.mcBackground.height = configuration.(property == "headerheight").val;
		}
		/**
		 * 
		 * @param	oModule
		 * @param	color
		 */
		private function initModule(oModule,color)
		{
			TweenMax.to(oModule.mcBackground, 0, {colorMatrixFilter:{colorize:color}} );
			stage.addEventListener(Event.RESIZE, oModule.onResize);
			addChild(oModule);
			addChild(oModule.sManager);
			oModule.onResize();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onStageResize(e:Event)
		{
			oBackground.update(stage.stageWidth,stage.stageHeight);
		}
		/**
		 * 
		 * @param	name
		 * @param	section
		 * @return
		 */
		public function getURL(name:String,section:String=null):String
		{
			var url:String=section == null? xURLs[name] : xURLs[section][name];
			var server:String = xURLs["server"];
			trace(".."+url);
			return server + url;
		}
		/**
		 * 
		 * @param	e
		 */
		private function onError(e:Event)
		{
			trace("Error loading main file");
		}
		
	}
	
}
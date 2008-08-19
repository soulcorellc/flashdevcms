package com.flashcms 
{
	import com.flashcms.site.Header;
	import flash.display.MovieClip;
	import com.flashcms.site.Background;
	import com.flashcms.data.XMLLoader;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import gs.TweenMax;
	/**
	* ...
	* @author David Barrios
	*/
	public class Shell extends MovieClip
	{
		private var oBackground:Background;
		private var oXMLLoader:XMLLoader;
		private var urlConfiguration:String = "./admin/xml/site/main.xml";
		private var oXML:XML;
		private var themes:XMLList;
		private var configuration:XMLList;
		private var oHeader:Header;
		public function Shell() 
		{
			init();
			
		}
		/**
		 * 
		 */
		private function init()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			oXMLLoader = new XMLLoader(urlConfiguration, onSiteData, onError);
		}
		private function setLayout()
		{
			trace("ok");
		}
		/**
		 * 
		 */
		private function createBackground()
		{
			oBackground = new Background(uint(themes.background), stage.stageWidth, stage.stageHeight);
			stage.addEventListener(Event.RESIZE, onStageResize);
			addChild(oBackground);
		}
		private function onSiteData(event:Event)
		{
			oXML = XML(event.target.data);
			themes = new XMLList(oXML.themes);
			configuration = XMLList(oXML.configuration);
			createBackground();
			loadHeader();
			loadFooter();
		}
		private function loadHeader()
		{
			oHeader = new Header();
			oHeader.mcBackground.width = stage.stageWidth;
			TweenMax.to(oHeader.mcBackground, 0, {colorMatrixFilter:{colorize:themes.header}} );
			addChild(oHeader);
		}
		private function loadFooter()
		{}
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
		 * @param	e
		 */
		private function onError(e:Event)
		{
			trace("Error loading main file");
		}
		
	}
	
}
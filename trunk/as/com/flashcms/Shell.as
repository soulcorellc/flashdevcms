package com.flashcms 
{
	import com.flashcms.site.SiteSection;
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
	import com.flashcms.components.menu.Menu;
	import fl.motion.easing.Elastic;
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
		private var themesXML:XML;
		private var configuration:XMLList;
		private var oHeader:Header;
		private var oFooter:Footer;
		private var oSection:SiteSection;
		private var xURLs:XMLList;
		public var mcMenu:Menu;
		private var sURLMenu:String;
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
			oFooter = new Footer();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			oXMLLoader = new XMLLoader(urlConfiguration, onConfiguration, onError);
			
		}
		/**
		 * 
		 */
		private function createBackground()
		{
			oBackground = new Background(themesXML.background, stage.stageWidth, stage.stageHeight);
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
			oXMLMainLoader = new XMLLoader(getURL("main", "core"), onMainData, null, null, { option:"getmain" } );
		}
		/**
		 * 
		 * @param	e
		 */
		private function onMainData(event:Event)
		{
			oMainXML = XML(event.target.data);
			var contentstring:String = oMainXML.themes[0].data;
			var oXMLTemp:XML = new XML(contentstring);
			themesXML=new XML(oXMLTemp.toString());
			
			configuration = XMLList(oMainXML.configuration);
			createBackground();
			initModule(oHeader,themesXML.header);
			initModule(oFooter, themesXML.footer);
			
			oHeader.setText(configuration.(property == "title").val);
			oHeader.setImage(configuration.(property == "headerimage").val);
			
			oHeader.mcBackground.height = configuration.(property == "headerheight").val;
			sURLMenu = getURL("main", "menu") ;
			oXMLLoader = new XMLLoader(sURLMenu+"?option=getall", onMenu, null, onError);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onMenu(e:Event)
		{
			oXML = XML(e.target.data);
			
			
			var treeXML:XML=new XML(<node/>);
			
			for each(var oMenu:XML in oXML.Menu)
			{
				if (String(oMenu.idParent).length<=0)
				{
					treeXML.node += <node id ={oMenu.idMenu} label = {oMenu.name} idContent={oMenu.idContent} /> ;
				}
				else
				{
					var node = treeXML..node.(@id == oMenu.idParent);
					node.node+= <node id = {oMenu.idMenu} label = {oMenu.name} idContent={oMenu.idContent} /> ;
				}
				
			}
			mcMenu = new Menu(themesXML);
			mcMenu.init(treeXML);
			mcMenu.addEventListener("ItemClick", onItemClick);
			addChild(mcMenu);
			mcMenu.x = 30;
			mcMenu.y = oHeader.y+oHeader.height+50;
			skinMenu();
			
			
			oSection = new SiteSection();
			oSection.oShell = this;
			oSection.x = 200;
			oSection.y = 200;
			addChild(oSection);
			

		}
		private function onItemClick(e:Event)
		{
			oSection.setSection(e.target.selectedID);
		}
		private function skinMenu()
		{
			
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
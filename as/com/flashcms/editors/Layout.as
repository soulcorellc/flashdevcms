﻿package com.flashcms.editors 
{
	import com.flashcms.cellrender.ButtonRenderer;
	import com.flashcms.core.Module;
	import com.flashcms.data.MultiLoader;
	import com.flashcms.events.*;
	import com.flashcms.events.PopupEvent;
	import com.yahoo.astra.fl.containers.BorderPane;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.yahoo.astra.layout.modes.BorderConstraints;
	import com.yahoo.example.views.ResizeHandle;
	import com.yahoo.example.events.DragEvent;
	import com.flashcms.layout.LayoutObject;
	import com.flashcms.editors.utils.Bar;
	import com.flashcms.data.XMLLoader;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.text.TextFieldAutoSize;
	import gs.TweenMax;
	import fl.controls.Button;
	/**
	* ...
	* @author David Barrios
	*/
	public class Layout extends Module
	{
		public var btSave:Button;
		public var dragStartWidth:int;
		public var hdragStartWidth:int;
		public var mcHeader:Sprite;
		public var mcFooter:Sprite;
		public var mcMenu:Sprite;
		public var mcLogo:Bitmap;
		public var mcBroken:MovieClip;
		public var mcBar:Bar;
		public var resizeHandle:ResizeHandle;
		public var hresizeHandle:ResizeHandle;
		public var config:Array;
		public var panel:BorderPane;
		public var MIN_WIDTH:int = 100;
		public var MIN_HEIGHT:int = 60;
		public var menutype:int = 0;
		public var txtSizeH:TextField;
		public var txtSizeM:TextField;
		public var txtTitle:TextField;
		private var oXMLLoader:XMLLoader;
		private var oXML:XML;
		private var themesXML:XML;
		private var menuwidth:int;
		private var headerheight:int;
		private var sURL:String;
		private var sURLLogo:String;
		private var oLogoLoader:MultiLoader;
		public function Layout() 
		{
			
		}
		/**
		 * 
		 */
		public override function init()
		{
			txtTitle.autoSize = TextFieldAutoSize.LEFT;
			oLogoLoader = new MultiLoader();
			oLogoLoader.addEventListener(LoadEvent.LOAD_EVENT, onLoadLogo);
			oLogoLoader.addEventListener(LoadError.LOAD_ERROR, onErrorLogo);
			loadXML();
		}
		/**
		 * 
		 */
		private function loadXML()
		{
			sURL = oShell.getURL("layout", "editors");
			oXMLLoader = new XMLLoader(sURL,onXMLData,null,null,{option:"getmain"});
		}
		/**
		 * 
		 * @param	e
		 */
		private function onXMLData(e:Event)
		{
			oXML = XML(e.target.data);
			
			menutype = oXML.configuration.(property == "menutype").val; 
			menuwidth = oXML.configuration.(property == "menuwidth").val;
			headerheight = oXML.configuration.(property == "headerheight").val;
			txtTitle.htmlText = oXML.configuration.(property == "title").val;
			sURLLogo = oXML.configuration.(property == "headerimage").val;
			
			
			var contentstring:String = oXML.themes[0].data;
			var oXMLTemp:XML = new XML(contentstring);
			themesXML=new XML(oXMLTemp.toString());
			
			
			TweenMax.to(mcHeader, 0, { tint: themesXML.header } );
			TweenMax.to(mcMenu, 0, { tint: themesXML.menu_up} );
			TweenMax.to(mcBar, 0, { tint: themesXML.footer} );
						
			
			panel.setStyle("color", oXML.configuration.(property == "background").val);
			txtSizeH.text = String(headerheight);
			txtSizeM.text = String(menuwidth);
			mcHeader.height = headerheight;
			mcMenu.width = menuwidth;
			draw();
			//mcBar.setMenu(menutype);
			btSave.addEventListener(MouseEvent.CLICK, onSave);
			loadLogo();
		}
		/**
		 * 
		 */
		private function draw()
		{
			//mcBar.addEventListener(Event.CHANGE, onMenuChange);
			//mcBar.addEventListener("save", onSave);
			hresizeHandle = new ResizeHandle();
			hresizeHandle.direction = "horizontal";
			resizeHandle = new ResizeHandle();
			resizeHandle.direction = "vertical";
			resizeHandle.addEventListener(DragEvent.DRAG_START, resizeDragStartHandler);
			resizeHandle.addEventListener(DragEvent.DRAG_UPDATE, resizeDragUpdateHandler);
			hresizeHandle.addEventListener(DragEvent.DRAG_START, hresizeDragStartHandler);
			hresizeHandle.addEventListener(DragEvent.DRAG_UPDATE, hresizeDragUpdateHandler);
			if (menutype== 0)
				setLeftConfig()
			else
				setRightConfig();
			panel.verticalGap = 5;	
			
			txtTitle.addEventListener(MouseEvent.CLICK, onTitleClick);
				
		}
		private function onTitleClick(e:MouseEvent)
		{
			oShell.showPopup("texteditor",{text:txtTitle.htmlText,logo:sURLLogo,header:""},onClosePopup);	
		}
		
		private function loadLogo()
		{
			oLogoLoader.add(sURLLogo);
			oLogoLoader.start();
		}
		private function onErrorLogo(e:LoadError)
		{
			if (mcLogo != null){
				removeChild(mcLogo);
			}
			if (mcBroken == null)
			{
				mcBroken = new ImageBroken();
				mcBroken.x = 10;
				mcBroken.y = 10;
				addChild(mcBroken);
			}
		}
		private function onLoadLogo(e:LoadEvent)
		{
			if (mcLogo != null){
				removeChild(mcLogo);
			}
			if (mcBroken != null){
				removeChild(mcBroken);
				mcBroken = null;
			}
			mcLogo = Bitmap(LoaderInfo(e.loaderTarget).loader.content);
			mcLogo.x = 10;
			mcLogo.y = 10;
			addChild(mcLogo);
		}
		/**
		 * 
		 */
		private function setLeftConfig()
		{
			txtSizeM.x = 4;	
			config=[  
				{target: this.mcHeader, constraint: BorderConstraints.TOP},
				{target: this.resizeHandle, constraint: BorderConstraints.TOP },
				{target: this.mcMenu, constraint: BorderConstraints.LEFT, maintainAspectRatio: false },
				{target: this.hresizeHandle, constraint: BorderConstraints.LEFT},
				{target: this.mcBar, constraint: BorderConstraints.BOTTOM}
			];
			panel.configuration = config;
		}
		/**
		 * 
		 */
		private function setRightConfig()
		{
			txtSizeM.x = 680;
			config=[  
				{target: this.mcHeader, constraint: BorderConstraints.TOP},
				{target: this.resizeHandle, constraint: BorderConstraints.TOP },
				{target: this.mcMenu, constraint: BorderConstraints.RIGHT, maintainAspectRatio: false },
				{target: this.hresizeHandle, constraint: BorderConstraints.RIGHT},
				{target: this.mcBar, constraint: BorderConstraints.BOTTOM}
			];
			panel.configuration = config;
		}
		/**
		 * 
		 * @param	e
		 */
		private function onMenuChange(e:Event)
		{
			menutype = e.target.menuType ;
			if (e.target.menuType == 0)
			setLeftConfig()
			else
			setRightConfig();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onSave(e:Event)
		{
			var datastring:String = getObject(4, txtSizeH.text) +";"+ getObject(6, txtSizeM.text) +";"+ getObject ( 8, txtTitle.htmlText) +";"+ getObject(11,sURLLogo);
			
			oXMLLoader = new XMLLoader(sURL, onSaveComplete, null, null, { option:"setconfiguration",data:datastring} );
		}
		/**
		 * Format two values to be sent to backend
		 * @param	id
		 * @param	value
		 */
		private function getObject(id:Number,value:String):String
		{
			return "{_id_@" + id + ",_val_@" + value + "}";
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function onSaveComplete(e:Event)
		{
			oShell.setStatusMessage("Layout Saved");
		}
		/**
		 * 
		 * @param	e
		 */
		private function onClosePopup(e:PopupEvent)
		{
			if (e.parameters.saved)
			{
				if (e.parameters.text != "")
				txtTitle.htmlText = e.parameters.text;
				else
				txtTitle.htmlText = "[Page Title]";
				trace("LOGO IS ", e.parameters.logo);
				sURLLogo = e.parameters.logo;
				loadLogo();
			}
		}
		function resizeDragStartHandler(event:DragEvent):void{
			dragStartWidth = mcHeader.height;
		}
		/**
		 * 
		 * @param	event
		 */
		function resizeDragUpdateHandler(event:DragEvent):void
		{
			var value = Math.min(2 * panel.height / 3, Math.max(0, dragStartWidth + event.delta));
			value = Math.max(MIN_HEIGHT, value);
			mcHeader.height = value;
			resizeHandle.y = mcHeader.height;
			txtSizeH.text = String(Math.round(value));
			
		}
		/**
		 * 
		 * @param	event
		 */
		function hresizeDragStartHandler(event:DragEvent):void{
			hdragStartWidth = mcMenu.width;
		}
		/**
		 * 
		 * @param	event
		 */
		function hresizeDragUpdateHandler(event:DragEvent):void
		{
			var value;
			if (menutype == 1)
			{
				
				event.delta *= -1;
				value = Math.round(Math.min(2 * panel.width / 3, Math.max(0, hdragStartWidth + event.delta)));
				mcMenu.width = value;
				hresizeHandle.x = panel.width-value;
			}
			else
			{
				value= Math.min(2 * panel.width / 3, Math.max(0, hdragStartWidth + event.delta));
				value = Math.max(MIN_WIDTH, value);
				mcMenu.width = value;
				hresizeHandle.x = mcMenu.width;
			}
			txtSizeM.text = String(Math.round(value));
		}
	}
	
}
package com.flashcms.editors 
{
	import com.flashcms.core.Module;
	import com.flashcms.events.PopupEvent;
	import com.yahoo.astra.fl.containers.BorderPane;
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
	import flash.text.TextFieldAutoSize;
	/**
	* ...
	* @author David Barrios
	*/
	public class Layout extends Module
	{
		public var dragStartWidth:int;
		public var hdragStartWidth:int;
		public var mcHeader:Sprite;
		public var mcFooter:Sprite;
		public var mcMenu:Sprite;
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
		private var menuwidth:int;
		private var headerheight:int;
		public function Layout() 
		{
			
		}
		/**
		 * 
		 */
		public override function init()
		{
			txtTitle.autoSize = TextFieldAutoSize.LEFT;
			loadXML();
		}
		private function loadXML()
		{
			oXMLLoader = new XMLLoader(oShell.getURL("layout", "editors"), onXMLData);
		}
		
		private function onXMLData(e:Event)
		{
			oXML = XML(e.target.data);
			menutype = oXML.configuration.(name == "menutype").value;
			menuwidth = oXML.configuration.(name == "menu").value;
			headerheight = oXML.configuration.(name == "header").value;
			txtTitle.text = oXML.configuration.(name == "headertext").value;
			txtSizeH.text = String(headerheight);
			txtSizeM.text = String(menuwidth);
			mcHeader.height = headerheight;
			mcMenu.width = menuwidth;
			draw();
			mcBar.setMenu(menutype);
		}
		
		private function draw()
		{
			mcBar.addEventListener(Event.CHANGE, onMenuChange);
			mcBar.addEventListener("save", onSave);
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
			oShell.showPopup("texteditor",{text:txtTitle.htmlText},onClosePopup);	
		}
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
		private function onMenuChange(e:Event)
		{
			menutype = e.target.menuType ;
			if (e.target.menuType == 0)
			setLeftConfig()
			else
			setRightConfig();
		}
		private function onSave(e:Event)
		{
			oShell.setStatusMessage("Saved!");
		}
		private function onClosePopup(e:PopupEvent)
		{
			if (e.parameters.saved)
			{
				txtTitle.htmlText = e.parameters.text;
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
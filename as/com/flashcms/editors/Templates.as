package com.flashcms.editors{
	
	import com.flashcms.data.XMLLoader;
	import com.flashcms.events.ErrorEvent;
	import com.yahoo.astra.fl.controls.TabBar;
	import fl.controls.TextArea;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import com.flashcms.core.Module;
	import com.yahoo.astra.fl.containers.VBoxPane;
	import com.yahoo.astra.layout.modes.*;
	import com.flashcms.components.Holder;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	
	/**
	* ...
	* @author Default
	*/
	public class Templates extends Module{
		public var oTabBar:TabBar;
		public var scPanel:ScrollPane;
		public var componentsPanel:VBoxPane;
		public var toolsPanel:VBoxPane;
		private var icon:Holder;
		private var mcLayout:Sprite;
		private var mcXML:Sprite;
		private var id:int = 0;
		private var selected:Holder;
		private var currentState:int = 0;
		private var txtXML:TextArea;
		public var xmlComponents:XML =
		<data>
			<components>
				<type>Text</type>
				<icon>IconText</icon>
			</components>
			<components>
				<type>Image</type>
				<icon>IconImage</icon>
			</components>
			<components>
				<type>Video</type>
				<icon>IconVideo</icon>
			</components>
		</data>;
		public var xmlTools:XML =
		<data>
			<button>
				<type>New</type>
				<icon>IconNew</icon>
			</button>
			<button>
				<type>Open</type>
				<icon>IconOpen</icon>
			</button>
			<button>
				<type>Save</type>
				<icon>IconSave</icon>
			</button>
		</data>
		public var xmlTemplate:XML = <template/>;
		
		/**
		 * 
		 */
		public function Templates() {
			
		}
		/**
		 * 
		 */
		public override function init()
		{
			oTabBar.addEventListener(Event.CHANGE, onTabChange);
			mcLayout = new Sprite();
			mcXML= new Sprite();
			mcLayout.graphics.beginFill(0xFFFFFF, 0.3);
			mcLayout.graphics.drawRect(10, 10, scPanel.width-20,scPanel.height-20);
			mcLayout.graphics.endFill();
			scPanel.source = mcLayout;
			txtXML = new TextArea();
			txtXML.width = scPanel.width - 40;
			txtXML.height = scPanel.height - 40;
			txtXML.x = 20;
			txtXML.y = 20;
			mcXML.addChild(txtXML);
			toolsPanel.setStyle( "skin", "ToolbarSkin" ); 
			setToolBar(xmlComponents.components,componentsPanel,onStartDrag);
			setToolBar(xmlTools.button,toolsPanel,onToolsChange);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onDelete)
		}
		/**
		 * 
		 * @param	data
		 * @param	toolbar
		 * @param	callback
		 */
		private function setToolBar(data:XMLList,toolbar:VBoxPane,callback:Function)
		{
			for each(var component:XML in data)
			{
				var oButton:Button = new Button();
				oButton.useHandCursor = true;
				oButton.addEventListener(MouseEvent.MOUSE_DOWN, callback);
				oButton.width = 32;
				oButton.label = "";
				oButton.name = component.type;
				oButton.setStyle("upSkin", Shape);
				oButton.setStyle("icon", component.icon);
				toolbar.addChild(oButton);
			}
			toolbar.setStyle( "skin", "ToolbarSkin" ); 
			toolbar.horizontalAlign = HorizontalAlignment.CENTER;
			toolbar.verticalAlign = VerticalAlignment.MIDDLE;
			toolbar.verticalGap = 10;
			toolbar.horizontalGap = 10;
			
		}
		/**
		 * 
		 * @param	e
		 */
		private function onToolsChange(e:MouseEvent)
		{
			switch(e.target.name)
			{
				case "Save":
				var url = oShell.getURL("save", "templates");
				var variables = new Object();
				variables.xml = xmlTemplate;
				new XMLLoader(url, onSave, onDataError, onError, variables);
				break;
			}
		}
		/**
		 * 
		 * @param	e
		 */
		private function onSave(e:Event)
		{
			trace("saved");
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDataError(e:ErrorEvent)
		{
			oShell.setStatusMessage(e.message);
		}
		private function onError(e:Event)
		{
			trace("error");
		}
		private function onTabChange(event:Event)
		{
			var index:int = (event.currentTarget as TabBar).selectedIndex;  
			
			currentState = index;
			switch(index)
			{
				case 0:
					showEditor();
				break;
				case 1:
					showXML();
				break;
			}
			
		}
		/**
		 * 
		 */
		private function showEditor()
		{
			trace("showEditor");
			scPanel.source = mcLayout;
		}
		/**
		 * 
		 */
		private function showXML()
		{
			trace("showXML");
			txtXML.text = xmlTemplate;
			scPanel.source = mcXML;
		}
		/**
		 * 
		 * @param	e
		 */
		private function onStartDrag(e:MouseEvent)
		{
			icon = new Holder(e.target.name,true);
			icon.x = mouseX-8;
			icon.y = mouseY - 8;
			icon.alpha = 0.5;
			addChild(icon);
			icon.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			icon.addEventListener("Select", onSelect);
			icon.startDrag();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onStopDrag(e:MouseEvent)
		{
			icon.stopDrag();
			icon.addEventListener("Resize", onHolderResize);
			icon.alpha = 1;
			icon.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			if (icon.dropTarget.parent.parent== scPanel)
			{
				insertHolder();
				insertXML();
			}
			else 
			{
				removeChild(icon);
				icon = null;
			}
		}
		/**
		 * 
		 * @param	e
		 */
		private function onHolderResize(e:Event)
		{
			updateXML(e.target);
		}
		/**
		 * 
		 */
		private function updateXML(target)
		{
			var node = xmlTemplate.component.(@id == target.id);
			node.@x = target.x;
			node.@y = target.y;
			node.@width = target.width;
			node.@height = target.height;
			trace(xmlTemplate);
		}
		/**
		 * 
		 */
		private function insertXML()
		{
			xmlTemplate.component += <component id = { icon.id } type = { icon.type } x = { icon.x } y = { icon.y } width = { icon.width } height = { icon.height } /> 
		}
		/**
		 * 
		 */
		private function removeXML()
		{
			var node:XMLList = xmlTemplate.component.(@id == selected.id);
			delete node[0];
		}
		/**
		 * 
		 */
		private function insertHolder()
		{
			var point = new Point(icon.x, icon.y);
			var point2 = this.localToGlobal(point);
			mcLayout.globalToLocal(point2);
			icon.id = id;
			icon.x = mcLayout.globalToLocal(point2).x;
			icon.y=scPanel.globalToLocal(point2).y;
			mcLayout.addChild(icon);
			scPanel.update();
			icon.setDragable();
			id++;
		}
		/**
		 * 
		 * @param	e
		 */
		private function onSelect(e:Event)
		{
			selected = e.target as Holder;
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDelete(e:KeyboardEvent)
		{
			switch (e.keyCode) {
				case Keyboard.DELETE:
				deleteComponent();
				break;
			}
		}
		/**
		 * 
		 */
		private function deleteComponent()
		{
			if(selected != null)
			{
				removeXML();
				mcLayout.removeChild(selected);
				selected = null;
			}
		}
		/**
		 * 
		 */
		private function updateLayout()
		{
			mcLayout.graphics.clear();
			mcLayout.graphics.beginFill(0xFFFFFF, 0.3);
			mcLayout.graphics.drawRect(10, 10, mcLayout.width, mcLayout.height);
			mcLayout.graphics.endFill();
			
		}
		
	}
	
}
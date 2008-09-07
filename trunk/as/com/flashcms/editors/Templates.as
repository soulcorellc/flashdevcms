package com.flashcms.editors{
	
	import com.flashcms.data.XMLLoader;
	import com.flashcms.events.ErrorEvent;
	import com.yahoo.astra.fl.controls.TabBar;
	import fl.controls.TextArea;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import com.flashcms.core.Module;
	import com.yahoo.astra.fl.containers.HBoxPane;
	import com.yahoo.astra.layout.modes.*;
	import com.flashcms.components.Holder;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import com.flashcms.events.PopupEvent;

	
	/**
	* ...
	* @author Default
	*/
	public class Templates extends Module{
		public var xmlComponents:XMLList;
		public var xmlTools:XMLList;
		public var xmlTemplate:XML=<data/>;
		public var xmlLoadedTemplate:XML;
		public var sURL:String;
		public var oTabBar:TabBar;
		public var scPanel:ScrollPane;
		public var componentsPanel:HBoxPane;
		public var toolsPanel:HBoxPane;
		public var txtName:TextField;
		private var icon:Holder;
		private var mcLayout:Sprite;
		private var mcXML:Sprite;
		private var idtemplate:int = -1;
		private var selected:Holder;
		private var currentState:int = 0;
		private var txtXML:TextArea;
		private var oXMLLoader:XMLLoader;
		private var oXMLTemplate:XMLLoader;
		private var id:int = 0;
		private var aComponents:Array;
		private var sTemplateName:String;
		private var edit:Boolean;
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
			idtemplate = parameters.idtemplate == undefined? -1:parameters.idtemplate;
			edit = parameters.edit == undefined? false:true;
			
			sURL=oShell.getURL("main", "template");
			oXMLLoader = new XMLLoader(oShell.getURL("main", "editors"), onXMLLoaded);
			aComponents = new Array();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onXMLLoaded(e:Event)
		{
			var oXML:XML = XML(e.target.data);
			xmlComponents = oXML.components;		
			xmlTools = oXML.button;
			
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
			txtXML.move(20, 20);
			mcXML.addChild(txtXML);
			toolsPanel.setStyle( "skin", "ToolbarSkin" ); 
			setToolBar(xmlComponents,componentsPanel,onStartDrag);
			setToolBar(xmlTools,toolsPanel,onToolsChange);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onDelete)
			if (idtemplate != -1)
			{
				loadTemplate();
			}
			else
			{
				showNamePicker();
			}
			
		}
		private function showNamePicker()
		{
			var oparameters = new Object();
			oparameters.title="WRITE A NAME FOR THE NEW TEMPLATE ";
			oShell.showPopup("name", oparameters, onNameSelected);
		}
		private function onNameSelected(e:PopupEvent)
		{
			sTemplateName = (e.parameters.name);
			txtName.text = "Template : " + sTemplateName;
		}
		private function loadTemplate()
		{
			oXMLTemplate = new XMLLoader(sURL, onTemplateLoaded, null, null, {option:"gettemplate",idTemplate:idtemplate } );
		}
		private function onTemplateLoaded(e:Event)
		{
			try{
				xmlLoadedTemplate = XML(e.target.data);
				sTemplateName = xmlLoadedTemplate.user[0].name;
				txtName.text = "Template : "+sTemplateName;
				var templatestring:String = xmlLoadedTemplate.user[0].content;
				var oXMLTemp:XML = new XML(templatestring);
				xmlTemplate = new XML(oXMLTemp.toString());
			}
			catch (e:Error)
			{
				trace("Error template: " + e.message);	
			}
			for each(var component:XML in xmlTemplate.component)
			{
				
				createComponent(component);
			}
			edit = true;
			
		}
		
		
		private function createComponent(component:XML)
		{
			var newcomponent:Holder;
			newcomponent = new Holder(component.@type, true);
			newcomponent.setSize(component.@width,component.@height);
			newcomponent.id = component.@id;
			newcomponent.x = component.@x;
			newcomponent.y = component.@y;
			mcLayout.addChild(newcomponent);
			newcomponent.setDragable();
			newcomponent.addEventListener("Resize", onHolderResize);
			newcomponent.addEventListener("Select", onSelect);
			id = int(component.@id) + 1 ;
			aComponents.push(newcomponent);
		}
		private function showPicker()
		{
			var oparameters = new Object();
			oparameters.title="SELECT A TEMPLATE ";
			oparameters.url = oShell.getURL("main", "template")+"?option=getall";
			oparameters.labelField = "name";
			oparameters.idfield = "idTemplate";
			oparameters.tableName = "template";
			oShell.showPopup("picker", oparameters, onTemplateSelected);
		}
		private function onTemplateSelected(e:PopupEvent)
		{
			idtemplate = e.parameters.selected;
			reset();
			loadTemplate();
		}
		private function reset()
		{
			xmlTemplate = new XML();
			for (var i in aComponents){
				mcLayout.removeChild(aComponents[i]);
			}
			aComponents = new Array();
			id = 0;
		}
		private function getIsValid(id:int)
		{
			
			if (xmlTemplate.component != null)
			{
				for each(var component:XML in xmlTemplate.component)
				{
					if (int(component.@id) == id)
					{
							return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * 
		 * @param	data
		 * @param	toolbar
		 * @param	callback
		 */
		private function setToolBar(data:XMLList,toolbar:HBoxPane,callback:Function)
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
					if (edit == true)
					{
						new XMLLoader(sURL, onSave, onDataError, onError, {option:"edittemplate",idTemplate:idtemplate,name:sTemplateName,content:xmlTemplate});
					}
					else
					{
						new XMLLoader(sURL, onSave, onDataError, onError, {option:"savetemplate",name:sTemplateName,content:xmlTemplate});
					}
				break;
				case "Open":
					showPicker();
				break;
				case "New":
					edit = false;
					reset();
					showNamePicker();
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
			trace("valid id : "+getIsValid(id));
			icon.id = id;
			icon.x = mcLayout.globalToLocal(point2).x;
			icon.y=scPanel.globalToLocal(point2).y;
			mcLayout.addChild(icon);
			scPanel.update();
			icon.setDragable();
			id++;
			aComponents.push(icon);
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
package com.flashcms.editors {
	
	import com.flashcms.components.ContentHolder;
	import com.flashcms.components.ImageHolder;
	import com.flashcms.components.ToolBar;
	import com.flashcms.components.VideoHolder;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.StageAlign;
	import flash.display.Shape;
	import com.flashcms.core.Module;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.events.PopupEvent;
	import com.yahoo.astra.fl.controls.TabBar;
	import fl.controls.Button;
	import fl.containers.ScrollPane;
	import com.yahoo.astra.fl.containers.HBoxPane;
	import com.yahoo.astra.layout.modes.*;
	import com.flashcms.components.Holder;
	import com.flashcms.components.TextHolder;
	import com.flashcms.components.TextBar;
	import com.flashcms.components.ImageBar;
	/**
	* ...
	* @author Default
	*/
	public class SectionEditor extends Module{
		public var oTabBar:TabBar;
		public var scPanel:ScrollPane;
		public var toolsPanel:HBoxPane;
		public var optionsPanel:HBoxPane;
		private var mcLayout:Sprite;
		private var oXMLLoader:XMLLoader;
		private var oXMLTemplate:XML;
		private var oXMLContent:XML=<content/>;
		private var oXML:XML;
		private var xmlBar:XMLList;
		private var xmlComponents:XMLList;
		private var oTextBar:TextBar;
		private var oImageBar:ImageBar;
		private var currentBar:ToolBar;
		private var sURLTemplates:String;
		private var oSelected:ContentHolder;
		/**
		 * 
		 */
		public function SectionEditor() {
			super("SectionEditor");
			
		}
		/**
		 * 
		 */
		public override function init()
		{
			oXMLLoader = new XMLLoader(oShell.getURL("main", "editors"), onXMLLoaded);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onXMLLoaded(e:Event)
		{
			oXML= XML(e.target.data);
			setToolBar(oXML.button, toolsPanel, onBarClick);
			setToolBar(oXML.properties, optionsPanel, onBarClick);
			sURLTemplates=oShell.getURL("main", "template")
			showPicker();
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
				if (component.toggle == "true")
				oButton.toggle = true;
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
		private function onBarClick(e:Event)
		{
			switch(e.target.name) {
				case "New":
					parameters.type = "create";
					showPicker();
				break;
				case "Open":
					parameters.type = "edit";
					showPicker();
				break;
				case "Save":
					saveContent();
				break;
				case "Properties":
					showBar(e.target.selected);
				break;
			}
		}
		private function showBar(state:Boolean)
		{
			trace("state : " + state);
			if (state==false)
			{
				showEditor();
			}
			else
			{
				hideBar();
			}
		}
		/**
		 * 
		 */
		private function saveContent()
		{
			foreach(
			trace(oXMLContent);
		}
		/**
		 * 
		 */
		private function showPicker()
		{
			var oparameters = new Object();
			oparameters.type = parameters.type;
			if(parameters.type=="create"){
				oparameters.title="SELECT A TEMPLATE TO CREATE CONTENT";
				oparameters.url = oShell.getURL("main", "template")+"?option=getall";
				oparameters.labelField = "name";
				oparameters.idfield = "idTemplate";
				oparameters.tableName = "template";
				
			}
			if (parameters.type == "edit") {
				oparameters.title = "SELECT A CONTENT TO EDIT";
				oparameters.url = oShell.getURL("main", "content")+"?option=getall";
				oparameters.labelField = "name";
				oparameters.idfield = "idContent";
				oparameters.tableName = "content";
			}
			oShell.showPopup("picker", oparameters, onTemplateSelected);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onTemplateSelected(e:PopupEvent)
		{
			draw();
			//oXMLLoader = new XMLLoader(url, onTemplate, null, null, { id:e.parameters.selected } );
			oXMLLoader = new XMLLoader(sURLTemplates, onTemplate, null, null, {option:"gettemplate",idTemplate:e.parameters.selected } );
		}
		/**
		 * 
		 */
		private function onTemplate(event:Event)
		{
			
			oXMLTemplate = XML(event.target.data);
			var templatestring:String = oXMLTemplate.template[0].content;
			var oXMLTemp:XML = new XML(templatestring);
			oXMLTemplate = new XML(oXMLTemp.toString());
			
			
			for each(var component:XML in oXMLTemplate.component)
			{
				createComponent(component);
				oXMLContent.component +=<component id = { component.@id } /> ;
				
			}
			
			scPanel.update();
		}
		/**
		 * 
		 * @param	component
		 */
		private function createComponent(component:XML)
		{
			var newcomponent:ContentHolder;
			switch(String(component.@type))
			{
				case "Text":
					newcomponent = new TextHolder(component.@width,component.@height);
				break;
				case "Video":
					newcomponent = new VideoHolder(component.@width,component.@height);
				break;
				case "Image":
					newcomponent = new ImageHolder(component.@width,component.@height);
				break;
			}
			newcomponent.id = component.@id;
			newcomponent.x = component.@x;
			newcomponent.y = component.@y;
			
			mcLayout.addChild(newcomponent);
			newcomponent.addEventListener(MouseEvent.CLICK, onSelectComponent);
			
			
		}
		/**
		 * 
		 * @param	e
		 */
		private function onSelectComponent(e:MouseEvent)
		{
			if(e.currentTarget != oSelected)
			hideBar();
			
			if(oSelected!=null)
			oSelected.clearSelection();
			
			ContentHolder(e.currentTarget).select();
			oSelected = ContentHolder(e.currentTarget);
			

		}
		/**
		 * 
		 * @param	component
		 */
		private function showEditor()
		{
			var editor:String = (oXML.components.(type == oSelected.type).editor);
			hideBar();
			
			switch(editor)
			{
				case "texteditor":
				if (currentBar  == null)
				{
					currentBar = new TextBar(oSelected["txtMain"]);
					currentBar.x = 0;
					currentBar.y = 350;
					addChild(currentBar);
				}
				break;
				case "imageeditor":
				case "videoeditor":
					currentBar = new ImageBar(oSelected);
					currentBar.x = 0;
					currentBar.y = 350;
					addChild(currentBar);
				break;
				
			}
		}
		/**
		 * 
		 */
		private function hideBar()
		{
			if (currentBar!= null){
				removeChild(currentBar);
				currentBar = null;
				Button(optionsPanel.getChildByName("Properties")).selected = true;
			}
		}
		/**
		 * 
		 * @param	e
		 */
		private function onCloseEditor(e:Event)
		{
			trace("closed");
		}
		/**
		 * 
		 */
		private function draw()
		{
			mcLayout = new Sprite();
			mcLayout.graphics.beginFill(0xFFFFFF, 0.3);
			mcLayout.graphics.drawRect(10, 10, scPanel.width-20,scPanel.height-20);
			mcLayout.graphics.endFill();
			scPanel.source = mcLayout;
		}
	}
	
}
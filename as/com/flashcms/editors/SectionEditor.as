package com.flashcms.editors {
	
	import com.flashcms.components.ContentHolder;
	import com.flashcms.components.ImageHolder;
	import com.flashcms.components.TextHolder;
	import com.flashcms.components.ToolBar;
	import com.flashcms.components.VideoHolder;
	import com.flashcms.core.PopupManager;
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
	import com.flashcms.components.TextBar;
	import com.flashcms.components.ImageBar;
	import flash.text.TextField;
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
		private var oXMLContentLoaded:XML;
		private var oXMLContent:XML=<content/>;
		private var oXML:XML;
		private var xmlBar:XMLList;
		private var xmlComponents:XMLList;
		private var oTextBar:TextBar;
		private var oImageBar:ImageBar;
		private var currentBar:ToolBar;
		private var sURLTemplates:String;
		private var oSelected:ContentHolder;
		private var aComponents:Array;
		private var sURLContent:String;
		private var sContentName:String;
		private var idTemplate:String;
		private var idContent:String;
		private var bLoaded:Boolean;
		private var edit:Boolean;
		public var txtName:TextField;
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
			aComponents = new Array();
			sURLTemplates = oShell.getURL("main", "template");
			sURLContent = oShell.getURL("main", "content")
			edit = parameters.edit == undefined? false:true;
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
					edit = false;
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
		/**
		 * 
		 * @param	state
		 */
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
			for each(var component:ContentHolder in aComponents)
			{
				switch(component.type)
				{
					case "Text":
						oXMLContent.component.(@id == component.id)[0]=(TextHolder(component).txtMain.text);
					break;
					case "Video":
						oXMLContent.component.(@id == component.id)[0]=(VideoHolder(component).sURL);
					break;
					case "Image":
						oXMLContent.component.(@id == component.id)[0]=(ImageHolder(component).sURL);
					break;
					
				}
			}
			if (edit == true)
			{
				trace("edit is true, saving");
				oXMLLoader = new XMLLoader(sURLContent, onContentSaved, null, null, { option:"editcontent", idContent:idContent,idTemplate:idTemplate, approved:"1", content:oXMLContent, name:sContentName } );
			}
			else
			{
				trace("edit is false, saving");
				oXMLLoader = new XMLLoader(sURLContent, onContentSaved, null, null, { option:"setcontent", idTemplate:idTemplate, approved:"1", content:oXMLContent, name:sContentName } );	
			}
			
		}
		private function onContentSaved(e:Event)
		{
			oShell.showMessageWindow("Saved "+sContentName+" ("+new Date().toDateString()+")");
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
				oparameters.url = sURLTemplates+"?option=getall";
				oparameters.labelField = "name";
				oparameters.idfield = "idTemplate";
				oparameters.tableName = "template";
				oShell.showPopup("picker", oparameters, onTemplateSelected);	
			}
			if (parameters.type == "edit") {
				oparameters.title = "SELECT A CONTENT TO EDIT";
				oparameters.url = sURLContent+"?option=getall";
				oparameters.labelField = "name";
				oparameters.idfield = "idContent";
				oparameters.tableName = "content";
				oShell.showPopup("picker", oparameters, onContentSelected);
			}
			
		}
		/**
		 * 
		 * @param	e
		 */
		private function onContentSelected(e:PopupEvent)
		{
			draw();
			aComponents = new Array();
			oXMLLoader = new XMLLoader(sURLContent, onContent, null, null, {option:"getcontent",idContent:e.parameters.selected } );
			
		}
		/**
		 * 
		 * @param	e
		 */
		private function onTemplateSelected(e:PopupEvent)
		{
			idTemplate = e.parameters.selected ;
			showNamePicker();	
		}
		
		private function showNamePicker()
		{
			var oparameters = new Object();
			oparameters.title="SELECT THE NAME OF THE NEW CONTENT";
			oShell.showPopup("name", oparameters, onNameSelected);
		}04
		private function onNameSelected(e:PopupEvent)
		{
			sContentName = e.parameters.name!= null?e.parameters.name:"untitled content" ;
			txtName.text = "Content : " + sContentName;
			draw();
			aComponents = new Array();
			oXMLLoader = new XMLLoader(sURLTemplates, onTemplate, null, null, { option:"gettemplate", idTemplate:idTemplate } );
			
		}
		/**
		 * 
		 * @param	event
		 */
		private function onContent(event:Event)
		{
			edit = true;
			bLoaded = true;
			oXMLContentLoaded = XML(event.target.data);
			idTemplate = oXMLContentLoaded.content[0].idTemplate;
			idContent= oXMLContentLoaded.content[0].idContent;
			var contentstring:String = oXMLContentLoaded.content[0].content;
			var oXMLTemp:XML = new XML(contentstring);
			oXMLContent = new XML(oXMLTemp.toString());
			sContentName = oXMLContentLoaded.content[0].name;
			oXMLLoader = new XMLLoader(sURLTemplates, onTemplate, null, null, {option:"gettemplate",idTemplate:idTemplate} );
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
				var holder:ContentHolder=createComponent(component);
				oXMLContent.component +=<component id = { component.@id } /> ;	
			}
			
			scPanel.update();
			if (bLoaded)
			{
				setComponentsData();
			}
		}
		/**
		 * 
		 */
		private function setComponentsData()
		{
			
			//trace(oXMLContent);
			for each(var component:ContentHolder in aComponents)
			{
				switch(component.type)
				{
					case "Text":
						TextHolder(component).txtMain.text=oXMLContent.component.(@id==component.id).text();
					break;
					case "Video":
						VideoHolder(component).sURL = oXMLContent.component.(@id == component.id).text();
						VideoHolder(component).update();
					break;
					case "Image":
						ImageHolder(component).sURL = oXMLContent.component.(@id==component.id).text();
						ImageHolder(component).update();
					break;
				}
			}
			
		}
		/**
		 * 
		 * @param	component
		 */
		private function createComponent(component:XML):ContentHolder
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
			aComponents.push(newcomponent);
			newcomponent.addEventListener(MouseEvent.CLICK, onSelectComponent);
			return newcomponent;
			
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
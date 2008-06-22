package com.flashcms.editors {
	import com.flashcms.core.Module;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.events.PopupEvent;
	import com.yahoo.astra.fl.controls.TabBar;
	import fl.containers.ScrollPane;
	import com.yahoo.astra.fl.containers.VBoxPane;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.flashcms.components.Holder;
	/**
	* ...
	* @author Default
	*/
	public class SectionEditor extends Module{
		public var oTabBar:TabBar;
		public var scPanel:ScrollPane;
		public var componentsPanel:VBoxPane;
		public var toolsPanel:VBoxPane;
		private var mcLayout:Sprite;
		private var oXMLLoader:XMLLoader;
		private var oXML:XML;
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
			var oparameters = new Object();
			oparameters.type = parameters.type;
			if(parameters.type=="create"){
				oparameters.title="SELECT A TEMPLATE TO CREATE CONTENT";
				oparameters.url = oShell.getURL("main", "templates");
				oparameters.labelField = "name";
				oparameters.tableName = "templates";
			}
			if (parameters.type == "edit") {
				oparameters.title="SELECT A CONTENT TO EDIT";
				oparameters.url = oShell.getURL("main", "contents");
				oparameters.labelField = "title";
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
			var url = oShell.getURL("get", "templates");
			oXMLLoader= new XMLLoader(url, onTemplate,null,null,{id:e.parameters.selected});
		}
		/**
		 * 
		 */
		private function onTemplate(event:Event)
		{
			oXML = XML(event.target.data);
			trace(oXML.component);
			
			for each(var component:XML in oXML.component)
			{
				createComponent(component);
			}
		}
		/**
		 * 
		 * @param	component
		 */
		private function createComponent(component:XML)
		{
			var newcomponent:Holder=new Holder(component.@type);
			newcomponent.x = component.@x;
			newcomponent.y = component.@y;
			newcomponent.setSize(int(component.@width),int(component.@height));
			mcLayout.addChild(newcomponent);
			
			
		}
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
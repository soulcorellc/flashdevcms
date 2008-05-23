package com.flashcms.admin {
	import com.flashcms.core.Module;
	import com.yahoo.astra.fl.controls.Tree;  
	import com.yahoo.astra.fl.controls.treeClasses.*;
	import fl.events.ListEvent;
	import com.flashcms.data.XMLLoader;
	import flash.events.Event;
	import fl.data.DataProvider;
	import fl.controls.ComboBox;
	/**
	* ...
	* @author Default
	*/
	public class Sections extends Module{
		var oXML:XML;
		var oXMLLoader:XMLLoader;
		
		public function Sections() {
			super("Sections");
		}
		/**
		 * 
		 */
		public override function init()
		{
			var url = oShell.getURL("main", "sections");
			oXMLLoader = new XMLLoader(url, onXMLData, onDataError, onError);
			
		}
		
		private function onXMLData(e:Event)
		{
			oXML = XML(e.target.data);
			treeSections.addEventListener(ListEvent.ITEM_CLICK,onClick);
			treeSections.dataProvider = new TreeDataProvider(XML(oXML.section));
			treeSections.openAllNodes();
			cbTemplates.dataProvider = new DataProvider( < data > { oXML.templates }</data>);
			cbTemplates.labelField = "name";
			cbTemplates.prompt = "Template of Selected Content";
			
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDataError(e:Event)
		{
		}
		/**
		 * 
		 * @param	e
		 */
		private function onError(e:Event)
		{
		}
		/**
		 * 
		 * @param	event
		 */
		private function onClick(event:ListEvent)
		{
			select(event.item.template);
		}
		/**
		 * 
		 * @param	id
		 */
		private function select(id:String)
		{
			for (var i = 0; i < cbTemplates.length;i++)
			{
				if (cbTemplates.getItemAt(i).id == id)
				{
					cbTemplates.selectedIndex = i;
				}
			}
		}
		
	}
	
}
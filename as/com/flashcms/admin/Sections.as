package com.flashcms.admin {
	import com.flashcms.core.Module;
	import com.yahoo.astra.fl.controls.Tree;  
	import com.yahoo.astra.fl.controls.treeClasses.*;
	import fl.controls.Button;
	import fl.controls.List;
	import fl.events.ListEvent;
	import com.flashcms.data.XMLLoader;
	import flash.events.Event;
	import fl.data.DataProvider;
	import fl.controls.ComboBox;
	import flash.events.MouseEvent;
	import com.flashcms.events.NavigationEvent;
	import fl.data.DataProvider;

	/**
	* ...
	* @author Default
	*/
	public class Sections extends Module{
		private var oXML:XML;
		private var oXMLLoader:XMLLoader;
		public var treeSections:Tree;
		public var btAdd:Button;
		public var btRemove:Button;
		public var lbContent:List;
		
		public function Sections() {
			super("Sections");
		}
		/**
		 * 
		 */
		public override function init()
		{
			var url = oShell.getURL("main", "menu")+"?option=getall";
			oXMLLoader = new XMLLoader(url, onXMLData, onDataError, onError);
			btAdd.enabled = false;
			btRemove.enabled = false;
		}
		/**
		 * 
		 * @param	e
		 */
		private function onXMLData(e:Event)
		{
			oXML = XML(e.target.data);
			
			var treeXML:XML=new XML(<node label="root"></node>);
			
			for each(var oMenu:XML in oXML.Menu)
			{
				trace("." + oMenu.idParent + ".");
				if (oMenu.idParent!="")
				{
					treeXML.node += <node id ={oMenu.idMenu} label = {oMenu.name} /> ;
				}
				else
				{
					var node = treeXML.node.(@id == oMenu.idParent);
					node+= <node id = {oMenu.idMenu} label = {oMenu.name} /> ;
				}
				
			}
			
			trace(treeXML);
			//trace(treeXML.node.(@id == "7"));
			treeSections.addEventListener(ListEvent.ITEM_CLICK,onClick);
			treeSections.dataProvider = new TreeDataProvider(treeXML);
		
			treeSections.openAllNodes();
			
			/*trace(oXML.content);
			
			for each (var item:XML in oXML.content)
			{	
				item.id+=<icon>{"Iconcontent"}</icon>
				trace(item);
			}
			
			lbContent.labelField = "title";
			lbContent.iconField = "icon";
			lbContent.dataProvider = new DataProvider( < data > { oXML.content }</data>);
			lbContent.addEventListener(ListEvent.ITEM_CLICK,onSelectContent);
			
			btAdd.addEventListener(MouseEvent.CLICK, onCreate);
			btRemove.addEventListener(MouseEvent.CLICK, onDelete);
			*/
		}
		private function onCreate(e:Event)
		{
			//oShell.setModule(new NavigationEvent("sectioneditor", {} ));
		}
		private function onEdit(e:Event)
		{
			trace("edit");
		}
		private function onDelete(e:Event)
		{
			trace("delete");
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
			btRemove.enabled = true;
		}
		/**
		 * 
		 * @param	event
		 */
		private function onSelectContent(event:ListEvent)
		{
			btAdd.enabled = true;
		}
		/**
		 * 
		 * @param	id
		 */
		private function select(id:String)
		{
			
		}
		
	}
	
}
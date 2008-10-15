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
	import com.flashcms.events.PopupEvent;

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
		private var sURLMenu:String;
		private var sURLContent:String;
		public function Sections() {
			super("Sections");
		}
		/**
		 * 
		 */
		public override function init()
		{
			sURLMenu = oShell.getURL("main", "menu") ;
			sURLContent = oShell.getURL("main", "content") ;
			oXMLLoader = new XMLLoader(sURLMenu+"?option=getall", onMenu, onDataError, onError);
			btAdd.enabled = false;
			btRemove.enabled = false;
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
					trace("adding ", oMenu.name, " to root ",oMenu.idMenu);
					treeXML.node += <node id ={oMenu.idMenu} label = {oMenu.name} /> ;
				}
				else
				{
					//add to a node to 
					trace("adding ", oMenu.name, " to ", oMenu.idParent);
					trace("found node?", treeXML.node.(@id == oMenu.idParent).@id);
					var node = treeXML..node.(@id == oMenu.idParent);
					node.node+= <node id = {oMenu.idMenu} label = {oMenu.name} /> ;
				}
				
			}
		
			treeSections.addEventListener(ListEvent.ITEM_CLICK,onClick);
			treeSections.dataProvider = new TreeDataProvider(treeXML);
		
			oXMLLoader = new XMLLoader(sURLContent+"?option=getall", onContent, onDataError, onError);
			
			
			//	treeSections.openAllNodes();
			
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
		
		private function onContent(e:Event)
		{
			oXML = XML(e.target.data);
			for each (var item:XML in oXML.content)
			{	
				item.id+=<icon>{"Iconcontent"}</icon>
				
			}
			lbContent.labelField = "name";
			lbContent.iconField = "icon";
			lbContent.dataProvider = new DataProvider( < data > { oXML.content }</data>);
			lbContent.addEventListener(ListEvent.ITEM_CLICK,onSelectContent);
			btAdd.addEventListener(MouseEvent.CLICK, onCreate);
			btRemove.addEventListener(MouseEvent.CLICK, onDelete);
		}
		
		
		private function onCreate(e:Event)
		{
			
			showNamePicker();
			//trace("section",treeSections.selectedItem.id,"content",lbContent.selectedItem.idContent);
			//oXMLLoader = new XMLLoader(sURLMenu, onMenuCreated, onDataError, onError,{option:"setmenu",name:"name",idParent:treeSections.selectedItem.id,idContent:lbContent.selectedItem.idContent});
			
			
			//oShell.setModule(new NavigationEvent("sectioneditor", {} ));
		}
		private function showNamePicker()
		{
			var oparameters = new Object();
			oparameters.title="SELECT A NAME FOR THE NEW SECTION";
			oShell.showPopup("name", oparameters, onNameSelected);
		}
		private function onNameSelected(e:PopupEvent)
		{
			//sTemplateName = e.parameters.name!= null?e.parameters.name:"untitled template" ;
			oXMLLoader = new XMLLoader(sURLMenu, onMenuCreated, onDataError, onError,{option:"setmenu",name:e.parameters.name,idParent:treeSections.selectedItem.id,idContent:lbContent.selectedItem.idContent,order:1});
		}
		private function onMenuCreated(e:Event)
		{
			oShell.setStatusMessage("Menu item created");
			oXMLLoader = new XMLLoader(sURLMenu+"?option=getall", onMenu, onDataError, onError);
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
			oShell.setStatusMessage("data error");
		}
		/**
		 * 
		 * @param	e
		 */
		private function onError(e:Event)
		{
			oShell.setStatusMessage("Error");
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
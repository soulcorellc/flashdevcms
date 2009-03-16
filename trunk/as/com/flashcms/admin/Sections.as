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
		public var btDelete:Button;
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
			oXMLLoader = new XMLLoader(sURLMenu+"?option=getall", onMenu, onMenuError, onError);
			btAdd.enabled = false;
			btRemove.enabled = false;
			btDelete.enabled = false;
		}
		private function onMenuError(e:Event)
		{
			var treeXML:XML = new XML(<node/>);
			treeSections.addEventListener(ListEvent.ITEM_CLICK,onClick);
			treeSections.dataProvider = new TreeDataProvider(treeXML);
			
			oXMLLoader = new XMLLoader(sURLContent+"?option=getall", onContent, onDataError, onError);
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
			
		}
		/**
		 * 
		 * @param	e
		 */
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
			btRemove.addEventListener(MouseEvent.CLICK, onDeleteMenu);
			btDelete.addEventListener(MouseEvent.CLICK, onDelete);
			
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function onCreate(e:Event)
		{
			var idparent = treeSections.selectedItem? treeSections.selectedItem.id : "";
			oXMLLoader = new XMLLoader(sURLMenu, onMenuCreated, onDataError, onError,{option:"setmenu",name:lbContent.selectedItem.name,idParent:idparent,idContent:lbContent.selectedItem.idContent,order:1});
		}
		/**
		 * 
		 * @param	e
		 */
		private function onMenuCreated(e:Event)
		{
			oShell.showMessageWindow("Menu item has been created");
			onRefresh();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onEdit(e:Event)
		{
			trace("edit");
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDelete(e:Event)
		{
			oXMLLoader = new XMLLoader(sURLContent, onRefreshContent, onDataError, onError,{option:"delete",idContent:lbContent.selectedItem.idContent});
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDeleteMenu(e:Event)
		{
			oXMLLoader = new XMLLoader(sURLMenu, onRefresh, onDataError, onError,{option:"delete",idMenu:treeSections.selectedItem.id});
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDataError(e:Event)
		{
			oShell.showMessageWindow("Error loading data from Section");
		}
		/**
		 * 
		 * @param	e
		 */
		private function onError(e:Event)
		{
			oShell.showMessageWindow("Error loading data from Section");
		}
		/**
		 * 
		 * @param	event
		 */
		private function onRefresh(e:Event=null)
		{
			oXMLLoader = new XMLLoader(sURLMenu+"?option=getall", onMenu, onDataError, onError);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onRefreshContent(e:Event=null)
		{
			
			oXMLLoader = new XMLLoader(sURLContent+"?option=getall", onContent, onDataError, onError);
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
			btDelete.enabled = true;
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
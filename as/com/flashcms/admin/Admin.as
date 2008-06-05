﻿package com.flashcms.admin {
	import com.flashcms.core.Module;
	import com.flashcms.events.ErrorEvent;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.events.NavigationEvent;
	import com.flashcms.events.PopupEvent;
	import com.flashcms.cellrender.ButtonRenderer;
	import com.flashcms.forms.FormData;
	import fl.controls.Button;
	import fl.controls.DataGrid;
	import fl.events.ListEvent;
	import fl.data.DataProvider;
	import fl.controls.dataGridClasses.DataGridColumn;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	/**
	* ...
	* @author Default
	*/
	public class Admin extends Module{
		public var dgMain:DataGrid;
		public var btCreate:Button;
		public var tableName:String;
		public var sectionName:String;
		public var xmlData:XML;
		private var editpopup:String;
		private var oFormData:FormData;
		/**
		 * 
		 */
		public function Admin() {
			super("Admin");
		}
		/**
		 * 
		 */
		public override function init()
		{
			trace("parameters.content :"+parameters.content);
			sectionName = parameters.section;
			tableName = parameters.content == undefined? parameters.section:parameters.content;
			trace("tableName : "+tableName)
			new XMLLoader(oShell.getURL("main", sectionName), onXMLData, onDataError, onError);
			btCreate.label = "Create New";
			btCreate.addEventListener(MouseEvent.CLICK, onCreate);
		}
		/**
		 * 
		 * 
		 * 
		 * @param	event
		 */
		private function onXMLData(event:Event)
		{
			xmlData = XML(event.target.data);
			editpopup = xmlData.parameters.editpopup;
			var myDP:DataProvider = new DataProvider(<data>{xmlData[tableName]}</data>);
			
			var col1:DataGridColumn = new DataGridColumn("name");
			col1.headerText = "Name";
			col1.width = 300;
			
			var col2:DataGridColumn = new DataGridColumn("edit");
			col2.headerText = "";
			col2.cellRenderer = ButtonRenderer;
			
			var col3:DataGridColumn = new DataGridColumn("delete");
			col3.headerText= "";
			col3.cellRenderer = ButtonRenderer;
			
			dgMain.addColumn(col1);
			dgMain.addColumn(col2);
			dgMain.addColumn(col3);
			
			dgMain.dataProvider = myDP;
			dgMain.addEventListener(ListEvent.ITEM_CLICK , onClickItem);
			
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDataError(e:ErrorEvent)
		{
			trace("Admin Error : " + e.message);
		}
		/**
		 * 
		 * 
		 * 
		 * @param	event
		 */
		private function onClickItem(event:ListEvent)
		{
			switch(event.columnIndex)
			{
				case 1:
					oFormData = new FormData(tableName, tableName, true, xmlData);
					if(editpopup == "templates"){
						oShell.setModule(new NavigationEvent("templates", { } ));
					}
					else
					{
						oShell.showPopup(editpopup, oFormData, onEdit);
					}
				break;
				case 2:
					oShell.showPopup("confirmation",{message:"Do you want to delete this user?"},onConfirmation);
				break;
			}
		}
		/**
		 * 
		 * @param	e
		 */
		private function onCreate(e:Event)
		{
			if(editpopup == "templates")
			{
				oShell.setModule(new NavigationEvent("templates", {} ));
			}
			else 
			{
				oFormData = new FormData(tableName, tableName, true, xmlData);
				oShell.showPopup(editpopup, oFormData, onEdit);
			}
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function onEdit(e:PopupEvent)
		{
			trace("edit closed");
		}
		
		private function onConfirmation(e:PopupEvent)
		{
			if (e.parameters.type == "yes")
			{
				trace("DELETING");
			}
		}
		/**
		 * 
		 * 
		 * 
		 * @param	event
		 */
		private function onError(event:IOErrorEvent)
		{
			trace("ioErrorHandler: " + event.text);
		}
		
	}
	
}
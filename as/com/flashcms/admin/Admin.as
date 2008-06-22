package com.flashcms.admin {
	import com.flashcms.core.Module;
	import com.flashcms.events.ErrorEvent;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.events.NavigationEvent;
	import com.flashcms.events.PopupEvent;
	import com.flashcms.cellrender.ButtonRenderer;
	import com.flashcms.forms.FormData;
	import com.yahoo.astra.fl.accessibility.EventTypes;
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
		private var sOption:String;
		private var sURL:String;
		private var idDelete:int;
		private var editoption:String;
		private var createoption:String;
		private var oXMLLoader:XMLLoader;
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
			editoption=parameters.edit;
			createoption=parameters.create;
			sectionName = parameters.section;
			sURL = oShell.getURL("main", sectionName);
			sOption = parameters.option;
			//trace("sOption : " + sOption);
			tableName = parameters.content == undefined || parameters.content==""? parameters.section:parameters.content;
			//trace("tableName : "+tableName)
			oXMLLoader=new XMLLoader(sURL, onXMLData, onDataError, onError,{option:sOption});
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
			
			dgMain.addColumn(createColumn("name","Name",300));
			dgMain.addColumn(createColumn("edit","",120,ButtonRenderer));
			dgMain.addColumn(createColumn("delete","",120,ButtonRenderer));
			if (tableName == "groups"){
				dgMain.addColumn(createColumn("users", "", 120, ButtonRenderer));
				dgMain.addColumn(createColumn("permissions","",120,ButtonRenderer));
			}
			dgMain.dataProvider = myDP;
			dgMain.addEventListener(ListEvent.ITEM_CLICK , onClickItem);
			
		}
		
		private function createColumn(name:String,label:String,width:int=120,cellrenderer:Class=null):DataGridColumn
		{
			var col1:DataGridColumn = new DataGridColumn(name);
			col1.headerText = label;
			col1.width = width;
			if(cellrenderer!=null){
				col1.cellRenderer = ButtonRenderer;
			}
			return col1;
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
			oFormData = new FormData(tableName, sectionName , true, xmlData);
			switch(event.columnIndex)
			{
				case 1:
					if(editpopup == "templates"){
						oShell.setModule(new NavigationEvent("templates", { } ));
					}
					else
					{
						oShell.showPopup(editpopup, {table:tableName,section:sectionName,requiredata:true,data:xmlData,id:event.item.id}, onEdit);
					}
				break;
				case 2:
					idDelete = int(event.item.id);
					oShell.showPopup("confirmation",{title:"DELETE ",message:"Do you want to delete ?"},onConfirmation);
				break;
				case 3:
					oFormData.section = "users";
					oShell.showPopup("assign",oFormData,onConfirmation);
				break;
				case 4:
					oFormData.section = "modules";
					oShell.showPopup("assign",oFormData,onConfirmation);
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
				oShell.showPopup(editpopup, {table:tableName,section:sectionName,requiredata:true,data:xmlData,create:true,editoption:editoption,createoption:createoption}, onEdit);
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
		/*
		 * 
		 * @param	e
		 */
		private function onConfirmation(e:PopupEvent)
		{
			if (e.parameters.type == "yes")
			{
				oXMLLoader=new XMLLoader(sURL, onDelete, onDeleteError, onError,{option:"delete",user:idDelete});
			}
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDelete(e:Event)
		{
			oShell.setStatusMessage("User Deleted");
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDeleteError(e:Event)
		{
			oShell.setStatusMessage("Error Deleting");
		}
		/**
		 * 
		 * @param	event
		 */
		private function onError(event:IOErrorEvent)
		{
			oShell.setStatusMessage(event.text);
			//trace("ioErrorHandler: " + event.text);
		}
		
	}
	
}
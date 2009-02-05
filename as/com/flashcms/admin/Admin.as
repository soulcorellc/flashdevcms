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
	import fl.controls.List;
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
		//public var dgMain:DataGrid;
		public var lbList:List;
		public var btCreate:Button;
		public var btEdit:Button;
		public var btDelete:Button;
		
		public var btPermissions:Button;
		public var btTheme:Button;
		
		public var tableName:String;
		public var sectionName:String;
		public var xmlData:XML;
		private var editpopup:String;
		private var oFormData:FormData;
		private var sOption:String;
		private var sURL:String;
		private var idDelete:String;
		private var editoption:String;
		private var createoption:String;
		private var idcolumn:String;
		private var deleteid:String;
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
			
			idcolumn = parameters.idcolumn;
			editoption=parameters.editoption;
			createoption=parameters.createoption;
			sectionName = parameters.section;
			editpopup = parameters.popup;
			deleteid = parameters.deleteid;
			sURL = oShell.getURL("main", sectionName);
			sOption = parameters.option;
			//trace("sOption : " + sOption);
			tableName = parameters.content == undefined || parameters.content==""? parameters.section:parameters.content;
			//trace("tableName : "+tableName)
			oXMLLoader=new XMLLoader(sURL, onXMLData, onDataError, onError,{option:sOption});
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
		
			for each (var item:XML in xmlData[tableName])
			{	
				item.id+=<icon>{"Icon"+tableName}</icon>
			}
			
			var myDP:DataProvider = new DataProvider(<data>{xmlData[tableName]}</data>);
			lbList.labelField = "name";
			lbList.dataProvider = myDP;
			lbList.addEventListener(ListEvent.ITEM_CLICK, onListSelect);
			lbList.iconField = "icon";
			setUpButtons();
		
		}
		private function onListSelect(e:ListEvent)
		{
			btCreate.enabled = true;
			btEdit.enabled = true;
			btDelete.enabled = true;
			btPermissions.enabled = true;
			btTheme.enabled = true;
				
		}
		private function setUpButtons()
		{
			btCreate.addEventListener(MouseEvent.CLICK, onCreate);
			btEdit.addEventListener(MouseEvent.CLICK, onEdit);
			btDelete.addEventListener(MouseEvent.CLICK, onDelete);
			if (tableName == "profile"){
				btPermissions.visible = true;
				btPermissions.addEventListener(MouseEvent.CLICK, onPermissions);
			}
			if (tableName == "themes") {
				btTheme.visible = true;
				btTheme.addEventListener(MouseEvent.CLICK, onTheme);
			}
			
		}
		private function onTheme(e:Event)
		{
			oXMLLoader=new XMLLoader(oShell.getURL("layout","editors"), onSetTheme, onDataError, onError,{option:"setconfiguration",data:"{_id_@7,_val_@"+lbList.selectedItem.idTheme+"}"});
		}
		/**
		 * 
		 * @param	e
		 */
		private function onSetTheme(e:Event)
		{
			trace("Saved");
			oShell.showMessageWindow("Se ha cambiado el tema por defecto a <b>"+lbList.selectedItem["name"]+"</b>");
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDataError(e:ErrorEvent)
		{
			trace("Admin Error : " + e);
		}
		
		private function onCreate(e:Event)
		{
			trace("create option: " + createoption);
			if(editpopup == "templates")
			{
				oShell.setModule(new NavigationEvent("templates", {} ));
			}
			else 
			{
				oShell.showPopup(editpopup, {table:tableName,section:sectionName,requiredata:false,data:xmlData,create:true,option:createoption}, onFinishEdit);
			}
		}
		private function onEdit(e:MouseEvent)
		{
			if(editpopup == "templates"){
				oShell.setModule(new NavigationEvent("templates", {idtemplate:lbList.selectedItem[idcolumn],edit:true}));
			}
			else
			{
				oShell.showPopup(editpopup, {table:tableName,section:sectionName,requiredata:true,data:xmlData,create:false,option:editoption,id:lbList.selectedItem[idcolumn]}, onFinishEdit);
			}
		}
		private function onDelete(e:MouseEvent)
		{
			trace("idColumn : " + idcolumn);
			idDelete = lbList.selectedItem[idcolumn];
			oShell.showPopup("confirmation",{title:"DELETE ",message:"Do you want to delete ?"},onConfirmation);
		}

		private function onPermissions(e:MouseEvent)
		{
			oFormData = new FormData(tableName, sectionName , true, xmlData);
			oFormData.section = "modules";
			oFormData.id = lbList.selectedItem[idcolumn];
			oShell.showPopup("assign",oFormData,onConfirmation);
		}
			
		/**
		 * 
		 * @param	e
		 */
		private function onFinishEdit(e:PopupEvent)
		{
			init();
		}
		/*
		 * 
		 * @param	e
		 */
		private function onConfirmation(e:PopupEvent)
		{
			if (e.parameters.type == "yes")
			{
				var objsend = new Object();
				objsend.option = "delete";
				objsend[deleteid]=idDelete
				
				oXMLLoader=new XMLLoader(oShell.getURL("data", sectionName), onFinishDelete, onDeleteError, onError,objsend);
			}
		}
		/**
		 * 
		 * @param	e
		 */
		private function onFinishDelete(e:Event)
		{
			oShell.setStatusMessage("User Deleted");
			init();
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
		}
		
	}
	
}
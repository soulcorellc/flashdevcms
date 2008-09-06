package com.flashcms.popups {
	import com.flashcms.core.Module;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.forms.FormData;
	import com.yahoo.astra.fl.accessibility.EventTypes;
	import com.yahoo.astra.fl.controls.containerClasses.MessageBox;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import flash.display.Sprite;
	import com.flashcms.components.ButtonBar;
	import flash.events.Event;
	import com.flashcms.events.PopupEvent;
	import com.flashcms.design.DynamicBG;
	import com.flashcms.layout.LayoutSchema;
	import flash.text.TextField;
	
	/**
	* ...
	* @author Default
	*/
	public class Assign extends Module{
		private var oForm:FormData;
		private var xmlList:XMLList;
		private var mcLayout:Sprite;
		public var scPanel:ScrollPane;
		private var oBar:ButtonBar;
		private var oBG:DynamicBG;
		private var oLayout:LayoutSchema;
		private var oXMLLoader:XMLLoader;
		private var oXMLModules:XMLLoader;
		private var oXMLUsers:XML;
		public var txtMessage:TextField;
		public function Assign() {
			createBG();
			
			mcLayout = new Sprite();
			oLayout = new LayoutSchema(mcLayout, 2, 30, 30);
			oLayout.xmargin = 10;
			oLayout.ymargin = 10;
			oBar = new ButtonBar(onCancel, onSave, "Cancel", "Save");
			oBar.x = 300;
			oBar.y = 270;
			addChild(oBar);
		}
		/**
		 * 
		 */
		private function createBG()
		{
			oBG = new DynamicBG(550, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		
		/**
		 * 
		 */
		public override function init()
		{
			scPanel.source = mcLayout;
			oForm = new FormData(parameters.table, parameters.section, parameters.requiredata, parameters.data);		
			oForm.id = parameters.id;
			xmlList = oForm.data["modules"];
			var index:int = 0;
			var yinit:int = 30;
			for each (var item:XML in xmlList)
			{
				var component:CheckBox = new CheckBox();
				component.name = item.idModule;
				component.x = 30;
				component.y = (index * 30)+yinit;
				mcLayout.addChild(component);
				oLayout.addComponent(component, item.name, "checkbox");
				index++;
			}
			scPanel.update();
			loadData();
		}
		private function loadData()
		{
			txtMessage.text = "Loading data...";
			var urlusers = oShell.getURL("permissions", "profile");
			oXMLLoader = new XMLLoader(urlusers, onModules,onModulesError,null,{option:"getprofilemodules",idprofile:parameters.id});
		}
		private function onModulesError(e:Event)
		{
			txtMessage.text = "";
			trace("no modules assigned");
		}
		private function onModules(e:Event)
		{
			txtMessage.text = "";
			oXMLUsers = XML(e.target.data);
			var selectedModules:Array = new Array();
			
			for (var i in oXMLUsers..idModule)
			{
				selectedModules.push(oXMLUsers..idModule[i]);
			}
			oLayout.setValues(selectedModules);
		}
		/*
		 * 
		 * @param	e
		 */
		private function onSave(e:Event)
		{
			var aModules:Array = oLayout.getFormArray();
			var saveoption:String = aModules.length == 0?"deleteprofilemodules":"setprofilemodules"; 
			var data:String="";
			for (var i = 0; i < aModules.length; i++)
			{
				data += aModules[i]+",";	
			}
			data = data.slice(0, data.length - 1);
			var urlusers = oShell.getURL("permissions", "profile");
			oXMLModules = new XMLLoader(urlusers, onSaveResponse, null, null,{option:saveoption,idprofile:oForm.id,data:data});
			txtMessage.text = "Saving modules...";
		}
		private function onSaveResponse(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE, { type:"yes" } ));
			
		}
		private function onCancel(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"no"}));
		}
		
	}
	
}
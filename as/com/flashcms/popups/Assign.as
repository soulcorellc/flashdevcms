package com.flashcms.popups {
	import com.flashcms.core.Module;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.forms.FormData;
	import com.yahoo.astra.fl.accessibility.EventTypes;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import flash.display.Sprite;
	import com.flashcms.components.ButtonBar;
	import flash.events.Event;
	import com.flashcms.events.PopupEvent;
	import com.flashcms.design.DynamicBG;
	import com.flashcms.layout.LayoutSchema;
	
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
		private var oXMLUsers:XML;
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
			trace("ID " + parameters.id);
			scPanel.source = mcLayout;
			oForm = new FormData(parameters.table, parameters.section, parameters.requiredata, parameters.data);		
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
			var urlusers = oShell.getURL("permissions", "profile");
			oXMLLoader = new XMLLoader(urlusers, onModules,null,null,{option:"getprofilemodules",idprofile:parameters.id});
		}
		private function onModules(e:Event)
		{
			oXMLUsers = XML(e.target.data);
			trace(oXMLUsers.users[0].name);
		
		}
		private function onSave(e:Event)
		{
			oLayout.getFormObject();
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"yes"}));
		}
		private function onCancel(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"no"}));
		}
		
	}
	
}
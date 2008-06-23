package com.flashcms.popups {
	import com.flashcms.core.Module;
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
	import com.flashcms.layout.Layout;
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
		private var oLayout:Layout;
		public function Assign() {
			createBG();
			
			mcLayout = new Sprite();
			oLayout = new Layout(mcLayout, 2, 30, 30);
			oLayout.xmargin = 10;
			oLayout.ymargin = 10;
			oBar = new ButtonBar(onSave, onCancel, "Cancel", "Save");
			oBar.x = 300;
			oBar.y = 295;
			addChild(oBar);
		}
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
			xmlList = oForm.data[oForm.section];
			var index:int = 0;
			var yinit:int = 30;
			for each (var item:XML in xmlList)
			{
				var component:CheckBox = new CheckBox();
				component.label = item.name;
				component.x = 30;
				component.y = (index * 30)+yinit;
				mcLayout.addChild(component);
				oLayout.addComponent(component, "", "checkbox");
				index++;
			
			}
			scPanel.update();
		}
		private function onSave(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"yes"}));
		}
		private function onCancel(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"yes"}));
		}
	}
	
}
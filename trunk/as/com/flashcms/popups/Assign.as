package com.flashcms.popups {
	import com.flashcms.core.Module;
	import com.flashcms.forms.FormData;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import flash.display.Sprite;
	
	/**
	* ...
	* @author Default
	*/
	public class Assign extends Module{
		private var oForm:FormData;
		private var xmlList:XMLList;
		private var mcLayout:Sprite;
		public var scPanel:ScrollPane;
		public var btCancel:Button;
		public var btSave:Button;
		public function Assign() {
			mcLayout = new Sprite();
		}
		/**
		 * 
		 */
		public override function init()
		{
			scPanel.source = mcLayout;
			oForm = new FormData(parameters.table, parameters.section, parameters.requiredata, parameters.data);
			//if (oForm.section == "assign")
			//{
				xmlList = oForm.data.users;
			//}
			var index:int = 0;
			var yinit:int = 30;
			for each (var item:XML in xmlList)
			{
				var component:CheckBox = new CheckBox();
				component.label = item.name;
				component.x = 30;
				component.y = (index * 30)+yinit;
				mcLayout.addChild(component);
				index++;
				
			}
			scPanel.update();
		}
		
	}
	
}
package com.flashcms.admin {
	import flash.events.Event;	
	import flash.display.DisplayObject;
	import com.flashcms.core.Module;
	import com.flashcms.events.ErrorEvent;
	import com.flashcms.layout.Layout;
	import com.flashcms.utils.XMLLoader;
	
	
	import com.flashcms.forms.ComponentFactory;
	import com.flashcms.forms.ComponentData;
	/**
	* ...
	* @author Default
	*/
	public class Edit extends Module{
		var oXMLLoader:XMLLoader;
		var oXML:XML;
		var oLayout:Layout;
		
		public function Edit() {
			oLayout = new Layout(this,2, 50, 90);
		}
		/**
		 * 
		 */
		public override function init()
		{
			switch(parameters.name)
			{
				case "user":
					new XMLLoader(oShell.getURL("getUser", "users"), onXMLData, onErrorData, onError);
				break;
			}
		}
		/**
		 * 
		 * @param	event
		 */
		private function onXMLData(event:Event)
		{
			oXML = (XML(event.target.data));
			createForm();
		}
		/**
		 * 
		 * @param	event
		 */
		private function onErrorData(event:ErrorEvent)
		{
			trace("ok xml but error");
		}
		/**
		 * 
		 */
		private function createForm()
		{
			for each(var component:XML in oXML.user.children())
			{
				var obj = addChild(ComponentFactory.getComponent(component));
				oLayout.addComponent(obj, component.name(), component.@type);
				ComponentData.setData(obj, component,parameters.data);
			}
			
		}
		/**
		 * 
		 */
		
		/**
		 * 
		 * @param	e
		 */
		private function onError(e:Event)
		{
			trace("error xml");
		}
		
		
	}
	
}
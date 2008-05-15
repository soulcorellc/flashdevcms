package com.flashcms.admin {
	import com.flashcms.core.Module;
	import com.flashcms.events.ErrorEvent;
	import com.flashcms.utils.XMLLoader;
	import fl.accessibility.UIComponentAccImpl;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import com.flashcms.forms.ComponentFactory;
	/**
	* ...
	* @author Default
	*/
	public class Edit extends Module{
		var oXMLLoader:XMLLoader;
		var oXML:XML;
		
		public function Edit() {
			
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
				setComponent(ComponentFactory.getComponent(component.@type),component);
				//trace(column.name()+" = "+column.text()+ "type : "+column.@type);
			}
		}
		private function setComponent(component:DisplayObject,properties:XML)
		{
		component.x
		}
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
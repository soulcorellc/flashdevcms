package com.flashcms.admin {
	import flash.events.Event;	
	import flash.display.DisplayObject;
	import com.flashcms.core.Module;
	import com.flashcms.events.ErrorEvent;
	import com.flashcms.layout.Layout;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.forms.ComponentFactory;
	import com.flashcms.forms.ComponentData;
	import com.flashcms.components.ButtonBar;
	import com.flashcms.events.PopupEvent;
	/**
	* ...
	* @author Default
	*/
	public class Edit extends Module{
		var oXMLLoader:XMLLoader;
		var oXML:XML;
		var oXMLSchema:XML;
		var oLayout:Layout;
		var oBar:ButtonBar;
		
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
					new XMLLoader(oShell.getURL("schema", "users"), onXMLSchema, onErrorData, onError);
				break;
			}
			oBar = new ButtonBar(send,close,"Save","Cancel");
			oBar.x = 50;
			oBar.y = 300;
			addChild(oBar);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onXMLSchema(event:Event)
		{
			oXMLSchema = XML(event.target.data);
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
			for each(var component:XML in oXMLSchema.user.children())
			{
				var obj = addChild(ComponentFactory.getComponent(component));
				oLayout.addComponent(obj, component.name(), component.@type);
				ComponentData.setData(obj, component,XML(oXML.user[component.name()]),parameters.data);
			}
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function onError(e:Event)
		{
			trace("error xml");
		}
		
		private function send(e:Event)
		{
			trace("send form");
		}
		
		private function close(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE));
		}
		
	}
	
}
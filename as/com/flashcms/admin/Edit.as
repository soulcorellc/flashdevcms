package com.flashcms.admin {
	import com.flashcms.core.Module;
	import com.flashcms.events.ErrorEvent;
	import com.flashcms.utils.XMLLoader;
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
		
		public override function init()
		{
			switch(parameters.name)
			{
				case "user":
					new XMLLoader(oShell.getURL("getUser", "users"), onXMLData, onErrorData, onError);
				break;
			}
		}
		
		private function onXMLData(event:Event)
		{
			oXML=(XML(event.target.data));
		}
		
		private function onErrorData(event:ErrorEvent)
		{
			trace("ok xml but error");
		}
		
		private function onError(e:Event)
		{
			trace("error xml");
		}
		
		
	}
	
}
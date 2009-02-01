package com.flashcms.deeplinking {
	import com.flashcms.deeplinking.SWFAddress;
	import com.flashcms.events.NavigationEvent;
	import flash.events.EventDispatcher;
	/**
	* ...
	* @author Default
	*/
	public class Navigation extends EventDispatcher{
		public var oController;
		public var lastmodule:String;
		public function Navigation(controller) {
			oController = controller;
			SWFAddress.setStrict(false);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onChange);
		}
		public function onChange(event:SWFAddressEvent)
		{
			trace("deeplinking Changed on SWFADDRESS: " + SWFAddress.getValue());
			var module:String = SWFAddress.getValue() == ""? "/":SWFAddress.getPath();
			var oparams:Object = new Object();
			
			var parameters = SWFAddress.getParameterNames();
			
			for (var i in parameters)
			{
				oparams[parameters[i]]= SWFAddress.getParameter(parameters[i]);
				oparams[parameters[i]] = SWFAddress.getParameter(parameters[i]);
			}
			
			module = module.slice(1, module.length);
			var oEvent = new NavigationEvent(module, oparams);
			dispatchEvent(oEvent);
		}
		
		public function setURL(module:String, parameters:Object=null)
		{
			//var sparams:String = "section=" + parameters.section;
			lastmodule = module;
			var sparams:String = "";
			for (var i in parameters)
			{
				if(isVisibleParameter(i)){
					sparams += i + "=" + parameters[i] + "&";
				}
			}
			
			sparams=sparams.slice(0, sparams.length - 1);
			
			//sparams = parameters.content == undefined? sparams : sparams +"&content="+ parameters.content;
			trace("setting value : " + "/" + module + "?" + sparams);
			SWFAddress.setValue("/" + module+"?"+sparams);
			SWFAddress.setTitle(":: " + module + " ::");
		}
		public function isVisibleParameter(name:String):Boolean
		{
			switch(name)
			{
			case "id":
			case "label":
			case "selected":
			case "module":
			case "enabled":
				return false;
				break;
			default:
				return true;
			break;
			}
			//i != "id" && i!="label" && i!="selected" && i!="module"
		}
		public function reset()
		{
			//SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, onChange);
			SWFAddress.setValue("");
		}
		public function forceupdate()
		{
			onChange(new SWFAddressEvent(""));
		}
	}
}
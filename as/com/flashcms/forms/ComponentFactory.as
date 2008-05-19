package com.flashcms.forms {
	import com.flashcms.forms.ComponentTypes;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.TextInput;
	import flash.display.DisplayObject;
	/**
	* ...
	* @author Default
	*/
	public class ComponentFactory {
		public function ComponentFactory() {
		
		}
		
		public static function getComponent(data:XML):DisplayObject
		{
			var component;
			
			switch(data.@type.toString())
			{
				case ComponentTypes.ComboBox:
					component = new ComboBox();
				break;
				case ComponentTypes.Textfield:
					component = new TextInput();
					
				break;
				case ComponentTypes.CheckBox:
					component = new CheckBox();
				break;
			}
			return component;
		}
		
		
		
	}
	
}
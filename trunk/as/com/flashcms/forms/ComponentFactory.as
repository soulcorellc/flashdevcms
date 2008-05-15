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
		
		public static function getComponent(type:String):DisplayObject
		{
			switch(type)
			{
				case ComponentTypes.ComboBox:
					return new ComboBox();
				break;
				case ComponentTypes.Textfield:
					return new TextInput();
				break;
				case ComponentTypes.CheckBox:
					return new CheckBox();
				break;
			}
		}
		
	}
	
}
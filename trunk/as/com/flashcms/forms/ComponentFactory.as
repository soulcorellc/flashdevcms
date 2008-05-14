package com.flashcms.forms {
	import com.flashcms.forms.ComponentTypes;
	/**
	* ...
	* @author Default
	*/
	public class ComponentFactory {
		
		public function ComponentFactory() {
			
		}
		
		public static function getComponent(type:String)
		{
			switch(type)
			{
				case ComponentTypes.ComboBox:
				
				break;
				case ComponentTypes.Textfield:
				
				break;
			}
		}
		
	}
	
}
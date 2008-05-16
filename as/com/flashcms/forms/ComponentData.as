package com.flashcms.forms {
	import com.flashcms.forms.ComponentTypes;
	import fl.data.DataProvider;
	/**
	* ...
	* @author Default
	*/
	public class ComponentData {
	
		
		public static function setData(component, data:XML,formdata:XML)
		{
			
			switch(data.@type.toString())
			{
				case ComponentTypes.ComboBox:
					var myDP:DataProvider = new DataProvider(<data>{formdata[data.@provider]}</data>);	
					component.dataProvider = myDP;
					component.labelField = data.@label;
				break;
				case ComponentTypes.Textfield:
					component.text = data.text();
					component.displayAsPassword = data.@password == "true"? true : false;
				break;
				case ComponentTypes.CheckBox:
					component.label = data.name();
					component.selected = data.text() == "true"? true:false;
				break;
			}
			return component;
		}
		
	}
	
}
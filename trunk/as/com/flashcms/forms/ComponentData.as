package com.flashcms.forms {
	import com.flashcms.forms.ComponentTypes;
	import fl.data.DataProvider;
	/**
	* ...
	* @author Default
	*/
	public class ComponentData {
	
		
		public static function setData(component,schema:XML,data:XML,formdata:XML)
		{
			trace("setting " + component + " data " + data.text()+" is a "+schema.@type);
			switch(schema.@type.toString())
			{
				case ComponentTypes.ComboBox:
					var myDP:DataProvider = new DataProvider(<data>{formdata[schema.@provider]}</data>);	
					component.dataProvider = myDP;
					component.labelField = schema.@label;
					//TODO  : select option
				break;
				case ComponentTypes.Textfield:
					component.text = data.text();
				break;
				case ComponentTypes.CheckBox:
					component.label = data.name();
					component.selected = data.text() == "true"? true:false;
				break;
			}
			return component;
		}
		
		public static function setCombo(component,data:XMLList,labelfield:String)
		{
			trace(data);
			var myDP:DataProvider = new DataProvider(<data>{data}</data>);	
			component.dataProvider = myDP;
			component.labelField = labelfield;
		}
		
	}
	
}
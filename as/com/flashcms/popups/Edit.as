package com.flashcms.popups {
	import com.flashcms.forms.FormData;
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
	import com.flashcms.forms.Validator;
	/**
	* ...
	* @author Default
	*/
	public class Edit extends Module{
		private var oXMLLoader:XMLLoader;
		private var oXML:XML;
		private var oXMLSchema:XML;
		private var oLayout:Layout;
		private var oBar:ButtonBar;
		private var oForm:FormData;
		private var id:int;
		private var create:Boolean;
		private var createoption:String;
		private var editoption:String;
		
		
		/**
		 * 
		 */
		public function Edit() {
			oLayout = new Layout(this,1, 50, 90);
		}
		/**
		 * 
		 */
		public override function init()
		{
			oForm = new FormData(parameters.table, parameters.section, parameters.requiredata, parameters.data);
			id = parameters.id;
			create = parameters.create;
			editoption = parameters.editoption;
			createoption=parameters.createoption;
			var urlschema:String = oShell.getURL("schema", oForm.section);
			new XMLLoader(urlschema, onXMLSchema, onErrorData, onError);
			
			oBar = new ButtonBar(send,close,"Save","Cancel");
			oBar.x = 50;
			oBar.y = 350;
			addChild(oBar);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onXMLSchema(event:Event)
		{
			oXMLSchema = XML(event.target.data);
			if (oForm.requiredata)
			{
				var urldata = oShell.getURL("data", oForm.section);
				new XMLLoader(urldata, onXMLData, onErrorData, onError, {option:"getuser",id:id} );
			}
			else
			{
				createForm();
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
			
			for each(var component:XML in oXMLSchema[oForm.table].children())
			{
				var obj = addChild(ComponentFactory.getComponent(component));
				oLayout.addComponent(obj, component.name(), component.@type);
				if(oForm.requiredata){
					ComponentData.setData(obj, component, XML(oXML[oForm.table][component.name()]) , oForm.data);
				}
			}
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function onError(e:Event)
		{
			trace("error loading xml file");
		}
		/**
		 * 
		 * @param	e
		 */
		private function send(e:Event)
		{
			option = create?createoption:editoption;
			new XMLLoader(urldata, onSaveData, onSaveError, onError, {option:option,id:id});
		}
		private function onSaveData(e:Event)
		{
			trace("saved");
		}
		private function onSaveError(e:Event)
		{
			trace("error saving");
		}
		/**
		 * 
		 * @param	e
		 */
		private function close(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE));
		}
		
	}
	
}
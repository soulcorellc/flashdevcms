package com.flashcms.sections {
	import com.flashcms.core.Module;
	import fl.controls.List;
	import flash.net.FileFilter;
	import flash.net.FileReferenceList;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	import fl.controls.Button;
	import flash.events.MouseEvent;
	/**
	* ...
	* @author Default
	*/
	public class Files extends Module{
		public var btUpload:Button;
		public var listFiles:List;
		private var fileRefList:FileReferenceList = new FileReferenceList();  
		private var aFileTypes:Array=new Array();
		public function Files() {
			
		}
		/**
		 * 
		 */
		public override function init()
		{
			trace("init on files");
			aFileTypes.push(new FileFilter("Images", "*.jpg;*.gif;*.png"));
			aFileTypes.push(new FileFilter("Videos", "*.flv"));
			fileRefList.addEventListener(Event.SELECT, selectHandler); 
			fileRefList.addEventListener(IOErrorEvent.IO_ERROR, onError); 
			btUpload.addEventListener(MouseEvent.CLICK, browseFiles); 
			listFiles.iconField = "icon";
		}
		/**
		 * 
		 * @param	e
		 */
		private function browseFiles(e:Event)
		{
			fileRefList.browse(aFileTypes);
		}
		/**
		 * 
		 * @param	event
		 */
		function selectHandler(event:Event):void  
		{  
			var request:URLRequest = new URLRequest("http://www.[yourdomain].com/upload/");  
			var file:FileReference;  
			var files:FileReferenceList = FileReferenceList(event.target);  
			var selectedFileArray:Array = files.fileList;  
			for (var i:uint = 0; i < selectedFileArray.length; i++)  
			{  
				file = FileReference(selectedFileArray[i]);  
				file.addEventListener(Event.COMPLETE, completeHandler); 
				file.addEventListener(IOErrorEvent.IO_ERROR, onError); 
				try  
				{  
				   file.upload(request);  
				}  
				catch (error:Error)  
				{  
					trace("Unable to upload files.");  
				}  
			}  
		}
		/**
		 * 
		 * @param	event
		 */
		function completeHandler(event:Event):void  
		{  
			trace("uploaded");  
		}  
		function onError(e:IOErrorEvent)
		{
			listFiles.addItem({label:"error uploading : "+e.target.name,icon:"iconError"});
		}
	}
}
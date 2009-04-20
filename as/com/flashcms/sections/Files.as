package com.flashcms.sections {
	import com.flashcms.components.FileExplorer;
	import com.flashcms.core.Module;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.events.ErrorEvent;
	import com.yahoo.astra.fl.accessibility.EventTypes;
	import com.yahoo.astra.fl.controls.Tree;
	import fl.controls.List;
	import flash.net.FileFilter;
	import flash.net.FileReferenceList;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import com.flashcms.utils.FileUtil;
	import flash.text.TextField;
	//import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
	
	/**
	* ...
	* @author Default
	*/
	public class Files extends Module{
		public var btUpload:Button;
		public var lsOutput:List;
		private var fileRefList:FileReferenceList = new FileReferenceList();  
		private var aFileTypes:Array = new Array();
		//public var treeFiles:Tree;
		public var mcFileExplorer:FileExplorer;
		public var btDelete:Button;
		public var btClear:Button;
		public var btUpdate:Button;
		public var txtSalida:TextField;
		public var oXMLLoader:XMLLoader;
		public var oXML:XML;
		private var sURLUpload:String;
		//private var sURLFiles:String;
		public function Files() {
			
		}
		/**
		 * 
		 */
		public override function init()
		{
			mcFileExplorer = new FileExplorer(oShell.getURL("files", "core"),oShell.getURL("media", "core"));
			addChild(mcFileExplorer);
			mcFileExplorer.x = 18;
			mcFileExplorer.y = 41;
			
			mcFileExplorer.init(350,387);
			sURLUpload = oShell.getURL("upload", "core");
			//sURLFiles = oShell.getURL("files", "core");
			
			aFileTypes.push(new FileFilter("Images", "*.jpg;*.gif;*.png"));
			aFileTypes.push(new FileFilter("Videos", "*.flv"));
			
			//treeFiles.setRendererStyle("closedBranchIcon", folderClosedIcon);
			//treeFiles.setRendererStyle("openBranchIcon", folderOpenIcon);
			//treeFiles.setRendererStyle("leafIcon", fileIcon);
			
			fileRefList.addEventListener(Event.SELECT, selectHandler); 
			fileRefList.addEventListener(IOErrorEvent.IO_ERROR, onError); 
			btUpload.addEventListener(MouseEvent.CLICK, browseFiles); 
			btDelete.addEventListener(MouseEvent.CLICK, deleteFile);
			btUpdate.addEventListener(MouseEvent.CLICK, update);
			btClear.addEventListener(MouseEvent.CLICK, clearOutput); 
			lsOutput.iconField = "icon";
			update();
		}
		private function update(e:Event=null)
		{
			mcFileExplorer.update();	
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
		 * @param	e
		 */
		private function deleteFile(e:Event)
		{
			
			mcFileExplorer.deleteFile();
			
		}
	
		
		/**
		 * 
		 * @param	e
		 */
		
		private function clearOutput(e:Event)
		{
			lsOutput.removeAll();
			
		}
		/**
		 * 
		 * @param	event
		 */
		function selectHandler(event:Event):void  
		{  
			var file:FileReference;  
			var files:FileReferenceList = FileReferenceList(event.target);  
			var selectedFileArray:Array = files.fileList;  
			for (var i:uint = 0; i < selectedFileArray.length; i++)  
			{  
				file = FileReference(selectedFileArray[i]); 
				file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				file.addEventListener(Event.COMPLETE, completeHandler); 
				file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				file.addEventListener(IOErrorEvent.IO_ERROR, onError); 
				
				var type:String = FileUtil.getFileType(file.type);
				try  
				{  
					txtSalida.text = "Uploading " + file.name;
					file.upload(new URLRequest(sURLUpload+"?tipo="+type));  
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
		function completeHandler(e:Event):void  
		{  
			trace("loaded "+e.target);
			lsOutput.addItemAt( { label:"Uploaded : " + e.target.name, icon:"iconSuccess" }, 0);
			
		}  
		function onError(e:IOErrorEvent)
		{
			lsOutput.addItemAt({label:"Error uploading : "+e.target.name,icon:"iconError"},0);
		}
		function securityErrorHandler(e:SecurityErrorEvent){
			trace("securityErrorHandler "+e.text);
		}
		private function progressHandler(event:ProgressEvent):void {
            var file:FileReference = FileReference(event.target);
			var sLoaded:String = String(Math.round((event.bytesLoaded / event.bytesTotal)*100));
			txtSalida.text = "Uploading " + file.name + " "+sLoaded+" %";

        }

	}
}
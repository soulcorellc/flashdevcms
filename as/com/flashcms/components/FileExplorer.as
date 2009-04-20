package com.flashcms.components 
{
	import com.flashcms.data.XMLLoader;
	import com.yahoo.astra.fl.accessibility.EventTypes;
	import flash.display.MovieClip;
	import com.yahoo.astra.fl.controls.Tree;
	import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
	import flash.events.Event;
	import com.flashcms.events.ErrorEvent;
	/**
	 * ...
	 * @author David Barrios
	 */
	public class FileExplorer extends MovieClip
	{
		public var treeFiles:Tree;
		public var oXML:XML;
		public var sURLFiles:String;
		public var sURLMedia:String;
		public var oXMLLoader:XMLLoader;
		public function FileExplorer(url,urlmedia) 
		{
			sURLFiles = url;
			sURLMedia = urlmedia;
		}
		/**
		 * 
		 */
		public function init(w:int,h:int)
		{
			treeFiles = new Tree();
			addChild(treeFiles);
			treeFiles.setSize(w, h);
			treeFiles.addEventListener(Event.CHANGE, onChange);
			treeFiles.setRendererStyle("closedBranchIcon", folderClosedIcon);
			treeFiles.setRendererStyle("openBranchIcon", folderOpenIcon);
			treeFiles.setRendererStyle("leafIcon", fileIcon);
			update();
		}
		public function onChange(e:Event)
		{
			dispatchEvent(e);	
		}
		/**
		 * 
		 * @param	e
		 */
		private function onFiles(e:Event)
		{
			oXML = XML(e.target.data);
			var treeXML:XML = new XML(<node><node label='images'/><node label='videos'/></node>);
			
			for each(var oItem:XML in oXML.images)
			{
				treeXML.node[0].node += <node id ={oItem.size} label = {oItem.name} tipo='images'/> ;
			}
			
			for each(var oItemVideo:XML in oXML.videos)
			{
				treeXML.node[1].node += <node id ={oItemVideo.size} label = {oItemVideo.name} tipo='videos' /> ;
			}
			treeFiles.dataProvider = new TreeDataProvider(treeXML);
			treeFiles.openAllNodes();
		}
		/**
		 * 
		 */
		public function update()
		{
			oXMLLoader = new XMLLoader(sURLFiles+"?action=getall", onFiles,onErrorFiles);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onErrorFiles(e:ErrorEvent)
		{
			trace(e.message);
		}
		/**
		 * 
		 */
		public function deleteFile()
		{
			if(treeFiles.selectedItem){
				if (treeFiles.selectedItem.tipo)
				{
					trace(treeFiles.selectedItem.tipo);	
					oXMLLoader = new XMLLoader(sURLFiles+"?action=delete&tipo="+treeFiles.selectedItem.tipo+"&filename="+treeFiles.selectedItem.label, onDelete,onErrorFiles);
				}
			}
			
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDelete(e:Event)
		{
			update();
		}
		public function getSelectedURL()
		{
			return sURLMedia + treeFiles.selectedItem.tipo + "/" + treeFiles.selectedItem.label;
		}
		
	}
	
}
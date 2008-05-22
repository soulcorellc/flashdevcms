package com.flashcms.admin {
	import com.flashcms.core.Module;
	import com.yahoo.astra.fl.controls.Tree;  
	import com.yahoo.astra.fl.controls.treeClasses.*;
	/**
	* ...
	* @author Default
	*/
	public class Sections extends Module{
		var oXML:XML =
		<node label="Root">  
            <node label="Folder 1">  
                <node label="File 1"/>  
                <node label="File 2"/>  
            </node>
			<node label="Folder 2">
				<node label="File 3"/>
				<node label="File 4"/>
			</node>  
        </node>  
		public function Sections() {
			super("Sections");
		}
		/**
		 * 
		 */
		public override function init()
		{
			treeSections.dataProvider = new TreeDataProvider(oXML);
		}
		
	}
	
}
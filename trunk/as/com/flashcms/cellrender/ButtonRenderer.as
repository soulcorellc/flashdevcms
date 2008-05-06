package com.flashcms.cellrender {
	import fl.controls.LabelButton;
	import fl.controls.listClasses.ListData;
	import fl.controls.listClasses.CellRenderer;
    import fl.controls.listClasses.ICellRenderer;
	import fl.controls.DataGrid;
	/**
	* ...
	* @author Default
	*/
	public class ButtonRenderer extends LabelButton implements ICellRenderer {
		private var _data:Object;
		private var _listData:ListData;
		public function ButtonRenderer () {
			
		}
		
		public function set data(d:Object):void {
            _data = d;
            //this.setStyle("icon", playIcon);
        }
        public function get data():Object {
            return _data;
        }
		public function set listData(ld:ListData):void {
            _listData = ld;
			this.label= DataGrid(listData.owner).getColumnAt(listData.column).headerText;
        }
        public function get listData():ListData {
            return _listData;
        }
		public override function set selected(s:Boolean):void {
            _selected = s;
        }
        public override function get selected():Boolean {
            return _selected;
        }
		
	}
	
}
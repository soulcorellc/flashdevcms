/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.containers
{
	import com.yahoo.astra.fl.containers.layoutClasses.AdvancedLayoutPane;
	import com.yahoo.astra.layout.modes.FlowLayout;
	import com.yahoo.astra.layout.modes.HorizontalAlignment;
	import com.yahoo.astra.layout.modes.VerticalAlignment;
	
	import fl.core.InvalidationType;

	/**
	 * A scrolling container that arranges its children using a flow algorithm
	 * similar to the flow of text in a document or webpage.
	 * 
	 * @example The following code configures a FlowPane container:
	 * <listing version="3.0">
	 * var pane:FlowPane = new FlowPane();
	 * pane.direction = "horizontal";
	 * pane.horizontalGap = 4;
	 * pane.verticalGap = 2;
	 * pane.horizontalAlign = HorizontalAlignment.CENTER;
	 * pane.verticalAlign = VerticalAlignment.BOTTOM;
	 * this.addChild( pane );
	 * </listing>
	 * 
	 * <p>This layout container supports advanced options specified through the
	 * <code>configuration</code> property.</p>
	 * 
	 * <dl>
	 * 	<dt><strong><code>target</code></strong> : DisplayObject</dt>
	 * 		<dd>A display object to be configured.</dd>
	 * 	<dt><strong><code>includeInLayout</code></strong> : Boolean</dt>
	 * 		<dd>If <code>false</code>, the target will not be included in layout calculations. The default value is <code>true</code>.</dd>
	 * </dl>
	 * 
	 * @author Josh Tynjala
	 */
	public class FlowPane extends AdvancedLayoutPane
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 * 
		 * @param configuration		An Array of optional configurations for the layout container's children.
		 */
		public function FlowPane(configuration:Array = null)
		{
			super(new FlowLayout(), configuration);
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
		 * Storage for the direction property.
		 */
		private var _direction:String = "horizontal";
		
		/**
		 * The direction in which children of this container are laid out. Once
		 * the edge of the container is reached, the children will begin
		 * appearing on the next row or column. Valid direction values include
		 * <code>"vertical"</code> or <code>"horizontal"</code>.
		 */
		public function get direction():String
		{
			return this._direction;
		}
		
		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			this._direction = value;
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Storage for the verticalGap property.
		 */
		private var _verticalGap:Number = 0;
		
		/**
		 * The number of pixels appearing between the container's children
		 * vertically.
		 */
		public function get verticalGap():Number
		{
			return this._verticalGap;
		}
		
		/**
		 * @private
		 */
		public function set verticalGap(value:Number):void
		{
			this._verticalGap = value;
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Storage for the horizontalGap property.
		 */
		private var _horizontalGap:Number = 0;
		
		/**
		 * The number of pixels appearing between the container's children
		 * horizontally.
		 */
		public function get horizontalGap():Number
		{
			return this._horizontalGap;
		}
		
		/**
		 * @private
		 */
		public function set horizontalGap(value:Number):void
		{
			this._horizontalGap = value;
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Storage for the verticalAlign property.
		 */
		private var _verticalAlign:String = VerticalAlignment.TOP;
		
		/**
		 * The vertical alignment of children displayed in the container.
		 * 
		 * @see com.yahoo.astra.layout.VerticalAlignment
		 */
		public function get verticalAlign():String
		{
			return this._verticalAlign;
		}
		
		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Storage for the horizontalAlign property.
		 */
		private var _horizontalAlign:String = HorizontalAlignment.LEFT;
		
		/**
		 * The horizontal alignment of children displayed in the container.
		 * 
		 * @see com.yahoo.astra.layout.HorizontalAlignment
		 */
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}
		
		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var flowLayout:FlowLayout = this.layoutMode as FlowLayout;
			if(flowLayout)
			{
				//pass the various properties to the layout mode
				flowLayout.direction = this.direction;
				flowLayout.horizontalAlign = this.horizontalAlign;
				flowLayout.verticalAlign = this.verticalAlign;
				flowLayout.horizontalGap = this.horizontalGap;
				flowLayout.verticalGap = this.verticalGap;
			}
			
			super.draw();
		}
		
	}
}
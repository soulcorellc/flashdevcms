/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.controls
{
	import com.yahoo.astra.fl.controls.carouselClasses.BoxCarouselRenderer;
	import com.yahoo.astra.fl.controls.carouselClasses.CarouselCellRenderer;
	import com.yahoo.astra.fl.controls.carouselClasses.CarouselListData;
	import com.yahoo.astra.fl.controls.carouselClasses.StackCarouselRenderer;
	import com.yahoo.astra.fl.controls.carouselClasses.ICarouselLayoutRenderer;
	import com.yahoo.astra.fl.controls.carouselClasses.SlidingCarouselRenderer;
	import com.yahoo.astra.fl.controls.carouselClasses.astra_carousel_internal;
	import com.yahoo.astra.fl.utils.UIComponentUtil;
	
	import fl.controls.ScrollPolicy;
	import fl.controls.SelectableList;
	import fl.controls.listClasses.ICellRenderer;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.events.ComponentEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	/**
	 * A list-like component that supports custom rendering engines for maximum
	 * creative flexibility.
	 * 
	 * @see fl.controls.List
	 * @see http://developer.yahoo.com/ypatterns/pattern.php?pattern=carousel Carousel Pattern
	 */
	public class Carousel extends SelectableList
	{
		
	//--------------------------------------
	//  Static Properties
	//--------------------------------------
	
		/**
		 * @private
		 */
		private static var defaultStyles:Object = 
		{
			cellRenderer: CarouselCellRenderer,
			skin: "Carousel_skin",
			contentPadding: 1
		};
		
		/**
		 * @private
		 * We need to ensure that the layout classes are included.
		 */
		private static const DEPENDENCIES:Array = [StackCarouselRenderer, CellRendererSymbol];
		
		/**
		 * @private
		 * A new invalidation type used by the Carousel related to layout.
		 */
		protected static const INVALIDATION_TYPE_LAYOUT:String = "layoutInvalid";
		
	//--------------------------------------
	//  Static Methods
	//--------------------------------------
	
		/**
		 * @private
		 * @copy fl.core.UIComponent#getStyleDefinition()
		 */
		public static function getStyleDefinition():Object
		{
			return mergeStyles(defaultStyles, SelectableList.getStyleDefinition());
		}
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function Carousel()
		{
			super();
			
			//no scroll bars
			this.horizontalScrollPolicy = this.verticalScrollPolicy = ScrollPolicy.OFF;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * Saves a list connecting items to item renderers so that the
		 * same renderer my be reused the next time this component redraws.
		 * Useful for when renderers load external assets.
		 */
		private var _itemToRendererHash:Dictionary = new Dictionary();
		
		/**
		 * @private
		 * Storage for the layout renderer property.
		 */
		private var _layoutRenderer:ICarouselLayoutRenderer;
		
		/**
		 * An instance of ICarouselLayoutRenderer that handles the layout of
		 * cell renderers for this Carousel instance.
		 */
		public function get layoutRenderer():ICarouselLayoutRenderer
		{
			return this._layoutRenderer;
		}
		
		/**
		 * @private
		 */
		public function set layoutRenderer(value:ICarouselLayoutRenderer):void
		{
			if(this._layoutRenderer)
			{
				this._layoutRenderer.cleanUp();
				this._layoutRenderer.removeEventListener(ComponentEvent.RESIZE, layoutRendererResizeHandler);
			}
			this._layoutRenderer = value;
			this._layoutRenderer.addEventListener(ComponentEvent.RESIZE, layoutRendererResizeHandler, false, 0, true);
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Storage for the labelField property.
		 */
		protected var _labelField:String = "label";
		
		[Inspectable(defaultValue="label")]
		/**
         * Gets or sets the name of the field in the <code>dataProvider</code> object 
         * to be displayed as the label in the tabs. 
		 *
         * <p>By default, the component displays the <code>label</code> property 
		 * of each <code>dataProvider</code> item. If the <code>dataProvider</code> 
		 * items do not contain a <code>label</code> property, you can set the 
		 * <code>labelField</code> property to use a different property.</p>
         *
         * <p><strong>Note:</strong> The <code>labelField</code> property is not used 
         * if the <code>labelFunction</code> property is set to a callback function.</p>
         * 
         * @default "label"
         *
         * @see #labelFunction
		 */
		public function get labelField():String
		{
			return this._labelField;	
		}
		
		/**
         * @private
		 */
		public function set labelField(value:String):void
		{
			if(this._labelField != value)
			{
				this._labelField = value;
				this.invalidate(InvalidationType.DATA);
			}
		}
		
		/**
		 * @private
		 * Storage for the labelFunction property.
		 */
		protected var _labelFunction:Function = null;
		
        /**
         * Gets or sets the function to be used to obtain the label for the item.
		 *
         * <p>By default, the component displays the <code>label</code> property
		 * for a <code>dataProvider</code> item. But some data sets may not have 
		 * a <code>label</code> field or may not have a field whose value
		 * can be used as a label without modification. For example, a given data 
		 * set might store full names but maintain them in <code>lastName</code> and  
		 * <code>firstName</code> fields. In such a case, this property could be
		 * used to set a callback function that concatenates the values of the 
		 * <code>lastName</code> and <code>firstName</code> fields into a full 
		 * name string to be displayed.</p>
		 *
         * <p><strong>Note:</strong> The <code>labelField</code> property is not used 
         * if the <code>labelFunction</code> property is set to a callback function.</p>
         *
         * @default null
		 */
		public function get labelFunction():Function
		{
			return this._labelFunction;	
		}
		
		/**
         * @private
		 */
		public function set labelFunction(value:Function):void
		{
			if(this._labelFunction != value)
			{
				this._labelFunction = value;
				this.invalidate(InvalidationType.DATA);
			}
		}
		
		/**
		 * @private
		 * Storage for the iconField property.
		 */
		private var _iconField:String = "icon";
		
		/**
		 * Gets or sets the item field that provides the icon for a cell renderer.
         *
         * <p><strong>Note:</strong> The <code>iconField</code> is not used if the 
		 * <code>iconFunction</code> property is set to a callback function.</p>
		 *
         * @default "icon"
         *
         * @see #iconFunction
		 */
		public function get iconField():String
		{
			return this._iconField;
		}
		
		/**
		 * @private
		 */
		public function set iconField(value:String):void
		{
			if(this._iconField != value)
			{
				this._iconField = value;
				this.invalidate(InvalidationType.DATA);
			}
		}
		
		/**
		 * @private
		 * Storage for the iconFunction property.
		 */
		protected var _iconFunction:Function = null;
		
        /**
         * Gets or sets the function to be used to obtain the icon for the item.
		 *
         * <p>By default, the component displays the <code>icon</code> property
		 * for a <code>dataProvider</code> item. But some data sets may not have 
		 * a <code>icon</code> field or may not have a field whose value
		 * can be used as a icon without modification.</p>
		 *
         * <p><strong>Note:</strong> The <code>iconField</code> property is not used 
         * if the <code>iconFunction</code> property is set to a callback function.</p>
         *
         * @default null
		 */
		public function get iconFunction():Function
		{
			return this._iconFunction;	
		}
		
		/**
         * @private
		 */
		public function set iconFunction(value:Function):void
		{
			if(this._iconFunction != value)
			{
				this._iconFunction = value;
				this.invalidate(InvalidationType.DATA);
			}
		}
		
		/**
		 * @private
		 * Storage for the sourceField property.
		 */
		private var _sourceField:String = "source";
		
		[Inspectable(defaultValue="source")]
		/**
		 * Gets or sets the item field that provides the source path for a cell renderer.
         *
         * <p><strong>Note:</strong> The <code>sourceField</code> is not used if the 
		 * <code>sourceFunction</code> property is set to a callback function.</p>
		 *
         * @default "source"
         *
         * @see #sourceFunction
		 */
		public function get sourceField():String
		{
			return this._sourceField;
		}
		
		/**
		 * @private
		 */
		public function set sourceField(value:String):void
		{
			if(this._sourceField != value)
			{
				this._sourceField = value;
				this.invalidate(InvalidationType.DATA);
			}
		}
		
		/**
		 * @private
		 * Storage for the sourceFunction property.
		 */
		protected var _sourceFunction:Function = null;
		
        /**
         * Gets or sets the function to be used to obtain the image source for the item.
		 *
         * <p>By default, the component displays the <code>source</code> property
		 * for a <code>dataProvider</code> item. But some data sets may not have 
		 * a <code>source</code> field or may not have a field whose value
		 * can be used as an image source without modification.</p>
		 *
         * <p><strong>Note:</strong> The <code>sourceField</code> property is not used 
         * if the <code>sourceFunction</code> property is set to a callback function.</p>
         *
         * @default null
		 */
		public function get sourceFunction():Function
		{
			return this._sourceFunction;	
		}
		
		/**
         * @private
		 */
		public function set sourceFunction(value:Function):void
		{
			if(this._sourceFunction != value)
			{
				this._sourceFunction = value;
				this.invalidate(InvalidationType.DATA);
			}
		}
		
		[Collection(collectionClass="fl.data.DataProvider", collectionItem="fl.data.TileListCollectionItem", identifier="item")]
		/**
         * @private
		 */
		override public function set dataProvider(value:DataProvider):void
		{
			super.dataProvider = value;
			if(this.dataProvider)
			{
				//make sure we have a valid selected index
				if(this.dataProvider.length == 0)
				{
					this.selectedIndex = -1;
				}
				else if(this.selectedIndex < 0 || this.selectedIndex >= this.dataProvider.length)
				{
					this.selectedIndex = 0;
				}
			}
		}
		
		/**
		 * @private
		 * SelectableList accesses the list property, which we've removed,
		 * so let's remake UIComponent's set enabled.
		 */
		override public function set enabled(value:Boolean):void
		{
			if (value == this._enabled)
			{
				return;
			}
			this._enabled = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		/**
		 * @private
		 * Flag that indicates that the layout renderer is currently being
		 * redrawn.
		 */
		protected var isDrawingRenderer:Boolean = false;
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * Retrieves the label text that the renderer displays for the given
		 * data object based on the <code>labelField</code> or <code>labelFunction</code>
		 * defined by the Carousel.
		 */
		override public function itemToLabel(item:Object):String
		{
			if(!item)
			{
				return "";
			}
			
			if(this.labelFunction != null)
			{
				return this.labelFunction(item);
			}
			else if(item.hasOwnProperty(this.labelField))
			{
				return item[this.labelField];
			}
			
			return "";
		}
		
		/**
		 * Retrieves the image source that the renderer displays for the given
		 * data object based on the <code>sourceField</code> or <code>sourceFunction</code>
		 * defined by the Carousel. Generally, this value is the URL to an image
		 * or SWF file to be displayed in a UILoader.
		 */
		public function itemToSource(item:Object):Object
		{
			if(!item)
			{
				return null;
			}
			
			if(this.sourceFunction != null)
			{
				return this.sourceFunction(item);
			}
			else if(item.hasOwnProperty(this.sourceField))
			{
				return item[this.sourceField];
			}
			
			return null;
		}
		
		/**
		 * Retrieves the icon that the renderer displays for the given
		 * data object based on the <code>iconField</code> or <code>iconFunction</code>
		 * defined by the Carousel.
		 */
		public function itemToIcon(item:Object):Object
		{
			if(!item)
			{
				return null;
			}
			
			if(this.iconFunction != null)
			{
				return this.iconFunction(item);
			}
			else if(item.hasOwnProperty(this.iconField))
			{
				return item[this.iconField];
			}
			
			return null;
		}
		
	//--------------------------------------
	//  Namespaced Methods
	//--------------------------------------
		
		/**
		 * Tells the Carousel that its cell renderers are invalid and that the
		 * layout renderer is beginning to draw.
		 */
		astra_carousel_internal function invalidateCellRenderers():void
		{
			this._layoutRenderer.cleanUp();
			
			this.activeCellRenderers = [];
			
			//save any cell renderers that are already showing
			//items that appear in the current data provider
			for(var item:Object in this._itemToRendererHash)
			{
				if(this.dataProvider.getItemIndex(item) < 0)
				{
					var renderer:ICellRenderer = ICellRenderer(this._itemToRendererHash[item]);
					this.availableCellRenderers.push(renderer);
					delete this._itemToRendererHash[item];
				}
			}
		}
		
		/**
		 * Informs the Carousel that the layout renderer has finished drawing
		 * and that it may perform any garbage collection needed.
		 */
		astra_carousel_internal function validateCellRenderers():void
		{
			//remove any cell renderers that we aren't using...
			var rendererCount:int = this.availableCellRenderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				var renderer:DisplayObject = DisplayObject(this.availableCellRenderers.shift());
				renderer.parent.removeChild(renderer);
			}
			
			//...even if they're for data that we still use (but don't display)!
			for each(renderer in this._itemToRendererHash)
			{
				renderer.parent.removeChild(renderer);
			}
			
			//create a hash of items to item renderers so that we can reuse the
			//same renderer for each item the next time we redraw
			this._itemToRendererHash = new Dictionary();
			rendererCount = this.activeCellRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				var activeRenderer:ICellRenderer = ICellRenderer(this.activeCellRenderers[i]);
				this._itemToRendererHash[activeRenderer.data] = activeRenderer;
			}
		}
		
		/**
		 * Creates a cell renderer for use by the layout renderer.
		 */
		astra_carousel_internal function createCellRenderer(item:Object, parent:DisplayObjectContainer = null):ICellRenderer
		{
			/*
			 * Algorithm works as follows:
			 * 
			 * 1) If we're requesting a cell renderer for data that was used the
			 * last time we redrew, reuse the same cell renderer.
			 * 
			 * 2) Reuse a cell renderer for data that no longer exists in the
			 * data provider.
			 * 
			 * 3) Create a new cell renderer if no cached renderers are
			 * available to be reused.
			 *
			 * fl.controls.List does the same thing.
			 * 
			 */
			 
			var renderer:ICellRenderer = this.itemToCellRenderer(item);
			if(renderer)
			{
				//we've already created this renderer, reuse it.
				return renderer;
			}
			
			if(!parent)
			{
				parent = DisplayObjectContainer(this.layoutRenderer);
			}
			
			if(this._itemToRendererHash[item])
			{
				//reuse a renderer if one already exists for this item
				renderer = this._itemToRendererHash[item];
				//we don't want to reuse it twice!
				delete this._itemToRendererHash[item];
				parent.setChildIndex(DisplayObject(renderer), parent.numChildren - 1);
			}
			else if(this.availableCellRenderers.length > 0)
			{
				renderer = ICellRenderer(this.availableCellRenderers.shift());
				parent.setChildIndex(DisplayObject(renderer), parent.numChildren - 1);
			}
			else
			{
				var CellRendererType:Object = this.getStyleValue("cellRenderer");
				renderer = UIComponentUtil.getDisplayObjectInstance(this, CellRendererType) as ICellRenderer;
				if(!(renderer is ICellRenderer))
				{
					throw new Error("Cell renderers must implement the ICellRenderer interface.");
				}
				parent.addChild(DisplayObject(renderer));
			}
			
			var label:String = this.itemToLabel(item);
			var icon:Object = this.itemToIcon(item);
			var source:Object = this.itemToSource(item);
			renderer.listData = new CarouselListData(label, source, icon, this, this.dataProvider.getItemIndex(item), 0, 0);
			renderer.data = item;
			renderer.selected = this.selectedItems.indexOf(item) >= 0;
			
			//update styles
			this.activeCellRenderers.push(renderer);
			if(Object(renderer).hasOwnProperty("setStyle"))
			{
				for(var n:String in this.updatedRendererStyles)
				{
					Object(renderer).setStyle(n, this.updatedRendererStyles[n]);
				}
			}
			
			return ICellRenderer(renderer);
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function configUI():void
		{
			super.configUI();
			
			if(!this.layoutRenderer)
			{
				this.layoutRenderer = new SlidingCarouselRenderer();
			}
			
			this.listHolder.removeChild(this.list);
			this.list = null;
		}
	
		/**
		 * @private
		 */
		override protected function draw():void
		{
			this.isDrawingRenderer = false;
			if(this.isInvalid(INVALIDATION_TYPE_LAYOUT))
			{
				if(this.layoutRenderer)
				{
					if(DisplayObject(this.layoutRenderer).parent != this.listHolder)
					{
						this.listHolder.addChild(DisplayObject(this.layoutRenderer));
					}
					this.layoutRenderer.carousel = this;
				}
			}
			
			super.draw();
			
			var contentPadding:Number = this.getStyleValue("contentPadding") as Number;
			var rendererWidth:Number = this.width - 2 * contentPadding;
			var rendererHeight:Number = this.height - 2 * contentPadding;
			this.layoutRenderer.move(contentPadding, contentPadding);
			this.layoutRenderer.setSize(rendererWidth, rendererHeight);
			this.isDrawingRenderer = true;
			this.layoutRenderer.drawNow();
			this.isDrawingRenderer = false;
		}
		
	//--------------------------------------
	//  Private Event Handlers
	//--------------------------------------
		
		/**
		 * @private
		 * Resizes the carousel when the layout renderer resizes.
		 */
		private function layoutRendererResizeHandler(event:ComponentEvent):void
		{
			var contentPadding:Number = this.getStyleValue("contentPadding") as Number;
			this.setSize(this.layoutRenderer.width + 2 * contentPadding, this.layoutRenderer.height + 2 * contentPadding);
			if(this.isDrawingRenderer)
			{
				//this could lead to an infinite loop if the layout renderer
				//sucks at its job. the renderer is expected to always check
				//whether its width and height values have changed.
				this.drawNow();
			}
		}
	}
}
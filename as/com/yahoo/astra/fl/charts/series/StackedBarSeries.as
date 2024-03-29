/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.charts.series
{
	import com.yahoo.astra.fl.charts.IChart;
	import com.yahoo.astra.fl.charts.ChartUtil;
	import com.yahoo.astra.fl.charts.axes.IAxis;
	import com.yahoo.astra.fl.charts.axes.IOriginAxis;
	
	/**
	 * A bar series type that stacks.
	 * 
	 * @author Josh Tynjala
	 */
	public class StackedBarSeries extends BarSeries implements IStackedSeries
	{
			
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function StackedBarSeries(data:Object=null)
		{
			super(data);
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function calculateYOffset(valueAxis:IOriginAxis, otherAxis:IAxis, markerSizes:Array, totalMarkerSize:Number, allSeriesOfType:Array):Number
		{
			if(!ChartUtil.isStackingAllowed(valueAxis, this))
			{
				return super.calculateYOffset(valueAxis, otherAxis, markerSizes, totalMarkerSize, allSeriesOfType);
			}
			
			var seriesIndex:int = allSeriesOfType.indexOf(this);
			return -(markerSizes[seriesIndex] as Number) / 2;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function calculateTotalMarkerSize(axis:IAxis, sizes:Array):Number
		{
			if(!ChartUtil.isStackingAllowed(axis, this))
			{
				return super.calculateTotalMarkerSize(axis, sizes);
			}
			
			var totalMarkerSize:Number = 0;
			var allSeriesOfType:Array = ChartUtil.findSeriesOfType(this, this.chart as IChart);
			var seriesCount:int = allSeriesOfType.length;
			for(var i:int = 0; i < seriesCount; i++)
			{
				var series:BarSeries = BarSeries(allSeriesOfType[i]);
				var markerSize:Number = this.calculateMarkerSize(series, axis);
				sizes.push(markerSize);
				totalMarkerSize = Math.max(totalMarkerSize, markerSize);
			}
			return totalMarkerSize;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function calculateMaximumAllowedMarkerSize(axis:IAxis):Number
		{
			if(!ChartUtil.isStackingAllowed(axis, this))
			{
				return super.calculateMaximumAllowedMarkerSize(axis);
			}
			return Number.POSITIVE_INFINITY;
		}
		
		/**
		 * @private
		 * Determines the origin of the bar. Either the axis origin or the
		 * stacked value.
		 */
		override protected function calculateOriginValue(index:int, axis:IOriginAxis, allSeriesOfType:Array):Object
		{
			if(!ChartUtil.isStackingAllowed(axis, this))
			{
				return super.calculateOriginValue(index, axis, allSeriesOfType);
			}
			
			var seriesIndex:int = allSeriesOfType.indexOf(this);
			var originValue:Object = axis.origin;
			if(seriesIndex > 0)
			{
				var previousSeries:StackedBarSeries = StackedBarSeries(allSeriesOfType[seriesIndex - 1]);
				originValue = IChart(this.chart).itemToAxisValue(previousSeries, index, axis);
			}
			return originValue;
		}
		
	}
}
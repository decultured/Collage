package Collage.Clips.LineChart
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	import Collage.Logger.*;
	
	public class LineChartClip extends Clip
	{		
		[Bindable][Savable] public var dataSetID:String = null;
		[Bindable][Savable] public var xAxisDataColumn:String = null;
		[Bindable][Savable] public var yAxisDataColumn:String = null; 

		[Bindable][Savable] public var Data:Array = new Array();
		
		[Savable] public var dataLoaded:Boolean = false;
		[Savable] public var rowsRequested:Number = 10;
		
		[Bindable][Savable] public var backgroundColor:Number = 0xFFFFFF;
		[Bindable][Savable] public var backgroundAlpha:Number = 0.0;
        
        // Line Options
		[Bindable][Savable] public var form:String = "line";
		[Bindable][Savable] public var lineWeight:Number = 2;
		[Bindable][Savable] public var lineAlpha:Number = 1;
		[Bindable][Savable] public var lineColor:Number = 0xff0000;
		
		// Grid Options
		[Bindable][Savable] public var gridVisible:Boolean = true;
		[Bindable][Savable] public var gridDirection:String = "both";
		[Bindable][Savable] public var gridColor:Number = 0xDDDDDD;
		[Bindable][Savable] public var gridAlpha:Number = 1.0;
		[Bindable][Savable] public var gridWeight:Number = 1;

		// Grid Origins
		[Bindable][Savable] public var gridHOriginVisible:Boolean = false;
		[Bindable][Savable] public var gridHOriginColor:Number = 0x559955;
		[Bindable][Savable] public var gridHOriginAlpha:Number = 0.5;
		[Bindable][Savable] public var gridHOriginWeight:Number = 1;
		[Bindable][Savable] public var gridVOriginVisible:Boolean = false;
		[Bindable][Savable] public var gridVOriginColor:Number = 0x559955;
		[Bindable][Savable] public var gridVOriginAlpha:Number = 0.5;
		[Bindable][Savable] public var gridVOriginWeight:Number = 1;

		// Vertical Axis 
		[Bindable][Savable] public var vAxisVisible:Boolean = true;
		[Bindable][Savable] public var vAxisColor:Number = 0xAAAAAA;
		[Bindable][Savable] public var vAxisAlpha:Number = 1.0;
		[Bindable][Savable] public var vAxisWeight:Number = 2;
		[Bindable][Savable] public var vAxisLabelSize:Number = 10;
		[Bindable][Savable] public var vAxisLabelColor:Number = 0x333333;
        [Bindable][Savable] public var vAxisLabelGap:Number = 10;

		// Horizontal Axis
		[Bindable][Savable] public var hAxisVisible:Boolean = true;
		[Bindable][Savable] public var hAxisColor:Number = 0xAAAAAA;
		[Bindable][Savable] public var hAxisAlpha:Number = 1.0;
		[Bindable][Savable] public var hAxisWeight:Number = 2;
		[Bindable][Savable] public var hAxisLabelSize:Number = 10;
		[Bindable][Savable] public var hAxisLabelColor:Number = 0x333333;
        [Bindable][Savable] public var hAxisLabelGap:Number = 10;

		private var _DataQuery:DataQuery = null;
	
		public function LineChartClip(dataObject:Object = null)
		{
			super(dataObject);
			CreateView(new LineChartClipView());
			CreateEditor(new LineChartClipEditor());
			type = "linechart";
		}
		
		public override function Resized():void
		{
			
		}
		
		public function RunQuery():void
		{
			if (dataSetID && yAxisDataColumn && xAxisDataColumn) {
				_DataQuery = new DataQuery();
				_DataQuery.dataset = dataSetID;
				_DataQuery.AddField(xAxisDataColumn, "desc");
				_DataQuery.AddField(yAxisDataColumn);
				_DataQuery.limit = rowsRequested;
				_DataQuery.addEventListener(DataQuery.COMPLETE, QueryFinished);
				_DataQuery.LoadQueryResults();
			}
		}
		
		public function ResetData():void
		{
			Data = new Array();
			dataLoaded = false;
			
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
		}

		private function QueryFinished(event:Event):void
		{
			var dataset:DataSet = DataEngine.GetDataSetByID(dataSetID);
			if (!dataset || !_DataQuery || !_DataQuery.result || !_DataQuery.result.rows is Array)
				return;

			var newData:Array = new Array();
			var rows:Array = _DataQuery.result.rows;
			
			//Alert.show("Rows: " + rows.length);
			if (rows.length < 3) {
				Alert.show("Not enough data for chart!");
				Logger.Log("Not enough data for chart - fewer than 3 rows", LogEntry.WARNING, this);
				return;
			}
			
			if (!rows[0])
				return;
				
			var xAxisMin:Number = rows[0][xAxisDataColumn];
			var xAxisMax:Number = rows[0][xAxisDataColumn];
			var yAxisMin:Number = rows[0][yAxisDataColumn];
			var yAxisMax:Number = rows[0][yAxisDataColumn];

			for (var rowKey:uint = 0; rowKey < rows.length; rowKey++)
			{
				if (!rows[rowKey][xAxisDataColumn] is Number || !rows[rowKey][yAxisDataColumn] is Number) {
					Logger.Log("Non-number row found for chart.", LogEntry.WARNING, this);
					continue;
				}
				
				var newObject:Object = new Object();
				
				newObject["x"] = rows[rowKey][xAxisDataColumn];
				newObject["y"] = rows[rowKey][yAxisDataColumn];
				
				if (xAxisMin > rows[rowKey][xAxisDataColumn])
					xAxisMin = rows[rowKey][xAxisDataColumn];
				if (xAxisMax < rows[rowKey][xAxisDataColumn])
					xAxisMax = rows[rowKey][xAxisDataColumn];
				if (yAxisMin > rows[rowKey][yAxisDataColumn])
					yAxisMin = rows[rowKey][yAxisDataColumn];
				if (yAxisMax < rows[rowKey][yAxisDataColumn])
					yAxisMax = rows[rowKey][yAxisDataColumn];
				
				newData.push(newObject);
			}
			
			if (xAxisMin >= xAxisMax) {
				Alert.show("No variance on X Axis, please choose other data");
				Logger.Log("No variance on X Axis, please choose other data", LogEntry.WARNING, this);
				ResetData();
				return;
			} if (yAxisMin >= yAxisMax) {
				Alert.show("No variance on Y Axis, please choose other data");
				Logger.Log("No variance on Y Axis, please choose other data", LogEntry.WARNING, this);
				ResetData();
				return;
			} 
			
			newData.sortOn("x", Array.NUMERIC);
			dataLoaded = true;

			Data = newData;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			
			_DataQuery = null;
		}
	}
}
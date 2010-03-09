package Collage.Clips.LineChart
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	
	public class LineChartClip extends Clip
	{		
		[Bindable] public var dataSetID:String = null;
		[Bindable] public var xAxisDataColumn:String = null;
		[Bindable] public var yAxisDataColumn:String = null; 

		public var Data:Array = new Array();
		
		public var dataLoaded:Boolean = false;
		public var rowsRequested:Number = 10;
		
		[Bindable] public var backgroundColor:Number = 0xFFFFEE;
		[Bindable] public var backgroundAlpha:Number = 1.0;
                              
		private var _DataQuery:DataQuery = null;
	
		public function LineChartClip(dataObject:Object = null)
		{
			super(dataObject);
			CreateView();
			CreateEditor();
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new LineChartClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new LineChartClipEditor();
				_Editor.model = this;
			}
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
				_DataQuery.LoadQueryResults();
				_DataQuery.addEventListener(DataQuery.COMPLETE, QueryFinished);
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

			Data = new Array();
			var rows:Array = _DataQuery.result.rows;
			
			//Alert.show("Rows: " + rows.length);
			if (rows.length < 3) {
				Alert.show("Not enough data for chart!");
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
					Alert.show("NAN!!!");
					break;
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
				
				Data.push(newObject);
			}
			
			if (xAxisMin >= xAxisMax) {
				Alert.show("No variance on X Axis, please choose other data");
				ResetData();
				return;
			} if (yAxisMin >= yAxisMax) {
				Alert.show("No variance on Y Axis, please choose other data");
				ResetData();
				return;
			} 
			
			Data.sortOn("x", Array.NUMERIC);
			dataLoaded = true;

			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			_DataQuery = null;
		}
		
		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "linechart";
			newObject["dataSetID"] = dataSetID;
			newObject["xAxisDataColumn"] = xAxisDataColumn;
			newObject["yAxisDataColumn"] = yAxisDataColumn;
			newObject["Data"] = Data;
			newObject["dataLoaded"] = dataLoaded;
			newObject["rowsRequested"] = rowsRequested;
			newObject["backgroundColor"] = backgroundColor;
			newObject["backgroundAlpha"] = backgroundAlpha;

			return newObject;
		}

		public override function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject)
				return false;
			super.LoadFromObject(dataObject);
			for (var key:String in dataObject)
			{
				if (key == "dataSetID") {
					dataSetID = dataObject[key];
				} else if (key == "xAxisDataColumn") {
					xAxisDataColumn = dataObject[key];
				} else if (key == "yAxisDataColumn") {
					yAxisDataColumn = dataObject[key];
				} else if (key == "Data" && dataObject[key] is Array) {
					Data = dataObject[key];
				} else if (key == "dataLoaded") {
					dataLoaded = dataObject[key] as Boolean;
				} else if (key == "rowsRequested") {
					rowsRequested = parseInt(dataObject[key]);
				} else if (key == "backgroundColor") {
					backgroundColor = parseInt(dataObject[key]);
				} else if (key == "backgroundAlpha") {
					backgroundAlpha = parseFloat(dataObject[key]);
				}	
			}
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			return true;
		}
	}
}
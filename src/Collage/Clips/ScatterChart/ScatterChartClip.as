package Collage.Clips.ScatterChart
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	
	public class ScatterChartClip extends Clip
	{		
		[Savable][Bindable] public var dataSetID:String = null;
		[Savable][Bindable] public var xAxisDataColumn:String = null;
		[Savable][Bindable] public var yAxisDataColumn:String = null; 

		[Savable][Bindable] public var Data:Array = new Array();

		public var dataLoaded:Boolean = false;
		[Savable]public var rowsRequested:Number = 10;

		[Savable][Bindable] public var backgroundColor:Number = 0xFFFFEE;
		[Savable][Bindable] public var backgroundAlpha:Number = 1.0;
                              
		private var _DataQuery:DataQuery = null;
	
		public function ScatterChartClip(dataObject:Object = null)
		{
			super(dataObject);
			type = "scatterchart";
			CreateView(new ScatterChartClipView());
			CreateEditor(new ScatterChartClipEditor());
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
				
			for (var rowKey:uint = 0; rowKey < rows.length; rowKey++)
			{
				if (!rows[rowKey][xAxisDataColumn] is Number || !rows[rowKey][yAxisDataColumn] is Number) {
					Alert.show("NAN!!!");
					break;
				}
				
				var newObject:Object = new Object();
				
				newObject["x"] = rows[rowKey][xAxisDataColumn];
				newObject["y"] = rows[rowKey][yAxisDataColumn];
				
				Data.push(newObject);
			}
			
			Data.sortOn("x", Array.NUMERIC);
			dataLoaded = true;

			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			_DataQuery = null;
		}
	}
}
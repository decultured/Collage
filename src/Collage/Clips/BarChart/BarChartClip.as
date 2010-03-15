package Collage.Clips.BarChart
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	
	public class BarChartClip extends Clip
	{		
		[Bindable][Savable] public var dataSetID:String = null;
		[Bindable][Savable] public var labelColumn:String = null;
		[Bindable][Savable] public var dataColumn:String = null; 
		[Bindable][Savable] public var dataModifier:String = null; 
		
		[Bindable][Savable] public var Data:Array = new Array();
		[Savable]public var dataLoaded:Boolean = false;
		[Savable]public var rowsRequested:Number = 10;

		[Bindable][Savable] public var backgroundAlpha:Number = 1.0;
		[Bindable][Savable] public var backgroundColor:Number = 0xFFFFFF;
		
		private var _DataQuery:DataQuery = null;
	
		public function BarChartClip(dataObject:Object = null)
		{
			super(dataObject);
			type="barchart";
			CreateView(new BarChartClipView());
			CreateEditor(new BarChartClipEditor());
		}

		public function RunQuery():void
		{
			if (dataSetID && dataColumn && labelColumn && dataModifier) {
				_DataQuery = new DataQuery();
				_DataQuery.dataset = dataSetID;
				_DataQuery.AddField(labelColumn, null, null, "val");
				_DataQuery.AddField(dataColumn, "desc", dataModifier);
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
			if (!_DataQuery || !_DataQuery.result || !_DataQuery.result.rows is Array)
				return;

			var newData:Array = new Array();
			var rows:Array = _DataQuery.result.rows;
			
			for (var rowKey:uint = 0; rowKey < rows.length; rowKey++)
			{
				if (!rows[rowKey][dataColumn] is Number) {
					Alert.show("NAN!!!");
					break;
				}
				
				var newObject:Object = new Object();
				newObject["label"] = rows[rowKey][labelColumn];
				newObject["value"] = rows[rowKey][dataColumn];
				
				newData.push(newObject);
			}

			newData.sortOn("label", Array.NUMERIC);
			Data = newData;
			dataLoaded = true;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			_DataQuery = null;
		}
	}
}
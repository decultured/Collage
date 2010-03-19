package Collage.Clips.PieChart
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	
	public class PieChartClip extends Clip
	{		
		[Savable][Bindable] public var dataSetID:String = null;
		[Savable][Bindable] public var labelColumn:String = null;
		[Savable][Bindable] public var dataColumn:String = null; 
		[Savable][Bindable] public var dataModifier:String = null; 
		[Savable][Bindable] public var isLineChart:Boolean = true; 

		[Savable][Bindable] public var Data:Array = new Array();
		[Savable]public var rowsRequested:Number = 10;
		public var dataLoaded:Boolean = false;

		[Savable][Bindable] public var backgroundAlpha:Number = 1.0;
		[Savable][Bindable] public var backgroundColor:Number = 0xFFFFFF;

		[Savable][Bindable] public var borderColor:Number = 0x000000;
		[Savable][Bindable] public var borderAlpha:Number = 0.5;
		[Savable][Bindable] public var borderWeight:Number = 2;
		
		[Savable][Bindable] public var radialColor:Number = 0x000000;
		[Savable][Bindable] public var radialAlpha:Number = 0.5;
		[Savable][Bindable] public var radialWeight:Number = 2;
		
		[Savable][Bindable] public var calloutColor:Number = 0x000000;
		[Savable][Bindable] public var calloutAlpha:Number = 0.5;
		[Savable][Bindable] public var calloutWeight:Number = 2;
		
		[Savable][Bindable] public var labelPosition:String = "callout";
		[Savable][Bindable] public var labelColor:Number = 0x333333;
		[Savable][Bindable] public var labelSize:Number = 10;
		[Savable][Bindable] public var innerRadius:Number = 0;
		[Savable][Bindable] public var explodeRadius:Number = 0;
		
		private var _DataQuery:DataQuery = null;
	
		public function PieChartClip(dataObject:Object = null)
		{
			super(dataObject);
			type = "piechart";
			CreateView(new PieChartClipView());
			CreateEditor(new PieChartClipEditor());
		}

		public function RunQuery():void
		{
			if (dataSetID && dataColumn && labelColumn && dataModifier) {
				_DataQuery = new DataQuery();
				_DataQuery.dataset = dataSetID;
				_DataQuery.AddField(labelColumn, null, null, "val");
				_DataQuery.AddField(dataColumn, "desc", dataModifier);
				_DataQuery.limit = 10;
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

			newData.sortOn("x", Array.NUMERIC);
			Data = newData;
			dataLoaded = true;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			_DataQuery = null;
		}
	}
}
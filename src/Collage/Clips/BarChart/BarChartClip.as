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
		
		[Bindable][Savable] public var barAlpha:Number = 1.0;
		[Bindable][Savable] public var barColor:Number = 0x00AA00;
		
		// Grid Options
		[Bindable][Savable] public var gridVisible:Boolean = true;
		[Bindable][Savable] public var gridDirection:String = "horizontal";
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
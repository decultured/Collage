package Collage.Clips.Guage
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	import Collage.Clip.*;
	
	public class GuageClip extends Clip
	{
		public var dataLoaded:Boolean = false;

		[Savable][Bindable] public var dataSetID:String = null;
		[Savable][Bindable] public var dataSetColumn:String = null;
		[Savable][Bindable] public var dataSetColumnModifier:String = null;

		[Savable][Bindable] public var value:Number = 75;
		[Savable][Bindable] public var minimum:Number = 0;
		[Savable][Bindable] public var maximum:Number = 100;
		[Savable][Bindable] public var backgroundColor:Number = 0x327bc2;
		[Savable][Bindable] public var bezelColor:Number = 0xAAAAAA;
		[Savable][Bindable] public var measureMarksColor:Number = 0xFFFFFF;
		[Savable][Bindable] public var measureMarksAlpha:Number = 1;
		[Savable][Bindable] public var startAngle:Number = 45;
		[Savable][Bindable] public var endAngle:Number = 315;
		[Savable][Bindable] public var indicatorColor:Number = 0xFC5976;
		[Savable][Bindable] public var indicatorCrownColor:Number = 0xAAAAAA;
		
		private var _DataQuery:DataQuery = null;

		public function GuageClip(dataObject:Object = null)
		{
			super(dataObject);
			type = "guage";
			CreateView(new GuageClipView());
			CreateEditor(new GuageClipEditor());
		}
		
		public function RunQuery():void
		{
			var dataset:DataSet = DataEngine.GetDataSetByID(dataSetID);
			
			if (!dataset)
				return;
				
			_DataQuery = new DataQuery();
			_DataQuery.dataset = dataSetID;
			_DataQuery.AddField(dataSetColumn, null, dataSetColumnModifier);
			_DataQuery.AddField(dataSetColumn, null, "max", null, "Max");
			_DataQuery.AddField(dataSetColumn, null, "min", null, "Min");
			_DataQuery.limit = 1;
			_DataQuery.LoadQueryResults();
			_DataQuery.addEventListener(DataQuery.COMPLETE, QueryFinished);
		}
		
		public function ResetData():void
		{
			dataLoaded = false;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
		}

		private function QueryFinished(event:Event):void
		{
			if (!_DataQuery || !_DataQuery.result || !_DataQuery.result.rows is Array || _DataQuery.result.rows.length < 1)
				return;

			
			if (_DataQuery.result.rows[0][dataSetColumn] is Number)
				value = _DataQuery.result.rows[0][dataSetColumn];
			if (_DataQuery.result.rows[0]["Min"] is Number)
				minimum = _DataQuery.result.rows[0]["Min"];
			if (_DataQuery.result.rows[0]["Max"] is Number)
				maximum = _DataQuery.result.rows[0]["Max"];
			
			dataLoaded = true;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			_DataQuery = null;
		}
	}
}
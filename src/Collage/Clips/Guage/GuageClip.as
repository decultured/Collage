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

		[Bindable] public var dataSetID:String = null;
		[Bindable] public var dataSetColumn:String = null;
		[Bindable] public var dataSetColumnModifier:String = null;

		[Bindable]public var value:Number = 75;
		[Bindable]public var minimum:Number = 0;
		[Bindable]public var maximum:Number = 100;
		[Bindable]public var backgroundColor:Number = 0x327bc2;
		[Bindable]public var bezelColor:Number = 0xAAAAAA;
		[Bindable]public var measureMarksColor:Number = 0xFFFFFF;
		[Bindable]public var measureMarksAlpha:Number = 1;
		[Bindable]public var startAngle:Number = 45;
		[Bindable]public var endAngle:Number = 315;
		[Bindable]public var indicatorColor:Number = 0xFC5976;
		[Bindable]public var indicatorCrownColor:Number = 0xAAAAAA;
		
		private var _DataQuery:DataQuery = null;

		public function GuageClip(dataObject:Object = null)
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
				_View = new GuageClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new GuageClipEditor();
				_Editor.model = this;
			}
		}
		
		public function RunQuery():void
		{
			var dataset:DataSet = DataEngine.GetDataSetByID(dataSetID);
			
			if (!dataset)
				return;
				
			_DataQuery = new DataQuery();
			_DataQuery.dataset = dataSetID;
			_DataQuery.AddField(dataSetColumn);//, null, dataSetColumnModifier);
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

			if (!_DataQuery.result.rows[0][dataSetColumn] is Number)
				return;
			
			value = _DataQuery.result.rows[0][dataSetColumn];
			
			dataLoaded = true;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			_DataQuery = null;
		}
	
		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "guage";
			newObject["value"] = value;
			newObject["minimum"] = minimum;
			newObject["maximum"] = maximum;
			newObject["backgroundColor"] = backgroundColor;
			newObject["bezelColor"] = bezelColor;
			newObject["measureMarksColor"] = measureMarksColor;
			newObject["measureMarksAlpha"] = measureMarksAlpha;
			newObject["startAngle"] = startAngle;
			newObject["endAngle"] = endAngle;
			newObject["indicatorColor"] = indicatorColor;
			newObject["indicatorCrownColor"] = indicatorCrownColor;

			return newObject;
		}
	}
}
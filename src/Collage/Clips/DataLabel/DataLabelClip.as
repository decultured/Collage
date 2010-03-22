package Collage.Clips.DataLabel
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	import Collage.Clip.*;
	
	public class DataLabelClip extends Clip
	{
		public var dataLoaded:Boolean = false;

		[Bindable] public var dataSetID:String = null;
		[Bindable] public var dataSetColumn:String = null;
		[Bindable] public var dataSetColumnModifier:String = null;

		[Bindable] public var text:String = "No Data";
		[Bindable] public var color:Number = 0x000000;
		[Bindable] public var backgroundAlpha:Number = 1.0;
		[Bindable] public var backgroundColor:Number = 0xFFFFFF;

		[Bindable] public var textWidth:Number = 200;
		[Bindable] public var textHeight:Number = 24;
		[Bindable] public var fontSize:Number = 18;

		private var _DataQuery:DataQuery = null;

		public function DataLabelClip(dataObject:Object = null)
		{
			super(dataObject);
			rotatable = false;
			CreateView(new DataLabelClipView());
			CreateEditor(new DataLabelClipEditor());
			height = 15;
			width = 40;
		}

		public override function Resized():void
		{
			if (width < textWidth)
				width = textWidth;
			if (height < textHeight)
				height = textHeight;
		}
		
		public function RunQuery():void
		{
			var dataset:DataSet = DataEngine.GetDataSetByID(dataSetID);
			
			if (!dataset)
				return;
				
			_DataQuery = new DataQuery();
			_DataQuery.dataset = dataSetID;
			_DataQuery.AddField(dataSetColumn, null, dataSetColumnModifier);
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
			
			text = _DataQuery.result.rows[0][dataSetColumn];
			
			dataLoaded = true;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			_DataQuery = null;
		}
		
		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "datalabel";
			newObject["dataSetID"] = dataSetID;
			newObject["dataSetColumn"] = dataSetColumn;
			newObject["dataSetColumnModifier"] = dataSetColumnModifier;
			newObject["text"] = text;
			newObject["color"] = color;
			newObject["backgroundAlpha"] = backgroundAlpha;
			newObject["backgroundColor"] = backgroundColor;
			newObject["textWidth"] = textWidth;
			newObject["textHeight"] = textHeight;
			newObject["fontSize"] = fontSize;

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
				} else if (key == "dataSetColumn") {
					dataSetColumn = dataObject[key];
				} else if (key == "dataSetColumnModifier") {
					dataSetColumnModifier = dataObject[key];
				} else if (key == "text") {
					text = dataObject[key];
				} else if (key == "dataLoaded") {
					dataLoaded = dataObject[key] as Boolean;
				} else if (key == "color") {
					color = parseInt(dataObject[key]);
				} else if (key == "backgroundColor") {
					backgroundColor = parseInt(dataObject[key]);
				} else if (key == "backgroundAlpha") {
					backgroundAlpha = parseInt(dataObject[key]);
				} else if (key == "textWidth") {
					textWidth = parseInt(dataObject[key]);
				} else if (key == "textHeight") {
					textHeight = parseInt(dataObject[key]);
				} else if (key == "fontSize") {
					fontSize = parseFloat(dataObject[key]);
				}
			}
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			return true;
		}
	}
}
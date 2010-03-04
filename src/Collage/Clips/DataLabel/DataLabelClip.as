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
			verticalSizable = false;
			horizontalSizable = false;
			rotatable = false;
			super(dataObject);
			CreateView();
			CreateEditor();
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new DataLabelClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new DataLabelClipEditor();
				_Editor.model = this;
			}
		}
		
		public override function Resized():void
		{
			width = textWidth;
			height = textHeight;
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
	}
}
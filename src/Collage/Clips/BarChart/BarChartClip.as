package Collage.Clips.BarChart
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	
	public class BarChartClip extends Clip
	{		
		[Bindable] public var dataSetID:String = null;
		[Bindable] public var labelColumn:String = null;
		[Bindable] public var dataColumn:String = null; 
		[Bindable] public var dataModifier:String = null; 
		
		public var Data:Array = new Array();
		public var dataLoaded:Boolean = false;
		public var rowsRequested:Number = 10;

		[Bindable] public var backgroundAlpha:Number = 1.0;
		[Bindable] public var backgroundColor:Number = 0xFFFFFF;
		
		private var _DataQuery:DataQuery = null;
	
		public function BarChartClip(dataObject:Object = null)
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
				_View = new BarChartClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new BarChartClipEditor();
				_Editor.model = this;
			}
		}

		public override function Resized():void
		{
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

			Data = new Array();
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
				
				Data.push(newObject);
			}

			Data.sortOn("x", Array.NUMERIC);
			dataLoaded = true;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			_DataQuery = null;
		}

		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "barchart";
			newObject["dataSetID"] = dataSetID;
			newObject["labelColumn"] = labelColumn;
			newObject["dataColumn"] = dataColumn;
			newObject["dataModifier"] = dataModifier;
			newObject["Data"] = Data;
			newObject["rowsRequested"] = rowsRequested;
			newObject["dataLoaded"] = dataLoaded;
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
				} else if (key == "labelColumn") {
					labelColumn = dataObject[key];
				} else if (key == "dataColumn") {
					dataColumn = dataObject[key];
				} else if (key == "dataModifier") {
					dataModifier = dataObject[key];
				} else if (key == "Data" && dataObject[key] is Array) {
					Data = dataObject[key];
				} else if (key == "dataLoaded") {
					dataLoaded = dataObject[key];
				} else if (key == "rowsRequested") {
					rowsRequested = parseInt(dataObject[key]);
				} else if (key == "backgroundColor") {
					backgroundColor = parseInt(dataObject[key]);
				} else if (key == "backgroundAlpha") {
					backgroundAlpha = parseInt(dataObject[key]);
				}	
			}
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			return true;
		}
	}
}
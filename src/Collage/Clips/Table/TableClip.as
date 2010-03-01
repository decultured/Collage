package Collage.Clips.Table
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	import mx.collections.*;
	import mx.controls.dataGridClasses.*;	

	public class TableClip extends Clip
	{
		[Bindable] public var dataSetID:String = null;
		[Bindable] public var backgroundAlpha:Number = 1.0;
		[Bindable] public var backgroundColor:Number = 0xFFFFFF;

		public var dataLoaded:Boolean = false;

		public var columns:Array = new Array();
		public var data:Array = new Array();

		private var _DataQuery:DataQuery = null;

		public function TableClip()
		{
			rotatable = false;
			super();
			CreateView();
			CreateEditor();
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new TableClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new TableClipEditor();
				_Editor.model = this;
			}
		}
		
		public override function Resized():void
		{
		}
		
		public function RunQuery():void
		{
			var dataset:DataSet = DataEngine.GetDataSetByID(dataSetID);
			
			if (!dataset)
				return;
				
			_DataQuery = new DataQuery();
			_DataQuery.dataset = dataSetID;

			columns = new Array();
			for (var key:String in dataset.columns) {
				var newColumn:DataGridColumn = new DataGridColumn();
				newColumn.dataField = dataset.columns[key]["label"];
				newColumn.headerText = dataset.columns[key]["label"];
				_DataQuery.AddField(dataset.columns[key]["label"]);
				columns.push(newColumn);
			}
				
			_DataQuery.limit = 50;
			_DataQuery.LoadQueryResults();
			_DataQuery.addEventListener(DataQuery.COMPLETE, QueryFinished);
		}
		
		public function ResetData():void
		{
			dataLoaded = false;
			data = new Array();
			columns = new Array();
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
		}

		private function QueryFinished(event:Event):void
		{
			if (!_DataQuery || !_DataQuery.result || !_DataQuery.result.rows is Array)
				return;

			data = new Array();
			var rows:Array = _DataQuery.result.rows;
			for (var rowKey:uint = 0; rowKey < rows.length; rowKey++)
			{
				var newObject:Object = new Object();

				for (var fieldKey:String in rows[rowKey])
				{
					newObject[fieldKey] = rows[rowKey][fieldKey];
				}
				
				data.push(newObject);
			}
			
			dataLoaded = true;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			_DataQuery = null;
		}
		
		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "table";
			newObject["dataSetID"] = dataSetID;
			newObject["backgroundAlpha"] = backgroundAlpha;
			newObject["backgroundColor"] = backgroundColor;
			newObject["dataLoaded"] = dataLoaded;

			if (columns) {
				newObject["columns"] = new Array();
				for (var i:uint = 0; i < columns.length; i++) {
					var newColumn:DataGridColumn = columns[i] as DataGridColumn;
					newObject["columns"][i] = new Object();
					newObject["columns"][i]["dataField"] = newColumn.dataField;
					newObject["columns"][i]["headerText"] = newColumn.headerText;
				}
			}
			newObject["data"] = data;

			return newObject;
		}
		
	}
}
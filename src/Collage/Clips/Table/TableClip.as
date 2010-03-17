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
		public static var QUERY_FINISHED:String = "Query Finished";
		
		[Savable][Bindable] public var dataSetID:String = null;
		[Savable][Bindable] public var backgroundAlpha:Number = 1.0;
		[Savable][Bindable] public var backgroundColor:Number = 0xFFFFFF;
		[Savable][Bindable] public var color:Number = 0x000000;

		public var dataLoaded:Boolean = false;

		public var columns:Array = new Array();
		[Savable]public var data:Array = new Array();
		[Savable]public var rowsRequested:Number = 10;

		private var _DataQuery:DataQuery = null;

		public function TableClip(dataObject:Object = null)
		{
			super(dataObject);
			rotatable = false;
			moveFromCenter = true;
			type = "table";
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
			var Count:uint = 0;
			for (var key:String in dataset.columns) {
				var newColumn:DataGridColumn = new DataGridColumn();
				newColumn.dataField = dataset.columns[key]["label"];
				newColumn.headerText = dataset.columns[key]["label"];
				(Count < 5) ? newColumn.visible = true : newColumn.visible = false;
				_DataQuery.AddField(dataset.columns[key]["label"]);
				columns.push(newColumn);
				Count++;
			}
				
			_DataQuery.limit = rowsRequested;
			_DataQuery.LoadQueryResults();
			_DataQuery.addEventListener(DataQuery.COMPLETE, QueryFinished);
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
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

			var dataset:DataSet = DataEngine.GetDataSetByID(dataSetID);
			
			if (!dataset)
				return;

			data = new Array();
			var rows:Array = _DataQuery.result.rows;
			for (var rowKey:uint = 0; rowKey < rows.length; rowKey++)
			{
				var newObject:Object = new Object();

				for (var fieldKey:String in rows[rowKey])
				{
					var dataColumn:DataSetColumn = dataset.GetColumnByLabel(fieldKey);
					if (dataColumn && dataColumn.datatype == "datetime" && rows[rowKey][fieldKey] is Number) {
						var now:Date = new Date();
						now.setTime(rows[rowKey][fieldKey]);
						newObject[fieldKey] = now.toLocaleString();
					} else {
						newObject[fieldKey] = rows[rowKey][fieldKey];
					}					
				}
				
				data.push(newObject);
			}
			
			dataLoaded = true;
			dispatchEvent(new Event(QUERY_FINISHED));
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			_DataQuery = null;
		}
		
		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			if (columns) {
				newObject["columns"] = new Array();
				for (var i:uint = 0; i < columns.length; i++) {
					var newColumn:DataGridColumn = columns[i] as DataGridColumn;
					newObject["columns"][i] = new Object();
					newObject["columns"][i]["dataField"] = newColumn.dataField;
					newObject["columns"][i]["headerText"] = newColumn.headerText;
					newObject["columns"][i]["visible"] = newColumn.visible;
				}
			}

			return newObject;
		}
		
		public override function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject)
				return false;
			super.LoadFromObject(dataObject);
			columns = new Array();
			for (var key:String in dataObject)
			{
				if (key == "columns" && dataObject[key] is Array) {
					columns = new Array();
					var colArray:Array = dataObject[key];
					for (var i:uint = 0; i < colArray.length; i++) {
						var newColumn:DataGridColumn = new DataGridColumn();
						newColumn.dataField = colArray[i]["dataField"];
						newColumn.headerText = colArray[i]["headerText"];
						newColumn.visible = colArray[i]["visible"];
						columns.push(newColumn);
					}
				}
			}
			dispatchEvent(new Event(QUERY_FINISHED));
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			return true;
		}
	}
}
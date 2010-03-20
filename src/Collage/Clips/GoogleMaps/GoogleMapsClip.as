package Collage.Clips.GoogleMaps
{
	import Collage.Logger.*;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	
	public class GoogleMapsClip extends Clip
	{
		[Bindable][Savable] public var dataSetID:String = null;
		[Bindable][Savable] public var latDataColumn:String = null;
		[Bindable][Savable] public var longDataColumn:String = null; 
		[Bindable][Savable] public var markers:Array = new Array();
		
		[Savable] public var dataLoaded:Boolean = false;
		[Savable] public var rowsRequested:Number = 10;
		
		[Bindable][Savable] public var markerColor:Number = 0x223344;
		[Bindable][Savable] public var markerStrokeColor:Number = 0x987654;
		[Bindable][Savable] public var markerShadows:Boolean = true;
		[Bindable][Savable] public var markerRadius:Number = 10;

		[Bindable][Savable] public var mapType:String = "normal";

		[Bindable][Savable] public var draggable:Boolean = true;
		[Bindable][Savable] public var zoomable:Boolean = true;
		
		[Bindable][Savable] public var positionControl:Boolean = true;
		[Bindable][Savable] public var zoomControl:Boolean = true;
		[Bindable][Savable] public var mapTypeControl:Boolean = true;
		[Bindable][Savable] public var scaleControl:Boolean = false;
		[Bindable][Savable] public var overviewMapControl:Boolean = false;
		
		private var _DataQuery:DataQuery = null;
		
		public function GoogleMapsClip(dataObject:Object = null)
		{
			super(dataObject);
			moveFromCenter = true;
			type = "googlemaps";
			CreateView(new GoogleMapsClipView());
			CreateEditor(new GoogleMapsClipEditor());
		}

		public function RunQuery():void
		{
			if (dataSetID && longDataColumn && latDataColumn) {
				_DataQuery = new DataQuery();
				_DataQuery.dataset = dataSetID;
				_DataQuery.AddField(latDataColumn);
				_DataQuery.AddField(longDataColumn);
				_DataQuery.limit = rowsRequested;
				_DataQuery.LoadQueryResults();
				_DataQuery.addEventListener(DataQuery.COMPLETE, QueryFinished);
			}
		}
		
		public function ResetData():void
		{
			markers = new Array();
			dataLoaded = false;
			
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
		}

		private function QueryFinished(event:Event):void
		{
			var dataset:DataSet = DataEngine.GetDataSetByID(dataSetID);
			if (!dataset || !_DataQuery || !_DataQuery.result || !_DataQuery.result.rows is Array)
				return;

			var newData:Array = new Array();
			var rows:Array = _DataQuery.result.rows;
			
			if (!rows[0])
				return;
				
			for (var rowKey:uint = 0; rowKey < rows.length; rowKey++)
			{
				if (!rows[rowKey][latDataColumn] is Number || !rows[rowKey][longDataColumn] is Number) {
					Logger.Log("Non-number row found for chart.", LogEntry.WARNING, this);
					continue;
				}
				
				var newObject:Object = new Object();
				
				newObject["latitude"] = rows[rowKey][latDataColumn];
				newObject["longitude"] = rows[rowKey][longDataColumn];
								
				newData.push(newObject);
			}
			
			dataLoaded = true;
			markers = newData;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			_DataQuery = null;
		}
	}
}
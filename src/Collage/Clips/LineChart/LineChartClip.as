package Collage.Clips.LineChart
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.*;
	import Collage.DataEngine.*;
	import com.adobe.serialization.json.JSON;
	
	public class LineChartClip extends Clip
	{		
		[Bindable] public var dataSetID:String = null;
		[Bindable] public var xAxisDataColumn:String = null;
		[Bindable] public var yAxisDataColumn:String = null; 
		
		public var Data:Array = new Array();
		
		public var dataLoaded:Boolean = false;
		public var xAxisMin:Number = 0;
		public var xAxisMax:Number = 10;
		public var yAxisMin:Number = 0;
		public var yAxisMax:Number = 10;
		
		public var xAxisGridLineCount:Number = 10;
		public var xAxisGridLabelCount:Number = 10;
		public var yAxisGridLineCount:Number = 10;
		public var yAxisGridLabelCount:Number = 10;
		
		[Bindable] public var ChartStyle:String = "solid-dot";
		
		[Bindable] public var lineColor:Number = 0x0000FF;
		[Bindable] public var lineWidth:Number = 2;
		[Bindable] public var dotSize:Number = 2;

		[Bindable] public var backgroundColor:Number = 0xFFFFEE;
                              
		[Bindable] public var showTitleText:Boolean = false;
		[Bindable] public var titleTextFontSize:Number = 16;
		[Bindable] public var titleText:String = "";
		[Bindable] public var titleTextColor:Number = 0xFF0000;
                              
		[Bindable] public var showYAxisText:Boolean = false;
		[Bindable] public var yAxisTextFontSize:Number = 16;
		[Bindable] public var yAxisText:String = "";
		[Bindable] public var yAxisTextColor:Number = 0xFF0000;

		[Bindable] public var showXAxisText:Boolean = false;
		[Bindable] public var xAxisTextFontSize:Number = 16;
		[Bindable] public var xAxisText:String = "";
		[Bindable] public var xAxisTextColor:Number = 0xFF0000;

		[Bindable] public var xAxisColor:Number = 0xFFCC00;
		[Bindable] public var yAxisColor:Number = 0xFFCC00;
		[Bindable] public var xAxisGridColor:Number = 0xFFEEAA;
		[Bindable] public var yAxisGridColor:Number = 0xFFEEAA;

		private var _DataQuery:DataQuery = null;
	
		public function LineChartClip()
		{
			super();
			CreateView();
			CreateEditor();
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new LineChartClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new LineChartClipEditor();
				_Editor.model = this;
			}
		}
		
		public override function Resized():void
		{
			
		}
		
		public function RunQuery():void
		{
			if (dataSetID && yAxisDataColumn && xAxisDataColumn) {
				_DataQuery = new DataQuery();
				_DataQuery.dataset = dataSetID;
				_DataQuery.AddField(xAxisDataColumn, "desc");
				_DataQuery.AddField(yAxisDataColumn);
				_DataQuery.limit = 50;
				_DataQuery.LoadQueryResults();
				_DataQuery.addEventListener(DataQuery.COMPLETE, QueryFinished);
			}
		}
		
		public function ResetData():void
		{
			Data = new Array();
			dataLoaded = false;
		    xAxisMin = 0;
		    xAxisMax = 10;
		    yAxisMin = 0;
		    yAxisMax = 10;
           
		    xAxisGridLineCount= 10;
		    xAxisGridLabelCount = 10;
		    yAxisGridLineCount = 10;
		    yAxisGridLabelCount = 10;
		   
		    showTitleText = false;
		    titleText = "";
		    showYAxisText = false;
		    yAxisText = "";
		    showXAxisText = false;
		    yAxisText = "";
			
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
		}

		private function QueryFinished(event:Event):void
		{
			if (!_DataQuery || !_DataQuery.result || !_DataQuery.result.rows is Array)
				return;

			Data = new Array();
			var rows:Array = _DataQuery.result.rows;
			
			//Alert.show("Rows: " + rows.length);
			if (rows.length < 3) {
				Alert.show("Not enough data for chart!");
				return;
			}
			
			for (var rowKey:uint = 0; rowKey < rows.length; rowKey++)
			{
				if (rows[rowKey][xAxisDataColumn] && rows[rowKey][yAxisDataColumn]) {
					if (!rows[rowKey][xAxisDataColumn] is Number || !rows[rowKey][yAxisDataColumn] is Number) {
						Alert.show("NAN!!!");
						break;
					}
					
					var newObject:Object = new Object();
					newObject["x"] = rows[rowKey][xAxisDataColumn];
					newObject["y"] = rows[rowKey][yAxisDataColumn];
					
					if (rowKey == 0) {
						xAxisMin = rows[rowKey][xAxisDataColumn];
						xAxisMax = rows[rowKey][xAxisDataColumn];
						yAxisMin = rows[rowKey][yAxisDataColumn];
						yAxisMax = rows[rowKey][yAxisDataColumn];
					} else {                                        
						if (xAxisMin > rows[rowKey][xAxisDataColumn])
							xAxisMin = rows[rowKey][xAxisDataColumn];
						if (xAxisMax < rows[rowKey][xAxisDataColumn])
							xAxisMax = rows[rowKey][xAxisDataColumn];
						if (yAxisMin > rows[rowKey][yAxisDataColumn])
							yAxisMin = rows[rowKey][yAxisDataColumn];
						if (yAxisMax < rows[rowKey][yAxisDataColumn])
							yAxisMax = rows[rowKey][yAxisDataColumn];
					}
					
					Data.push(newObject);
				}
			}
			
			if (xAxisMin >= xAxisMax) {
				Alert.show("No variance on X Axis, please choose other data");
				ResetData();
			} if (yAxisMin >= yAxisMax) {
				Alert.show("No variance on Y Axis, please choose other data");
				ResetData();
			} else {
				var yPadding:Number = (yAxisMax - yAxisMin) / 10;
				yAxisMax += yPadding;
				yAxisMin -= yPadding;
				Data.sortOn("x", Array.NUMERIC);
				dataLoaded = true;
			}
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
			
			Alert.show("Query Run!" + BuildChartJSONString());
			_DataQuery = null;
		}
		
		public function BuildChartJSONString():String
		{
			var dataObj:Object = new Object();
			
			dataObj["bg_colour"] = "#" + backgroundColor.toString(16);

			dataObj["x_axis"] = new Object();
			dataObj["x_axis"]["grid-colour"] = "#" + xAxisGridColor.toString(16);
			dataObj["x_axis"]["colour"] = "#" + xAxisColor.toString(16);
			dataObj["x_axis"]["min"] = xAxisMin;
			dataObj["x_axis"]["max"] = xAxisMax;
			dataObj["x_axis"]["tick-height"] = 0;

			if (xAxisGridLineCount > 0)
				dataObj["x_axis"]["steps"] = int((xAxisMax - xAxisMin) / xAxisGridLineCount);

			dataObj["x_axis"]["labels"] = new Object();
			dataObj["x_axis"]["labels"]["visible-steps"] = 0;

			dataObj["y_axis"] = new Object();
			dataObj["y_axis"]["grid-colour"] = "#" + yAxisGridColor.toString(16);
			dataObj["y_axis"]["colour"] = "#" + yAxisColor.toString(16);
			dataObj["y_axis"]["min"] = yAxisMin;
			dataObj["y_axis"]["max"] = yAxisMax;
			dataObj["y_axis"]["tick-length"] = 0;
			
			if (yAxisGridLineCount > 0)
				dataObj["y_axis"]["steps"] = (yAxisMax - yAxisMin) / yAxisGridLineCount;

			dataObj["y_axis"]["labels"] =  new Object();
			dataObj["y_axis"]["labels"]["labels"] = new Array();
			dataObj["y_axis"]["labels"]["steps"] = 0;
			
			if (showTitleText && titleText && titleText.length > 0) {
				dataObj["title"] = new Object();
				dataObj["title"]["text"] = titleText;

				dataObj["title"]["style"] = "{font-size:" + titleTextFontSize + "px; color:#" + titleTextColor.toString(16) + ";}";
				//font-family: Verdana; text-align: center;
			}
			if (showYAxisText && yAxisText && yAxisText.length > 0) {
				dataObj["y_legend"] = new Object();
				dataObj["y_legend"]["text"] = yAxisText;

				dataObj["y_legend"]["style"] = "{font-size:" + yAxisTextFontSize + "px; color:#" + yAxisTextColor.toString(16) + ";}";
			}
			if (showXAxisText && xAxisText && xAxisText.length > 0) {
				dataObj["x_legend"] = new Object();
				dataObj["x_legend"]["text"] = xAxisText;

				dataObj["x_legend"]["style"] = "{font-size:" + xAxisTextFontSize + "px; color:#" + xAxisTextColor.toString(16) + ";}";
			}
			
			dataObj["elements"] = new Array();
			dataObj["elements"][0] = new Object();
			dataObj["elements"][0]["type"] = "scatter_line";
			dataObj["elements"][0]["colour"] = "#" + lineColor.toString(16);
			dataObj["elements"][0]["width"] = lineWidth;
			dataObj["elements"][0]["dot-style"] = new Object();
			dataObj["elements"][0]["dot-style"]["type"] = ChartStyle;
			dataObj["elements"][0]["dot-style"]["dot-size"] = dotSize;
			dataObj["elements"][0]["dot-style"]["halo-size"] = 0;
			dataObj["elements"][0]["dot-style"]["tip"] = "X: #x#<br>Y: #y#";
			if (Data && Data.length > 2)
				dataObj["elements"][0]["values"] = Data;

			return JSON.encode(dataObj);
		}

		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "linechart";
			newObject["dataSetID"] = dataSetID;
			newObject["xAxisDataColumn"] = xAxisDataColumn;
			newObject["yAxisDataColumn"] = yAxisDataColumn;
			newObject["Data"] = Data;
			newObject["dataLoaded"] = dataLoaded;
			newObject["xAxisMin"] = xAxisMin;
			newObject["xAxisMax"] = xAxisMax;
			newObject["yAxisMin"] = yAxisMin;
			newObject["yAxisMax"] = yAxisMax;
			newObject["xAxisGridLineCount"] = xAxisGridLineCount;
			newObject["xAxisGridLabelCount"] = xAxisGridLabelCount;
			newObject["yAxisGridLineCount"] = yAxisGridLineCount;
			newObject["yAxisGridLabelCount"] = yAxisGridLabelCount;
			newObject["ChartStyle"] = ChartStyle;
			newObject["lineColor"] = lineColor;
			newObject["lineWidth"] = lineWidth;
			newObject["dotSize"] = dotSize;
			newObject["backgroundColor"] = backgroundColor;
			newObject["showTitleText"] = showTitleText;
			newObject["titleTextFontSize"] = titleTextFontSize;
			newObject["titleText"] = titleText;
			newObject["titleTextColor"] = titleTextColor;
			newObject["showYAxisText"] = showYAxisText;
			newObject["yAxisTextFontSize"] = yAxisTextFontSize;
			newObject["yAxisText"] = yAxisText;
			newObject["yAxisTextColor"] = yAxisTextColor;
			newObject["showXAxisText"] = showXAxisText;
			newObject["xAxisTextFontSize"] = xAxisTextFontSize;
			newObject["xAxisText"] = xAxisText;
			newObject["xAxisTextColor"] = xAxisTextColor;
			newObject["xAxisColor"] = xAxisColor;
			newObject["yAxisColor"] = yAxisColor;
			newObject["xAxisGridColor"] = xAxisGridColor;
			newObject["yAxisGridColor"] = yAxisGridColor;

			return newObject;
		}

	}
}
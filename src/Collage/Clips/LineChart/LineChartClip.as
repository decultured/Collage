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
		
		[Bindable] public var Data:Array = new Array();
		
		[Bindable] public var xAxisMin:Number = 0;
		[Bindable] public var xAxisMax:Number = 10;
		[Bindable] public var yAxisMin:Number = 0;
		[Bindable] public var yAxisMax:Number = 10;
		
		[Bindable] public var ChartStyle:String = "scatter_line";
		
		[Bindable] public var lineColor:Number = 0x0000FF;
		[Bindable] public var lineWidth:Number = 2;
		[Bindable] public var dotSize:Number = 2;

		[Bindable] public var backgroundColor:Number = 0xFFFFEE;
                              
		[Bindable] public var showTitleText:Boolean = false;
		[Bindable] public var titleTextFontSize:Number = 20;
		[Bindable] public var titleText:String = "";
		[Bindable] public var titleTextColor:Number = 0xFF0000;
                              
		[Bindable] public var showYAxisText:Boolean = false;
		[Bindable] public var yAxisTextFontSize:Number = 20;
		[Bindable] public var yAxisText:String = "";
		[Bindable] public var yAxisTextColor:Number = 0xFF0000;

		[Bindable] public var showXAxisText:Boolean = false;
		[Bindable] public var xAxisTextFontSize:Number = 20;
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
				_DataQuery.AddField(xAxisDataColumn, true);
				_DataQuery.AddField(yAxisDataColumn);
				_DataQuery.LoadQueryResults();
				_DataQuery.addEventListener(DataQuery.COMPLETE, QueryFinished);
			}
		}
		
		private function QueryFinished(event:Event):void
		{
			if (!_DataQuery || !_DataQuery.result || !_DataQuery.result.rows is Array)
				return;

			var rows:Array = _DataQuery.result.rows;
			for (var rowKey:uint = 0; rowKey < rows.length; rowKey++)
			{
				if (rows[rowKey][xAxisDataColumn] && rows[rowKey][yAxisDataColumn]) {
					var newObject:Object = new Object();
					newObject["x"] = rows[rowKey][xAxisDataColumn];
					newObject["y"] = rows[rowKey][yAxisDataColumn];
					
					if (rowKey == 0) {
						xAxisMin = parseInt(rows[rowKey][xAxisDataColumn]);
						xAxisMax = parseInt(rows[rowKey][xAxisDataColumn]);
						yAxisMin = parseInt(rows[rowKey][yAxisDataColumn]);
						yAxisMax = parseInt(rows[rowKey][yAxisDataColumn]);
					} else {
						if (xAxisMin > parseInt(rows[rowKey][xAxisDataColumn]))
							xAxisMin = parseInt(rows[rowKey][xAxisDataColumn]);
						if (xAxisMax < parseInt(rows[rowKey][xAxisDataColumn]))
							xAxisMax = parseInt(rows[rowKey][xAxisDataColumn]);
						
						if (yAxisMin > parseInt(rows[rowKey][yAxisDataColumn]))
							yAxisMin = parseInt(rows[rowKey][yAxisDataColumn]);
						if (yAxisMax < parseInt(rows[rowKey][yAxisDataColumn]))
							yAxisMax = parseInt(rows[rowKey][yAxisDataColumn]);
					}
					Data.push(newObject);
				}
			}
				
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
			
			dataObj["y_axis"] = new Object();
			dataObj["y_axis"]["grid-colour"] = "#" + yAxisGridColor.toString(16);
			dataObj["y_axis"]["colour"] = "#" + yAxisColor.toString(16);
			dataObj["y_axis"]["min"] = yAxisMin;
			dataObj["y_axis"]["max"] = yAxisMax;
			
			if (showTitleText && yAxisText && yAxisText.length > 0) {
				dataObj["title"] = new Object();
				dataObj["title"]["text"] = titleText;
				dataObj["title"]["style"] = new Object();
				dataObj["title"]["style"]["font-size"] = titleTextFontSize;
				dataObj["title"]["style"]["color"] = "#" + titleTextColor.toString(16);
				//font-family: Verdana; text-align: center;
			}
			if (showYAxisText && yAxisText && yAxisText.length > 0) {
				dataObj["y_legend"] = new Object();
				dataObj["y_legend"]["text"] = yAxisText;
				dataObj["y_legend"]["style"] = new Object();
				dataObj["y_legend"]["style"]["font-size"] = yAxisTextFontSize;
				dataObj["y_legend"]["style"]["color"] = "#" + yAxisTextColor.toString(16);
			}
			if (showXAxisText && xAxisText && xAxisText.length > 0) {
				dataObj["x_legend"] = new Object();
				dataObj["x_legend"]["text"] = xAxisText;
				dataObj["x_legend"]["style"] = new Object();
				dataObj["x_legend"]["style"]["font-size"] = xAxisTextFontSize;
				dataObj["x_legend"]["style"]["color"] = "#" + xAxisTextColor.toString(16);
			}
			
			dataObj["elements"] = new Array();
			dataObj["elements"][0] = new Object();
			dataObj["elements"][0]["type"] = ChartStyle;
			dataObj["elements"][0]["colour"] = lineColor.toString(16);
			dataObj["elements"][0]["width"] = lineWidth;
			dataObj["elements"][0]["dot-size"] = dotSize;
			dataObj["elements"][0]["values"] = Data;

			return JSON.encode(dataObj);
		}
	}
}
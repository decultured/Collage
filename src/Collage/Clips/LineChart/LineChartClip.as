package Collage.Clips.LineChart
{
	import Collage.Clip.*;
	
	public class LineChartClip extends Clip
	{		
		[Bindable] public var dataSetID:String = null;
		[Bindable] public var xAxisDataColumn:String = null;
		[Bindable] public var yAxisDataColumn:String = null; 
		
		[Bindable] public var Data:Array = new Array();
		
		[Bindable] public var ChartStyle:String = "line";
		
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
	}
}
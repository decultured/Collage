package Collage.Clips.Label
{
	import Collage.Clip.*;
	
	public class LabelClip extends Clip
	{
		[Bindable][Savable]public var text:String = "Default Text";
		[Bindable][Savable]public var color:Number = 0x000000;
		[Bindable][Savable]public var backgroundAlpha:Number = 1.0;
		[Bindable][Savable]public var backgroundColor:Number = 0xFFFFFF;

		[Bindable][Savable]public var textWidth:Number = 200;
		[Bindable][Savable]public var textHeight:Number = 24;
		[Bindable][Savable]public var fontSize:Number = 18;

		public function LabelClip(dataObject:Object = null)
		{
			super(dataObject);
			height = 15;
			width = 40;
			rotatable = false;
			type = "label";
			CreateView(new LabelClipView());
			CreateEditor(new LabelClipEditor());
		}

		public override function Resized():void
		{
			if (width < textWidth)
				width = textWidth;
			if (height < textHeight)
				height = textHeight;
		}
	}
}
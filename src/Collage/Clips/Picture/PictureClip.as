package Collage.Clips.Picture
{
	import flash.events.*;
	import Collage.Clip.*;
	
	public class PictureClip extends Clip
	{
		[Bindable] public var aspectRatio:Number = 0;
		[Bindable] public var imageLoaded:Boolean = false;
		[Bindable][Savable] public var url:String = null;
		[Bindable][Savable] public var fileId:String = null;
		
		public static const IMAGE_LOADED:String = "PictureClip_ImageLoaded";
		
		public function PictureClip(dataObject:Object = null)
		{
			super(dataObject);
			type = "image";
			CreateView(new PictureClipView());
			CreateEditor(new PictureClipEditor());
		}
		
		public override function Resized():void
		{
			if (!height || !aspectRatio)
				return;
				
			var modelRatio:Number = width / height;
		
			if (modelRatio > aspectRatio) {
				width = height * aspectRatio;
			} else if (modelRatio < aspectRatio) {
				height = width / aspectRatio;
			}
		}
		
		public override function LoadFromData(data:Object):Boolean
		{
			var view:PictureClipView = _View as PictureClipView;
			return view.LoadFromData(data);
		}
	}
}
package Collage.Clips.Picture
{
	import Collage.Clip.*;
	
	public class PictureClip extends Clip
	{
		[Bindable] public var aspectRatio:Number = 0;
		private var _URL:String = null;
		
		[Bindable]
		public function get url():String {return _URL;}
		public function set url(url:String):void
		{
			_URL = url;
		}
		
		public function PictureClip()
		{
			super();
			CreateView();
			CreateEditor();
		}
		
		protected override function CreateView():void
		{
			_View = new PictureClipView();
			_View.model = this;
		}

		protected override function CreateEditor():void
		{
			_Editor = new PictureClipEditor();
			_Editor.model = this;
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
	}
}
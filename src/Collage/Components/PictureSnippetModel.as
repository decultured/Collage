package Collage.Components
{
	import Collage.Snippet.*;
	
	public class PictureSnippetModel extends SnippetModel
	{
		[Bindable] public var aspectRatio:Number = 0;
		private var _URL:String = null;
		
		[Bindable]
		public function get url():String {return _URL;}
		public function set url(url:String):void
		{
			_URL = url;
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
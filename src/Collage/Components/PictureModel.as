package Collage.Components
{
	import Collage.Snippet.*;
	
	public class PictureModel extends SnippetModel
	{
		[Bindable] public var aspectRatio:Number = 1.777777;
		
		public override function Resized():void
		{
			if (!height)
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
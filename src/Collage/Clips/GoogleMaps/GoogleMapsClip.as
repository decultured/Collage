package Collage.Clips.GoogleMaps
{
	import Collage.Clip.*;
	
	public class GoogleMapsClip extends Clip
	{
		public function GoogleMapsClip(dataObject:Object = null)
		{
			moveFromCenter = true;
			super(dataObject);
			CreateView(new GoogleMapsClipView());
			CreateEditor(new GoogleMapsClipEditor());
		}
		
		public override function Resized():void
		{
		}

		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();
			newObject["type"] = "skeleton";
			return newObject;
		}

	}
}
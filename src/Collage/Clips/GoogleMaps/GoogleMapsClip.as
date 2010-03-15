package Collage.Clips.GoogleMaps
{
	import Collage.Clip.*;
	
	public class GoogleMapsClip extends Clip
	{
		public function GoogleMapsClip(dataObject:Object = null)
		{
			super(dataObject);
			moveFromCenter = true;
			type = "googlemaps";
			CreateView(new GoogleMapsClipView());
			CreateEditor(new GoogleMapsClipEditor());
		}
	}
}
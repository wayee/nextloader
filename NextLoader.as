package
{
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	
	import nl.NLManager;
	import nl.NLOption;
	
	public class NextLoader extends Sprite
	{
		public function NextLoader()
		{
			var resList:Array = ['fireworks.swf', 'fireworksone.swf', 'fireworkstwo.swf', 'fireworksthree.swf', 'fireworksfour.swf'];
			var resPriority:Array = [3, 5, 2, 4, 1];
			var len:int = resList.length; 
			var loadList:Array = [];
			var nlOption:NLOption;
			for (var i:int=0; i<len; i++) {
				nlOption = new NLOption(resList[i], resPriority[i], complete, progress);
				loadList.push(nlOption);
			}
			NLManager.Load(loadList);
		}
		
		private function complete(p_option:NLOption):void
		{
			trace("loaded swf:", p_option.Url);
		}
		
		private function progress(p_option:NLOption):void
		{
			var e:ProgressEvent = p_option.EventObject as ProgressEvent;
			trace(p_option.Url, 'loaded/total', Math.round(e.bytesLoaded*1.0/e.bytesTotal*10000)/100+'%');
		}
	}
}
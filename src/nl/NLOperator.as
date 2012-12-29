package nl {
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class NLOperator {
		private var waitingSequeue:Array;
		private var loadedDict:Dictionary;
		private var preTime:uint;
		private var isLoading:Boolean = false;
		private var curOption:NLOption;
		
		private function completeHandler():void {
			if (curOption.CompleteHandler != null) {
				curOption.CompleteHandler(curOption.CompleteHandlerParam);
			}
			isLoading = false;
			loadedDict[curOption.Path] = curOption;
		}
		
		private function progressHandler():void {
			if (curOption.ProgressHandler != null) {
				curOption.ProgressHandler(curOption.ProgressHandlerParam);
			}
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		public function Loadone(force:Boolean = false):void 	{
			var loadContinue:Boolean = true;
			if (isLoading && !force) {
				if (getTimer() - preTime > (5 * 60 * 1000)) { // 上一个资源加载太久了
					isLoading = false;
				} else {
					loadContinue = false;
				}
			}
			if (loadContinue) {
				preTime = getTimer();
				// load resource
				curOption = waitingSequeue.pop();
			}
		}
		
		public function AppendsWaiting(p_resourceList:Array):void {
			if (p_resourceList && p_resourceList.length > 0) {
				var len:uint = p_resourceList.length;
				var option:NLOption = new NLOption;
				for (var i:int=0; i<len; i++) {
					option = p_resourceList[i];
					AppendWaiting(option);
				}
				waitingSequeue.sort("priority", Array.NUMERIC);
			}
		}

		public function AppendsWaitingSimple(p_resourceList:Array):void {
			if (p_resourceList && p_resourceList.length > 0) {
				var len:uint = p_resourceList.length;
				var option:NLOption = new NLOption;
				for (var i:int=0; i<len; i++) {
					option.Path = p_resourceList[i];
					AppendWaiting(option);
				}
				waitingSequeue.sort("priority", Array.NUMERIC);
			}
		}
		
		public function AppendWaiting(p_option:NLOption):void {
			waitingSequeue.push(p_option);
			waitingSequeue.sort("priority", Array.NUMERIC);
		}
		
		public function AppendCompleted(p_option:NLOption):void	{
			loadedDict[p_option.Path] = p_option;
		}
		
		public function HasLoaded(key:String):Boolean {
			if ( loadedDict.hasOwnProperty(key) ) {
				return true;
			}
			return false;
		}
	}
}
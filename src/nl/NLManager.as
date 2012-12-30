package nl {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.Dictionary;
	

	/**
	 * 加载管理器
	 * - 排队自动加载
	 * - 资源加载可以有单独的回调（实现背景和前景加载）
	 * - 相同的资源正在加载，可以检测到，加载完成和加载过程都有回调到所有请求的地方
	 * - 加载时间太长，直接过期，重新开启
	 *  
	 * @author Andy Cai <huayicai@gmail.com>
	 * 
	 */
	public class NLManager {
		static private var waitingSequeue:Array = [];
		static private var loaderCache:Dictionary = new Dictionary;
		static private var isLoading:Boolean = false;
		
		static private function loaderEventHandler(e:Event):void {
			var type:String = e.type;
			var nlLoader:NLLoader = e.target as NLLoader;
			var nlOption:NLOption = nlLoader.getOption();
			switch (type) {
				case Event.COMPLETE:
					if (nlOption.CompleteHandler != null) {
						nlOption.EventObject = e;
						nlOption.CompleteHandler(nlOption);
					}
					loaderCache[nlOption.Url] = 1;
					removeLoadEvent(nlLoader);
					loadNext();
					break;
				case ProgressEvent.PROGRESS:
					if (nlOption.ProgressHandler != null) {
						nlOption.EventObject = e;
						nlOption.ProgressHandler(nlOption);
					}
					break;
				case IOErrorEvent.IO_ERROR:
				case SecurityErrorEvent.SECURITY_ERROR:
					trace("NLManager: loading " + nlOption.Url + " error.");
					if (nlOption.ErrorHandler != null) {
						nlOption.EventObject = e;
						nlOption.ErrorHandler(nlOption);
					}
					removeLoadEvent(nlLoader);
					loadNext();
					break;
			}
		}
		
		static private function initLoadEvent(p_nlLoader:NLLoader):void {
			if (p_nlLoader) {
				p_nlLoader.addEventListener(Event.COMPLETE, loaderEventHandler);
				p_nlLoader.addEventListener(ProgressEvent.PROGRESS, loaderEventHandler);
				p_nlLoader.addEventListener(IOErrorEvent.IO_ERROR, loaderEventHandler);
				p_nlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderEventHandler);
			}
		}
		
		static private function removeLoadEvent(p_nlLoader:NLLoader):void {
			if (p_nlLoader) {
				p_nlLoader.removeEventListener(Event.COMPLETE, loaderEventHandler);
				p_nlLoader.removeEventListener(ProgressEvent.PROGRESS, loaderEventHandler);
				p_nlLoader.removeEventListener(IOErrorEvent.IO_ERROR, loaderEventHandler);
				p_nlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderEventHandler);
			}
		}
		
		static private function loadNext():void {
			if (waitingSequeue.length > 0) {
				isLoading = true;
				var loader:NLLoader = waitingSequeue.shift() as NLLoader;
				loaderCache[loader.getOption().Url] = 0;
				initLoadEvent(loader);
				loader.Load();
			} else {
				isLoading = false;
			}
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		static public function HasLoaded(p_url:String):Boolean
		{
			return loaderCache[p_url];
		}
		
		/**
		 * p_loadData [NPOption, ...] 
		 */
		static public function Load(p_loadData:Array):void {
			var len:int = p_loadData.length;
			var nlLoader:NLLoader;
			var nlOption:NLOption;
			for (var i:int=0; i<len; i++) {
				nlOption = p_loadData[i];
				if (loaderCache.hasOwnProperty(nlOption.Url)) {
					if (loaderCache[nlOption.Url]) { // loaded
						if (nlOption.CompleteHandler != null) {
							nlOption.CompleteHandler(nlOption.CompleteHandlerParam);
						}
					} else { // not complete
					}
				} else {
					nlLoader = new NLLoader(nlOption);
					waitingSequeue.push(nlLoader);
				}
			}
			waitingSequeue.sortOn("Priority", Array.NUMERIC|Array.DESCENDING);
			
			if ( !isLoading ) {
				loadNext();
			}
		}
		
		/**
		 * p_loadData [(String)Path, ...] 
		 */
		static public function LazyLoad(p_loadData:Array, p_loader:NLLoader=null):void {
			var len:int = p_loadData.length;
			var nlLoader:NLLoader;
			var nlOption:NLOption;
			for (var i:int=0; i<len; i++) {
				nlOption = new NLOption(p_loadData[i]);
				if (loaderCache.hasOwnProperty(nlOption.Url)) {
					if (loaderCache[nlOption.Url]) { // loaded
						if (nlOption.CompleteHandler != null) {
							nlOption.CompleteHandler(nlOption.CompleteHandlerParam);
						}
					} else { // not complete
					}
				} else {
					nlLoader = new NLLoader(nlOption);
					waitingSequeue.push(nlLoader);
				}
			}
			waitingSequeue.sortOn("Priority", Array.NUMERIC);
			loadNext();
		}
	}
}
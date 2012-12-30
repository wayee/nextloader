package nl {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;

	public class NLLoader extends EventDispatcher {
		private var nlOption:NLOption;
		private var loader:Loader;
		public var Priority:int;
		
		public function NLLoader(p_option:NLOption) {
			loader = new Loader;
			nlOption = p_option;
			Priority = p_option.Priority;
			initLoadEvent();
		}
		
		private function initLoadEvent():void {
			if (loader) {
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderEventHandler);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderEventHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderEventHandler);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderEventHandler);
			}
		}
		
		private function removeLoadEvent():void	{
			if (loader) {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderEventHandler);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderEventHandler);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderEventHandler);
				loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderEventHandler);
			}
		}
		
		private function loaderEventHandler(e:Event):void {
			var type:String = e.type;
			switch (type) {
				case Event.COMPLETE:
					removeLoadEvent();
					loader = null;
					dispatchEvent(e);
					break;
				case ProgressEvent.PROGRESS:
					dispatchEvent(e);
					break;
				case IOErrorEvent.IO_ERROR:
				case SecurityErrorEvent.SECURITY_ERROR:
					removeLoadEvent();
					loader = null;
					dispatchEvent(e);
					break;
			}
		}
		

		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		public function getOption():NLOption
		{
			return nlOption;
		}
		
		public function Load():void 	{
			// load resource
			var context:LoaderContext = new LoaderContext;
			if (Security.sandboxType == Security.REMOTE) {
				context.securityDomain = SecurityDomain.currentDomain;
			}
			
			switch (nlOption.Target) {
				case NLOption.TARGET_CHILD:
					context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					break;
				case NLOption.TARGET_SAME:
					context.applicationDomain = ApplicationDomain.currentDomain;
					break;
				case NLOption.TARGET_NEW:
					context.applicationDomain = new ApplicationDomain;
					break;
			}
			
			loader.load(new URLRequest(nlOption.Url), context);
		}
	}
}
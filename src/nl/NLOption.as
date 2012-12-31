package nl {
	import flash.events.Event;

	public class NLOption {
		static public const TARGET_CHILD:String = "child";
		static public const TARGET_SAME:String = "same";
		static public const TARGET_NEW:String = "new";
		
		public var Url:String = '';					// 路径
		public var Priority:int = 0;				// 优先级
		public var CompleteHandler:Function;		// 完成回调
		public var CompleteHandlerParam:Object;		// 完成回调参数
		public var ProgressHandler:Function;		// 加载过程回调
		public var ProgressHandlerParam:Object;		// 加载过程回调参数
		public var ErrorHandler:Function;			// 错误回调
		public var ErrorHandlerParam:Object;		// 错误回调参数
		public var EventObject:Event = null;		// 事件
		public var Target:String;					// 目标["child", "same", "new"]

		private var Background:Boolean = false;		// 后台加载
		private var Pause:Boolean = false;			// 暂停
		private var Completed:Boolean = false;		// 加载完成
		
		public function NLOption(p_url:String, p_priority:int=0, p_complete:Function=null, 
								 p_progress:Function=null, p_err:Function=null, p_completeData:Object=null, 
								 p_progressData:Object=null, p_errData:Object=null, p_target:String="same") {
			Url = p_url;
			Priority = p_priority;
			CompleteHandler = p_complete;
			ProgressHandler = p_progress;
			ErrorHandler = p_err;
			CompleteHandlerParam = p_completeData;
			ProgressHandlerParam = p_progressData;
			ErrorHandlerParam = p_errData;
			Target = p_target;
		}
	}
}
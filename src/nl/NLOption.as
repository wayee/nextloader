package nl {
	public class NLOption {
		public var Path:String = '';					// 路径
		public var Priority:int = 0;					// 优先级
		public var Background:Boolean = false;			// 后台加载
		public var CompleteHandler:Function = null;		// 完成回调
		public var CompleteHandlerParam:Object = null;	// 完成回调参数
		public var ProgressHandler:Function = null;		// 加载过程回调
		public var ProgressHandlerParam:Object = null;	// 加载过程回调参数
		public var Pause:Boolean = false;				// 暂停
		public var Completed:Boolean = false;			// 加载完成
	}
}
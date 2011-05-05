component  extends='ModelGlue.gesture.controller.Controller' hint='i am a model-glue controller' output='false'
	beans='UserService, AppConfig'
{
	public function onApplicationStart(event){
	}
	public function onSessionStart(event){
	}
	public function onSessionEnd(event){
	}
	public  function init( framework)
	 hint='Constructor' output='false'{
		super.init(framework);
		return this;
	}
	
	public function beforeRequest(event){
		arguments.event.setValue('AppConfig', beans.AppConfig);
	}
}

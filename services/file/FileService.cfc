component accessors='true' displayname='FileService' output='false'
{
	
	property name='AppConfig' type='any' displayname='AppConfig';
	
	public function init(){
		return this;
	}
	
	public void function createDir(dir){
		if(!directoryExists(arguments.dir)){
			directoryCreate(arguments.dir);
		}
	}

	public void function writeFile(f,data=''){
		var storageType = getAppConfig().getConfigSetting('storageType');
		
		fileWrite(arguments.f, arguments.data);
		
		if(storageType == 's3'){
			var s3ID = getAppConfig().getConfigSetting('s3ID');
			var permissions = [{group='all', permission='read'}, {id=s3ID, permission='full_control'}];
			storeSetACL(arguments.f, permissions);
		}
	}
	
	public void function moveFile(src, dest){
		var storageType = getAppConfig().getConfigSetting('storageType');
		
		if(fileExists(arguments.src)){
			fileMove(arguments.src, arguments.dest);
		}
		
		if(storageType == 's3'){
			var s3ID = getAppConfig().getConfigSetting('s3ID');
			var permissions = [{group='all', permission='read'}, {id=s3ID, permission='full_control'}];
			storeSetACL(arguments.dest, permissions);
		}
	}
	
	public void function delete(target,recurse=false){
		var r = arguments.recurse ? true : false;
		if(fileExists(arguments.target)){
			try{
				fileDelete(arguments.target);
			}
			catch(Any e){
				logError(e.message);
			}
		}
		else if(directoryExists(arguments.target)){
			try{
				directoryDelete(arguments.target,r);
			}
			catch(Any e){
				logError(e.message);
			}
		}
		else{
			logError('Tried to delete, but could not find target file or directory: ' & arguments.target);
		}
	}
	
	public void function storeSlideImage(img, storeRoot, storePath){
		var storageType = getAppConfig().getConfigSetting('storageType');
		
		imageWrite(arguments.img, arguments.storeRoot & arguments.storePath,true,1);
		
		if(storageType == 's3'){
			var s3ID = getAppConfig().getConfigSetting('s3ID');
			var permissions = [{group='all', permission='read'}, {id=s3ID, permission='full_control'}];
			storeSetACL(arguments.storeRoot & arguments.storePath, permissions);
		}
		
	}
	
	public boolean function storeImage(fileField, storeRoot, storePath, thumbPath){
		var tmpRoot = getAppConfig().getConfigSetting('virtualTempRoot');
		var storageType = getAppConfig().getConfigSetting('storageType');
		
		var uploadedImg = fileUpload(tmpRoot, arguments.fileField, 'image/*,application/octet-stream', 'makeUnique');
		
		if(uploadedImg.fileWasSaved){
			var serverImg = uploadedImg.ServerDirectory & '/' & uploadedImg.ServerFileName & '.' & uploadedImg.ServerFileExt;	
			var tmpImage = imageNew(serverImg);
			imageResize(tmpImage, 150, 150);
			imageWrite(tmpImage, arguments.storeRoot & arguments.storePath, 1, true);
			
			//do we need to set ACL?
			if(storageType == 's3'){
				var s3ID = getAppConfig().getConfigSetting('s3ID');
				var permissions = [{group='all', permission='read'}, {id=s3ID, permission='full_control'}];
				storeSetACL(arguments.storeRoot & arguments.storePath, permissions);
			}
			
			if(!isNull(arguments.thumbPath)){
				var imgThumb = imageNew(tmpImage);
				imageResize(imgThumb, 50, 50);
				imageWrite(imgThumb, arguments.storeRoot & arguments.thumbPath, 1, true);
				if(storageType == 's3'){
					storeSetACL(arguments.storeRoot & arguments.thumbPath, permissions);
				}
			}		
			
			if(fileExists(serverImg)) fileDelete(serverImg);
			
			return true;
		}
		else{
			return false;
		}
	}
	
	private void function logError(msg){
		var isLogging = getAppConfig().getConfigSetting('logFileDeleteErrors');
		var logFile = getAppConfig().getConfigSetting('fileDeleteErrorsLogName');		
		if(isLogging) writeLog(file=logFile, text=arguments.msg);
	}
}
component displayname='SlideSixImport' accessors='true'{
	property name='SlideSixImportConfig' type='any' displayname='SlideSixImportConfig';
	property name='SlideshowService' type='any' displayname='SlideshowService';
	property name='UserService' type='any' displayname='UserService';
	property name='FileService' type='any' displayname='FileService';
	property name='AppConfig' type='any' displayname='AppConfig';
	property name='Utils' type='any' displayname='Utils';
	
	public SlideSixImportService function init(){
		return this;
	}
	

	public any function authenticate(u,p){
		var key = getSlideSixImportConfig().getConfigSetting('slidesixAPIKey');
		var baseURL = getSlideSixImportConfig().getConfigSetting('slidesixAPIURL');
		var cURL = baseURL & '?method=authenticateUser';
		var req = new com.adobe.coldfusion.http(url=cURL, method='post');
		req.addParam(type='formfield', name='apiKey', value=key);
		req.addParam(type='formfield', name='loginUser', value=arguments.u);
		req.addParam(type='formfield', name='loginPassword', value=hash(arguments.p, 'md5'));
		req.addParam(type='formfield', name='returnType', value='json');
		var result = req.send().getPrefix();
		return deserializeJSON(result.fileContent);
	}
	
	public any function getSlideshows(userid,token){
		var key = getSlideSixImportConfig().getConfigSetting('slidesixAPIKey');
		var baseURL = getSlideSixImportConfig().getConfigSetting('slidesixAPIURL');
		var cURL = baseURL & '?method=getSlideShows';
		var req = new com.adobe.coldfusion.http(url=cURL, method='post');
		req.addParam(type='formfield', name='apiKey', value=key);
		req.addParam(type='formfield', name='remoteSessionToken', value=arguments.token);
		req.addParam(type='formfield', name='createdBy', value=arguments.userid);
		req.addParam(type='formfield', name='returnType', value='json');
		var result = req.send().getPrefix();
		return deserializeJSON(result.fileContent);
	}

	public any function getSlideshow(alias){
		var key = getSlideSixImportConfig().getConfigSetting('slidesixAPIKey');
		var baseURL = getSlideSixImportConfig().getConfigSetting('slidesixXMLURL');
		var cURL = baseURL & '&alias=' & arguments.alias;
		var req = new com.adobe.coldfusion.http(url=cURL, method='get');
		var result = req.send().getPrefix();
		return xmlParse(result.fileContent);
	}

	public any function importSlideshow(x){
		var data = {};
		data.title = x.presentation.title.xmlText;
		data.abstract = x.presentation.description.xmlText;
		data.isConverting = 0;
		data.importedID = toString(x.presentation.XmlAttributes.id);
		
		var cuID = getUserService().getCurrentUserID();
		var ssid = getSlideshowService().saveSlideshowInfo(0, data, cuID);
		var ss = getSlideshowService().readSlideshow(ssid);
		var storeRoot = getAppConfig().getConfigSetting('storageRootDir');
		var ssRoot = ss.getSlideshowRootDir();
		var ssRootFull = storeRoot & ssRoot;
		var thumbRoot = ssRoot & '/thumbs';
		var slideRoot = ssRoot & '/slides';
		var fs = getFileService();
		
		var tname = getUtils().getStrippedUUID() & '_import_slidesix_slides';
		thread name=tname x=x fs=fs ssid=ssid SlideshowService=getSlideshowService() thumbRoot=thumbRoot storeRoot=storeRoot slideRoot=slideRoot{
			var ss = attributes.SlideshowService.readSlideshow(attributes.ssid);
			var slides = attributes.x.presentation.slides;
			for(var s=1; s <= arrayLen(slides); s++){
				var slide = slides.slide[s];
				var title = slide.title;
				var slideImg = imageNew(slide.slideContentPath.xmlText);
				var d = {};
				d.title = slide.title.xmlText;
				d.text = slide.text.xmlText;
				d.notes = slide.notes.xmlText;
				d.slideNumber = slide.slideNumber.xmlText;
				d.showNotes = slide.showNotes.xmlText;
				d.pathToSlide = attributes.slideRoot & '/' & s & '.jpg';
				attributes.fs.storeSlideImage(slideImg, attributes.storeRoot, d.pathToSlide);
				d.height = slideImg.height;
				d.width = slideImg.width;
				d.pathToSlideThumb = attributes.thumbRoot & '/' & s & '_thumb.jpg';
				imageResize(slideImg,150,'');
				attributes.fs.storeSlideImage(slideImg, attributes.storeRoot, d.pathToSlideThumb);
				d.slideshow = ss;
				attributes.SlideshowService.saveNewSlide(javacast('null',''),d);
				if(s == 1){
					attributes.SlideshowService.saveSlideshowInfo(ss.getID(),{pathToThumb=d.pathToSlideThumb});
				}
			}
			attributes.SlideshowService.saveSlideshowInfo(ss.getID(),{lastBuildDate=now()});
		}
		return ss.getTitle();
	}
}
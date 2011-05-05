component extends='model.Base'  persistent='true' entityname='Slideshow' table='slideshows' displayname='Slideshow' hint='i am a slideshow' output='false'
{
	property name='abstract' notEmpty=true display='Description' max=3000 ormtype='string' length=3000 notnull=true;
	property name='alias' notEmpty=true display='Alias' max=250 ormtype='string' length=250 notnull=true;
	property name='title' notEmpty=true display='Title' max=250 ormtype='string' length=250 notnull=true;
	property name='slideshowRootDir' max=250 ormtype='string' length=250;
	property name='pathToThumb' max=4000 ormtype='string' length=4000;
	property name='pathToAttachment' max=4000 ormtype='string' length=4000;
	property name='lastBuildDate' display='Last Build Date' ormtype='timestamp';
	property name='createdBy' display='Created By' fieldtype='many-to-one' cfc='model.users.User' lazy=true cascade='save-update' inverse=true;
	property name='eventSlideshowRelationships' fieldtype='one-to-many' cfc='model.events.EventSlideshowRelationship' fkcolumn='slideshowID' inverseJoinColumn='slideshowID' inverse=true lazy=true cascade='save-update' singularname='eventSlideshowRelationship';
	property name='group' fieldtype='many-to-one' cfc='model.groups.Group' lazy=true cascade='save-update' singularname='group';
	property name='hasErrors' display='Has Errors' default=0 ormtype='boolean' notnull=true;
	property name='allowComments' display='Allow Comments' ormtype='boolean' default=1 notnull=true;
	property name='notifyComments' display='Notify Comments' ormtype='boolean' default=1 notnull=true;
	property name='isConverting' display='Is Converting' ormtype='boolean' notnull=true;
	property name='isPublishing' display='Is Publishing' ormtype='boolean' default=0 notnull=true;
	property name='password' display='Password' max=50 ormtype='string' isMatch='{confirmPassword}' length=50;
	property name='confirmPassword' display='Confirm Password' max=50 insert=false update=false persistent=false mustmatch='Password';
	property name='comments' fieldtype='one-to-many' cfc='model.slideshows.comments.Comment' fkcolumn='slidehowID' singularname='comment' lazy=true cascade='all-delete-orphan';
	property name='favoritedBy' fieldtype='many-to-many' cfc='model.users.User' linktable='favorites' inversejoincolumn='slideshowID' lazy=true cascade='all-delete-orphan';
	property name='rankings' fieldtype='one-to-many' cfc='model.slideshows.rankings.Ranking' fkcolumn='slideshowID' lazy=true cascade='all-delete-orphan' singularname='ranking';
	property name='views' fieldtype='one-to-many' cfc='model.slideshows.views.View' fkcolumn='slideshowID' lazy=true cascade='all-delete-orphan' singularname='view';
	property name='slides' fieldtype='one-to-many' cfc='model.slideshows.slides.Slide' singularname='slide' fkcolumn='slideshowID' inversejoincolumn='slideshowID' lazy=true inverse=true;
	property name='tagAssociations' fieldtype='one-to-many' cfc='model.slideshows.tags.TagAssociation' fkcolumn='slideshowID' inversejoincolumn='slideshowID' singularname='tagAssociation' lazy=true cascade='all' inverse=true;
	property name='avgRank' formula='select avg(r.rank) from rankings r where r.slideshowID=id';
	property name='countRank' formula='select count(r.rank) from rankings r where r.slideshowID=id';
	property name='numViews' formula='select count(v.id) from views v where v.slideshowID=id';
	property name='numEmbeddedViews' formula='select count(v.id) from views v where v.slideshowID=id and v.embeddedView = 1';
	property name='numFavorites' formula='select count(s.slideshowID) from favorites s where s.slideshowID=id';
	property name='numComments' formula='select count(c.id) from comments c where c.slideshowID=id';
	property name='numSlides' formula='select count(s.id) from slides s where s.slideshowID=id';
	property name='numSlidesWithMedia' formula='select count(s.id) from slides s where s.slideshowID=id and (s.pathToSlideMedia is not null or s.externalMediaID is not null)';
	property name='eventIDList' persistent=false;
	property name='tagList' persistent=false;
	property name='embedCode' persistent=false;
	property name='creditName' ormtype='string' length='250';
	property name='creditURL' ormtype='string' length='1000';
	property name='importedID' sqltype='char(35)';
	property name='isFeatured' notnull='true' ormtype='boolean' default='0' dbdefault='0';
	
	savecontent variable='variables.oCode'{
		writeOutput("<object height='{height}' width='{width}'>
		    <param name='movie' value='http://{server}/viewer/SlideSixViewer.swf?slideshowID={slideshowID}'/>
		    <param name='menu' value='false'/>
		    <param name='scale' value='noScale'/>
		    <param name='allowFullScreen' value='true'/>
		    <param name='allowScriptAccess' value='always'/>
		    <param value='transparent' name='wmode'/>
		    <param value='quality' name='best'/>
		    <embed src='http://{server}/viewer/SlideSixViewer.swf?slideshowID={slideshowID}' allowscriptaccess='always' allowfullscreen='true' height='{height}' width='{width}' type='application/x-shockwave-flash' wmode='transparent' quality='best'/>
		</object>");
	}
	
	public function getEmbedCode(){
		var embedCode = replaceNoCase(variables.oCode, '{server}', cgi.server_name, 'all');
		embedCode = replaceNoCase(embedCode, '{slideshowID}', getID(), 'all');
		embedCode = replaceNoCase(embedCode, '{height}', 425, 'all');
		embedCode = replaceNoCase(embedCode, '{width}', 550, 'all');
		return embedCode;
	}
	
	public function setCreatedBy(user){
		variables.createdBy = !isNull(arguments.user) ? arguments.user : '';
		if(!isNull(arguments.user) && !arguments.user.hasSlideshow(this)){
			arguments.user.addSlideshow(this);
		}
	}
	public function removeCreatedBy(){
		variables.createdBy = javacast('null', '');
	}
	
	public function setGroup(group){
		variables.group = !isNull(arguments.group) ? arguments.group : javacast('null', '');
		if(!isNull(arguments.group) && !arguments.group.hasSlideshow(this)){
			arguments.group.addSlideshow(this);
		}
	}

	public function addEventSlideshowRelationship(eventSlideshowRelationship){
		if(isNull(variables.eventSlideshowRelationships)){
			variables.eventSlideshowRelationships = arrayNew(1);
		}
		
		arrayAppend(variables.eventSlideshowRelationships, arguments.eventSlideshowRelationship);
		
		if(!isNull(arguments.eventSlideshowRelationship) && !arguments.eventSlideshowRelationship.hasSlideshow(this)){
			arguments.eventSlideshowRelationships.setSlideshow(this);
		}
	}
	
	public function addSlide(slide){
		if(isNull(variables.slides)){
			variables.slides = arrayNew(1);
		}
		
		arrayAppend(variables.slides, arguments.slide);
		
		if(!isNull(arguments.slide) && !arguments.slide.hasSlideshow(this)){
			arguments.slide.setSlideshow(this);
		}
	}
	
	public function getEventIDList(){
		var rArr = getEventSlideshowRelationships();
		var rList = '';
		if(!isNull(rArr) && arrayLen(rArr)){
			for(var r in rArr){
				rList = listAppend(rList,r.getEvent().getID());
			}
		}
		return rList;
	}
	
	
	public function getTagList(){
		var tArr = getTagAssociations();
		var tList = '';
		if(!isNull(tArr) && arrayLen(tArr)){
			for(var t in tArr){
				tList = listAppend(tList,t.getTag().getTag());
			}
		}
		return tList;
	}
	
	public void function setPassword(password){
		if(structKeyExists(arguments, 'password') && len(trim(arguments.password))){
			variables.password = hash(arguments.password, 'md5');
		}
		else{
			variables.password = javacast('null', '');
		}
	}
	
	public void function setConfirmPassword(confirmPassword){
		if(structKeyExists(arguments, 'confirmPassword') && len(trim(arguments.confirmPassword))){
			variables.confirmPassword = hash(arguments.confirmPassword, 'md5');
		}
		else{
			variables.confirmPassword = javacast('null', '');
		}
	}
	
	public void function postLoad(){
		if(!isNull(getPassword()) && len(trim(getPassword()))){
			variables.confirmPassword = variables.password;
		}
	}
}
component extends="model.Base"  persistent="true" entityname="Slideshow" table="slideshows" displayname="Slideshow" hint="i am a slideshow" output="false"
{
	/**
	*@notEmpty
	*@display Description
	*@max 3000
	*@ormtype string
	*@length 3000
	*@notnull true
	*/
	property name="abstract";
	/**
	*@notEmpty
	*@display Alias
	*@max 250
	*@ormtype string
	*@length 250
	*@notnull true
	*/
	property name="alias";
	/**
	*@notEmpty
	*@display Title
	*@max 250
	*@ormtype string
	*@length 250
	*@notEmpty
	*@notnull true
	*/
	property name="title";
	/**
	*@max 250
	*@ormtype string
	*@length 250
	*/
	property name="slideshowRootDir";
	/**
	*@max 4000
	*@ormtype string
	*@length 4000
	*/
	property name="pathToThumb";
	/**
	*@max 4000
	*@ormtype string
	*@length 4000
	*/
	property name="pathToAttachment";
	/**
	*@display Last Build Date
	*@ormtype timestamp
	*/
	property name="lastBuildDate";
	/**
	*@display Created By
    *@fieldtype many-to-one
	*@cfc model.users.User
	*@lazy true
	*@cascade save-update
	*@inverse true
	*/
	property name="createdBy";
	
	/**
	*@fieldtype many-to-one
	*@cfc model.groups.Group
	*@lazy true
	*@cascade save-update
	*@singularname group
	*/
	property name="group";
	
	/**
	*@display Has Errors
	*@default 0
	*@ormtype boolean
	*@notnull
	*/
	property name="hasErrors";
	
	/**
	*@display Allow Comments
	*@ormtype boolean
	*@default 1
	*@notnull
	*/
	property name="allowComments";
	
	/**
	*@display Notify Comments
	*@ormtype boolean
	*@default 1
	*@notnull
	*/
	property name="notifyComments";
	/**
	*@display Is Importing
	*@ormtype boolean
	*@default 0
	*@notnull
	*/
	property name="isConverting";
	/**
	*@display Is Publishing
	*@ormtype boolean
	*@default 0
	*@notnull
	*/
	property name="isPublishing";
	/**
	*@display Password
	*@max 50
	*@ormtype string
	*@isMatch {confirmPassword}
	*@length 50
	*/
	property name="password";
	/**
	*@display Confirm Password
	*@max 50
	*@insert false
	*@update false
	*@persistent false
	*@mustmatch Password
	*/	
	property name="confirmPassword";
	
	/**
    *@fieldtype one-to-many
	*@cfc model.slideshows.comments.Comment
	*@fkcolumn slideshowID
	*@singularName comment
	*@lazy true
	*@cascade all-delete-orphan
    */
	property name="comments";
	
	/**
    *@fieldtype many-to-many
	*@cfc model.users.User
	*@linkTable favorites
	*@inverseJoinColumn slideshowID
	*@lazy true
	*@cascade all-delete-orphan
    */
	property name="favoritedBy";
	
	/**
    *@fieldtype one-to-many
	*@cfc model.slideshows.rankings.Ranking
	*@fkcolumn slideshowID
	*@lazy true
	*@cascade all-delete-orphan
	*@singularname ranking
    */
	property name="rankings";
	
	/**
    *@fieldtype one-to-many
	*@cfc model.slideshows.views.View
	*@fkcolumn slideshowID
	*@lazy true
	*@cascade all-delete-orphan
	*@singularname view
    */
	property name="views";
	
	/**
    *@fieldtype one-to-many
	*@cfc model.slideshows.slides.Slide
	*@singularName slide
	*@fkcolumn slideshowID
	*@inverseJoinColumn slideshowID
	*@lazy true
	*@cascade all-delete-orphan
	*@inverse true
    */
	property name="slides";
	
	/**
    *@fieldtype one-to-many
	*@cfc model.slideshows.tags.TagAssociation
	*@fkcolumn slideshowID
	*@inverseJoinColumn slideshowID
	*@singularName tagAssociation
	*@lazy true
	*@cascade all
	*@inverse true
    */
	property name="tagAssociations";
	
	property name="avgRank" formula="select avg(r.rank) from rankings r where r.slideshowID=id";
	property name="countRank" formula="select count(r.rank) from rankings r where r.slideshowID=id";
	property name="numViews" formula="select count(v.id) from views v where v.slideshowID=id";
	property name="numEmbeddedViews" formula="select count(v.id) from views v where v.slideshowID=id and v.embeddedView = 1";
	property name="numFavorites" formula="select count(s.slideshowID) from favorites s where s.slideshowID=id";
	property name="numComments" formula="select count(c.id) from comments c where c.slideshowID=id";
	property name="numSlides" formula="select count(s.id) from slides s where s.slideshowID=id";
	property name="numSlidesWithMedia" formula="select count(s.id) from slides s where s.slideshowID=id and (s.pathToSlideMedia is not null or s.externalMediaID is not null)";
	/**
    *@persistent false
    */
	property name="tagList";

	/**
    *@persistent false
    */
	property name="embedCode";
	
	savecontent variable="variables.oCode"{
		writeOutput('<object height="{height}" width="{width}">
		    <param name="movie" value="http://{server}/viewer/SlideSixViewer.swf?slideshowID={slideshowID}"/>
		    <param name="menu" value="false"/>
		    <param name="scale" value="noScale"/>
		    <param name="allowFullScreen" value="true"/>
		    <param name="allowScriptAccess" value="always"/>
		    <param value="transparent" name="wmode"/>
		    <param value="quality" name="best"/>
		    <embed src="http://{server}/viewer/SlideSixViewer.swf?slideshowID={slideshowID}" allowscriptaccess="always" allowfullscreen="true" height="{height}" width="{width}" type="application/x-shockwave-flash" wmode="transparent" quality="best"/>
		</object>');
	}
	
	public function getEmbedCode(){
		var embedCode = replaceNoCase(variables.oCode, "{server}", cgi.server_name, "all");
		embedCode = replaceNoCase(embedCode, "{slideshowID}", getID(), "all");
		embedCode = replaceNoCase(embedCode, "{height}", 425, "all");
		embedCode = replaceNoCase(embedCode, "{width}", 550, "all");
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
	
	public function addSlide(slide){
		if(isNull(variables.slides)){
			variables.slides = arrayNew(1);
		}
		
		arrayAppend(variables.slides, arguments.slide);
		
		if(!isNull(arguments.slide) && !arguments.slide.hasSlideshow(this)){
			arguments.slide.setSlideshow(this);
		}
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
			variables.password = hash(arguments.password, "md5");
		}
		else{
			variables.password = javacast('null', '');
		}
	}
	
	public void function setConfirmPassword(confirmPassword){
		if(structKeyExists(arguments, 'confirmPassword') && len(trim(arguments.confirmPassword))){
			variables.confirmPassword = hash(arguments.confirmPassword, "md5");
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
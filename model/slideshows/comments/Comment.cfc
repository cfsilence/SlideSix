component extends="model.Base"  persistent="true" entityname="Comment" table="comments" displayname="Comment" hint="i am a slideshow comment" output="false"
{
	/**
	*@notEmpty
	*@display Name
	*@max 100
	*@ormtype string
	*@length 100
	*@notnull true
	*/
	property name="name";
	/**
	*@notEmpty
	*@display Email Address
	*@max 250
	*@ormtype string
	*@length 250
	*@notnull true
	*@email
	*/
	property name="email";
	/**
	*@notEmpty
	*@display URL
	*@max 1000
	*@ormtype string
	*@length 1000
	*/
	property name="url";
	/**
	*@display comment
	*@notEmpty
	*@notnull
	*@max 8000
	*@ormtype string
	*@length 8000
	*/
	property name="comment";
	
	/**
    *@ormtype boolean
	*@default 1
	*@notnull
    */
	property name="isSubscribed";
	
	/**
	*@display Slideshow
	*@sqltype char(35)
    *@fieldtype many-to-one
	*@cfc model.slideshows.Slideshow
	*@lazy true
	*@cascade save-update
	*@inverse true
	*/
	property name="slideshow";
	
	public function setSlideshow(slideshow){
		variables.slideshow = !isNull(arguments.slideshow) ? arguments.slideshow : '';
		if(!isNull(arguments.slideshow) && !arguments.slideshow.hasComment(this)){
			arguments.slideshow.addComment(this);
		}
	}

}
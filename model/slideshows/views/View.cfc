component extends="model.Base" persistent="true" entityname="View" table="views" displayname="View" hint="i am a Slideshow View" output="false"
{
	
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
	
	/**
    *@ormtype string
    */
	property name="referrer";
	
	/**
    *@ormtype boolean
	*@default 0
    */
	property name="embeddedView";
	
	public function setSlideshow(slideshow){
		variables.slideshow = !isNull(arguments.slideshow) ? arguments.slideshow : '';
		if(!isNull(arguments.slideshow) && !arguments.slideshow.hasView(this)){
			arguments.slideshow.addView(this);
		}
	}

}
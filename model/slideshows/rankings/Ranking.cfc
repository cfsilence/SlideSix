component extends="model.Base" persistent="true" entityname="Ranking" table="rankings" displayname="Ranking" hint="i am a Slideshow Ranking" output="false"
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
    *@ormtype integer
	*@notnull
	*@default 0
    */
	property name="rank";
	
	public function setSlideshow(slideshow){
		variables.slideshow = !isNull(arguments.slideshow) ? arguments.slideshow : '';
		if(!isNull(arguments.slideshow) && !arguments.slideshow.hasRanking(this)){
			arguments.slideshow.addRanking(this);
		}
	}

}
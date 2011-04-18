component extends="model.Base" persistent="true" entityname="Slide" table="slides" displayname="Slide" hint="i am a slide" output="false"
{
	/**
	*@max 4000
	*@ormtype string
	*@length 4000
	*/
	property name="pathToSlide";
	
	/**
	*@max 4000
	*@ormtype string
	*@length 4000
	*/
	property name="pathToSlideThumb";

	/**
	*@max 4000
	*@ormtype string
	*@length 4000
	*/
	property name="pathToSlideMedia";
	
	/**
	*@display Text
	*@max 8000
	*@ormtype string
	*@length 8000
	*/
	property name="text";
	
	/**
	*@display Notes
	*@max 4000
	*@ormtype string
	*@length 4000
	*/
	property name="notes";
	
	/**
    *@ormtype boolean
	*@default 1
    */
	property name="showNotes";
	
	/**
	*@display Title
	*@max 250
	*@ormtype string
	*@length 250
	*@notEmpty
	*@notnull
	*/
	property name="title";
	
	/**
    *@ormtype string
	*@length 100
    */
	property name="externalMediaID";
	
	/**
    *@ormtype string
	*@length 100
    */
	property name="externalMediaSource";
	
	/**
    *@ormtype boolean
	*@default 0
    */
	property name="hasNarration";
	
	/**
    *@ormtype integer
	*@notnull
    */
	property name="slideNumber";
	
	/**
    *@ormtype integer
	*@notnull
    */
	property name="height";
	
	/**
    *@ormtype integer
	*@notnull
    */
	property name="width";

	/**
	*@fieldtype many-to-one
	*@cfc model.slideshows.Slideshow
	*@lazy true
	*@cascade all
	*@singularname slideshow
	*/
	property name="slideshow";
	
	property name="hasMedia" formula="select count(s.id) from slides s where s.id=id and (s.pathToSlideMedia is not null or s.externalMediaID is not null)";
}
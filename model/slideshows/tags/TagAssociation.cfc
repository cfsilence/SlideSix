component extends="model.Base" persistent="true" entityname="TagAssociation" table="tagToSlideshow" displayname="TagAssociation" hint="i am a TagAssocation" output="false"
{
	/**
    *@fieldtype many-to-one
	*@cfc model.slideshows.Slideshow
	*@fkcolumn slideshowID
	*@lazy true
	*@cascade save-update
	*@singularname slideshow
	*@uniqueKey tagAssociationKey
    */
	property name="slideshow";
	/**
    *@fieldtype many-to-one
	*@cfc model.slideshows.tags.Tag
	*@fkcolumn tagID
	*@lazy true
	*@cascade save-update
	*@singularname tag
	*@uniqueKey tagAssociationKey
    */
	property name="tag";

}
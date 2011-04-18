component extends="model.Base" persistent="true" entityName="Tag" table="tags" displayname="Tag" hint="i am a Tag" output="false"
{
	/**
    *@display Tag
	*@notEmpty
	*@ormtype string
	*@max 100
	*@length 100
    */
	property name="tag";
	
	/**
    *@fieldtype one-to-many
	*@cfc model.slideshows.tags.tagAssociation
	*@fkcolumn tagID
	*@inverseJoinColumn tagID
	*@lazy true
	*@cascade all-delete-orphan
	*@singularname tagAssociation
    */
	property name="tagAssocations";
}
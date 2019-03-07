package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

class WPDslLanguageSupportGenerator {
	
	Resource resource
	IFileSystemAccess2 fsa
	IGeneratorContext context
	String pluginName
	String sinceVersion
	String link
	
	new(Resource _resource, IFileSystemAccess2 _fsa, IGeneratorContext _context, String _pluginName, String _sinceVersion, String _link) 
	{
    	resource=_resource;
    	fsa=_fsa;
    	context=_context;
    	pluginName=_pluginName;
    	sinceVersion=_sinceVersion;
    	link=_link;
  	}
  	
  	def createLanguagePOTFile()
  	{
  		fsa.generateFile('/languages/'+Auxiliary::pluginNameToFileName(pluginName) + '.pot', '');
 	}
 	
}
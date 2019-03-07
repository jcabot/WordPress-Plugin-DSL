package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

class WPDslRootFilesGenerator {
	
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
  	
  	def createIndexFile()
  	{
  		fsa.generateFile('index.php', '<?php // Silence is golden<?php // Silence is golden')
 	}
 	
 	def createUninstallFile()
  	{
  		fsa.generateFile('uninstall.php', uninstallTemplate)
 	}

	def String uninstallTemplate()
	{
		'''
		<?php

		/**
		 * Fired when the plugin is uninstalled.
		 *
		 * When populating this file, consider the following flow
		 * of control:
		 *
		 * - This method should be static
		 * - Check if the $_REQUEST content actually is the plugin name
		 * - Run an admin referrer check to make sure it goes through authentication
		 * - Verify the output of $_GET makes sense
		 * - Repeat with other user roles. Best directly by using the links/query string parameters.
		 * - Repeat things for multisite. Once for a single site in the network, once sitewide.
		 *
		 * This file may be updated more in future version of the Boilerplate; however, this is the
		 * general skeleton and outline for how the file should work.
		 *
		 * For more information, see the following discussion:
		 * https://github.com/tommcfarlin/WordPress-Plugin-Boilerplate/pull/123#issuecomment-28541913
		 *
		 * @link       «link»
		 * @since      «sinceVersion»
		 *
		 * @package    «pluginName»
		 */
		
		// If uninstall not called from WordPress, then exit.
		if ( ! defined( 'WP_UNINSTALL_PLUGIN' ) ) {
			exit;
		}
		
		'''
	
	
		
	}
	
	
	
}
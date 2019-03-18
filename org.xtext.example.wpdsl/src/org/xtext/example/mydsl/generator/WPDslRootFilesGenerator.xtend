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
	String description
	String author
	String authorURI
	
	new(Resource _resource, IFileSystemAccess2 _fsa, IGeneratorContext _context, String _pluginName, String _sinceVersion, String _link, String _description, String _author, String _authorURI) 
	{
    	resource=_resource;
    	fsa=_fsa;
    	context=_context;
    	pluginName=_pluginName;
    	sinceVersion=_sinceVersion;
    	link=_link;
    	description=_description
    	author=_author
    	authorURI=_authorURI
  	}
  	
  	def createIndexFile()
  	{
  		fsa.generateFile('index.php', '<?php // Silence is golden<?php // Silence is golden')
 	}
 	
 	def createPluginFile()
 	{
 		fsa.generateFile(Auxiliary::pluginNameToFileName(pluginName)+'.php', pluginTemplate)
 	}
 	
 	def createGitIgnoreFile()
 	{
 		fsa.generateFile('.gitignore', gitIgnoreTemplate);
 	}
 	
 	def createUninstallFile()
  	{
  		fsa.generateFile('uninstall.php', uninstallTemplate)
 	}
 	
 	def String pluginTemplate()
 	{
 		'''
 		<?php
 		
 		/**
 		 * The plugin bootstrap file
 		 *
 		 * This file is read by WordPress to generate the plugin information in the plugin
 		 * admin area. This file also includes all of the dependencies used by the plugin,
 		 * registers the activation and deactivation functions, and defines a function
 		 * that starts the plugin.
 		 *
 		 * @link              «link»
 		 * @since             «sinceVersion»
 		 * @package           «Auxiliary::pluginNameToClassName(pluginName)»
 		 *
 		 * @wordpress-plugin
 		 * Plugin Name:       «pluginName»
 		 * Plugin URI:        https://wordpress.org/plugins/«Auxiliary::normalizedPluginName(pluginName)»
 		 * Description:       «description»
 		 * Version:           1.0.0
 		 * Author:            «author»
 		 * Author URI:        «authorURI»
 		 * License:           GPL-2.0+
 		 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 		 * Text Domain:       «Auxiliary::normalizedPluginName(pluginName)»
 		 * Domain Path:       /languages
 		 *
 		 * This plugin is distributed under the terms of the GNU General Public License as published by
 		 * the Free Software Foundation, either version 2 of the License, or  any later version.
 		 *
 		 * This plugin is distributed in the hope that it will be useful,
 		 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 		 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 		 * GNU General Public License for more details.
 		 */
 		
 		
 		// If this file is called directly, abort.
 		if ( ! defined( 'WPINC' ) ) {
 			die;
 		}
 		
 		/**
 		 * Currently plugin version.
 		 * Start at version 1.0.0 and use SemVer - https://semver.org
 		 * Rename this for your plugin and update it as you release new versions.
 		 */
 		define( '«Auxiliary::pluginNameToConstantName(pluginName)»', '1.0.0' );
 		
 		/**
 		 * The code that runs during plugin activation.
 		 * This action is documented in includes/class-«Auxiliary::pluginNameToFileName(pluginName)».php
 		 */
 		function activate_«Auxiliary::pluginNameToFunctionName(pluginName)»() {
 			require_once plugin_dir_path( __FILE__ ) . 'includes/class-«Auxiliary::pluginNameToFileName(pluginName)»-activator.php';
 			«Auxiliary::pluginNameToClassName(pluginName)»_Activator::activate();
 		}
 		
 		/**
 		 * The code that runs during plugin deactivation.
 		 * This action is documented in includes/class-«Auxiliary::pluginNameToFileName(pluginName)»-deactivator.php
 		 */
 		function deactivate_«Auxiliary::pluginNameToFunctionName(pluginName)»() {
 			require_once plugin_dir_path( __FILE__ ) . 'includes/class-«Auxiliary::pluginNameToFileName(pluginName)»-deactivator.php';
 			«Auxiliary::pluginNameToClassName(pluginName)»_Deactivator::deactivate();
 		}
 		
 		register_activation_hook( __FILE__, 'activate_«Auxiliary::pluginNameToFunctionName(pluginName)»' );
 		register_deactivation_hook( __FILE__, 'deactivate_«Auxiliary::pluginNameToFunctionName(pluginName)»' );
 		
 		/**
 		 * The core plugin class that is used to define internationalization,
 		 * admin-specific hooks, and public-facing site hooks.
 		 */
 		require plugin_dir_path( __FILE__ ) . 'includes/class-«Auxiliary::pluginNameToFileName(pluginName)».php';
 		
 		/**
 		 * Begins execution of the plugin.
 		 *
 		 * Since everything within the plugin is registered via hooks,
 		 * then kicking off the plugin from this point in the file does
 		 * not affect the page life cycle.
 		 *
 		 * @since    1.0.0
 		 */
 		function run_«Auxiliary::pluginNameToFunctionName(pluginName)»() {
 		
 			$plugin = new «Auxiliary::pluginNameToClassName(pluginName)»();
 			$plugin->run();
 		
 		}
 		run_«Auxiliary::pluginNameToFunctionName(pluginName)»();
 		
 		
 		
 		'''
 		
 	}
 		
 		
 		
 	
 	def String gitIgnoreTemplate()
 	{
 		'''
 		
 		# Numerous always-ignore extensions
 		*.diff
 		*.err
 		*.orig
 		*.log
 		*.rej
 		*.swo
 		*.swp
 		*.vi
 		*~
 		*.sass-cache
 		
 		# OS or Editor folders
 		.DS_Store
 		Thumbs.db
 		.cache
 		.project
 		.settings
 		.tmproj
 		*.esproj
 		nbproject
 		*.sublime-project
 		*.sublime-workspace
 		
 		# Dreamweaver added files
 		_notes
 		dwsync.xml
 		
 		# Komodo
 		*.komodoproject
 		.komodotools
 		
 		# Folders and files to ignore
 		.hg
 		.svn
 		.CVS
 		intermediate
 		.idea
 		cache
 		
 		vendor/*
 		!vendor/bin/
 		
 		vendor/bin/*
 		!vendor/bin/tests/
 		
 		vendor/bin/tests/*
 		!vendor/bin/tests/acceptance/   ««« this is the only kind of test I use
 		
 		
 		wpcs/
 		composer.json
 		composer.lock
 		
 		
 		'''
 		
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
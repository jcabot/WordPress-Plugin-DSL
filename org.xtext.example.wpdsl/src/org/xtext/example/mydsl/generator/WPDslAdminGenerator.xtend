package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext


class WPDslAdminGenerator {
	
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
	
	
	def createCSSFiles()
  	{
  		fsa.generateFile('/admin/css/'+Auxiliary::pluginNameToFileName(pluginName) + '-admin.css', '/**
 * All of the CSS for your admin-specific functionality should be
 * included in this file.
 */');
 	}
 	
 	def createJSFiles()
  	{
  		fsa.generateFile('/admin/css/'+Auxiliary::pluginNameToFileName(pluginName) + '-admin.js', jsTemplate);
 	}
 	
 	def createPartialsFiles()
  	{
  		fsa.generateFile('/admin/partials/'+Auxiliary::pluginNameToFileName(pluginName) + '-admin-display.php', partialsTemplate);
 	}
 	
  	def createIndexFile()
  	{
  		fsa.generateFile('/admin/index.php', '<?php // Silence is golden<?php // Silence is golden')
 	}
 	
 	def createMainAdminFile()
  	{
  		fsa.generateFile('/admin/class-'+Auxiliary::pluginNameToFileName(pluginName) + '-admin.php', mainadminTemplate);
 	}
 	
 			
 	def String mainadminTemplate()
	{
		'''
		<?php
		
		/**
		 * The admin-specific functionality of the plugin.
		 *
		 * @link       «link»
		 * @since      «sinceVersion»
		 *
	     * @package    «Auxiliary::pluginNameToClassName(pluginName)»
		 * @subpackage «Auxiliary::pluginNameToClassName(pluginName)»\admin
		 */
	
		class «Auxiliary::pluginNameToClassName(pluginName)»_Admin {
		
			/**
			 * The ID of this plugin.
			 *
			 * @access   private
			 * @var      string    $plugin_name    The ID of this plugin.
			 */
			private $plugin_name;
		
			/**
			 * The version of this plugin.
			 *
			 * @access   private
			 * @var      string    $version    The current version of this plugin.
			 */
			private $version;
		
			/**
			 * Initialize the class and set its properties.
			 *
			 * @param      string    $plugin_name       The name of this plugin.
			 * @param      string    $version    The version of this plugin.
			 */
			public function __construct( $plugin_name, $version ) {
		
				$this->plugin_name = $plugin_name;
				$this->version = $version;
		
			}
		
			/**
			 * Register the stylesheets for the admin area.
			 *
			 */
			public function enqueue_styles() {
		
				/**
				 * This function is provided for demonstration purposes only.
				 *
				 * An instance of this class should be passed to the run() function
				 * defined in Plugin_Name_Loader as all of the hooks are defined
				 * in that particular class.
				 *
				 * The Plugin_Name_Loader will then create the relationship
				 * between the defined hooks and the functions defined in this
				 * class.
				 */
		
				wp_enqueue_style( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'css/«Auxiliary::pluginNameToFileName(pluginName)»-admin.css', array(), $this->version, 'all' );
		
			}
		
			/**
			 * Register the JavaScript for the admin area.
			 *
			 */
			public function enqueue_scripts() {
		
				/**
				 * This function is provided for demonstration purposes only.
				 *
				 * An instance of this class should be passed to the run() function
				 * defined in Plugin_Name_Loader as all of the hooks are defined
				 * in that particular class.
				 *
				 * The Plugin_Name_Loader will then create the relationship
				 * between the defined hooks and the functions defined in this
				 * class.
				 */
		
				wp_enqueue_script( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'js/«Auxiliary::pluginNameToFileName(pluginName)»-admin.js', array( 'jquery' ), $this->version, false );
		
			}
		
		}
		
		
		'''
		
	}
 		
 	def String partialsTemplate()
	{
		'''
		<?php
		
		/**
		 * Provide a admin area view for the plugin
		 *
		 * This file is used to markup the admin-facing aspects of the plugin.
		 *
		 *
         * @package    «Auxiliary::pluginNameToClassName(pluginName)»
		 * @subpackage «Auxiliary::pluginNameToClassName(pluginName)»\admin\partials
		 */
		?>
		
		<!-- This file should primarily consist of HTML with a little bit of PHP. -->
		'''
	}
 	
 	def String jsTemplate()
	{
		'''
		(function( $ ) {
			'use strict';
		
			/**
			 * All of the code for your admin-facing JavaScript source
			 * should reside in this file.
			 *
			 * Note: It has been assumed you will write jQuery code here, so the
			 * $ function reference has been prepared for usage within the scope
			 * of this function.
			 *
			 * This enables you to define handlers, for when the DOM is ready:
			 *
			 * $(function() {
			 *
			 * });
			 *
			 * When the window is loaded:
			 *
			 * $( window ).load(function() {
			 *
			 * });
			 *
			 * ...and/or other possibilities.
			 *
			 * Ideally, it is not considered best practise to attach more than a
			 * single DOM-ready or window-load handler for a particular page.
			 * Although scripts in the WordPress core, Plugins and Themes may be
			 * practising this, we should strive to set a better example in our own work.
			 */
		
		})( jQuery );
		
		
		'''
	}
 	
 	
 	
 	
 	
}
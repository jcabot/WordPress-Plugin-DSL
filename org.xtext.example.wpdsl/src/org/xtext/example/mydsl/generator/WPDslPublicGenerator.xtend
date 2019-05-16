package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.xtext.example.mydsl.wpDsl.GenerationConfig

class WPDslPublicGenerator {
	
	Resource resource
	IFileSystemAccess2 fsa
	IGeneratorContext context
	String pluginName
	String sinceVersion
	String link
	boolean extendedPublic
	
	new(Resource _resource, IFileSystemAccess2 _fsa, IGeneratorContext _context, String _pluginName, String _sinceVersion, String _link) 
	{
    	resource=_resource;
    	fsa=_fsa;
    	context=_context;
    	pluginName=_pluginName;
    	sinceVersion=_sinceVersion;
    	link=_link;
        extendedPublic=false;
        var GenerationConfig gc= resource.allContents.filter(GenerationConfig).head;
    	if (gc.^extendedPublicClasses) 
    		extendedPublic=true; 
   	}
  	
  	  	
	def createCSSFiles()
  	{
  		fsa.generateFile('/public/css/'+Auxiliary::pluginNameToFileName(pluginName) + '-public.css', '/**
 * All of the CSS for your public-specific functionality should be
 * included in this file.
 */');
 	}
 	
 	def createJSFiles()
  	{
  		fsa.generateFile('/public/js/'+Auxiliary::pluginNameToFileName(pluginName) + '-public.js', jsTemplate);
 	}
 	
 	def createPartialsFiles()
  	{
  		fsa.generateFile('/public/partials/'+Auxiliary::pluginNameToFileName(pluginName) + '-public-display.php', partialsTemplate);
 	}
 	
  	def createIndexFile()
  	{
  		fsa.generateFile('/public/index.php', '<?php // Silence is golden<?php // Silence is golden')
 	}
 	
 	def createMainPublicFile()
  	{
  		fsa.generateFile('/public/class-'+Auxiliary::pluginNameToFileName(pluginName) + '-public.php', mainpublicTemplate);
 	}
  	
  	
  	def String mainpublicTemplate()
  	{
  		'''
  		<?php
  		
  		/**
  		 * The public-facing functionality of the plugin.
  		 *
  		 * @link       «link»
  		 * @since      «sinceVersion»
  		 *
  		 * @package    «Auxiliary::pluginNameToClassName(pluginName)»
  		 * @subpackage «Auxiliary::pluginNameToClassName(pluginName)»\public
  		*/
  		
  		class «Auxiliary::pluginNameToClassName(pluginName)»_Public {
  		
  			/**
  			 * The ID of this plugin.
  			 *
  			 * @since    1.0.0
  			 * @access   protected
  			 * @var      string    $plugin_name    The ID of this plugin.
  			 */
  			protected $plugin_name;
  		
  			/**
  			 * The version of this plugin.
  			 *
  			 * @since    1.0.0
  			 * @access   protected
  			 * @var      string    $version    The current version of this plugin.
  			 */
  			protected $version;
  		
  			/**
  			 * Initialize the class and set its properties.
  			 *
  			 * @since    1.0.0
  			 * @param      string    $plugin_name       The name of the plugin.
  			 * @param      string    $version    The version of this plugin.
  			 */
  			public function __construct( $plugin_name, $version ) {
  		
  				$this->plugin_name = $plugin_name;
  				$this->version = $version;
  		
  			}
  		
  			/**
  			 * Register the stylesheets for the public-facing side of the site.
  			 *
  			 * @since    1.0.0
  			 */
  			public function enqueue_styles() { 
  		
  				wp_enqueue_style( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'css/«Auxiliary::pluginNameToFileName(pluginName)»-public.css', array(), $this->version, 'all' );
  		
  			}
  		
  			/**
  			 * Register the JavaScript for the public-facing side of the site.
  			 *
  			 * @since    1.0.0
  			 */
  			public function enqueue_scripts() {
  		
  				wp_enqueue_script( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'js/«Auxiliary::pluginNameToFileName(pluginName)»-public.js', array( 'jquery' ), $this->version, false );
  				«IF extendedPublic »
  					$this->define_additional_enqueue_scripts();
  				«ENDIF»
  			}
  		
  			«IF extendedPublic»
  				protected function define_additional_enqueue_scripts(){}
  			«ENDIF»
  		}
  		
  		'''
  		
  		
  	}
  	def String partialsTemplate()
	{
		'''
		<?php
		
		/**
		 * Provide a public area view for the plugin
		 *
		 * This file is used to markup the public-facing aspects of the plugin.
		 *
		 *
         * @package    «Auxiliary::pluginNameToClassName(pluginName)»
		 * @subpackage «Auxiliary::pluginNameToClassName(pluginName)»\public\partials
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
			 * All of the code for your public-facing JavaScript source
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
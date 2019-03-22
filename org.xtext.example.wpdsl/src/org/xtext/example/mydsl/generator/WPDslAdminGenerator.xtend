package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import java.util.Iterator
import org.xtext.example.mydsl.wpDsl.NewMenuItem
import org.xtext.example.mydsl.wpDsl.MenuItem
import org.xtext.example.mydsl.wpDsl.MenuItemInfo

class WPDslAdminGenerator {
	
	Resource resource
	IFileSystemAccess2 fsa
	IGeneratorContext context
	String pluginName
	String sinceVersion
	String link
	boolean newMenu
	Iterable<NewMenuItem> newMenuItems
		
	new(Resource _resource, IFileSystemAccess2 _fsa, IGeneratorContext _context, String _pluginName, String _sinceVersion, String _link, boolean _newMenu) 
	{
    	resource=_resource;
    	fsa=_fsa;
    	context=_context;
    	pluginName=_pluginName;
    	sinceVersion=_sinceVersion;
    	link=_link;
    	newMenu=_newMenu;
    	if(newMenu) newMenuItems=resource.allContents.toIterable.filter(NewMenuItem);
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
  		fsa.generateFile('/admin/js/'+Auxiliary::pluginNameToFileName(pluginName) + '-admin.js', jsTemplate);
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
			
			«IF newMenu»
				/** 
				 *  Creation of the admin menu options
				 */
				public function init_admin_menu() {
					«FOR f:newMenuItems»
						«IF (f.superMenu ===null) »	
							add_menu_page(
								'«f.menuItemInfo.miPageTitle»'		
						«ELSE» 	
						 	add_submenu_page(
						 		'«getParentMenuItemSlug(f.superMenu)»' 
						 		,'«f.menuItemInfo.miPageTitle»'		
						«ENDIF» 
							,'«f.menuItemInfo.miTitle»'
							,'«getMenuItemCapability(f.menuItemInfo)»' 
							,'«getMenuItemSlug(f.menuItemInfo)»'
							,«getMenuItemFunctionWithArrayCallback(f.menuItemInfo)»		
							«getMenuItemIcon(f.menuItemInfo)»
							«getMenuItemPosition(f.menuItemInfo)»	 
							);						
					«ENDFOR»
				}
				««« Second iterator to create the empty functions to be filled to render the linked pages. If two items share the same page we'll have a duplicated function
		
				/** 
				 *  Rendering functions for the admin menu options
				 */
				«FOR g:resource.allContents.toIterable.filter(NewMenuItem)»
					public function	«getMenuItemFunction(g.menuItemInfo)»() {
						echo '<div class="wrap">' . "\n";
						echo '<h1>' . '«g.menuItemInfo.miPageTitle»'. '</h1>' . "\n";
						echo '</div>' . "\n";
					}				
				«ENDFOR»
			
			«ENDIF»
		
		}
		
		'''
	}
	
	def String getMenuItemPosition(MenuItemInfo mi)
	{
		if(mi.miPosition>0) ",'"+mi.miPosition+"'"
	}
	
	def String getMenuItemIcon(MenuItemInfo mi)
	{
		if(mi.miIcon!==null) ",'"+mi.miIcon+"'"
	}
	
	def String getMenuItemFunction(MenuItemInfo mi)
	{
		if(mi.miFunction!==null) mi.miFunction
		else Auxiliary::menuFunctionFromPageTitle(mi.miPageTitle)
	}
	
	def String getMenuItemFunctionWithArrayCallback(MenuItemInfo mi)
	{
		if(mi.miFunction!==null) {"array($this,'"+mi.miFunction+"')"}
		else {"array($this,'"+Auxiliary::menuFunctionFromPageTitle(mi.miPageTitle)+"')"}
	}
	
	def String getMenuItemSlug(MenuItemInfo mi)
	{
		if(mi.miPageSlug!==null) mi.miPageSlug
		else Auxiliary::getMenuSlugFromTitle(mi.miTitle)
	}
	
	def String getMenuItemCapability(MenuItemInfo mi)
	{
		if(mi.miCapability!==null) mi.miCapability
		else 'manage_options'
	}
	
	def String getParentMenuItemSlug(MenuItem mi)
	{
		if (mi.type instanceof NewMenuItem )
		{
			if ((mi.type as NewMenuItem).menuItemInfo.miPageSlug!==null) (mi.type as NewMenuItem).menuItemInfo.miPageSlug
			else Auxiliary::getMenuSlugFromTitle((mi.type as NewMenuItem).menuItemInfo.miTitle)
		}
		
		//To be completed with the slugs of predefined menu pages (tools, settings,...).
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
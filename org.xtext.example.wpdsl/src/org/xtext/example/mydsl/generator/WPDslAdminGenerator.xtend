package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import java.util.Iterator
import org.xtext.example.mydsl.wpDsl.NewMenuItem
import org.xtext.example.mydsl.wpDsl.MenuItem
import org.xtext.example.mydsl.wpDsl.MenuItemInfo
import org.xtext.example.mydsl.wpDsl.Settings
import java.util.Set
import java.util.HashSet
import org.xtext.example.mydsl.wpDsl.GenerationConfig
import org.xtext.example.mydsl.wpDsl.ExistingMenuItem
import org.xtext.example.mydsl.wpDsl.ExistingMenuItemOptions
import org.xtext.example.mydsl.wpDsl.HTMLFormFieldTypes

class WPDslAdminGenerator { 
	
	Resource resource
	IFileSystemAccess2 fsa
	IGeneratorContext context
	String pluginName
	String sinceVersion
	String link
	boolean newMenu
	boolean isSettings
	Iterable<NewMenuItem> newMenuItems
	Set<String> processedMenuItems=new HashSet<String>();
	Settings settings;
	boolean extendedAdmin;
		
	new(Resource _resource, IFileSystemAccess2 _fsa, IGeneratorContext _context, String _pluginName, String _sinceVersion, String _link, boolean _newMenu, boolean _isSettings) 
	{
    	resource=_resource;
    	fsa=_fsa;
    	context=_context;
    	pluginName=_pluginName;
    	sinceVersion=_sinceVersion;
    	link=_link;
    	newMenu=_newMenu;
    	if(newMenu) newMenuItems=resource.allContents.toIterable.filter(NewMenuItem);
    	isSettings=_isSettings;
    	if(isSettings) settings=resource.allContents.toIterable.filter(Settings).head;
    	var GenerationConfig gc= resource.allContents.filter(GenerationConfig).head;
    	extendedAdmin=false;
    	if (gc.^extendedAdminClasses) 
    		extendedAdmin=true; 
    	
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
  		fsa.generateFile('/admin/partials/class-'+Auxiliary::pluginNameToFileName(pluginName) + '-admin-display.php', displayTemplate);
  		fsa.generateFile('/admin/partials/class-'+Auxiliary::pluginNameToFileName(pluginName) + '-admin-settings.php', settingsTemplate);
   	}
 	
  	def createIndexFile()
  	{
  		fsa.generateFile('/admin/index.php', '<?php // Silence is golden<?php // Silence is golden')
 	}
 	
 	def createMainAdminFile()
  	{
  		fsa.generateFile('/admin/class-'+Auxiliary::pluginNameToFileName(pluginName) + '-admin.php', mainAdminTemplate);
 	}
 	
 			
 	def String mainAdminTemplate()
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
			 * @access   protected
			 * @var      string    $plugin_name    The ID of this plugin.
			 */
			protected $plugin_name;
		
			/**
			 * The version of this plugin.
			 *
			 * @access   protected
			 * @var      string    $version    The current version of this plugin.
			 */
			protected $version;
			
			/**
			 * Initialize the class and set its properties.
			 *
			 * @param      string    $plugin_name       The name of this plugin.
			 * @param      string    $version    The version of this plugin.
			 */
			public function __construct( $plugin_name, $version) {
		
				$this->plugin_name = $plugin_name;
				$this->version = $version;
				$this->load_dependencies();
		
			}
			
			protected function load_dependencies() {
				require_once plugin_dir_path( dirname( __FILE__ ) ) .  'admin/partials/class-«Auxiliary::pluginNameToFileName(pluginName)»-admin-display.php';
				«IF extendedAdmin »
					require_once plugin_dir_path( dirname( __FILE__ ) ) .  'admin/partials/class-«Auxiliary::pluginNameToFileName(pluginName)»-admin-display-ext.php';
				«ENDIF»
				«IF isSettings»
					require_once plugin_dir_path( dirname( __FILE__ ) ) .  'admin/partials/class-«Auxiliary::pluginNameToFileName(pluginName)»-admin-settings.php';
				«ENDIF»
			}
			
		
			/**
			 * Register the stylesheets for the admin area.
			 *
			 */
			public function enqueue_styles() {
		
				wp_enqueue_style( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'css/«Auxiliary::pluginNameToFileName(pluginName)»-admin.css', array(), $this->version, 'all' );
		
			}
		
			/**
			 * Register the JavaScript for the admin area.
			 *
			 */
			public function enqueue_scripts() {
		
				wp_enqueue_script( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'js/«Auxiliary::pluginNameToFileName(pluginName)»-admin.js', array( 'jquery' ), $this->version, false );
		
			}
		}
			
		'''
	}
	
	def boolean createdMenuItemFunctionAlready(NewMenuItem item) {
		if(isSettings && settings.pageSettings.type==item) true //The menu item corresponds to the settings page, if existing, is processed afterwards
		else if (processedMenuItems.contains(item.menuItemInfo.miPageTitle)) 
				true
		     else {
		     	processedMenuItems.add(item.menuItemInfo.miPageTitle);
		     	false;
		     }
	}
	
	def String getMenuItemPosition(MenuItemInfo mi)
	{
		if(mi.miPosition>0) ",'"+mi.miPosition+"'"
	}
	
	def String getMenuItemIcon(MenuItemInfo mi)
	{
		if(mi.miIcon!==null) ",'"+mi.miIcon+"'"
	}
	
	def String getNewMenuItemFunction(MenuItemInfo mii)
	{
		if(mii.miFunction!==null) mii.miFunction
		else Auxiliary::menuFunctionFromPageTitle(mii.miPageTitle)
	}
	
	def String getMenuItemFunction(MenuItem mi)
	{
		if(mi.type instanceof NewMenuItem) getNewMenuItemFunction( (mi.type as NewMenuItem).menuItemInfo )
		else Auxiliary::menuFunctionFromPageTitle(mi.name)
	}
	
	def String getMenuItemFunctionWithArrayCallback(MenuItemInfo mi)
	{
		if(isSettings && settings.pageSettings.type instanceof NewMenuItem && (settings.pageSettings.type as NewMenuItem).menuItemInfo.miPageTitle==mi.miPageTitle) 
			 if(mi.miFunction!==null) {"array($this->settings,'"+mi.miFunction+"')"}
			 else {"array($this->settings,'"+Auxiliary::menuFunctionFromPageTitle(mi.miPageTitle)+"')"}
		else if(mi.miFunction!==null) {"array($this,'"+mi.miFunction+"')"}
			 else {"array($this,'"+Auxiliary::menuFunctionFromPageTitle(mi.miPageTitle)+"')"}
	}
	
	def String getMenuItemSlug(MenuItemInfo mi)
	{
		if(mi.miPageSlug!==null) mi.miPageSlug
		else Auxiliary::getMenuSlugFromTitle(mi.miTitle)
	}
	
	def String getMenuItemSlug(MenuItem mi)
	{
		if(mi.type instanceof NewMenuItem) getMenuItemSlug( (mi.type as NewMenuItem).menuItemInfo )
		else 
		{
			if ((mi.type as ExistingMenuItem).option==ExistingMenuItemOptions.DISCUSSION) 'discussion'	
			//to complete with the slugs of other default WP admin pages
		}
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
	
	def String displayTemplate()
	{
		'''
		<?php
		
		/**
		 * Provide a admin area view for the plugin
		 *
		 * This file is used to manage the admin-facing aspects of the plugin.
		 *
		 *
		 * @link       «link»
		 * @since      «sinceVersion»
		 * @package    «Auxiliary::pluginNameToClassName(pluginName)»
		 * @subpackage «Auxiliary::pluginNameToClassName(pluginName)»\admin
		 */
		 		
		class «Auxiliary::pluginNameToClassName(pluginName)»_Admin_Display{
			protected $plugin_name;
		 		
		 	protected $version;
		 	
		 	protected $admin;
		 	
		 	protected $settings;
		 		
		 	/**
		 	 * Initialize the class and set its properties.
		 	 *
		 	 * @param      string    $plugin_name       The name of this plugin.
		 	 * @param      string    $version    The version of this plugin.
		 	 * @param      «Auxiliary::pluginNameToClassName(pluginName)»_Admin    $admin    Link with the main admin object.
		 	 */
		 	public function __construct( $plugin_name, $version, $admin, $settings ) {
		 		$this->plugin_name = $plugin_name;
		 		$this->version = $version;
		 		$this->admin = $admin;
		 		$this->settings = $settings;
		 	}
		 			
				
			«IF newMenu»
				/** 
				 *  Creation of the admin menu items
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
				««« Second iterator to create the empty functions to be filled to render the linked pages. 
				
				/** 
				 *  Rendering functions for the admin menu options
				 */
				«FOR g:resource.allContents.toIterable.filter(NewMenuItem)»
					«IF (!createdMenuItemFunctionAlready(g))»
						public function	«getNewMenuItemFunction(g.menuItemInfo)»() {
							echo '<div class="wrap">' . "\n";
							echo '<h1>' . '«g.menuItemInfo.miPageTitle»'. '</h1>' . "\n";
							echo '</div>' . "\n";
						}				
					«ENDIF» 
				«ENDFOR»
			«ENDIF»
		}
		'''
	}
	
	def String settingsTemplate()
	{
		'''
		<?php
		
		/**
		 * Provide a admin area view for the plugin
		 *
		 * This file is used to manage the settings  of the plugin.
		 *
		 *
		 * @link       «link»
		 * @since      «sinceVersion»
		 * @package    «Auxiliary::pluginNameToClassName(pluginName)»
		 * @subpackage «Auxiliary::pluginNameToClassName(pluginName)»\admin
		 */
				 		
		class «Auxiliary::pluginNameToClassName(pluginName)»_Admin_Settings{
			protected $plugin_name;
				 		
			protected $version;
			
			protected $admin;
				 		
			/**
			 * Initialize the class and set its properties.
			 *
			 * @param      string    $plugin_name       The name of this plugin.
			 * @param      string    $version    The version of this plugin.
			 * @param      «Auxiliary::pluginNameToClassName(pluginName)»_Admin    $admin    Link with the main admin object.
			 */
			public function __construct( $plugin_name, $version, $admin) {
				$this->plugin_name = $plugin_name;
				$this->version = $version;
				$this->admin = $admin;
			}
			 			
		
			«IF isSettings» 
				/** 
				*  Creation of the plugin settings
				 */
				public function init_settings() {
					register_setting(
						«IF settings.pageSettings.type instanceof NewMenuItem»
							'«settings.name»_group',
						«ELSE»
							'«getMenuItemSlug(settings.pageSettings)»',
						«ENDIF»	
						'«settings.name»');	
					
					«FOR ss:settings.ssections»
					  	add_settings_section(
					  		'«ss.name»',
					  		'«ss.desc»',
					  		false, '«getMenuItemSlug(settings.pageSettings)»'
					  	);
					  	
					  	«FOR sf:ss.sfields»
					  		add_settings_field(
					  			'«sf.name»',
					  			'«sf.desc»', 
					  			array($this,'render_«sf.name»_field'),
					  			'«getMenuItemSlug(settings.pageSettings)»',
					  			'«ss.name»'
					  		);
					  			 						
					  	«ENDFOR»		 			«ENDFOR»
				}
					
				
				«IF settings.pageSettings.type instanceof NewMenuItem»
					/** 
					*  Rendering the settings page
					*/
					public function «getMenuItemFunction(settings.pageSettings)»() {
						// Check required user capability
						if ( !current_user_can( 'manage_options' ) )  {
						wp_die( esc_html__( 'You do not have sufficient permissions to access this page.' ) );
						}		 				
	
						// Admin Page Layout
						echo '<div class="wrap">' . "\n";
						echo '	<h1>' . get_admin_page_title() . '</h1>' . "\n";
						echo '	<form action="options.php" method="post">' . "\n";
						settings_fields( '«settings.name»_group' );
						do_settings_sections( '«getMenuItemSlug(settings.pageSettings)»' );
						submit_button();
						echo '</form>' . "\n";
						echo '</div>' . "\n";
					}
		 			
		 		«ENDIF»				
				/** 
				*  Rendering the options fields
				*/
				«FOR ss:settings.ssections»
					«FOR sf:ss.sfields»
						public function render_«sf.name»_field() {
							// Retrieve the full set of options
							$options = get_option( '«settings.name»' );
							// Field output.
							«IF sf.type==HTMLFormFieldTypes.NUMBER || sf.type==HTMLFormFieldTypes.TEXT»
								«IF sf.^default!==null» 
									// Set default value for this particular option in the group
									$value = isset( $options['«sf.name»'] ) ? $options['«sf.name»'] : '«sf.^default»';
								«ELSE»
									$value =  isset( $options['«sf.name»'] ) ? $options['«sf.name»'] : '0';
								«ENDIF» 
								echo '<input type="number" name="«settings.name»[«sf.name»]" size="10" value="' . esc_attr( $value ).'" />';
							«ELSEIF sf.type==HTMLFormFieldTypes.TEXT»
								«IF sf.^default!==null» 
									// Set default value for this particular option in the group
									$value = isset( $options['«sf.name»'] ) ? $options['«sf.name»'] : '«sf.^default»';
								«ELSE»
									$value = isset( $options['«sf.name»'] ) ? $options['«sf.name»'] : ' ';
								«ENDIF» 
								echo '<input type="number" name="«settings.name»[«sf.name»]" size="10" value="' . esc_attr( $value ).'" />';
							«ELSEIF sf.type==HTMLFormFieldTypes.RANGE»
								«IF sf.^default!==null» 
									// Set default value for this particular option in the group
									$value = isset( $options['«sf.name»'] ) ? $options['«sf.name»'] : '«sf.^default»';
								«ELSE»
									$value = $value = isset( $options['«sf.name»'] ) ? $options['«sf.name»'] : '«sf.min»';
								«ENDIF» 
								echo '<input type="range" name="«settings.name»[«sf.name»]" size="10" value="' . esc_attr( $value ).'" min="«sf.^min»" max="«sf.^max»" />';
							«ELSEIF sf.type==HTMLFormFieldTypes.CHECKBOX»
								$checked = isset( $options['«sf.name»'] ) ? $options['«sf.name»'] : '0';
								echo '<input type="checkbox" name="«settings.name»[«sf.name»]" value="1"'  . checked(1, $checked, false) .'/>';
							«ELSE»
								echo '<input type="number" name="«settings.name»[«sf.name»]" size="10" value="' . esc_attr( $value ).'" />';
		 					«ENDIF»
						}
		 			«ENDFOR»
		 		«ENDFOR»
			«ENDIF»
		}
		 		
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
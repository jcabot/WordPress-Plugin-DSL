package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.xtext.example.mydsl.wpDsl.GenerationConfig

class WPDslCoreFilesGenerator {
	
	Resource resource
	IFileSystemAccess2 fsa
	IGeneratorContext context
	String pluginName
	String sinceVersion
	String link
	boolean adminSide
	boolean publicSide
	boolean newMenu
	boolean settings
	boolean extendedAdmin
	boolean extendedPublic

	new(Resource _resource, IFileSystemAccess2 _fsa, IGeneratorContext _context, String _pluginName, String _sinceVersion, String _link, boolean _adminSide, boolean _publicSide, boolean _newMenu, boolean _settings) 
	{
    	resource=_resource;
    	fsa=_fsa;
    	context=_context;
    	pluginName=_pluginName;
    	sinceVersion=_sinceVersion;
    	link=_link;
    	adminSide=_adminSide;
    	publicSide=_publicSide;
    	newMenu=_newMenu;
    	settings=_settings;
 	
		var GenerationConfig gc= resource.allContents.filter(GenerationConfig).head;
       	extendedAdmin=false;extendedPublic=false;
    	if (gc.^extendedAdminClasses) 
    		extendedAdmin=true; 
    	if (gc.^extendedPublicClasses) 
    		extendedPublic=true; 
	
	}
	
	
	def createActivatorFile()
  	{
  		fsa.generateFile('/includes/class-'+Auxiliary::pluginNameToFileName(pluginName) + '-activator.php', activatorTemplate);
 	}

	def createDeactivatorFile()
  	{
  		fsa.generateFile('/includes/class-'+Auxiliary::pluginNameToFileName(pluginName) + '-deactivator.php', deactivatorTemplate);
 	}

	def createi18nFile()
  	{
  		fsa.generateFile('/includes/class-'+Auxiliary::pluginNameToFileName(pluginName) + '-i18n.php', i18nTemplate);
 	}
 		
	def createIndexFile()
  	{
  		fsa.generateFile('/includes/index.php', '<?php // Silence is golden<?php // Silence is golden')
 	}
 	
 	def createLoaderFile()
  	{
  		fsa.generateFile('/includes/class-'+Auxiliary::pluginNameToFileName(pluginName) + '-loader.php', loaderTemplate);
 	}
 	

	def createMainPluginFile()
  	{
  		fsa.generateFile('/includes/class-'+Auxiliary::pluginNameToFileName(pluginName) + '.php', mainPluginTemplate);
 	}
 	
 	private def String mainPluginTemplate()
	{
		'''
		<?php
		
		/**
		 * The file that defines the core plugin class
		 *
		 * A class definition that includes attributes and functions used across both the
		 * public-facing side of the site and the admin area.
		 *
		 * @link       «link»
		 * @since      «sinceVersion»
		 * @package    «Auxiliary::pluginNameToClassName(pluginName)»
		 * @subpackage «Auxiliary::pluginNameToClassName(pluginName)»\includes
		 */
		
		class «Auxiliary::pluginNameToClassName(pluginName)» {
		
			/**
			 * The loader that's responsible for maintaining and registering all hooks that power
			 * the plugin.
			 *
			 * @var      «Auxiliary::pluginNameToClassName(pluginName)»_Loader    $loader    Maintains and registers all hooks for the plugin.
			 */
			protected $loader;
		
			/**
			 * The unique identifier of this plugin.
			 *
			 * @var      string    $plugin_name    The string used to uniquely identify this plugin.
			 */
			protected $plugin_name;
		
			/**
			 * The current version of the plugin.
			 *
			 * @var      string    $version    The current version of the plugin.
			 */
			protected $version;
		
			/**
			 * Define the core functionality of the plugin.
			 *
			 * Set the plugin name and the plugin version that can be used throughout the plugin.
			 * Load the dependencies, define the locale, and set the hooks for the admin area and
			 * the public-facing side of the site.
			 *
			 */
			public function __construct() {
				if ( defined( '«Auxiliary::pluginNameToConstantName(pluginName)»_VERSION' ) ) {
					$this->version = «Auxiliary::pluginNameToConstantName(pluginName)»_VERSION;
				} else {
					$this->version = '1.0.0';
				}
				$this->plugin_name = '«Auxiliary::normalizedPluginName(pluginName)»';
		
				$this->load_dependencies();
				$this->set_locale();
				«IF adminSide»
					$this->define_admin_hooks();
				«ENDIF»
				«IF publicSide»
					$this->define_public_hooks();
				«ENDIF»
		
			}
		
			/**
			 * Load the required dependencies for this plugin.
			 *
			 * Include the following files that make up the plugin:
			 *
			 * - «Auxiliary::pluginNameToClassName(pluginName)»_Loader. Orchestrates the hooks of the plugin.
			 * - «Auxiliary::pluginNameToClassName(pluginName)»_i18n. Defines internationalization functionality.
			 * - «Auxiliary::pluginNameToClassName(pluginName)»_Admin. Defines all hooks for the admin area.
			 * - «Auxiliary::pluginNameToClassName(pluginName)»_Public. Defines all hooks for the public side of the site.
			 *
			 * Create an instance of the loader which will be used to register the hooks
			 * with WordPress.
			 *
			 * @access   private
			 */
			private function load_dependencies() {
		
				/**
				 * The class responsible for orchestrating the actions and filters of the
				 * core plugin.
				 */
				require_once plugin_dir_path( dirname( __FILE__ ) ) . 'includes/class-«Auxiliary::pluginNameToFileName(pluginName)»-loader.php';
		
				/**
				 * The class responsible for defining internationalization functionality
				 * of the plugin.
				 */
				require_once plugin_dir_path( dirname( __FILE__ ) ) . 'includes/class-«Auxiliary::pluginNameToFileName(pluginName)»-i18n.php';
		
				«IF adminSide»
					/**
					 * The class responsible for defining all actions that occur in the admin area.
					 */
					require_once plugin_dir_path( dirname( __FILE__ ) ) . 'admin/class-«Auxiliary::pluginNameToFileName(pluginName)»-admin.php';
					«IF extendedAdmin»
						require_once plugin_dir_path( dirname( __FILE__ ) ) . 'admin/class-«Auxiliary::pluginNameToFileName(pluginName)»-admin-ext.php';
					«ENDIF»
					
				«ENDIF»
		
				«IF publicSide»
					/**
					 * The class responsible for defining all actions that occur in the public-facing
					 * side of the site.
					 */
					require_once plugin_dir_path( dirname( __FILE__ ) ) . 'public/class-«Auxiliary::pluginNameToFileName(pluginName)»-public.php';
					«IF extendedPublic»
						require_once plugin_dir_path( dirname( __FILE__ ) ) . 'public/class-«Auxiliary::pluginNameToFileName(pluginName)»-public-ext.php';
					«ENDIF»
				«ENDIF»
				$this->loader = new «Auxiliary::pluginNameToClassName(pluginName)»_Loader();
			}
		
			/**
			 * Define the locale for this plugin for internationalization.
			 *
			 * Uses the «Auxiliary::pluginNameToClassName(pluginName)»_i18n class in order to set the domain and to register the hook
			 * with WordPress.
			 *
			 * @access   private
			 */
			private function set_locale() {
				$plugin_i18n = new «Auxiliary::pluginNameToClassName(pluginName)»_i18n();
				$this->loader->add_action( 'plugins_loaded', $plugin_i18n, 'load_plugin_textdomain' );
			}
		
			«IF adminSide»
				/**
				 * Register all of the hooks related to the admin area functionality
				 * of the plugin.
				 *
				 * @access   private
				 */
				protected function define_admin_hooks() {
					«IF extendedAdmin»
						$plugin_admin = new «Auxiliary::pluginNameToClassName(pluginName)»_Admin_Ext( $this->get_plugin_name(), $this->get_version() );
					«ELSE»
						$plugin_admin = new «Auxiliary::pluginNameToClassName(pluginName)»_Admin( $this->get_plugin_name(), $this->get_version() );
					«ENDIF»
					$this->loader->add_action( 'admin_enqueue_scripts', $plugin_admin, 'enqueue_styles' );
					$this->loader->add_action( 'admin_enqueue_scripts', $plugin_admin, 'enqueue_scripts' );
					$plugin_settings=null;
					«IF settings»
						$plugin_settings = new «Auxiliary::pluginNameToClassName(pluginName)»_Admin_Settings( $this->get_plugin_name(), $this->get_version(),$plugin_admin );
						$this->loader->add_action( 'admin_init', $plugin_settings, 'init_settings' ); 	// Registering also the plugin settings
					«ENDIF»
					«IF newMenu»
						«IF extendedAdmin»
							$plugin_display = new «Auxiliary::pluginNameToClassName(pluginName)»_Admin_Display_Ext( $this->get_plugin_name(), $this->get_version(), $plugin_admin, $plugin_settings );
						«ELSE»
							$plugin_display = new «Auxiliary::pluginNameToClassName(pluginName)»_Admin_Display( $this->get_plugin_name(), $this->get_version(), $plugin_admin, $plugin_settings );
						«ENDIF»
						$this->loader->add_action( 'admin_menu', $plugin_display, 'init_admin_menu' ); 	// Registering also the main plugin menu
					«ENDIF»
					«IF extendedAdmin»
						$this->define_additional_admin_hooks($plugin_admin);
					«ENDIF»
				}
				
				«IF extendedAdmin»
					protected function define_additional_admin_hooks($plugin_admin){}
				«ENDIF»
				
			«ENDIF»
		
			«IF publicSide»
				/**
				 * Register all of the hooks related to the public-facing functionality
				 * of the plugin.
				 *
				 * @access   private
				 */
				protected function define_public_hooks() {
					«IF extendedPublic»
						$plugin_public = new «Auxiliary::pluginNameToClassName(pluginName)»_Public_Ext( $this->get_plugin_name(), $this->get_version() );
					«ELSE»
						$plugin_public = new «Auxiliary::pluginNameToClassName(pluginName)»_Public( $this->get_plugin_name(), $this->get_version() );
					«ENDIF»
					$this->loader->add_action( 'wp_enqueue_scripts', $plugin_public, 'enqueue_styles' );
					$this->loader->add_action( 'wp_enqueue_scripts', $plugin_public, 'enqueue_scripts' );
					«IF extendedPublic»
						$this->define_additional_public_hooks($plugin_public);
					«ENDIF»
				}
				«IF extendedPublic»
					protected function define_additional_public_hooks($plugin_public){}
				«ENDIF»
			«ENDIF»
		
			/**
			 * Run the loader to execute all of the hooks with WordPress.
			 *
			 */
			public function run() {
				$this->loader->run();
			}
		
			/**
			 * The name of the plugin used to uniquely identify it within the context of
			 * WordPress and to define internationalization functionality.
			 *
			 * @return    string    The name of the plugin.
			 */
			public function get_plugin_name() {
				return $this->plugin_name;
			}
		
			/**
			 * The reference to the class that orchestrates the hooks with the plugin.
			 *
			 * @return    Plugin_Name_Loader    Orchestrates the hooks of the plugin.
			 */
			public function get_loader() {
				return $this->loader;
			}
		
			/**
			 * Retrieve the version number of the plugin.
			 *
			 * @return    string    The version number of the plugin.
			 */
			public function get_version() {
				return $this->version;
			}
		
		}
		
 		'''
 			
 	}
 		
 	

	private def String activatorTemplate()
	{
		'''
		<?php
		
		/**
		 * Fired during plugin activation
		 * This class defines all code necessary to run during the plugin's activation.
		 *
		 * @since      «sinceVersion»
		 * @package    «Auxiliary::pluginNameToClassName(pluginName)»
		 * @subpackage «Auxiliary::pluginNameToClassName(pluginName)»\includes
		 */
		
		class «Auxiliary::pluginNameToClassName(pluginName)»_Activator{
		
			public static function activate() {
		
			}
		
		}
		'''
	}
	
	private def String deactivatorTemplate()
	{
		'''
		<?php
		
		/**
		 * Fired during plugin deactivation
		 * This class defines all code necessary to run during the plugin's deactivation.
		 *
		 * @since      «sinceVersion»
		 * @package    «Auxiliary::pluginNameToClassName(pluginName)»
		 * @subpackage «Auxiliary::pluginNameToClassName(pluginName)»\includes
		 */
				
		class «Auxiliary::pluginNameToClassName(pluginName)»_Deactivator{
		
			public static function deactivate() {
		
			}
		
		}
		'''
	}
	
	private def String i18nTemplate()
	{
		'''
		<?php
			
		/**
		 * Define the internationalization functionality
		 *
		 * Loads and defines the internationalization files for this plugin
		 * so that it is ready for translation.
		 *
		 * @since      «sinceVersion»
		 * @package    «Auxiliary::pluginNameToClassName(pluginName)»
		 * @subpackage «Auxiliary::pluginNameToClassName(pluginName)»\includes
		 * @package   
		 */
		
		class «Auxiliary::pluginNameToClassName(pluginName)»_i18n {
		
			/**
			 * Load the plugin text domain for translation.
			 *
			 */
			public function load_plugin_textdomain() {
		
				load_plugin_textdomain(
					'«Auxiliary::pluginNameToClassName(pluginName)»',
					false,
					dirname( dirname( plugin_basename( __FILE__ ) ) ) . '/languages/'
				);
		
			}
		}
		'''
	}
	
	private def String loaderTemplate()
	{
		'''
		<?php
		
		/**
		 * Register all actions and filters for the plugin
		 *
		 * @link       «link»
		 * @since      «sinceVersion»
		 *
		 * @package    «Auxiliary::pluginNameToClassName(pluginName)»
		 * @subpackage «Auxiliary::pluginNameToClassName(pluginName)»\includes
		 */
		
		/**
		 * Register all actions and filters for the plugin.
		 *
		 * Maintain a list of all hooks that are registered throughout
		 * the plugin, and register them with the WordPress API. Call the
		 * run function to execute the list of actions and filters.
		 *
		 */
		class «Auxiliary::pluginNameToClassName(pluginName)»_Loader {
		
			/**
			 * The array of actions registered with WordPress.
			 *
			 * @var      array    $actions    The actions registered with WordPress to fire when the plugin loads.
			 */
			protected $actions;
		
			/**
			 * The array of filters registered with WordPress.
			 *
			 * @var      array    $filters    The filters registered with WordPress to fire when the plugin loads.
			 */
			protected $filters;
		
			/**
			 * Initialize the collections used to maintain the actions and filters.
			 *
			 */
			public function __construct() {
		
				$this->actions = array();
				$this->filters = array();
		
			}
		
			/**
			 * Add a new action to the collection to be registered with WordPress.
			 *
			 * @param    string               $hook             The name of the WordPress action that is being registered.
			 * @param    object               $component        A reference to the instance of the object on which the action is defined.
			 * @param    string               $callback         The name of the function definition on the $component.
			 * @param    int                  $priority         Optional. The priority at which the function should be fired. Default is 10.
			 * @param    int                  $accepted_args    Optional. The number of arguments that should be passed to the $callback. Default is 1.
			 */
			public function add_action( $hook, $component, $callback, $priority = 10, $accepted_args = 1 ) {
				$this->actions = $this->add( $this->actions, $hook, $component, $callback, $priority, $accepted_args );
			}
		
			/**
			 * Add a new filter to the collection to be registered with WordPress.
			 *
			 * @param    string               $hook             The name of the WordPress filter that is being registered.
			 * @param    object               $component        A reference to the instance of the object on which the filter is defined.
			 * @param    string               $callback         The name of the function definition on the $component.
			 * @param    int                  $priority         Optional. The priority at which the function should be fired. Default is 10.
			 * @param    int                  $accepted_args    Optional. The number of arguments that should be passed to the $callback. Default is 1
			 */
			public function add_filter( $hook, $component, $callback, $priority = 10, $accepted_args = 1 ) {
				$this->filters = $this->add( $this->filters, $hook, $component, $callback, $priority, $accepted_args );
			}
		
			/**
			 * A utility function that is used to register the actions and hooks into a single
			 * collection.
			 *
			 * @access   private
			 * @param    array                $hooks            The collection of hooks that is being registered (that is, actions or filters).
			 * @param    string               $hook             The name of the WordPress filter that is being registered.
			 * @param    object               $component        A reference to the instance of the object on which the filter is defined.
			 * @param    string               $callback         The name of the function definition on the $component.
			 * @param    int                  $priority         The priority at which the function should be fired.
			 * @param    int                  $accepted_args    The number of arguments that should be passed to the $callback.
			 * @return   array                                  The collection of actions and filters registered with WordPress.
			 */
			private function add( $hooks, $hook, $component, $callback, $priority, $accepted_args ) {
		
				$hooks[] = array(
					'hook'          => $hook,
					'component'     => $component,
					'callback'      => $callback,
					'priority'      => $priority,
					'accepted_args' => $accepted_args
				);
		
				return $hooks;
		
			}
		
			/**
			 * Register the filters and actions with WordPress.
			 *
			 */
			public function run() {
		
				foreach ( $this->filters as $hook ) {
					add_filter( $hook['hook'], array( $hook['component'], $hook['callback'] ), $hook['priority'], $hook['accepted_args'] );
				}
		
				foreach ( $this->actions as $hook ) {
					add_action( $hook['hook'], array( $hook['component'], $hook['callback'] ), $hook['priority'], $hook['accepted_args'] );
				}
		
			}
		
		}
		

		'''
		
	}

}
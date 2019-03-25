<?php

/**
 * The admin-specific functionality of the plugin.
 *
 * @link       https://wordpress.org/plugins/serious-duplicated-terms/
 * @since      1.0.0
 * @package    Serious_Duplicated_Terms
 * @subpackage Serious_Duplicated_Terms\admin
 */

class Serious_Duplicated_Terms_Admin {

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

		wp_enqueue_style( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'css/serious-duplicated-terms-admin.css', array(), $this->version, 'all' );

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

		wp_enqueue_script( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'js/serious-duplicated-terms-admin.js', array( 'jquery' ), $this->version, false );

	}
	
	/** 
	 *  Creation of the admin menu options
	 */
	public function init_admin_menu() {
		add_menu_page(
			'Analysis Duplicated Terms'		
			,'Serious Duplicated Terms'
			,'manage_options' 
			,'analysis'
			,array($this,'analysis_duplicated_terms')		
			);						
		add_submenu_page(
			'analysis' 
			,'Analysis Duplicated Terms'		
			,'Analysis'
			,'manage_options' 
			,'analysis'
			,array($this,'analysis_duplicated_terms')		
			);						
		add_submenu_page(
			'analysis' 
			,'Configuration Duplicated Terms'		
			,'Configuration'
			,'manage_options' 
			,'configuration'
			,array($this,'configuration_duplicated_terms')		
			);						
	}
			
	/** 
	 *  Rendering functions for the admin menu options
	 */
	public function	analysis_duplicated_terms() {
		echo '<div class="wrap">' . "\n";
		echo '<h1>' . 'Analysis Duplicated Terms'. '</h1>' . "\n";
		echo '</div>' . "\n";
	}				
	public function	analysis_duplicated_terms() {
		echo '<div class="wrap">' . "\n";
		echo '<h1>' . 'Analysis Duplicated Terms'. '</h1>' . "\n";
		echo '</div>' . "\n";
	}				
	public function	configuration_duplicated_terms() {
		echo '<div class="wrap">' . "\n";
		echo '<h1>' . 'Configuration Duplicated Terms'. '</h1>' . "\n";
		echo '</div>' . "\n";
	}				
			

}


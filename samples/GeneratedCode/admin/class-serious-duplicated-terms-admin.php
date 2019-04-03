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
	 *  Creation of the admin menu items
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
			
	
	/** 
	 *  Creation of the plugin settings
	 */
	public function init_settings() {
		
		register_setting(
			'settingsPlugin_group',
			'configuration'  					);
		
	
		add_settings_section(
			'consider',
			'Look for duplicates in tags, categories or both',
			false, 
			'configuration'
		);
	
	
		add_settings_field(
			'tags',
			'Tags', 
			array($this,'render_tags_field'),
			'configuration',
			'consider'
		);
		
	
		add_settings_field(
			'categories',
			'Categories', 
			array($this,'render_categories_field'),
			'configuration',
			'consider'
		);
		
	
	
		add_settings_section(
			'distance',
			'Consider Levenshtein Distance',
			false, 
			'configuration'
		);
	
	
		add_settings_field(
			'levenshtein',
			'Levenhstein', 
			array($this,'render_levenshtein_field'),
			'configuration',
			'distance'
		);
		
	
		add_settings_field(
			'maxDistance',
			'Max Distance', 
			array($this,'render_maxDistance_field'),
			'configuration',
			'distance'
		);
		
	
	}
	
	/** 
	*  Rendering the settings page
	*/
	public function	configuration_duplicated_terms() {
	
		// Check required user capability
		if ( !current_user_can( 'manage_options' ) )  {
			wp_die( esc_html__( 'You do not have sufficient permissions to access this page.' ) );
		}
	
		// Admin Page Layout
		echo '<div class="wrap">' . "\n";
		echo '	<h1>' . get_admin_page_title() . '</h1>' . "\n";
		echo '	<form action="options.php" method="post">' . "\n";
	
		settings_fields( 'settingsPlugin_group' );
		do_settings_sections( 'configuration' );
		submit_button();
	
		echo '</form>' . "\n";
		echo '</div>' . "\n";
	
	}
	
	/** 
	*  Rendering the options fields
	*/
	
	public function render_tags_field() {
	
		// Retrieve the full set of options
		$options = get_option( 'configuration' );
		// Field output.
		$checked = isset( $options['tags'] ) ? $options['tags'] : '0';
		echo '<input type="checkbox" name="configuration[tags]" value="1"'  . checked(1, $checked, false) .'/>';
	}
	
	public function render_categories_field() {
	
		// Retrieve the full set of options
		$options = get_option( 'configuration' );
		// Field output.
		$checked = isset( $options['categories'] ) ? $options['categories'] : '0';
		echo '<input type="checkbox" name="configuration[categories]" value="1"'  . checked(1, $checked, false) .'/>';
	}
	
	public function render_levenshtein_field() {
	
		// Retrieve the full set of options
		$options = get_option( 'configuration' );
		// Field output.
		$checked = isset( $options['levenshtein'] ) ? $options['levenshtein'] : '0';
		echo '<input type="checkbox" name="configuration[levenshtein]" value="1"'  . checked(1, $checked, false) .'/>';
	}
	
	public function render_maxDistance_field() {
	
		// Retrieve the full set of options
		$options = get_option( 'configuration' );
		// Field output.
		// Set default value for this particular option in the group
		$value = isset( $options['maxDistance'] ) ? $options['maxDistance'] : '3';
		echo '<input type="number" name="configuration[maxDistance]" size="10" value="' . esc_attr( $value ).'" />';
	}

}


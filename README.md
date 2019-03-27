# WordPress Plugin DSL
 A simple DSL (Domain-Specific Language) to generate scaffolding code for WordPress Plugins. 
 
## Contents

The DSL is defined with [Xtext](https://www.eclipse.org/Xtext/). An [Xtend](https://www.eclipse.org/xtend/) template takes care of generating an initial boilerplate version of the WordPress plugin according to the [WordPress Boilerplate Project](https://github.com/DevinVinson/WordPress-Plugin-Boilerplate).
 
 ### WordPress DSL
 Right now the language supports the definition of very basic (but still useful to save time when writing boilerplate code) plugin information:
 
 - Plugin Name
 - General Options to populare the file's headers (author, author URI, description,...)
 - Whether your plugin has an admin view, a public view or both
 - Menu information
 
 The grammar is of the WordPress Plugin DSL is available in the *WPDsl.xtext* file. For a usage example, see the sample plugin definition in the samples folder. 
 
  ### WordPress Code Generator
  Based on the above information, we generate a ready-to-use plugin that you can move to your WordPress installation and activate. The sample folder includes, as an example, the WordPress code generated from the sample plugin.
  
 
  ### Installation
  The DSL is a standard Xtext project. If you know how to use Xtext, getting stated with the WordPress DSL is straighforward. If not, I   recommend you to familiarize yourself with Xtext first with this [15 min tutorial](https://www.eclipse.org/Xtext/documentation/102_domainmodelwalkthrough.html)
  
  
## Contribution
This is a project aimed to help in the development of my own plugins. It will grow as I detect new opportunities to automate other plugin development aspects (e.g. settings). 

Contributions are welcome but as long as they remain aligned with the above goal. 

## License
The WordPress Plugin Boilerplate is licensed under the GPL v2 or later.

* This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License, version 2, as published by the Free Software Foundation.

* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

* A copy of the license is included in the root of the plugin’s directory. The file is named LICENSE.

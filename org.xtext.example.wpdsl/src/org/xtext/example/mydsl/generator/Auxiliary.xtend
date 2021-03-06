package org.xtext.example.mydsl.generator

class Auxiliary {
	
	static def String pluginNameToFileName(String pluginName)
	{
		pluginName.toLowerCase.replaceAll(' ','-');
	}
	
	static def String pluginNameToClassName(String pluginName) //keeps the upper cases in the original name definition
	{
		pluginName.replaceAll(' ','_');
	}
	
	static def String pluginNameToConstantName(String pluginName)
	{
		pluginName.toUpperCase.replaceAll(' ','_');
	}
	
	static def String normalizedPluginName(String pluginName)
	{
		pluginName.toLowerCase.replaceAll(' ','-');
	}
	
	static def String pluginNameToFunctionName(String pluginName)
	{
		pluginName.toLowerCase.replaceAll(' ','_');
	}
	
	static def String getMenuSlugFromTitle(String menuName)
	{
		menuName.toLowerCase.replaceAll(' ','-');
	}
	
	static def String menuFunctionFromPageTitle(String pageTitle)
	{
		pageTitle.toLowerCase.replaceAll(' ','_');
	}
	
}
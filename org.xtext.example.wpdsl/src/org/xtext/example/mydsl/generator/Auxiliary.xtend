package org.xtext.example.mydsl.generator

class Auxiliary {
	
	static def String pluginNameToFileName(String pluginName)
	{
		pluginName.toLowerCase.replaceAll(' ','-');
	}
	
	static def String pluginNameToClassName(String pluginName)
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
	
	
}
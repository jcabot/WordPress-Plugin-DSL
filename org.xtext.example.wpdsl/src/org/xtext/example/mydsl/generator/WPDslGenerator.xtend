/*
 * generated by Xtext 2.16.0
 */
package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.xtext.example.mydsl.wpDsl.MenuItem
import org.xtext.example.mydsl.wpDsl.PluginDefinition
import org.xtext.example.mydsl.wpDsl.GlobalInfo
import org.xtext.example.mydsl.wpDsl.Admin
import org.xtext.example.mydsl.wpDsl.PublicView
import org.xtext.example.mydsl.wpDsl.GenerationConfig
import org.xtext.example.mydsl.wpDsl.NewMenuItem
import org.xtext.example.mydsl.wpDsl.Settings

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class WPDslGenerator extends AbstractGenerator {
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		
		var GlobalInfo gi= resource.allContents.filter(GlobalInfo).head;
		var String pluginName=gi.pluginName; //var String pluginName=resource.allContents.filter(GlobalInfo).map[pluginName].head;
		var String link=gi.link;  
		var String sinceVersion=gi.since;
		var String description=gi.description
		var String author=gi.author;
		var String authorURI=gi.authorURI; 
		var boolean publicSide=!resource.allContents.filter(PublicView).empty;
		var boolean adminSide=!resource.allContents.filter(Admin).empty
		var boolean isNewMenu=!resource.allContents.filter(NewMenuItem).empty
		var boolean isSettings=!resource.allContents.filter(Settings).empty
								
		var rootFilesGen = new WPDslRootFilesGenerator(resource, fsa, context, pluginName, sinceVersion, link, description, author, authorURI)
		rootFilesGen.createPluginFile
		rootFilesGen.createIndexFile
		rootFilesGen.createUninstallFile
		if (!resource.allContents.filter(GenerationConfig).map[gitIgnore].empty)
		{
			rootFilesGen.createGitIgnoreFile;
		}
		
		var coreFilesGen = new WPDslCoreFilesGenerator(resource, fsa, context, pluginName, sinceVersion, link, adminSide, publicSide, isNewMenu, isSettings)
		coreFilesGen.createIndexFile
		coreFilesGen.createActivatorFile
		coreFilesGen.createDeactivatorFile
		coreFilesGen.createLoaderFile
		coreFilesGen.createi18nFile
		coreFilesGen.createMainPluginFile
		
		var langGen = new WPDslLanguageSupportGenerator(resource, fsa, context, pluginName, sinceVersion, link)
		langGen.createLanguagePOTFile
		
		if (adminSide)
		{
			var adminGen = new WPDslAdminGenerator(resource, fsa, context, pluginName, sinceVersion, link, isNewMenu, isSettings);
			adminGen.createCSSFiles
			adminGen.createIndexFile
			adminGen.createJSFiles
			adminGen.createMainAdminFile
			adminGen.createPartialsFiles
		}		
		
		if (publicSide)
		{
			var publicGen = new WPDslPublicGenerator(resource, fsa, context, pluginName, sinceVersion, link);
			publicGen.createCSSFiles
			publicGen.createIndexFile
			publicGen.createJSFiles
			publicGen.createMainPublicFile
			publicGen.createPartialsFiles
		}		
		
	
		
	//	fsa.generateFile('plugin.php', 'Menu items: ' + 
	//		resource.allContents
	//			.filter(MenuItem)
	//			.map[name]
	//			.join(', '))
	}
	
	
	//def createCorePluginStructure(IFileSystemAccess2 fsa){
	//	fsa.generateFile('/testfolder2/plugin.php','');
		
		
	
}

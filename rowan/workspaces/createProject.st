"Workspace used to create the skeleton Rowan project for T2F2T-Conversion"
| project componentName projectName packageName className |
projectName := 'T2F2T-Conversion'.
componentName := 'Core'.
packageName := projectName, '-Core'.
className := 'T2F2TConversion'.
project := (Rowan newProjectNamed: projectName)
	packageConvention: 'Rowan';
	packageFormat: 'tonel';
	projectsHome: '/home/dhenrich/rogue/_homes/rogue/_home/shared/repos';
	gitUrl: 'file:///home/dhenrich/rogue/_homes/rogue/_home/shared/repos/T2F2T-Conversion';
  projectSpecFile: 'rowan/', projectName, '.ston';
	revision: 'gemstone';
	yourself.
project _projectSpecification
	componentsPath: 'rowan/components';
	packagesPath: 'rowan/src';
	projectsPath: 'rowan/projects';
	specsPath: 'rowan/specs';
	projectSpecPath: 'rowan';
	specName: projectName.

project
	addTopLevelComponentNamed: componentName;
	addPackageNamed: packageName toComponentNamed: componentName;	
	yourself.
(project packageNamed: packageName)
	addClassNamed: className 
		super: 'Object' 
		category: projectName.
(project resolve)
	export;
	exportLoadSpecification


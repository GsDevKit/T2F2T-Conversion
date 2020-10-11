create command
_createProject: projectName packageConvention: packageConvention root: root t2f2tDir: t2f2tDir packageDir: packageDir componentName: componentName format: format
	| project resolvedProject |
	project := (Rowan newProjectNamed: projectName)
		packageConvention: packageConvention;
		packageFormat: format;
		diskUrl: 'file://' , root pathString;
		projectSpecFile: t2f2tDir , '/' , format , '.ston';
		specName: format;
		componentsPath: t2f2tDir , '/components';
		packagesPath: packageDir;
		projectsPath: t2f2tDir , '/projects';
		specsPath: t2f2tDir , '/specs';
		projectSpecPath: t2f2tDir;
		projectSpecName: format;
		yourself.

	project addTopLevelComponentNamed: componentName.

	resolvedProject := project resolve.
	Rowan projectTools createV2
		createResolvedProjectRepository: resolvedProject repository.
	resolvedProject
		exportProjectSpecification;
		exportProjects;
		exportComponents;
		exportLoadSpecification
create command
createForProject: projectRootPath t2f2t: t2f2tDir tonel: tonelPackageDir filetree: filePackageDir stdout: stdout
	^ self
		createForProject: projectRootPath
		t2f2t: t2f2tDir
		tonel: tonelPackageDir
		filetree: filePackageDir
		projectName: 't2f2tMeta'
		componentName: 'Core'
		packageConvention: 'Monticello'
		stdout: stdout
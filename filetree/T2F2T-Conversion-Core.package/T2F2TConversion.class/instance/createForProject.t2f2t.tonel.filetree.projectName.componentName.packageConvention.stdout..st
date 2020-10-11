create command
createForProject: projectRootPath t2f2t: t2f2tDir tonel: tonelPackageDir filetree: filetreePackageDir projectName: projectName componentName: componentName packageConvention: packageConvention stdout: stdout
	| projectRoot t2f2tRoot |
	projectRoot := projectRootPath asFileReference.
	projectRoot exists
		ifFalse: [ 
			^ self
				error:
					'The project directory ' , projectRootPath printString , ' does not exist.'
				to: stdout ].
	t2f2tRoot := projectRoot.

	(projectRoot / tonelPackageDir) ensureCreateDirectory.
	self
		_createProject: projectName
		packageConvention: packageConvention
		root: t2f2tRoot
		t2f2tDir: t2f2tDir
		packageDir: tonelPackageDir
		componentName: componentName
		format: 'tonel'.

	(projectRoot / filetreePackageDir) ensureCreateDirectory.
	self
		_createProject: projectName
		packageConvention: packageConvention
		root: t2f2tRoot
		t2f2tDir: t2f2tDir
		packageDir: filetreePackageDir
		componentName: componentName
		format: 'filetree'
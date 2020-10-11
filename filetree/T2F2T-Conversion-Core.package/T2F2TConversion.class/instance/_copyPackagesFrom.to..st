filetree/tonel commands
_copyPackagesFrom: sourceProject to: targetProject
	sourceProject
		readPackageNamesBlock: [ :packageName | 
			"read all of the packages"
			true ].
	targetProject packagesRoot ensureCreateDirectory.
	targetProject packages: sourceProject packages.
	targetProject exportPackages
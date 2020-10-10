"Workspace used to load the T2F2T-Conversion project into GemStone (with Rowan
	already installed) using tonel format packages"
| projectParentPath |
projectParentPath := System gemEnvironmentVariable: 'ROWAN_PROJECTS_HOME'.
(Rowan
	projectFromUrl: 'file://', projectParentPath, '/T2F2T-Conversion/rowan/specs/tonel.ston'
	gitUrl: 'file://', projectParentPath, '/T2F2T-Conversion') load

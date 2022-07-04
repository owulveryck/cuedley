package cuedley

let _mapKind = 0
let _anchorKind = 1
let _componentKind = 2

#Map: {
	title?: string
	_kind:  _mapKind
	anchors: [...#anchor]
}

#element: {
	X: int
	Y: int
	...
}

#Note: #element & {
	description: string
}

#Evolution: {
	name?:  string
	stage1: string
	stage2: string
	stage3: string
	stage4: string
}

_stageOfEvolutionConstraints: *50 | int & >=0 & <=100
stage1:                       0
stage2:                       17
stage3:                       40
stage4:                       70

#anchor: {
	name: string
	expresses: [...#need]
	visibility:       0
	StageOfEvolution: _stageOfEvolutionConstraints
	kind:             _anchorKind
}

#need: {
	name: string
	visibility: {for dep in fulfilledBy {>=dep.visibility & int & <=0}}
	StageOfEvolution: _stageOfEvolutionConstraints
	fulfilledBy: [...#fulfiller]
}

#fulfiller: {
	name: string
	visibility: {for dep in dependsOn {>=dep.visibility & int & <=0}}
	StageOfEvolution: _stageOfEvolutionConstraints
	dependsOn: [...#component]
}

#component: {
	name: string
	visibility: {for dep in dependsOn {>=dep.visibility & int & <=0}}
	StageOfEvolution: _stageOfEvolutionConstraints
	dependsOn: [...#component]
	_kind: _componentKind
}

package cuedley

let mapKind = 0
let anchorKind = 1
let componentKind = 2
let fulfillerKind = 4

_debug: 4

#Map: {
	title?: string
	kind:   mapKind
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
	visibility:       string | {int & <100 & >=0} | *0
	StageOfEvolution: string
	kind:             anchorKind
}

#need: {
	name:             string
	visibility:       string | {int & <100 & >=0} | *0
	StageOfEvolution: string
	fulfilledBy: [...#fulfiller]
}

#fulfiller: {
	name:             string
	visibility:       string | {int & <100 & >=0} | *0
	StageOfEvolution: string
	kind:             fulfillerKind
	dependsOn: [...#component]
}

#component: {
	name:             string
	visibility:       string | {int & <100 & >=0}
	StageOfEvolution: string
	kind:             componentKind
	dependsOn: [...#component]
}

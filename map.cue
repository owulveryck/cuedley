package cuedley

#Map: {
	title?: string
	components: [...#Component]
}

#element: {
	X: int
	Y: int
	...
}

#Component: #element & {
	title: string
}

#Anchor: #element & {
	title: string
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

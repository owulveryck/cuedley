package main

import "github.com/owulveryck/cuedley"

myMap: cuedley.#Map & {
	title: "title"
	anchors: [public, business]
}

public: cuedley.#anchor & {
	name: "Public"
	expresses: [thirst]
	StageOfEvolution: "|..........|..........|..........|...x......|"
}

business: cuedley.#anchor & {
	name: "Business"
	expresses: [thirst]
	StageOfEvolution: "|..........|..........|......x..|..........|"
}

thirst: cuedley.#need & {
	name: "thirst"
	fulfilledBy: [cupOfTea]
	StageOfEvolution: "|..........|..........|..........|.....x....|"
}
cupOfTea: cuedley.#fulfiller & {
	name:             "Cup Of Tea"
	visibility:       10
	StageOfEvolution: "|..........|..........|......x...|........|"
	dependsOn: [cup, tea, hotWater]
}
cup: cuedley.#component & {
	visibility:       cupOfTea.visibility - 10
	StageOfEvolution: "|..........|..........|..........|..x.......|"
	name:             "Cup"
}

myPipeline: cuedley.#pipeline & {
	entryPoint: cupOfTea
	elements: [cup, tea, hotWater]
}

group: cuedley.#group & {
	legend: "build in-house"
	elements: [cupOfTea, tea]
}

tea: cuedley.#component & {
	visibility:       cup.visibility + 10
	StageOfEvolution: "|..........|..........|..........|...x......|"
	name:             "Tea"
}
hotWater: cuedley.#component & {
	visibility:       cup.visibility + 20
	StageOfEvolution: "|..........|..........|..........|..x.......|"
	name:             "Hot Water"
	dependsOn: [water, kettle]
}

water: cuedley.#component & {
	visibility:       hotWater.visibility + 10
	StageOfEvolution: "|..........|..........|..........|.....x....|"
	name:             "Water"
}
kettle: cuedley.#component & {
	visibility:       hotWater.visibility + 15
	StageOfEvolution: "|..........|......x...|..........|..........|"
	name:             "Kettle"
	dependsOn: [power]
}

power: cuedley.#component & {
	visibility:       kettle.visibility + 20
	StageOfEvolution: "|..........|..........|.........x|..........|"
	name:             "Power"
}

package main

import "github.com/owulveryck/cuedley"

myMap: cuedley.#Map & {
	anchors: [public, business]
}

public: cuedley.#anchor & {
	name: "Public"
	expresses: [thirst]
}

business: cuedley.#anchor & {
	name: "Business"
	expresses: [thirst]
}

thirst: cuedley.#need & {
	name:       "thirst"
	visibility: 0
	fulfilledBy: [cupOfTea]
	StageOfEvolution: 55
}

cupOfTea: cuedley.#fulfiller & {
	name:       "Cup Of Tea"
	visibility: business.visibility - 5
	dependsOn: [tea, cup, hotWater]
}

tea: cuedley.#component & {
	visibility: business.visibility - 10
	name:       "Tea"
}
cup: cuedley.#component & {
	visibility: business.visibility - 15
	name:       "Cup"
}

hotWater: cuedley.#component & {
	name:       "Hot Water"
	visibility: business.visibility - 20
	dependsOn: [water, kettle]
}

kettle: cuedley.#component & {
	name:       "Kettle"
	visibility: business.visibility - 30
	dependsOn: [power]
}

power: cuedley.#component & {
	visibility: business.visibility - 40
	name:       "Power"
}

water: cuedley.#component & {
	visibility: business.visibility - 35
	name:       "Water"
}

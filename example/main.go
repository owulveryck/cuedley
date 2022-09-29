package main

import (
	"image"
	"log"
	"math"
	"os"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"
	"github.com/owulveryck/wardleyToGo"
	"github.com/owulveryck/wardleyToGo/components/wardley"
	svgmap "github.com/owulveryck/wardleyToGo/encoding/svg"
)

var identifier int64

func main() {
	// We need a cue.Context, the New'd return is ready to use
	ctx := cuecontext.New()

	// cuedleyDefs := load.Instances([]string{"github.com/owulveryck/cuedley/example"}, nil)
	cuedleyDefs := load.Instances([]string{"."}, nil)
	allDefinitions, err := ctx.BuildInstances(cuedleyDefs)
	if err != nil {
		log.Fatal(err)
	}
	definitions := allDefinitions[0]
	m := wardleyToGo.NewMap(0)

	var theMap cue.Path
	componentMap := make(map[string]*wardley.Component)
	definitions.Walk(
		func(v cue.Value) bool {
			return v.IncompleteKind().IsAnyOf(cue.StructKind)
		},
		func(v cue.Value) {
			p := v.Path()
			selectors := p.Selectors()
			if len(selectors) >= 1 && selectors[len(selectors)-1].String() == "kind" {
				d, err := v.Uint64()
				if err != nil {
					log.Fatal("kind should be an int", err)
				}
				switch d {
				case 0:
					theMap = cue.MakePath(selectors[0])
					log.Printf("%v is a map", selectors[0])
					/*
						case 1:
							log.Printf("%v is an anchor", selectors[0])
						case 2:
							log.Printf("%v is a component", selectors[0])
					*/
				default:
					c := componentFromValue(definitions.LookupPath(cue.MakePath(selectors[0])))
					componentMap[c.Label] = c
					err := m.AddComponent(c)
					if err != nil {
						log.Fatal(err)
					}
				}
			}

		})
	mapValue := definitions.LookupPath(theMap)
	var allPaths []cue.Path
	mapValue.Walk(
		func(v cue.Value) bool {
			return true
		},
		func(v cue.Value) {
			p := v.Path()
			sels := p.Selectors()
			if len(sels) > 0 && sels[len(sels)-1].String() == "name" {
				allPaths = append(allPaths, p)
			}
		})
	for i, p := range allPaths {
		if len(p.Selectors()) > 4 { // 4 is the first anchor
			for j := i; j >= 0; j-- {
				if len(allPaths[j].Selectors()) < len(p.Selectors()) {
					dest := definitions.LookupPath(p)
					source := definitions.LookupPath(allPaths[j])
					s, _ := source.String()
					d, _ := dest.String()
					if componentMap[s] != nil && componentMap[d] != nil {
						m.SetCollaboration(&wardley.Collaboration{
							F:     componentMap[s],
							T:     componentMap[d],
							Type:  wardley.RegularEdge,
							Label: "",
						})
					}
					//log.Printf("%v -> %v", source, dest)
					break
				}
			}
		}
	}

	e, err := svgmap.NewEncoder(os.Stdout, image.Rect(0, 0, 1100, 900), image.Rect(30, 50, 1070, 850))
	if err != nil {
		log.Fatal(err)
	}
	defer e.Close()
	style := svgmap.NewWardleyStyle(svgmap.DefaultEvolution)
	e.Init(style)
	err = e.Encode(m)
	if err != nil {
		log.Fatal(err)
	}
}

func componentFromValue(v cue.Value) *wardley.Component {
	id := identifier
	identifier++
	c := wardley.NewComponent(id)
	c.Placement = image.Point{}
	label, err := v.LookupPath(cue.ParsePath("name")).String()
	if err != nil {
		panic("label should be a string")
	}
	c.Label = label
	evol, err := v.LookupPath(cue.ParsePath("StageOfEvolution")).String()
	if err != nil {
		panic("evol should be a string")
	}
	c.Placement.X = computeEvolution(evol)
	c.Placement.Y = computeVisibility(v.LookupPath(cue.ParsePath("visibility")))

	return c
}

func computeEvolution(s string) int {
	currentStage := -1
	currentCursor := 0
	stages := make([]int, 5)
	cursor := 0
	stage := 0
	for _, c := range s {
		if c == '|' {
			currentCursor = 0
			currentStage++
			continue
		}
		if c != 'x' {
			currentCursor++
		}
		if c == 'x' {
			cursor = currentCursor
			stage = currentStage
		}
		stages[currentStage]++
	}
	stagePositions := []float64{0, 17.4, 40, 70, 100}
	position := stagePositions[stage] + (stagePositions[stage+1]-stagePositions[stage])*float64(cursor)/float64(stages[stage])
	return int(math.Round(position))
}
func computeVisibility(v cue.Value) int {
	s, err := v.String()
	if err != nil {
		visitibility, err := v.Int64()
		if err != nil {
			panic(err)
		}
		return int(visitibility)
	}
	currentStage := -1
	currentCursor := 0
	stages := make([]int, 5)
	cursor := 0
	stage := 0
	for _, c := range s {
		if c == '|' {
			currentCursor = 0
			currentStage++
			continue
		}
		if c != 'x' {
			currentCursor++
		}
		if c == 'x' {
			cursor = currentCursor
			stage = currentStage
		}
		stages[currentStage]++
	}
	stagePositions := []float64{0, 25, 50, 75, 100}
	position := stagePositions[stage] + (stagePositions[stage+1]-stagePositions[stage])*float64(cursor)/float64(stages[stage])
	return int(math.Round(position))
}

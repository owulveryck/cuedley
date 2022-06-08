package cuedley

import (
	"tool/cli"
	"text/template"
)

command: genCheatSheet: {
	cli.Print & {
		text: template.Execute(_cheatSheetTmpl, {Characteristics: characteristics, GeneralProperties: generalProperties})
	}
}

_cheatSheetTmpl: """
	|Stage (of activity) | I | II | III | IV |
	|---|---|---|---|---|
	|_Characteristics_|   |   |   |   |	
	{{ range $k, $v := .Characteristics -}}
	| {{$k}} | {{$v.stage1}} | {{$v.stage2}} | {{$v.stage3}} | {{$v.stage4}} |	
	{{end -}}
	|_General Properties_|   |   |   |   |	
	{{ range $k, $v := .GeneralProperties -}}
	| {{$k}} | {{$v.stage1}} | {{$v.stage2}} | {{$v.stage3}} | {{$v.stage4}} |	
	{{end}}
	"""

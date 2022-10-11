repo := "github:carpinchomug/nixos-config"


alias sw := switch-local
alias hl := switch-home-local


update:
	nix flake update


switch: (_switch repo "thinkpad")

switch-local: (_switch "." "thinkpad")


switch-home: (_switch-home repo "akiyoshi")

switch-home-local: (_switch-home "." "akiyoshi")


_switch flake machine:
	nixos-rebuild switch --flake {{flake}}#{{machine}} --use-remote-sudo


_switch-home flake user:
	nix build {{flake}}#homeConfigurations.{{user}}.activationPackage -o generation
	./generation/activate
	rm generation

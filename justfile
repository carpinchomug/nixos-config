repo := "github:carpinchomug/nixos-config"


alias sl := switch-local
alias hl := switch-home-local


update:
	nix flake update

test: test-system test-home

test-system:
	nixos-rebuild test --flake .#thinkpad --use-remote-sudo

test-home:
	nix build .#homeConfigurations.akiyoshi.activationPackage --dry-run

switch:
	nixos-rebuild switch --flake {{repo}}#thinkpad --use-remote-sudo

switch-local:
	nixos-rebuild switch --flake .#thinkpad --use-remote-sudo

switch-home:
	nix build {{repo}}#homeConfigurations.akiyoshi.activationPackage
	./result/activate
	rm result

switch-home-local:
	nix build .#homeConfigurations.akiyoshi.activationPackage
	./result/activate
	rm result

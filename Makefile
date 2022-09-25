repo = github:carpinchomug/nixos-config

update:
	nix flake update

switch:
	nixos-rebuild switch --use-remote-sudo --flake "$(repo)#thinkpad"

home-switch:
	home-manager switch --flake "$(repo)#akiyoshi"

cleanup:
	sudo nix-collect-garbage -d
	nixos-rebuild boot --use-remote-sudo --flake "$(repo)#thinkpad"
	home-manager switch --flake "$(repo)#akiyoshi"

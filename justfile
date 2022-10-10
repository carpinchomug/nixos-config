repo := "github:carpinchomug/nixos-config"

update:
	nix flake update

switch:
	nixos-rebuild switch --use-remote-sudo --flake "{{repo}}#thinkpad"

switch-home:
	home-manager switch --flake "{{repo}}#akiyoshi"

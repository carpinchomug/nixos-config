{
  systemd.network.enable = true;

  services.resolved = {
    enable = true;

    # https://github.com/systemd/systemd/issues/10579
    # dnssec = "false";
  };
}

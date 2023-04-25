let
  yavko = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDGzxjYoalywVSGUXuU6cBDhuwgIIpElTjkz9fpBIxJ"
  ];
in {
  "pass.age".publicKeys = yavko;
  "downonspot.age".publicKeys = yavko;
}

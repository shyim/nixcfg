{ lib
, ...
}: {
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      # oracle arm
      hostName = "100.111.47.100";
      maxJobs = 10;
      sshKey = "/Users/shyim/.nix-ssh-key";
      sshUser = "root";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      system = "aarch64-linux";
    }
    {
      # bob m1
      hostName = "100.119.170.85";
      maxJobs = 10;
      sshKey = "/Users/shyim/.nix-ssh-key";
      sshUser = "root";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      system = "x86_64-darwin";
    }
    {
      # bob m1
      hostName = "100.119.170.85";
      maxJobs = 10;
      sshKey = "/Users/shyim/.nix-ssh-key";
      sshUser = "root";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      system = "aarch64-darwin";
    }
    {
      # hetzner intel
      hostName = "138.201.121.30";
      maxJobs = 10;
      sshKey = "/Users/shyim/.nix-ssh-key";
      sshUser = "root";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      system = "x86_64-linux";
    }
  ];
}

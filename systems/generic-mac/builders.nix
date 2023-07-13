{ lib
, ...
}: {
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "shea.bunny-chickadee.ts.net";
      maxJobs = 10;
      sshKey = "/Users/shyim/.ssh/nix";
      sshUser = "root";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      system = "aarch64-linux";
    }
    {
      hostName = "138.201.121.30";
      maxJobs = 10;
      sshKey = "/Users/shyim/.ssh/nix";
      sshUser = "root";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      system = "x86_64-linux";
    }
    {
      hostName = "88.99.6.33";
      maxJobs = 10;
      sshKey = "/Users/shyim/.ssh/nix";
      sshUser = "root";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "system" "features" ];
      system = "x86_64-linux";
    }
  ];
}

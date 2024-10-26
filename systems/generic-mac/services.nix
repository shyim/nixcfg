{ pkgs
, ...
}: {
  users.users.shyim = {
    name = "shyim";
    home = "/Users/shyim";
    shell = pkgs.fish;
  };
}

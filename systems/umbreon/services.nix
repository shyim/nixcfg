{ pkgs
, lib
, config
, ...
}: {
  users.users.shyim = {
    name = "shyim";
    home = "/Users/shyim";
  };
}

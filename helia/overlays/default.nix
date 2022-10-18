let 
  toplevel = {
    pkgs = (import ./pkgs);
  };
in
  with toplevel; [
    pkgs
  ]
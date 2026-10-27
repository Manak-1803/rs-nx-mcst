{
  flake.modules.generic.nocturne = {lib, ...}: {
    specialisation = lib.genAttrs [ "server" "windows" ] (name: {
    configuration = {
      environment.etc."specialisation".text = name;
    };
  });
  };
}

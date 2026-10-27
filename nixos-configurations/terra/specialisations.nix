{
  flake.modules.generic.terra = {lib, ...}: {
    specialisation = lib.genAttrs [ "windows" ] (name: {
    configuration = {
      environment.etc."specialisation".text = name;
    };
  });
  };
}

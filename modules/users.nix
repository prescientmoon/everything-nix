{ ... }: {
  users = {
    mutableUsers = false;
    users.adrielus = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      hashedPassword =
        "$6$5NX9cuUbX$yjiBbroplRLanLfJ5wNjjsd9rSvN81BCNEnuF2DUgfMa/TPYdl5PUYcWF52VxNbisDPsR2Q5EhgNrgALatpT3/";
    };
  };
}

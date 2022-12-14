self: super:
with self; {
  discord = unstable.discord;
  vscode = unstable.vscode;
  tetrio-desktop = unstable.tetrio-desktop;
  sumneko-lua-language-server = super.sumneko-lua-language-server.overrideAttrs (old: rec {
    version = "unstable-2022-12-09";

    src = fetchFromGitHub {
      owner = "sumneko";
      repo = "lua-language-server";
      rev = "6d740a76ce170c396108e8bfc26b1286ac32c62f";
      sha256 = "0p9nyhzciw1i6r5crmrwx80ma21dxd3hl9sgvq6qc6qnmn67w8km";
      fetchSubmodules = true;
    };
  });
}

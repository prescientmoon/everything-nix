Consumers of this module can pick between the [`iwd`](./iwd), [`wpa-supplicant`](./wpa_supplicant.nix), or the [`network-manager`](./network-manager.nix) backends. I usually prefer the latter (since the associated NixOS module allows declaratively configuring the networks), but the network card on _calypso_ is very bad, and `iwd` seems to work slightly less terribly than `wpa-supplicant`.

The certificate is taken from the source code of the python script found at [cat.eduroam.org](https://cat.eduroam.org/) for my university.

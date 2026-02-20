# Bees is a de-duplication daemon for BTRFS.
let
  # Where to store the hashmap containing bees' state.
  # workDir = "/persist/state/.bees";
in
{
  # Automatically create the required subvolume if it doesn't exist. I'm not
  # sure this is super necessary, but oh well...
  # systemd.tmpfiles.rules = [ "Q ${workDir}" ];

  services.beesd.filesystems.root = {
    # inherit workDir;

    spec = "/";

    # I think the service will require that much RAM. For the extent to be as
    # small as possible, I think this needs to offer 1GiB of memory per 256GiB
    # of storage.
    #
    # Since the filesystem in question has 384GiB of storage, we will thus
    # allocate 1.5 GiB for the service.
    hashTableSizeMB = 1536;

    # The current load average can be checked with `uptime`. This flag tells
    # bees to throttle itself if the load average goes over this threshold. I
    # chose a random value, which I might tweak in the future.
    extraOptions = [
      "--loadavg-target"
      "4.0"
    ];
  };
}

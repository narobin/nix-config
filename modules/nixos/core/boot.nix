{ ... }:
{
  security = {
    # lockKernelModules = true;
    protectKernelImage = true;
  };

  nix.settings.allowed-users = [ "@users" ];

  boot = {
    # kernelModules = [ ];
    blacklistedKernelModules = [
      # Unused/Obscure Filesystems
      "cramfs"
      "freevxfs"
      "jffs2"
      "hfs"
      "hfsplus"
      "squashfs"
      "udf"
      "ntfs"
      "ntfs3"
      "exfat"
      "lockd"
      "sunrpc"
      "minix"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "jfs"
      "hpfs"
      "f2fs"
      "efs"
      "erofs"
      "exofs"
      "adfs"
      "affs"
      "bfs"
      "befs"

      # Uncommon / Legacy Network Protocols
      "dccp"
      "sctp"
      "rds"
      "tipc"
      "atm"
      "can"
      "n-hdlc"
      "ax25"
      "netrom"
      "x25"
      "rose"
      "decnet"
      "econet"
      "af_802154"
      "ipx"
      "appletalk"
      "psnap"
      "p8023"
      "p8022"
      "mkiss"
      "sixpack"

      # Network Filesystems
      # TODO: remove those needed for intranet drive
      "nfs"
      "nfsd"
      "nfsv3"
      "nfsv4"
      "cifs"
      "smbfs"
      "ksmbd"
      "gfs2"
      "afs"
      "9p"
      "ncpfs"

      # Firewire
      "firewire-core"
      "firewire-ohci"
      "firewire-sbp2"

      # CD-ROM
      "cdrom"
      "sr_mod"

      # Testing
      "vivid"
      "btrfs"

      # Intel
      "intel_mei"
      "intel_pmt_telemetry"
      "intel_pmt_class"

      # RNDIS
      "rndis_host"

      # Framebuffer
      "fbcon"
      "vesafb"
      "efifb"

      # Joysticks
      "joydev"
      "input_joystick"

      # Floppy Disks
      "floppy"
    ];
    kernelParams = [
      "slab_nomerge"
      "page_poison=1"
      "page_alloc.shuffle=1"
      "debugfs=off"
    ];
    kernel.sysctl = {
      "kernel.kptr_restrict" = "2";
      "net.core.bpf_jit_enable" = false;
      "kernel.ftrace_enabled" = false;
      "kernel.io_uring_disabled" = 2;

      "net.ipv4.conf.all.log_martians" = true;
      "net.ipv4.conf.all.rp_filter" = "1";
      "net.ipv4.conf.default.log_martians" = true;
      "net.ipv4.conf.default.rp_filter" = "1";

      "net.ipv4.icmp_echo_ignore_broadcasts" = true;

      "net.ipv4.conf.all.accept_redirects" = false;
      "net.ipv4.conf.all.secure_redirects" = false;
      "net.ipv4.conf.default.accept_redirects" = false;
      "net.ipv4.conf.default.secure_redirects" = false;
      "net.ipv6.conf.all.accept_redirects" = false;
      "net.ipv6.conf.default.accept_redirects" = false;

      "net.ipv4.conf.all.send_redirects" = false;
      "net.ipv4.conf.default.send_redirects" = false;
    };
  };
  
  environment = {
    memoryAllocator.provider = "hardened_malloc";
  };
}

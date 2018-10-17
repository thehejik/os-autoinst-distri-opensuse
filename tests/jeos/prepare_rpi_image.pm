# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2018 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Dump RPi image to an empty drive to publish
# Maintainer: Tomas Hehejik <thehejik@suse.com>

use base "opensusebasetest";
use strict;
use testapi;
use serial_terminal 'select_virtio_console';
use File::Basename;

sub run {
    select_virtio_console();
    my $version = get_var('VERSION');
    my $build = get_var('BUILD');
    my $rpi_image_url = "http://openqa.suse.de/assets/hdd/SLES$version-JeOS.aarch64-15.1-RaspberryPi-Build$build.raw.xz";
    assert_script_run("time curl -s -O -L $rpi_image_url");
    # Determine first harddrive without any partition - on aarch64 HDD_2 is detected as vda for some reason
    my $empty_drive = script_output('lsblk -pdsn -o NAME | grep -v "/dev/[sv]d.[[:digit:]]" | head -n 1');
    my $rpi_image = basename($rpi_image_url);
    assert_script_run("time xzcat $rpi_image | dd bs=4M of=$empty_drive iflag=fullblock oflag=direct && sync", 600);
}

1;

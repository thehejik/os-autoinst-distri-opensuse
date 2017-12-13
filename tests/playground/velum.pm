# SUSE's openQA tests
#
# Copyright © 2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: example how to use selenimu in openQA
# Maintainer: Tomas Hehejik <thehejik@suse.com>

use base "opensusebasetest";
use strict;
use testapi;
use selenium;

use utils 'zypper_call', 'pkcon_quit';

sub run {
    my $self = shift;
    select_console(get_var('VIRTIO_CONSOLE') ? 'root-virtio-terminal' : 'root-console');
    pkcon_quit();
    add_chromium_repos;
    install_chromium;
    install_java;
    enable_selenium_port;
    serial_for_user;

    my $driver = selenium_driver();

    # selenium test starts here
    $driver->get('https://carpo.qa.suse.cz/');
    $driver->mouse_move_to_location(element => wait_for_xpath("//input[\@id='user_email']"));
    $driver->click('LEFT');
    $driver->send_keys_to_active_element('thehejik@suse.com');
    $driver->mouse_move_to_location(element => wait_for_xpath("//input[\@id='user_password']"));
    $driver->click('LEFT');
    $driver->send_keys_to_active_element('susetesting');
    $driver->mouse_move_to_location(element => wait_for_xpath("//button[contains(\@class, 'btn')]"));
    $driver->click('LEFT');

    wait_for_xpath("//footer[\@class='row']");

    $driver->quit();
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:

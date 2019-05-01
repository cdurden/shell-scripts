#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Sort of mini driver.
Read a specific InputDevice (my_mx_mouse),
monitoring for special thumb button
Use uinput (virtual driver) to create a mini keyboard
Send alt keystroke on that keyboard

To set up a persistent device file at the path /dev/dellactivepen, create the file /etc/udev/rules.d/93-dellactivepen.conf.rules with the following contents:

KERNEL=="event[0-9]*", SUBSYSTEM=="input", SUBSYSTEMS=="input", ATTRS{name}=="Wacom HID 482E Pen", SYMLINK+="dellactivepen", GROUP="dellactivepen", MODE="640"
To set uinput permissions, so that this file can be run as a user in the 'input' group, create the file /etc/udev/rules.d/94-dellactivepen.uinput.rules with the following contents:

KERNEL=="uinput", GROUP="input", MODE="660"

Then run this python script when X starts (e.g. run it in xinitrc) 
"""

from evdev import InputDevice, categorize, ecodes
import uinput

# Initialize keyboard, choosing used keys
mod_keyboard = uinput.Device([
    uinput.KEY_KEYBOARD,
    uinput.KEY_LEFTALT,
    uinput.KEY_LEFTCTRL,
    uinput.KEY_RIGHTCTRL,
    uinput.KEY_LEFTMETA,
    uinput.KEY_F4,
    ])

mod_key = uinput.KEY_LEFTALT

# Sort of initialization click (not sure if mandatory)
# ( "I'm-a-keyboard key" )
mod_keyboard.emit_click(uinput.KEY_KEYBOARD)

# Useful to list input devices
#for i in range(0,15):
#    dev = InputDevice('/dev/input/event{}'.format(i))
#    print(dev)

# Declare device patch.
# I made a udev rule to assure it's always the same name
dev = InputDevice('/dev/dellactivepen')
#print(dev)
mod_key_on = False

# Infinite monitoring loop
for event in dev.read_loop():
    # My thumb button code (use "print(event)" to find)
    print(event.code)
    if event.code == 321 :
        # Button status, 1 is down, 0 is up
        if event.value == 1:
            mod_keyboard.emit(mod_key, 1)
            mod_key_on = True
        elif event.value == 0:
            mod_keyboard.emit(mod_key, 0)
            mod_key_on = False

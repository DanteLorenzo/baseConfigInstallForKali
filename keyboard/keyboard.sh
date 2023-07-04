#!/bin/bash

#Uncommnet this to dump keyboards shortcuts
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > dump_1
dconf dump /org/gnome/desktop/wm/keybindings/ > dump_2
dconf dump /org/gnome/shell/keybindings/ > dump_3
dconf dump /org/gnome/mutter/keybindings/ > dump_4
dconf dump /org/gnome/mutter/wayland/keybindings/ > dump_5

#Uncoment this to load keyboards shortcuts 
#cat dump_1 | dconf load /org/gnome/settings-daemon/plugins/media-keys/
#cat dump_2 | dconf load /org/gnome/desktop/wm/keybindings/
#cat dump_3 | dconf load /org/gnome/shell/keybindings/
#cat dump_4 | dconf load /org/gnome/mutter/keybindings/
#cat dump_5 | dconf load /org/gnome/mutter/wayland/keybindings/


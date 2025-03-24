#!/bin/bash

# Nombre del archivo de backup con fecha y hora
backup_file="$HOME/mydesktop.sd.tar.gz"

echo "Making desktop backup."
# Directorios generales
tar -czvf "$backup_file" \
    "$HOME/.config/dconf" \
    "$HOME/.local/share/backgrounds" \
    "$HOME/.themes" \
    "$HOME/.icons" \
    "$HOME/.local/share/icons" \
    "$HOME/.local/share/fonts" \
    "$HOME/.fonts" \
    "$HOME/.config/gtk-4.0" \
    "$HOME/.config/gtk-3.0" \
    # GNOME
    "$HOME/.local/share/gnome-background-properties" \
    "$HOME/.local/share/gnome-shell" \
    "$HOME/.local/share/nautilus-python" \
    "$HOME/.local/share/nautilus" \
    "$HOME/.local/share/gnome-control-center"

echo "Desktop Backup compled!"

echo "Making dconf backup"
dconf dump / > "$HOME/dconf.conf" && echo "Dconf backup DONE" || echo "Dconf backup ERROR"
echo "Making pacman backup packages"
pacman -Qq | grep -v "$(pacman -Qqm)" > "$HOME/pacmanPackages.txt" && echo "Pacman OK" || echo "Pacman ERROR"
echo "Making AUR backup packages"
pacman -Qqm > "$HOME/aurPackages.txt" && echo "AUR OK" || echo "AUR ERROR"
echo "Adding changes to chezmoi"
chezmoi managed | grep -v "run_once" | grep -vE '^\.config$' | xargs -rn1 chezmoi add -v

# echo "CHANGED ADDED SUCCESSFULLY" || echo "ERROR ADDING CHANGES"

echo "Commiting and pushing changes"
actual_dir="$(pwd)"
cd "$(chezmoi source-path)"
git add .
git commit -am "new backup"
git push 
cd $actual_dir
echo "ALL DONE"
rm -f "$HOME/mydesktop.sd.tar.gz" "$HOME/dconf.conf" "$HOME/pacmanPackages.txt" "$HOME/aurPackages.txt"

# Command for restoring desktop configuration tar file
tar -xzvf mydesktop.sd.tar.gz -C /

# Command for restoring dconf settings
dconf load / < dconf.conf

# Commands for installing pacman and aur packages
pacman -S --needed - < pacmanPackages.txt 
yay -S --needed - < aurPackages.txt

# Commands for restoring chezmoi dotfiles
 
chezmoi init --repo "url"
chezmoi apply

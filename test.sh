#!/bin/bash

dotfilesrepo="https://github.com/Andr0id88/ubuntudots.git"

progsfile="https://raw.githubusercontent.com/Andr0id88/ubunturice/master/progs.csv"

initialcheck() { apt update && apt upgrade dialog || { echo "Are you sure you're running this as the root user? Are you sure you're using an Arch-based distro? ;-) Are you sure you have an internet connection? Are you sure your Arch keyring is updated?"; exit; } ;}

welcomemsg() { \
	dialog --title "Welcome!" --msgbox "Welcome to Kali's Auto-Rice Bootstrapping Script!\\n\\nThis script will automatically install a fully-featured i3wm Arch Linux desktop, which I use as my main machine.\\n\\n-Kali" 10 60
	}

preinstallmsg() { \
	dialog --title "Let's get this party started!" --yes-label "Let's go!" --no-label "No, nevermind!" --yesno "The rest of the installation will now be totally automated, so you can sit back and relax.\\n\\nIt will take some time, but when done, you can relax even more with your complete system.\\n\\nNow just press <Let's go!> and the system will begin installation!" 13 60 || { clear; exit; }
	}

maininstall() { # Installs all needed programs from main repo.
	dialog --title "KARBS Installation" --infobox "Installing \`$1\` ($n of $total). $1 $2" 5 70
	apt install -y "$1" >/dev/null 2>&1
	}


installationloop() { \
	([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) || curl -Ls "$progsfile" | sed '/^#/d' > /tmp/progs.csv
	total=$(wc -l < /tmp/progs.csv)
	while IFS=, read -r tag program comment; do
	n=$((n+1))
	echo "$comment" | grep "^\".*\"$" >/dev/null && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"
	maininstall "$program" "$comment"
	done < /tmp/progs.csv

finalize(){ \
	dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\\n\\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment (it will start automatically in tty1).\\n\\n.t Luke" 12 80
	}

### THE ACTUAL SCRIPT ###

### This is how everything happens in an intuitive format and order.

# Check if user is root on Arch distro. Install dialog.
initialcheck

# Welcome user.
welcomemsg || { clear; exit; }

# Get and verify username and password.
getuserandpass

# Give warning if user already exists.
usercheck || { clear; exit; }

# Last chance for user to back out before install.
preinstallmsg || { clear; exit; }

### The rest of the script requires no user input.

adduserandpass

# Refresh Arch keyrings.
refreshkeys

# Allow user to run sudo without password. Since AUR programs must be installed
# in a fakeroot environment, this is required for all builds with AUR.
newperms "%wheel ALL=(ALL) NOPASSWD: ALL"

dialog --title "KARBS Installation" --infobox "Installing \`basedevel\` and \`git\` for installing other software." 5 70
pacman --noconfirm --needed -S base-devel git >/dev/null 2>&1

manualinstall $aurhelper

# The command that does all the installing. Reads the progs.csv file and
# installs each needed program the way required. Be sure to run this only after
# the user has been created and has priviledges to run sudo without a password
# and all build dependencies are installed.
installationloop
welcomemsg
preinstallmsg
maininstall
installationloop
finalize

# Install programs from progs.csv
# OLDIFSS=$IFS
# IFS=","

# while read programs
#  do
# 	 apt-get install -y $programs >/dev/null 2>&1
# 	 echo "installing $programs"
# done < progs.csv
# IFS=$OLDIFS






# Setup plugged for nvim
# curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
# https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# # Update\install all vim plugins
# nvim -E -c "PlugUpdate|visual|q|q"

# # Unsure if this will work or not, it is supposed to UpdateRemotePlugins to make Ultisnips work.
# nvim -E -c "UpdateRemotePlugins|visual|q|q"
clear

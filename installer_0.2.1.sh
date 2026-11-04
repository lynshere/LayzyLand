#!/bin/bash

#flag colors
FLAG_1='\033[38;2;241;73;82m'     # #F14952
FLAG_2='\033[38;2;255;158;94m' # #FF9E5E
FLAG_3='\033[38;2;255;245;70m' # #FFF546
FLAG_4='\033[38;2;255;255;255m' # #FFFFFF
FLAG_5='\033[38;2;45;45;45m'    # #2D2D2D

NC='\033[0m'

shopt -s dotglob nullglob
set -e

echo -e "
    //////////////////////////////////////////
    /// Welcome to the LayzyLand installer ///
    //////////////////////////////////////////
    

    this script is going to back up your entire current .config file and install the entierty of Layzyland includeing packages
    0.2.1 lithsexual

    ${FLAG_1}####################
    ${FLAG_2}####################
    ${FLAG_3}####################
    ${FLAG_4}####################
    ${FLAG_5}####################

    ${NC}do you want to continue?
    \e[4mY\e[0mes \e[4mN\e[0mo \e[4mW\e[0mithoutPackages
"


while true; do
    read -rp "(y/n/w): " ynw
    case $ynw in
        [Yy]*)
            echo "checking for paru.."
            if command -v paru >/dev/null 2>&1; then
                echo "Backing up your config ^^"
                sleep 1.5
                mkdir -pv ~/.config/LayzyLand_Backup
                for item in ~/.config/*; do
                    [[ "$item" == "$HOME/.config/LayzyLand_Backup" ]] && continue
                    cp -rv "$item" ~/.config/LayzyLand_Backup/
                done
                echo "Backup done, moving on to packages"
                sleep 1.5
                sudo pacman -Syu --needed hyprland hyprlock waybar hyprshutdown hyprpaper hyprlauncher hyprpolkitagent fastfetch fish grim gtk4 base-devel git --noconfirm
                paru -S nmgui-bin
                systemctl enable --user --now hyprpolkitagent
                chsh -s /usr/bin/fish
                echo "packages are done, now on to the config (the looks and shiny oooooh)"
                sleep 1.5
                rm -rfv /tmp/LayzyLand
                git clone https://github.com/lynshere/LayzyLand /tmp/LayzyLand || exit 1
                rm -rfv ~/.config/hypr
                rm -rfv ~/.config/waybar
                rm -rfv ~/.config/fastfetch
                rm -rfv ~/.config/gtk-4.0
                rm -rfv ~/.config/fish
                mkdir -pv ~/.config/hypr
                mkdir -pv ~/.config/waybar
                mkdir -pv ~/.config/fastfetch
                mkdir -pv ~/.config/gtk-4.0
                mkdir -pv ~/.config/fish
				mkdir -pv ~/Pictures/Wallpaper
                echo "hyprland stuff"
                cp -rv /tmp/LayzyLand/config/hypr/. ~/.config/hypr
                echo "non-hyprland stuff ig"
				cp -rv /tmp/LayzyLand/config/Wallpaper/. ~/Pictures/Wallpaper
                cp -rv /tmp/LayzyLand/config/fastfetch/. ~/.config/fastfetch
                cp -rv /tmp/LayzyLand/config/fish/. ~/.config/fish
                cp -rv /tmp/LayzyLand/config/gtk-4.0/. ~/.config/gtk-4.0
                cp -rv /tmp/LayzyLand/waybar/. ~/.config/waybar
                echo "and done, install finished I think, have fun :3"
                break
            else
                echo "please install paru and then run again, sorry"
            fi
            ;;
        [Nn]*)
            echo "ok you do you ig :3"
            sleep 1.5
            break
            ;;
        [Ww]*)
            echo "working on it trust, please use y or n"
            break
            ;;
    esac
done

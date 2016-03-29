# System settings before starting X
. $HOME/.bashrc

# Do not add anything after next line
#[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1

#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

if [ -e /home/fiendfan1/.nix-profile/etc/profile.d/nix.sh ]; then . /home/fiendfan1/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

source <( HALCYON_NO_SELF_UPDATE=1 "/app/halcyon/halcyon" paths )

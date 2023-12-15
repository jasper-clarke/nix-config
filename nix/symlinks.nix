{ config, lib, pkgs, ... }:

{
  system.userActivationScripts = {
    xmonad.text = ''
      if [[ ! -h "$HOME/.config/xmonad/xmonad.hs" ]]; then
        ln -s "$HOME/.flake/setup/configs/xmonad.hs" "$HOME/.config/xmonad/xmonad.hs"
        echo "Xmonad was linked" >> "$HOME/rebuild.log"
      else
        echo "XMonad.hs was present" >> "$HOME/rebuild.log"
      fi
    '';
    polybar.text = ''
      if [[ ! -h "$HOME/.config/polybar/config.ini" ]]; then
        ln -s "$HOME/.flake/setup/configs/polybar-config.ini" "$HOME/.config/polybar/config.ini"
        echo "Polybar was linked" >> "$HOME/rebuild.log"
      else
        echo "Polybar's config was present" >> "$HOME/rebuild.log"
      fi
    '';
    compfy.text = ''
      if [[ ! -h "$HOME/.config/compfy/compfy.conf" ]]; then
        ln -s "$HOME/.flake/setup/configs/compfy.conf" "$HOME/.config/compfy/compfy.conf"
        echo "Compfy was linked" >> "$HOME/rebuild.log"
      else
        echo "Compfy.conf was present" >> "$HOME/rebuild.log"
      fi
    '';
    starship.text = ''
      if [[ ! -h "$HOME/.config/starship.toml" ]]; then
        ln -s "$HOME/.flake/setup/configs/starship.toml" "$HOME/.config/starship.toml"
        echo "Starship was linked" >> "$HOME/rebuild.log"
      else
        echo "Starship.toml was present" >> "$HOME/rebuild.log"
      fi
    '';
    doom.text = ''
      if [[ -d "$HOME/.doom.d" ]]; then
        echo "Doom is present" >> "$HOME/rebuild.log"
      else
        echo "Doom does not exist, please run the doom install script" >> "$HOME/rebuild.log"
      fi
    '';
  };
}

#!/bin/bash

# TEST
set -e

# Ensure we're in the script's directory
cd "$(dirname "$0")"

# Optional: Install paru if missing
if ! command -v paru &> /dev/null; then
    echo "Paru not found. Installing..."
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
fi

echo "Installing required packages..."
paru -S --needed stow ripgrep zsh neovim tmux ghostty --noconfirm

echo "Installing Oh‑My‑Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "Changing default shell to Zsh for current user..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi

echo "Stowing all dotfiles..."
for dir in */; do
    stow "${dir%/}"
done

echo "Dotfiles stowed."

echo "Setup complete! Please log out and log back in for shell change to take full effect."

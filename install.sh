#!/bin/zsh

# List of programs to install
PROGRAMS=(
  rectangle 
  warp
  hiddenbar
  starship
  ranger
  stow
  lazygit
  nvim
  zoxide
  exa
  fzf
  neofetch
  miniforge
)

# Loop through the list of programs and prompt the user for confirmation before installing each one
for program in "${PROGRAMS[@]}"
do
  # Prompt the user for confirmation before installing the program
  echo "Do you want to install $program with Homebrew? (y/n): "
  read answer

  # Check if the user entered "y" or "Y" (yes), and install the program if they did
  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "Installing $program with Homebrew..."
    brew install $program
  else
    echo "Skipping installation of $program"
  fi
done

# **fonts**
echo "Do you want to install nerd fonts? (y/n): "
read answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
  brew tap homebrew/cask-fonts
  brew install --cask font-sauce-code-pro-nerd-font
  brew install --cask font-hack-nerd-font
else
  echo "Skipping installation of fonts"
fi

echo "Installation complete!"

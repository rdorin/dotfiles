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
)

# Loop through the list of programs and install each one with Homebrew
for program in "${PROGRAMS[@]}"
do
  echo "Installing $program with Homebrew..."
  brew install $program
done

echo "Installation complete!"

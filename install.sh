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

echo "Installation complete!"

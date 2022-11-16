FORMULAS=(
    nvm
    fontconfig
    kubectl
    yarn
)

CASKS=(
    rectangle
    visual-studio-code
    slack
    android-studio
    postman
    postico
)

# Install homebrew itself
echo "Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install oh-my-zsh terminal
echo "Installing Oh-My-ZSH terminal"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install AWS CLI
echo "Installin AWS CLI"
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# Install formulas
echo "Installing formulas"
for i in "${FORMULAS[@]}"; do
  echo "Installing $i"
  brew install "$i"
done

# Install casks
echo "Installing casks"
for i in "${CASKS[@]}"; do
  echo "Installing $i"
  brew install --cask "$i"
done

# Copy ZSH config to home
cp .zshrc $HOME/.zshrc

# Set git config
read -p 'Username for git global config: ' GITUSER
read -p 'Email for git global config: ' GITEMAIL
echo "Configuring Git"
git config --global user.name $GITUSER
git config --global user.email $GITEMAIL
git config --global core.pager "less -FX"

# Generate SSH keys for github
read -p 'Personal Github ssh key name: ' GHSSHKEY
ssh-keygen -t ed25519 -C $GITEMAIL

# Start ssh agent
eval "$(ssh-agent -s)"

# Configure github ssh to use the generated ssh key
touch ~/.ssh/config
echo "
# Github config
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/$GHSSHKEY" >> ~/.ssh/config

# Add the ssh key to keychain
ssh-add --apple-use-keychain ~/.ssh/$GHSSHKEY

echo "Remember to add the $GHSSHKEY to Github ssh keys"
echo "More info at https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
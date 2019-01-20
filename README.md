# tools
A place to save config files and other coding toolings

## Linux Environments
When setting up a new linux environment:

### oh-my-zsh
A fun shell

1. Run `sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
2. Copy [`gerbus.zsh-theme`](https://raw.githubusercontent.com/gerbus/tools/master/gerbus.zsh-theme) to `~/.oh-my-zsh/custom`
(ToDo: make the server name a color based on the name)
3. Edit `~/.zshrc` and change the `ZSH_THEME` to `gerbus`


### iterm2
An advanced terminal

1. Download and install iterm2
2. Open Preferences > Profiles
3. Rename "Default" to something better
4. Go to Keys and make [these changes](https://stackoverflow.com/questions/6205157/iterm-2-how-to-set-keyboard-shortcuts-to-jump-to-beginning-end-of-line)
5. Go to colors and import [this file](https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/ForestBlue.itermcolors)


### Sublime Text 3
1. Download and install
2. Install Package Manager
3. Install and enable Package "color scheme - Gerbus"
4. Paste [`Preferences.sublime-settings`](https://raw.githubusercontent.com/gerbus/tools/master/Preferences.sublime-settings) into `~/Library/Application Support/Sublime Text 3/Packages/User`

## Mac Environments

### slate
A window management tool

1. Install [slate](https://github.com/jigish/slate)
2. Download [.slate](https://github.com/gerbus/tools/blob/master/.slate) to `~` path

## Windows Environments

### autohotkey
A hotkey configurator that serves as a great window management tool


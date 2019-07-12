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
6. Go to terminal and check `unlimited scrollback`, and `silence bell`


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

### cygwin
A linux terminal for windows

1. https://medium.com/@alllexsm/how-to-install-z-shell-zsh-on-cygwin-dd9ee380d783

### autohotkey
A hotkey configurator that serves as a great window management tool

## GIF Screencapture
1. Capture screen with QuickTime
2. Convert to GIF
> `ffmpeg -i /Users/chrisgerber/Pictures/Screengrabs/\#3550\ -\ mac-chrome.mov -pix_fmt rgb24 -r 10 -f gif -filter:v "setpts=0.75*PTS" /Users/chrisgerber/Pictures/Screengrabs/\#3550\ -\ mac-chrome.gif`

## Git tricks
### Rebasing a branch
[force-with-lease](https://blog.developer.atlassian.com/force-with-lease/) 
[force after rebase](https://willi.am/blog/2014/08/12/the-dark-side-of-the-force-push/)
1. `git rebase develop -i`
2. Do some squashing and re-messaging
3. `ggpush` if no changes have been pushed to `remote/origin` yet
4. `git push origin <branchname> --force-with-lease` if some commits were already pushed to `remote` before `rebase`


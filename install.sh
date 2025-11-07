#!/bin/bash
# 自动安装 oh-my-zsh、tmux、nvim 配置

set -e
# 1. 安装必要依赖
if [ -x "$(command -v apt)" ]; then
    sudo apt update
    sudo apt install -y zsh git curl wget
fi

echo "=== 安装 Oh My Zsh ==="
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "=== 克隆 dotfiles 仓库 ==="
cd $HOME
if [ ! -d "$HOME/dotfiles" ]; then
    git clone git git@github.com:LiuXiao-Rucile/dotfile.git ~/dotfiles
else
    cd ~/dotfiles
    git pull
fi

echo "=== 创建符号链接 ==="
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim

echo "=== 安装 Neovim 插件 ==="
nvim --headless +PackerSync +qa || true

echo "=== 安装完毕 ==="
echo "请重启终端或执行 'source ~/.zshrc' 来应用配置"


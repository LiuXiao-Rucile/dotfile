#!/bin/bash
# =====================================================
# 智能 dotfiles 安装脚本
# 支持读取现有 zsh 主题和插件自动安装
# 支持选择性安装 zsh / tmux / nvim
# =====================================================

set -e

# 默认安装所有
INSTALL_ZSH=0
INSTALL_TMUX=0
INSTALL_NVIM=0
INSTALL_ALL=1

# 显示帮助
function usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --zsh        安装 zsh + oh-my-zsh + 插件 + 主题"
    echo "  --tmux       安装 tmux 配置"
    echo "  --nvim       安装 Neovim 配置"
    echo "  --all        安装所有（默认）"
    echo "  -h, --help   显示帮助"
    exit 1
}

# 解析参数
if [ $# -gt 0 ]; then
    INSTALL_ALL=0
    for arg in "$@"; do
        case $arg in
            --zsh) INSTALL_ZSH=1 ;;
            --tmux) INSTALL_TMUX=1 ;;
            --nvim) INSTALL_NVIM=1 ;;
            --all) INSTALL_ALL=1 ;;
            -h|--help) usage ;;
            *) echo "Unknown option $arg"; usage ;;
        esac
    done
fi

if [ $INSTALL_ALL -eq 1 ]; then
    INSTALL_ZSH=1
    INSTALL_TMUX=1
    INSTALL_NVIM=1
fi

# 克隆 dotfiles 仓库
if [ ! -d "$HOME/dotfiles" ]; then
    git clone  git@github.com:LiuXiao-Rucile/dotfile.git ~/dotfiles
else
    cd ~/dotfiles
    git pull
fi

# -------------------------------
# 安装 Zsh + Oh My Zsh
# -------------------------------
if [ $INSTALL_ZSH -eq 1 ]; then
    echo "=== 安装 Zsh + Oh My Zsh ==="

    if ! command -v zsh >/dev/null 2>&1; then
        if [ -x "$(command -v apt)" ]; then
            sudo apt update
            sudo apt install -y zsh git curl wget
        fi
    fi

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # 链接 .zshrc
    ln -sf ~/dotfiles/.zshrc ~/.zshrc

    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

    # 自动读取插件列表
    PLUGINS=$(grep "^plugins=" ~/.zshrc | sed 's/plugins=//' | tr -d '()"' | tr ' ' '\n')
    for plugin in $PLUGINS; do
        if [ "$plugin" == "zsh-autosuggestions" ] && [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
        elif [ "$plugin" == "zsh-syntax-highlighting" ] && [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
        else
            echo "插件 $plugin 需要手动检查或已存在"
        fi
    done

    # 自动读取主题
    CURRENT_THEME=$(grep "^ZSH_THEME=" ~/.zshrc | cut -d'"' -f2)
    echo "当前 Zsh 主题: $CURRENT_THEME"

    if [[ "$CURRENT_THEME" == "powerlevel10k/powerlevel10k" ]] && [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
    fi

    echo "Zsh 配置安装完成，请执行 'source ~/.zshrc' 生效"
fi

# -------------------------------
# 安装 tmux 配置
# -------------------------------
if [ $INSTALL_TMUX -eq 1 ]; then
    echo "=== 安装 tmux ==="

    if ! command -v tmux >/dev/null 2>&1; then
        if [ -x "$(command -v apt)" ]; then
            sudo apt install -y tmux
        fi
    fi

    ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf

    [ ! -d "$HOME/.tmux/plugins/tpm" ] && \
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    echo "tmux 配置安装完成"
fi

# -------------------------------
# 安装 Neovim 配置
# -------------------------------
if [ $INSTALL_NVIM -eq 1 ]; then
    echo "=== 安装 Neovim 配置 ==="

    if ! command -v nvim >/dev/null 2>&1; then
        if [ -x "$(command -v apt)" ]; then
            sudo apt install -y neovim
        fi
    fi

    mkdir -p ~/.config
    ln -sf ~/dotfiles/.config/nvim ~/.config/nvim

    # 安装插件（lazy.nvim 为例）
    nvim --headless +Lazy! sync +qa || true

    echo "Neovim 配置安装完成"
fi

echo "=== 所有选择的组件安装完成 ==="


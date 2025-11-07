# Dotfiles 配置仓库

## 简介  
这个仓库包含我的开发环境配置（zsh、oh‑my‑zsh、tmux、Neovim）。  
使用一键脚本即可快速在新机器或远程服务器上部署相同环境。

## 目录结构  
dotfiles/
├── .zshrc
├── .tmux.conf
├── .config/
│ └── nvim/
└── install.sh
## 支持组件  
- zsh + oh‑my‑zsh（主题 + 插件）  
- tmux（含插件管理器 tpm）  
- Neovim（含插件管理器 lazy.nvim 或 packer.nvim）

## 快速安装  
在新机器或服务器上执行以下命令：  
```bash
git clone git@github.com:<你的用户名>/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
--zsh：只安装 zsh 配置

--tmux：只安装 tmux 配置

--nvim：只安装 Neovim 配置

--all：安装所有模块（默认）

-h, --help：显示帮助信息
```
## 配置说明
zsh

主题：在 .zshrc 中由 ZSH_THEME="..." 指定

插件：在 .zshrc 中由 plugins=(…) 指定

自定义插件或主题可放置于 ~/.oh-my-zsh/custom/plugins 或 custom/themes

tmux

配置文件：~/.tmux.conf

插件管理：使用 tpm（~/.tmux/plugins/tpm）

启动 tpm：按下 prefix + I 安装插件

Neovim

配置目录：~/.config/nvim

插件管理器：推荐 lazy.nvim 或 packer.nvim

初始化完成后可执行 nvim --headless +Lazy! sync +qa 安装插件

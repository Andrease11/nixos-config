{pkgs, ...}:

{
	environment.systemPackages = with pkgs; [
		neovim
		fd
    lazygit
    vimPlugins.fzf-lua
    vimPlugins.LazyVim
    git
    gcc
    nodejs
    vimPlugins.LazyVim
    rustup
    ripgrep
    xclip
    fzf
	];

	programs.neovim = {
	enable = true;
	defaultEditor = true;
	};
}

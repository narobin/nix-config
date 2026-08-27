{ ... }:
{
  programs.neovim = {
    enable = true;
    initLua = ''
      vim.opt.expandtab = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2
      vim.opt.smartindent = true
      vim.opt.autoindent = true

      vim.opt.wrap = true
      vim.opt.linebreak = true
      vim.opt.breakindent = true
      vim.opt.breakindentopt = "shift:2"
      vim.opt.showbreak = "↳ "

      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = true
      vim.opt.incsearch = true
      
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.signcolumn = "yes"
      vim.opt.cursorline = true
      vim.opt.termguicolors = true
      vim.opt.scrolloff = 8
      vim.opt.sidescrolloff = 8
      vim.opt.wrapscan = true

      vim.opt.backspace = "indent,eol,start"
      vim.opt.clipboard = "unnamedplus"
      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undofile = true
      vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
      vim.opt.completeopt = "menuone,noselect"
      
      vim.opt.foldmethod = "indent"
      vim.opt.foldlevel = 99 
    '';
  };
}
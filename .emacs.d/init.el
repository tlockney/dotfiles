(fset `yes-or-no-p `y-or-n-p)
(transient-mark-mode t)
(column-number-mode t)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(setq major-mode 'text-mode)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message nil)
(setq initial-major-mode 'org-mode)
(setq confirm-nonexistent-file-or-buffer nil)
(setq delete-old-version t)
(setq version-control t)
(setq vc-make-backup-files t)
(setq backup-directory-alist `((".*" . "~/.emacs.d/backups")))
(setq vc-follow-symlinks t)
(setq kill-buffer-query-functions (remq 'process-kill-buffer-query-function
					kill-buffer-query-functions))

(desktop-save-mode 1)
(setq desktop-path '("~/.emacs.d")
      desktop-base-file-name "emacs-desktop")
(require 'saveplace)
(setq-default save-place t)
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'Info-mode)
(add-to-list 'desktop-modes-not-to-save 'comint-mode)
(add-to-list 'desktop-modes-not-to-save 'doc-view-mode)
(add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)

;; Remove toolbar, scrollbar, and menubar
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)

;; set font
(defun font-exists-p (font) (if (null (x-list-fonts font)) nil t))
(when (window-system)
  (cond ((font-exists-p "FiraCode Nerd Font Mono") (set-frame-font "FiraCode Nerd Font Mono:spacing=100:size=16" nil t))
    ((font-exists-p "Fira Code") (set-frame-font "Fira Code:spacing=100:size=16" nil t))))

(load-theme 'wombat)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Enable mouse
(require 'mouse)
(xterm-mouse-mode t)
(require 'mwheel nil 'noerror)
(mouse-wheel-mode t)

;; Maximize emacs on startup and removes title bar (borderless fullscreen)
;(set-frame-parameter nil 'fullscreen 'fullboth)

;; Highlight Current Line
(add-hook 'after-init-hook 'global-hl-line-mode)

;; Highlight corresponding parantheses when cursor is on one
(setq show-paren-delay 0) ;; show matching parens without delay
(show-paren-mode t)

;; Proper line wrapping
(global-visual-line-mode t)

;; Show trailing white spaces
(setq-default show-trailing-whitespace t)

;; Remove useless whitespace before saving a file
(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; set up some essentials
(setq user-full-name "Thomas Lockney"
      user-mail-address "thomas@lockney.net"
      custom-file (expand-file-name "custom.el" user-emacs-directory))

(require 'server)
(unless (server-running-p) (server-start))

;; Set up package management
(setq package-install-upgrade-built-in t)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
	("elpa" . "https://elpa.gnu.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package lsp-mode
  :diminish "LSP"
  :init (setq lsp-keymap-prefix "C-l")
  :hook (((deno-ts-mode
	   rust-mode
	   tsx-ts-mode
	   typescript-ts-mode
	   js-ts-mode))
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-treemacs
  :after lsp)

(use-package deno-ts-mode)

(use-package typescript-ts-mode)

(use-package company
  :bind (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.3)
  (global-company-mode t))

(use-package material-theme
  :config
  (progn (load-theme 'material t)))

(use-package writeroom-mode)

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rust-mode
  :mode "\\.rs\\'")

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-mode 2))

(use-package corfu
  :custom
  (curfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.0)
  :init
  (global-corfu-mode))

;; Emacs config
;;
;; Much of the following is based on these resources:
;;   https://www.guilhermesalome.com/posts/making-emacs-look-good.html
;;

(fset `yes-or-no-p `y-or-n-p)
(transient-mark-mode t)
(column-number-mode t)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"
      major-mode 'text-mode
      inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-screen t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil
      initial-major-mode 'org-mode
      confirm-nonexistent-file-or-buffer nil
      delete-old-version -1
      version-control t
      vc-make-backup-files t
      backup-directory-alist `((".*" . "~/.emacs.d/backups"))
      vc-follow-symlinks t
      kill-buffer-query-functions (remq 'process-kill-buffer-query-function
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
(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      (menu-bar-mode -1)
      (tooltip-mode -1))
  (progn
    (require 'mouse)
    (xterm-mouse-mode t)
    (when (require 'mwheel nil 'noerror)(mouse-wheel-mode t))
  ))

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

(use-package tree-sitter)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package lsp-mode
  :diminish "LSP"
  :ensure t
  :hook (((rust-mode
	   tsx-ts-mode
	   typescript-ts-mode
	   js-ts-mode) . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)

(use-package rust-mode
  :ensure t)

(use-package material-theme
  :ensure t
  :config
  (progn (load-theme 'material t)))

(use-package writeroom-mode
  :ensure t)

(use-package corfu
  :custom
  (curfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.0)
  :init
  (global-corfu-mode))

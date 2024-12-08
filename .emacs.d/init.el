;; Emacs config
;;
;; Much of the following is based on these resources:
;;   https://www.guilhermesalome.com/posts/making-emacs-look-good.html
;;

;; You will most likely need to adjust this font size for your system!
(defvar tlockney/default-font-size 180)

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
(setq delete-old-version -1)
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
      custom-file "~/.emacs.d/custom.el")

(require 'server)
(unless (server-running-p) (server-start))

;; Set up package management
(require 'package)
(setq
 use-package-always-ensure t
 package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
		    ("melpa-stable" . "https://stable.melpa.org/packages/")
		    ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package tree-sitter)

(use-package rust-mode)

(use-package company)

(use-package material-theme
  :config
  (progn (load-theme 'material t)))

(use-package writeroom-mode)

(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; (use-package doom-themes
;;   :init (load-theme 'doom-gruvbox))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

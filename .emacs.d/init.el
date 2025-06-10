;; Increase garbage collection threshold during startup
(setq gc-cons-threshold (* 50 1000 1000))

;; Reset it after startup
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq gc-cons-threshold (* 2 1000 1000))))

(fset `yes-or-no-p `y-or-n-p)
(transient-mark-mode t)
(column-number-mode t)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(setq major-mode 'text-mode)
(setq confirm-nonexistent-file-or-buffer nil)
(setq vc-follow-symlinks t)
(setq kill-buffer-query-functions (remq 'process-kill-buffer-query-function
					kill-buffer-query-functions))

(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)

(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs.d/backups/"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t
      auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

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
;;(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)

;; set font
(defun font-exists-p (font)
  (if (null (x-list-fonts font)) nil t))

(when (display-graphic-p)
  (cond ((font-exists-p "FiraCode Nerd Font Mono")
	 (set-frame-font "FiraCode Nerd Font Mono:spacing=100:size=16" nil t))
	((font-exists-p "Fira Code")
	 (set-frame-font "Fira Code:spacing=100:size=16" nil t))
	(t (message "Preferred fonts not found, using default"))))

(load-theme 'wombat)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Enable mouse
(require 'mouse)
(xterm-mouse-mode t)
(require 'mwheel nil 'noerror)
(mouse-wheel-mode t)

;; Mouse support in terminal (useful for tmux)
(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  (global-set-key [mouse-4] 'scroll-down-line)
  (global-set-key [mouse-5] 'scroll-up-line))

;; Better terminal experience
(unless (display-graphic-p)
  ;; Faster terminal updates
  (setq echo-keystrokes 0.02)
  ;; Better colors in terminal
  (setq frame-background-mode 'dark)
  ;; Reduce visual noise
  (setq visible-bell nil)
  (setq ring-bell-function 'ignore)
  ;; Better scrolling in terminal
  (setq scroll-conservatively 10000)
  (setq scroll-preserve-screen-position t))

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

(use-package compat
  :ensure t)

(use-package vertico
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :init
  (marginalia-mode))

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

;; Display possible completions at all places
(use-package ido-completing-read+
  :ensure t
  :config
  ;; This enables ido in all contexts where it could be useful, not just
  ;; for selecting buffer and file names
  (ido-mode t)
  (ido-everywhere t)
  ;; This allows partial matches, e.g. "uzh" will match "Ustad Zakir Hussain"
  (setq ido-enable-flex-matching t)
  (setq ido-use-filename-at-point nil)
  ;; Includes buffer names of recently opened files, even if they're not open now.
  (setq ido-use-virtual-buffers t)
  :diminish nil)

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
  (corfu-cycle t)                    ;; Enable cycling for `corfu-next/previous`
  (corfu-auto t)                     ;; Enable auto completion
  (corfu-auto-prefix 1)              ;; Trigger after 1 character (faster for quick edits)
  (corfu-auto-delay 0.1)             ;; Very fast trigger for quick work
  (corfu-separator ?\s)              ;; Orderless field separator
  (corfu-quit-at-boundary 'separator) ;; Quit at word boundaries (good for quick edits)
  (corfu-quit-no-match t)            ;; Quit if no match (less intrusive)
  (corfu-preview-current nil)        ;; Disable preview (cleaner in terminal)
  (corfu-preselect 'prompt)          ;; Preselect the prompt
  (corfu-on-exact-match 'insert)     ;; Auto-insert exact matches (faster workflow)
  (corfu-scroll-margin 3)            ;; Smaller scroll margin
  (corfu-max-width 80)               ;; Limit width (better for terminal/SSH)
  (corfu-min-width 20)               ;; Minimum width
  (corfu-count 10)                   ;; Show fewer candidates (less overwhelming)
  :bind
  (:map corfu-map
	("TAB" . corfu-next)
	([tab] . corfu-next)
	("S-TAB" . corfu-previous)
	([backtab] . corfu-previous)
	("C-n" . corfu-next)
	("C-p" . corfu-previous)
	("RET" . corfu-insert)
	("C-g" . corfu-quit))         ;; Easy exit
  :init
  (global-corfu-mode))

;; corfu-terminal for SSH/terminal use
(use-package corfu-terminal
  :if (not (display-graphic-p))
  :config
  (corfu-terminal-mode +1))

(use-package cape
  :init
  ;; Add useful completion functions to completion-at-point-functions
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)  ;; Dynamic abbreviations
  (add-to-list 'completion-at-point-functions #'cape-file)     ;; File paths
  (add-to-list 'completion-at-point-functions #'cape-elisp-block) ;; Elisp in org blocks
  :config
  ;; Make dabbrev case-sensitive for better matches in quick edits
  (setq dabbrev-case-fold-search nil))


;; Recent buffers in a new Emacs session
(use-package recentf
  :config
  (setq recentf-auto-cleanup 'never
	recentf-max-saved-items 1000
	recentf-save-file (concat user-emacs-directory ".recentf"))
  (recentf-mode t)
  :bind ("C-x C-r" . recentf-open-files)
  :diminish nil)

(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.8)            ;; Slightly longer delay for less distraction
  (setq which-key-max-display-columns 4)     ;; Better for terminal windows
  (setq which-key-max-description-length 25) ;; Shorter descriptions
  (setq which-key-replacement-alist
      '(("C-l" . "LSP"))))                   ;; Show "LSP" instead of the full prefix

(use-package consult
  :bind (("M-s l" . consult-line)           ; Alternative to C-s (keep default for now)
	 ("C-x b" . consult-buffer)         ; Enhanced buffer switching
	 ("M-y" . consult-yank-pop)         ; Better kill ring
	 ("M-g g" . consult-goto-line)      ; Quick line jumping
	 ("C-c h" . consult-history)        ; Command history
	 ("C-c f" . consult-find)           ; Find files
	 ("C-c r" . consult-recent-file)))  ; Recent files

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

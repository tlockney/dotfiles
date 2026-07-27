;;; init.el --- A lean Emacs -*- lexical-binding: t; -*-

;; Goals, in priority order:
;;   1. Start fast, and start clean on a machine that has never run it.
;;   2. Be a comfortable general-purpose text editor, not an IDE.
;;   3. Behave the same in a terminal (emacs -nw, tmux, ssh) as in a GUI frame.
;;
;; See early-init.el for the parts that must run before the first frame.
;; There is deliberately no LSP, no tree-sitter auto-installer, and no
;; per-language package here.  Emacs 30 ships Eglot and the built-in *-ts-modes;
;; if a project ever needs them, `M-x eglot' is one command away and costs
;; nothing until it is called.

;;; ----------------------------------------------------------------- startup

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1
                  file-name-handler-alist tl/file-name-handler-alist)))

;;; ---------------------------------------------------------------- packages

(require 'package)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("gnu" . 3) ("nongnu" . 2) ("melpa" . 1))
      package-install-upgrade-built-in t)

(package-initialize)

;; First run on a new machine: fetch the archive contents once, before any
;; `use-package' form needs them.  Doing it here rather than letting each
;; :ensure discover the empty cache also avoids repeated network round-trips.
(unless package-archive-contents
  (package-refresh-contents))

;; compat must exist and be activated before the packages that macro-expand
;; against it are byte-compiled, or the first run dies with
;; "Cannot open load file: compat-NN".
(unless (package-installed-p 'compat)
  (package-install 'compat))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-expand-minimally t)

;;; ---------------------------------------------------------------- defaults

(setq-default major-mode 'text-mode
              indent-tabs-mode nil
              fill-column 80)

(setq use-short-answers t
      confirm-nonexistent-file-or-buffer nil
      vc-follow-symlinks t
      create-lockfiles nil
      sentence-end-double-space nil
      require-final-newline t
      load-prefer-newer t)

;; Don't ask before killing a buffer that still has a live process.
(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function kill-buffer-query-functions))

(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)

(setq user-full-name "Thomas Lockney"
      user-mail-address "thomas@lockney.net"
      custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

;;; ------------------------------------------------------------------- files

(let ((backups   (expand-file-name "backups/" user-emacs-directory))
      (autosaves (expand-file-name "auto-save-list/" user-emacs-directory)))
  (make-directory backups t)
  (make-directory autosaves t)
  (setq backup-by-copying t
        backup-directory-alist `(("." . ,backups))
        auto-save-file-name-transforms `((".*" ,autosaves t))
        delete-old-versions t
        kept-new-versions 6
        kept-old-versions 2
        version-control t))

;; Cursor position per file, minibuffer history, and a recent-files list.
;; These are the cheap parts of session persistence; full desktop restore was
;; the single largest startup cost and restored paths that don't exist on
;; other machines.
(save-place-mode 1)
(savehist-mode 1)
(setq recentf-max-saved-items 1000
      recentf-auto-cleanup 'never
      recentf-save-file (expand-file-name ".recentf" user-emacs-directory))
(recentf-mode 1)
(keymap-global-set "C-x C-r" #'recentf-open-files)

;;; -------------------------------------------------------------- appearance

;; Exactly one theme.  This used to load wombat and then material on top of
;; it, which is pointless work at startup either way.

(column-number-mode)
(global-display-line-numbers-mode)
(global-visual-line-mode)
(show-paren-mode)
(setq show-paren-delay 0)
(add-hook 'after-init-hook #'global-hl-line-mode)

(defun tl/font-available-p (family)
  "Return non-nil if FAMILY is usable in the current frame."
  (and (display-graphic-p)
       (find-font (font-spec :family family))))

(defun tl/frame-appearance (&optional frame)
  "Apply per-display settings to FRAME.

Run for each new frame rather than once at startup, because under
`emacsclient' the daemon has no display when init.el is read and
`display-graphic-p' would answer for the wrong frame."
  (with-selected-frame (or frame (selected-frame))
    (cond ((tl/font-available-p "FiraCode Nerd Font Mono")
           (set-frame-font "FiraCode Nerd Font Mono:spacing=100:size=16" nil t))
          ((tl/font-available-p "Fira Code")
           (set-frame-font "Fira Code:spacing=100:size=16" nil t)))
    ;; doom-modeline draws tofu when it asks for glyphs the frame's font
    ;; can't supply, which is every terminal and every machine without a
    ;; patched font installed.
    (setq doom-modeline-icon (and (tl/font-available-p "Symbols Nerd Font Mono") t))))

(add-hook 'after-make-frame-functions #'tl/frame-appearance)
(add-hook 'window-setup-hook #'tl/frame-appearance)

;;; ---------------------------------------------------------------- terminal

(setq echo-keystrokes 0.02
      scroll-conservatively 10000
      scroll-preserve-screen-position t
      visible-bell nil
      ring-bell-function #'ignore)

(unless (display-graphic-p)
  (xterm-mouse-mode 1))
(mouse-wheel-mode 1)
;; Fallback for terminals that report the old button protocol rather than SGR.
(keymap-global-set "<mouse-4>" #'scroll-down-line)
(keymap-global-set "<mouse-5>" #'scroll-up-line)

;;; -------------------------------------------------------------- whitespace

;; Only where it is signal.  As a global default it also lit up dired,
;; *Messages*, and every other buffer you can't edit anyway.
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook (lambda () (setq show-trailing-whitespace t))))

;; `whitespace-cleanup' already deletes trailing whitespace, so the separate
;; `delete-trailing-whitespace' hook this replaces was redundant.
(add-hook 'before-save-hook #'whitespace-cleanup)

;;; ---------------------------------------------------------------- bindings

(keymap-global-set "<escape>" #'keyboard-escape-quit)

;;; -------------------------------------------------------------- completion

(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind (("M-s l" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y"   . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("C-c h" . consult-history)
         ("C-c f" . consult-find)
         ("C-c r" . consult-recent-file)))

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0.1)
  (corfu-separator ?\s)
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match t)
  (corfu-preview-current nil)
  (corfu-preselect 'prompt)
  (corfu-on-exact-match 'insert)
  (corfu-scroll-margin 3)
  (corfu-max-width 80)
  (corfu-min-width 20)
  (corfu-count 10)
  :bind
  (:map corfu-map
        ("TAB"     . corfu-next)
        ([tab]     . corfu-next)
        ("S-TAB"   . corfu-previous)
        ([backtab] . corfu-previous)
        ("C-n"     . corfu-next)
        ("C-p"     . corfu-previous)
        ("RET"     . corfu-insert)
        ("C-g"     . corfu-quit))
  :init (global-corfu-mode))

;; corfu's child frames don't exist in a terminal; corfu-terminal draws the
;; popup with overlays instead.  Decided per frame, for the same daemon
;; reason as `tl/frame-appearance'.
(use-package corfu-terminal
  :after corfu
  :config
  (defun tl/corfu-terminal (&optional frame)
    (with-selected-frame (or frame (selected-frame))
      (corfu-terminal-mode (if (display-graphic-p) -1 1))))
  (add-hook 'after-make-frame-functions #'tl/corfu-terminal)
  (tl/corfu-terminal))

(use-package cape
  :after corfu
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  :config
  (setq dabbrev-case-fold-search nil))

;; Built in as of Emacs 30 -- no package needed.
(setq which-key-idle-delay 0.8
      which-key-max-display-columns 4
      which-key-max-description-length 25)
(which-key-mode)

;;; ------------------------------------------------------------------ pretty

;; material-theme is unmaintained (last release 2015) and specifies some face
;; attributes as nil, which Emacs 30 warns about into *Messages* whenever a
;; graphical frame applies it.  Harmless, but it is the only startup noise
;; left; `(load-theme 'modus-vivendi)' is a built-in, warning-free swap.
(use-package material-theme
  :config (load-theme 'material t))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Emacs has no built-in markdown mode, and markdown is text editing rather
;; than IDE work.  It arrived as an lsp-mode dependency before; now it is
;; here on purpose.
(use-package markdown-mode
  :mode ("\\.md\\'" "\\.markdown\\'"))

;;; ------------------------------------------------------------------ server

;; $EDITOR is `emacsclient -a emacs', so the server needs to be up.  Started
;; last so a failure anywhere above doesn't leave a half-configured server
;; serving clients.
(require 'server)
(unless (server-running-p)
  (server-start))

;;; init.el ends here

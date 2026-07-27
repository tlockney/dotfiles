;;; early-init.el --- Runs before package.el and the first frame -*- lexical-binding: t; -*-

;; Emacs 27+ loads this before package initialization and before the initial
;; frame is created.  Anything that changes frame geometry belongs here, so
;; the frame gets drawn once at its final size instead of flickering.

;; Effectively disable GC for the duration of startup.  init.el restores a
;; sane working threshold on `emacs-startup-hook'.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; init.el drives package activation itself so it can guarantee that
;; dependencies are on the load-path before anything macro-expands against
;; them.  Without this, a first run on a machine with an empty elpa/ fails
;; while activating packages that expand against compat.
(setq package-enable-at-startup nil)

;; Frame chrome.  Setting these as frame parameters avoids drawing the bars
;; and then removing them.
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Don't re-lay-out the frame every time the font or modeline changes size.
(setq frame-inhibit-implied-resize t)

;; Native compilation warnings come almost entirely from third-party
;; packages, where there is nothing useful to do about them.
(setq native-comp-async-report-warnings-errors 'silent)

;; Skip the regexp scan of `file-name-handler-alist' for every file loaded
;; during startup.  init.el puts it back.
(defvar tl/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;;; early-init.el ends here

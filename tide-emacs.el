(setq initial-major-mode 'text-mode)

;;;; prefer UTF8

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;;; detect operating system

(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-a-linux* (eq system-type 'gnu/linux))
(defconst *is-a-windows* (eq system-type 'windows-nt))

;;;; store custom settings in ~/.emacs.d/custom.el

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;;; essential settings

(when *is-a-mac*
  (setq mac-option-modifier 'meta)
  (custom-set-variables '(ns-use-srgb-colorspace nil)))

(when *is-a-windows*
  (setq default-directory "~/")

  (setq inhibit-compacting-font-caches t)

  (setq w32-pass-lwindow-to-system nil)
  (setq w32-lwindow-modifier 'super)

  (setq w32-pass-rwindow-to-system nil)
  (setq w32-rwindow-modifier 'super)

  (setq w32-pass-apps-to-system nil)
  (setq w32-apps-modifier 'hyper))

(setq-default
 buffers-menu-max-size 30
 case-fold-search t
 column-number-mode t
 delete-selection-mode t
 indent-tabs-mode nil
 mouse-yank-at-point t
 save-interprogram-paste-before-kill t
 scroll-preserve-screen-position 'always
 set-mark-command-repeat-pop t
 tooltip-delay 1.5
 truncate-lines nil
 truncate-partial-width-windows nil
 visible-bell nil)

(setq use-file-dialog nil
      x-gtk-use-system-tooltips t
      use-dialog-box nil
      inhibit-startup-screen t
      inhibit-startup-echo-area-message t
      require-final-newline t
      global-auto-revert-mode t
      create-lockfiles nil
      indicate-empty-lines t)

;; do not ask follow link
(customize-set-variable 'find-file-visit-truename t)

;; modes

(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
(if (fboundp 'set-scroll-bar-mode)
    (set-scroll-bar-mode nil))
(if (fboundp 'menu-bar-mode)
    (menu-bar-mode -1))

(global-hl-line-mode +1)
(transient-mark-mode t)
(global-prettify-symbols-mode t)
(electric-indent-mode t)
(electric-quote-mode t)
(electric-pair-mode t)
(show-paren-mode t)
(cua-selection-mode t)
(winner-mode t)
(windmove-default-keybindings)

(fset 'yes-or-no-p 'y-or-n-p)

;; Don't disable narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;; Don't disable case-change functions
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(setq tramp-ssh-controlmaster-options
      "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no")

;; UI

(load-theme 'leuven t)

(defconst *seartipy-default-fonts*
  '("Monaco"
    "Consolas"
    "Ubuntu Mono"
    "Source Code Pro"
    "mononoki"
    "Roboto Mono"
    "Fira Code"
    "Hack"
    "dingbats"
    "Dejavu Sans Mono"))

(if (>= emacs-major-version 25)
  (require 'seq)

  (defun seartipy/font-available-p (font)
    "Check if FONT available on the system."
    (seq-contains (font-family-list) font))

  (let ((font (seq-find 'seartipy/font-available-p
                        *seartipy-default-fonts*)))
    (when font
      (set-frame-font (concat font " 13")))))

;;;; MELPA

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(setq load-prefer-newer t)
(package-initialize)

;;;; IDO

(setq ido-enable-prefix                         nil
      ido-enable-flex-matching                  t
      ido-everywhere                            t 
      ido-create-new-buffer                     'always
      ido-use-filename-at-point                 'guess
      ido-max-prospects                         10
      ido-default-file-method                   'selected-window
      ido-auto-merge-work-directories-length    -1)

(ido-mode +1)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t
      use-package-verbose t)
(eval-when-compile
  (require 'use-package))
(use-package diminish)

(use-package eldoc)
(use-package flycheck
  :config
  (global-flycheck-mode))
(use-package company)

(use-package tide
  :init
  (setq tide-tsserver-executable "node_modules/typescript/bin/tsserver")
  :config
  (flycheck-add-next-checker 'jsx-tide '(warning . javascript-eslint) 'append)
  (flycheck-add-next-checker 'tsx-tide '(warning . javascript-eslint) 'append))

(use-package web-mode
  :mode ("\\.ts\\'"  "\\.html\\'")
  :init
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  
  (defun web-mode-setup ()
    (tide-setup)
    (tide-hl-identifier-mode)
    (company-mode +1)
    (eldoc-mode +1)
    (setq mode-name "TS"))
  (add-hook 'web-mode-hook  'web-mode-setup))

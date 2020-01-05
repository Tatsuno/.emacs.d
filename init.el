;;; init.el --- Emacs Initialization Script

;;; Commentary:

;;; Code:

;; ---------------------------------------------------------------------------
;; Helper functions

;; Check OS

(defun win? () "Check if OS is Windows" (eq system-type 'windows-nt))
(defun mac? () "Check if OS is macOS" (eq system-type 'darwin))
(defun linux? () "Check if OS is Linux" (eq system-type 'gnu/linux))

;; Split window

(defun split-window-horizontally-n (num_wins)
  (interactive "p")
  (dotimes (i (- num_wins 1))
    (split-window-horizontally))
  (balance-windows))

(defun split-window-vertically-n (num_wins)
  (interactive "p")
  (dotimes (i (- num_wins 1))
    (split-window-vertically))
  (balance-windows))

;; ---------------------------------------------------------------------------
;; Settings of built-in packages

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(frame-title-format (format "Emacs - %%f") t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (dired-details+ lsp-haskell lsp-mode lsp-ui dired-toggle shackle markdown-mode yasnippet web-mode use-package smex smartparens rust-mode projectile prodigy popwin pallet nyan-mode multiple-cursors magit idle-highlight-mode htmlize haskell-mode flycheck-cask expand-region exec-path-from-shell drag-stuff company)))
 '(prefer-coding-system (quote utf-8))
 '(ring-bell-function (quote ignore))
 '(show-paren-mode t)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(truncate-lines t))

;; Backup
(setq backup-directory-alist '((".*" . "~/.ehist")))

(load-theme 'wombat)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(if (win?)
  (progn (set-face-attribute 'default nil
    :family "Consolas"
    :height 100)
  (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "MS Gothic" :size 12))))
(if (mac?)
  (progn (set-face-attribute 'default nil
    :family "Menlo"
    :height 120)
  (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Hiragino Kaku Gothic W3"))))
(if (linux?)
  (progn (set-face-attribute 'default nil
    :family "DejaVu Sans Mono"
    :height 90)
  (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "VL Gothic"))))

;; Window Size
(when window-system (set-frame-size (selected-frame) 80 48))

;; Global Keymap
(define-key global-map "\C-h" 'delete-backward-char)
(define-key global-map "\M-h" 'backward-kill-word)
(define-key global-map "\C-z" 'delete-window)
(define-key global-map "\C-xj" 'dired-toggle)
(global-set-key "\M-n"  (lambda () (interactive) (forward-line 3)))
(global-set-key "\M-p"  (lambda () (interactive) (forward-line -3)))
(global-set-key "\C-v"  (lambda () (interactive) (scroll-up 3)))
(global-set-key "\M-v"  (lambda () (interactive) (scroll-down 3)))
(global-set-key "\C-x4" (lambda () (interactive) (split-window-horizontally-n 3)))
(global-set-key "\C-x5" (lambda () (interactive) (split-window-vertically-n 3)))
(global-set-key "\C-xt" (lambda () (interactive) (shell)))

;; ---------------------------------------------------------------------------
;; ensure to use use-package

(require 'package)
(package-initialize)
(setq package-archives
  '(("gnu" . "http://elpa.gnu.org/packages/")
    ("melpa" . "http://melpa.org/packages/")
    ("org" . "http://orgmode.org/elpa/")))

(unless package-archive-contents
  (package-refresh-contents))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(require 'use-package)

;; ---------------------------------------------------------------------------
;; Minor Modes

(use-package whitespace
  :ensure t
  :config
  (setq whitespace-style '(face trailing tabs space-mark tab-mark))
  (setq whitespace-display-mappings
    '((space-mark ?\x3000 [?\□])
      (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
      (global-whitespace-mode 1))

(use-package linum
  :ensure t
  :config
  (global-linum-mode t)
  (setq linum-format "%5d"))

(use-package shackle
  :ensure t
  :init
  (shackle-mode 1)
  :config
  (setq shackle-rules
    '(("*Buffer List*" :align left)
      ("*Warning*" :align below)
      ("*Messages*" :align below)
      ("*Help*" :align below)
      ("*shell*" :align below) ; C-x t
      (magit-status-mode :align left) ; C-x g
      ))
  (setq shackle-default-size 0.25))

(use-package windmove
  :ensure t
  :config
  (windmove-default-keybindings 'meta)) ; move buffer with (Alt + Arrow)

(use-package dired-toggle
  :ensure t
  :init
  (add-hook 'dired-toggle-mode-hook 'dired-hide-details-mode))

(use-package flycheck
  :ensure t
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save idle-change new-line mode-enabled)))

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook #'global-company-mode)
  :config
  (define-key company-active-map (kbd "C-h") 'delete-backward-char))

(use-package lsp
  :commands lsp
  :hook
  (haskell-mode . lsp))

(use-package lsp-ui
  :after lsp)

(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "C-x g") 'magit-status))

;; ---------------------------------------------------------------------------
;; Major Modes

(use-package org
  :ensure t
  :config
  (require 'ox-md nil t))

(use-package lsp-haskell
  :after lsp)

;;; init.el ends here

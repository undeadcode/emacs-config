(setq inhibit-startup-message t)

(scroll-bar-mode -1)		; No visible scrollbar
(tool-bar-mode -1)		; No visible toolbar
(tooltip-mode -1)		; No visible tooltips
(menu-bar-mode -1)		; No menubar
(set-fringe-mode 10)

(set-face-attribute 'default nil :font "Inconsolata" :height 120)
(add-hook 'emacs-startup-hook 'toggle-frame-fullscreen)

;; Make ESC quit prompt
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Emacs backup
(setq backup-directory-alist '(("." . "~/.saves")))

;; Line and column numbers
(column-number-mode)
(global-display-line-numbers-mode)
(dolist (mode '(org-mode-hook
				term-mode-hook
				shell-mode-hook
				eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; C better identation
(setq c-basic-offset 4
	  tab-width 4
	  indent-tabs-mode t
	  c-default-style "linux")

;; Set up package.el to work with MELPA
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
						 ("melpa-stable" . "https://stable.melpa.org/packages/")
						 ("org" . "https://orgmode.org/elpa/")
						 ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(defun und/org-mode-setup ()
  (org-indent-mode)
  (setq evil-auto-indent nil))

(use-package org
  :hook
  (org-mode . und/org-mode-setup))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (setq evil-undo-system 'undo-redo))

;; C++ mirror mode powered by libclang
;; run M-x irony-install-server for the first time
(use-package irony
  :hook
  (c++-mode-hook . irony-mode)
  (c-mode-hook . irony-mode)
  (objc-mode-hook . irony-mode)
  (irony-mode-hook . irony-cdb-autosetup-compile-options))

;; Linting
(use-package flycheck
  :init (global-flycheck-mode))
(use-package flycheck-irony
  :after flyckeck
  :hook
  (flycheck-mode-hook . flycheck-irony-setup))

;; Text completion
(use-package company
  :init (global-company-mode)
  :bind ("C-ö" . company-complete))
(use-package company-irony
  :after company
  :config
  (add-to-list 'company-backends 'company-irony))

(use-package counsel
  :init (counsel-mode))

(use-package swiper
  :bind (("C-s" . swiper)))

;; Better autocompletion
(use-package ivy
  :init (ivy-mode))

(use-package ivy-rich
  :init (ivy-rich-mode))

(use-package which-key
  :init (which-key-mode))

;; Run M-x all-the-icons-install-fonts
(use-package doom-modeline
  :init (doom-modeline-mode))

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t	 ; if nil, bold is universally disabled
		doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-dracula t)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

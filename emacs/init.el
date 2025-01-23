;; package.el and native compile
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-native-compile t)
(setq native-comp-async-report-warnings-errors nil)
(package-initialize)

;; use-package configuration
(require 'use-package)
(setq use-package-verbose t)
(setq use-package-compute-statistics t)
(setq use-package-always-ensure t)

;; Emacs custom
(unless (file-exists-p "~/.emacs.d/custom.el")
  (make-empty-file "~/.emacs.d/custom.el"))
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Basic editor config
(cua-mode)
(electric-pair-mode)
(xterm-mouse-mode)
(tool-bar-mode -1)
(setq inhibit-startup-screen t)
(set-default-coding-systems 'utf-8)
(global-auto-revert-mode)
(setq-default backward-delete-char-untabify-method nil)
(setq-default compilation-scroll-output t)
(setq-default auto-save-default nil)
(setq-default make-backup-files nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq read-process-output-max (* 10 1024 1024))

;; Default Style Config
(setq-default c-basic-offset 4)
(setq-default sgml-basic-offset 4)
(setq-default tab-width 4)
(setq-default indent-tabs-mode t)

;; Theme and Icons
(use-package all-the-icons)

(use-package doom-themes
  :init
  (load-theme 'doom-acario-dark t))

;; General Packages
(use-package projectile
  :demand t
  :init
  (setq projectile-project-search-path '(("~/projects" . 2)))
  :custom
  (projectile-switch-project-action 'treemacs-add-and-display-current-project-exclusively)
  (projectile-find-file-hook 'treemacs-add-and-display-current-project-exclusively)
  (projectile-find-dir-hook 'treemacs-add-and-display-current-project-exclusively)
  :config
  (projectile-mode)
  :bind-keymap
  ("M-p" . projectile-command-map))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  :custom
  (dashboard-agenda-prefix-format "%i %-12:c")
  (dashboard-footer-messages '("always_ff @(posedge clk or negedge rst_n)"))
  (dashboard-agenda-sort-strategies '(priority-up time-up))
  (dashboard-startup-banner 'logo)
  (dashboard-items '((recents   . 5)
                     (projects  . 5)
                     (agenda    . 25)))
  (initial-buffer-choice (lambda () (dashboard-open))))

(use-package doom-modeline
  :after (all-the-icons)
  :init
  (doom-modeline-mode 1))

(use-package treemacs
  :after (treemacs-all-the-icons)
  :bind ([f7] . treemacs)
  :config
  (treemacs-load-theme "all-the-icons")
  (with-eval-after-load 'treemacs
	(define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))
  :custom
  (treemacs-width 20)
  (treemacs-hide-gitignored-files-mode t)
  (treemacs-follow-mode t)
  (treemacs-indent-guide-style line))

(use-package magit
  :commands magit-status)

(use-package company
  :init
  (global-company-mode)
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 1)
  (company-backends '(
					  company-capf
					  (company-c-headers company-clang company-keywords)
					  company-semantic
					  company-cmake
					  company-files))
  (company-clang-executable "/usr/bin/clang-19")
  :config
  (company-tng-mode))

(use-package flycheck
  :init
  (global-flycheck-mode)
  :custom
  (flycheck-c/c++-clang-executable "/usr/bin/clang-19"))

(use-package ivy
  :init
  (ivy-mode 1))

(use-package counsel
  :init
  (counsel-mode 1))

(use-package treemacs-all-the-icons
  :after (treemacs all-the-icons))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-magit
  :after (treemacs magit))

;; Notetaking and To-Do
(use-package org
  :defer t
  :mode ("\\.org\\'" . org-mode)
  :pin gnu
  :bind (("M-o" . org-agenda))
  :custom
  (org-startup-truncated nil)
  (org-agenda-files '("~/notes"))
  (org-priority-highest 1)
  (org-priority-lowest 6)
  (org-priority-default 4)
  (org-icalendar-include-todo t)
  (org-icalendar-use-deadline '(event-if-todo))
  (org-icalendar-use-scheduled '(event-if-todo))
  (org-icalendar-timezone "America/Toronto")
  (org-export-with-broken-links t)
  (org-todo-keywords '((sequence "TODO(t)" "BLOCKED(b)" "WIP(w)" "|" "DONE(d)" "DELEGATED(e)" "UNCOMPLETE(u)" "CANCELED(c)")))
  (org-priority-faces '((?1 . (:foreground "#F8C300"))
						(?2 . (:foreground "#00923F"))
						(?3 . (:foreground "#31A1DB"))
						(?4 . (:foreground "#A21A68"))
						(?5 . (:foreground "#FF7D24"))
						(?6 . (:foreground "#8A999A")))))

(use-package toc-org
  :defer t
  :commands toc-org-insert-toc)

(use-package org-roam
  :defer t
  :custom
  (org-roam-directory "~/notes")
  (org-roam-database-connector 'sqlite-builtin)
  :bind (("M-n l" . org-roam-buffer-toggle)
         ("M-n f" . org-roam-node-find)
         ("M-n i" . org-roam-node-insert)
		 ("M-n c" . org-roam-dailies-capture-today))
  :init
  (org-roam-db-autosync-mode))

;; Non-programming file modes
(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query))

(use-package markdown-mode
  :mode "\\.md\\'")

(use-package git-modes)

;; Embedded C Programming
(use-package company-c-headers
  :custom
  (company-c-headers-path-system
   '("/usr/include/" "/usr/local/include/")))

;; Other Programming
(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))

(use-package rust-ts-mode
  :mode "\\.rs\\'")

(use-package nasm-mode
  :mode "\\.asm\\'")

;; Digital Design
(use-package verilog-mode
  :mode ("\\.v\\'" "\\.vh\\'" "\\.sv\\'" "\\.svh\\'")
  :custom
  (verilog-auto-newline nil)
  (verilog-auto-indent-on-newline nil)
  (verilog-case-indent 4)
  (verilog-indent-level 4)
  (verilog-indent-level-behavioral 4)
  (verilog-indent-level-declaration 4)
  (verilog-indent-level-directive 4)
  (verilog-indent-level-module 4)
  :pin gnu)

(use-package verilog-ext
  :hook ((verilog-mode . verilog-ext-mode))
  :custom
  (verilog-ext-feature-list '(hideshow capf imenu hierarchy xref beautify hideshow font-lock))
  :config
  (verilog-ext-mode-setup))

(use-package vhdl-mode
  :mode ("\\.vhd\\'" "\\.vhdl\\'")
  :custom
  (vhdl-indent-tabs-mode t)
  (vhdl-standard (list 08))
  (vhdl-basic-offset 4))

(add-to-list 'auto-mode-alist '("\\.f\\'" . text-mode))
(add-to-list 'auto-mode-alist '("\\.vc\\'" . text-mode))
(add-to-list 'auto-mode-alist '("\\.sdc\\'" . tcl-mode))

;; Language Server Protocol
(use-package lsp-mode
  :defer t
  :commands lsp
  :custom
  (lsp-diagnostics-provider :flycheck)
  (lsp-clangd-binary-path "/usr/bin/clangd-19"))

(use-package lsp-ui
  :defer t
  :custom
  (lsp-ui-doc-delay 0.05))

(use-package lsp-java
  :defer t
  :custom
  (lsp-java-autobuild-enabled nil)
  (lsp-java-jdt-download-url "https://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz"))

(use-package lsp-pyright
  :defer t)

(dir-locals-set-class-variables 'lsp-project
								`((c-mode . ((eval . (lsp-deferred))))
								  (c++-mode . ((eval . (lsp-deferred))))
								  (java-mode . ((eval . (lsp-deferred))))
								  (js-mode . ((eval . (lsp-deferred))))
								  (python-ts-mode . ((eval . (lsp-deferred))))
								  (rust-ts-mode . ((eval . (lsp-deferred))))))

;; Source Formatting
(use-package clang-format
  :custom
  (clang-format-executable "/usr/bin/clang-format-19"))

(defun default-format-buffer ()
  (interactive)
  (cond
   ((or (eq major-mode 'c-mode) (eq major-mode 'c++-mode) (eq major-mode 'c-ts-mode) (eq major-mode 'c++-ts-mode))
	(if (bound-and-true-p lsp-mode)
		(progn
		  (message "Formatting with clangd")
		  (lsp-format-buffer))
	  (progn
		(message "Formatting with clang-format")
		(clang-format-buffer))
	  ))
   ((eq major-mode 'java-mode)
	(progn
	  (message "Formatting with JDT-LS")
	  (lsp-format-buffer)
	  ))
   ((or (eq major-mode 'js-mode) (eq major-mode 'js-jsx-mode))
	(progn
	  (message "Formatting with typescript-language-server")
	  (lsp-format-buffer)
	  ))
   ((eq major-mode 'verilog-mode)
	(progn
	  (message "Indenting Verilog/SystemVerilog")
	  (indent-region (point-min) (point-max))
	  ))
   ((eq major-mode 'vhdl-mode)
	(progn
	  (message "Formatting VHDL")
	  (vhdl-beautify-buffer)
	  ))
   (t
	(message "No formatter for this major mode"))))

(global-set-key (kbd "C-c f") 'default-format-buffer)

;; Line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(global-set-key [f8] 'display-line-numbers-mode)

;; Project specific configuration
(mapc 'load-file (file-expand-wildcards "~/.emacs.d/project-config/*.el"))
(mapc 'load-file (file-expand-wildcards "~/.emacs.d/repo-config/*.el"))

;; End of start-up and start-up profiling
(garbage-collect)
(setq gc-cons-threshold (* 50 1024 1024))

(defun display-startup-time ()
  (message "Emacs loaded on %s in %s with %d garbage collections."
		   (format-time-string "%b %e %H:%M")
		   (format "%.2f seconds"
				   (float-time
					(time-subtract after-init-time before-init-time)))
		   gcs-done))

(add-hook 'emacs-startup-hook 'display-startup-time)

(defun native-comp-all-package ()
  (interactive)
  (native-compile-async "~/.emacs.d/elpa" 'recursively))

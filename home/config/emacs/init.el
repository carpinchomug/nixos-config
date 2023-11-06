;;; init.el --- My Emacs configuration file          -*- lexical-binding: t; -*-

;; This program is free software; you can redistribute it and/or modif
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This is my Emacs configuration file. It's part of my larger
;; NixOS/home-manager configuration and, as such, both Emacs and Elisp
;; packages are meant to be managed by the nix package
;; manager. However, I try to make it portable to environments where
;; nix is unavailable. Especially, it should always be compatible with
;; Emacs for Windows as my work laptop runs Windows.

;;; Code:

;;;; Startup

;; Make sure emacs will find the right user directory.
(setq user-emacs-directory
      (if (nixp)
          (expand-file-name "emacs" (getenv "XDG_CONFIG_HOME"))
        "~/.emacs.d"))

;; If managed by nix, set `package-archives' to nil to avoid
;; installing packages by accident. Otherwise, let `package' install
;; packages from MELPA as well as ELPA. According to Emacs Prelude,
;; accessing MELPA using HTTPS from Emacs for Windows is problematic,
;; so let it fallback to HTTP.
(if (nixp)
    (setq package-archives nil)
  (if (eq system-type 'windows-nt)
      (add-to-list 'package-archives
                   '("melpa" . "http://melpa.org/packages/") t)
    (add-to-list 'package-archives
                 '("melpa" . "https://melpa.org/packages/") t)))

;; Load `use-package'.
(eval-when-compile
  (require 'use-package))
(require 'bind-key)

;; Eagerly load packages with `use-package' if started as a daemon.
(when (daemonp)
  (setq use-package-always-demand t))

;;;; General configuration
(use-package emacs
  :custom
  ;; C source code
  (ring-bell-function 'ignore)
  (scroll-margin 5)
  (scroll-conservatively 100)
  (system-time-locale "C")

  (use-short-answers t)

  ;; files.el
  (auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-save" user-emacs-directory) t)))
  (backup-directory-alist `((".*" . ,(expand-file-name "backup" user-emacs-directory))))
  (require-final-newline t)
  (scroll-preserve-screen-position t)

  ;; simple.el
  (indent-tabs-mode nil)

  :custom-face
  (region ((t (:foreground unspecified))))

  :init
  ;; C source code
  (when (eq system-type 'windows-nt)
    (setq default-directory "~"))

  (add-hook 'org-mode-hook #'variable-pitch-mode)

  :config
  ;; frame.el
  (blink-cursor-mode -1)

  ;; menu-bar.el
  (menu-bar-mode -1)

  ;; scroll-bar.el
  (scroll-bar-mode -1)

  ;; simple.el
  (column-number-mode)
  (global-visual-line-mode)
  (line-number-mode)

  ;; tool-bar.el
  (tool-bar-mode -1)

  (make-directory (expand-file-name "auto-save" user-emacs-directory) t)
  (make-directory (expand-file-name "backup" user-emacs-directory) t)

  ;; Very good guide on defining fontsets.
  ;; https://casouri.github.io/note/2021/fontset/index.html

  ;; Fontset for the variable pitch face.
  (create-fontset-from-fontset-spec
   (font-xlfd-name
    (font-spec :family "Iosevka Aile"
               :size 12
               :registry "fontset-variable")))
  (defun my/setup-fonts ()
    (set-fontset-font t
                      'japanese-jisx0213.2004-1
                      "Sarasa Mono J"
                      nil
                      'append)
    (set-fontset-font "fontset-variable"
                      'japanese-jisx0213.2004-1
                      "Sarasa UI J"
                      nil
                      'append)
    (set-face-attribute 'default nil :font "Iosevka" :height 120)
    (set-face-attribute 'fixed-pitch nil :font "Iosevka" :height 1.0)
    (set-face-attribute 'variable-pitch nil :fontset "fontset-variable" :height 1.0))

  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'my/setup-fonts)
    (when (display-graphic-p)
      (my/setup-fonts))))

;;;; Packages

;;;;; autorevert
(use-package autorevert
  :ensure nil
  :config
  (global-auto-revert-mode))

;;;;; avy
(use-package avy
  :ensure t
  :bind ("C-x j" . avy-goto-char-timer)
  :custom
  (avy-timeout-seconds 0.75))

;;;;; beacon
(use-package beacon
  :ensure t
  :commands (beacon-mode beacon-blink)
  :config
  (add-to-list 'beacon-dont-blink-major-modes 'comint-mode)
  (add-to-list 'beacon-dont-blink-major-modes 'dashboard-mode)
  (add-to-list 'beacon-dont-blink-major-modes 'eshell-mode)
  (add-to-list 'beacon-dont-blink-major-modes 'eat-mode))

;;;;; cape
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block))

;;;;; cmake-mode
(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

;;;;; consult
(use-package consult
  :ensure t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :custom
  (consult-narrow-key "<")
  (consult-project-function #'consult--default-project-function)

  :init
  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any)))

;;;;; corfu
(use-package corfu
  :ensure t
  :preface
  (defun corfu-send-shell (&rest _)
    "Send completion candidate when inside comint/eshell."
    (cond
     ((and (derived-mode-p 'eshell-mode) (fboundp 'eshell-send-input))
      (eshell-send-input))
     ((and (derived-mode-p 'comint-mode)  (fboundp 'comint-send-input))
      (comint-send-input))))
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-quit-no-match 'separator)
  :init
  (add-hook 'eshell-mode-hook (lambda ()
                                (setq corfu-auto nil)
                                (corfu-mode)))
  :config
  (advice-add #'corfu-insert :after #'corfu-send-shell)
  (global-corfu-mode))

(use-package emacs
  :ensure nil
  :custom
  (completion-cycle-threshold 3)
  (tab-always-indent 'complete))

;;;;; css-mode
(use-package css-mode
  :ensure nil
  :mode "\\.css\\'"
  :init
  (when (treesit-language-available-p 'css)
    (add-to-list 'major-mode-remap-alist '(css-mode . css-ts-mode))))

;;;;; csv-mode
(use-package csv-mode
  :ensure t
  :mode (("\\.csv\\'" . csv-mode)
         ("\\.tsv\\'" . tsv-mode)))

;;;;; c-ts-mode
(use-package cc-mode
  :ensure nil
  :commands (c-ts-mode c++-ts-mode)
  :custom
  (c-ts-mode-hook c-mode-hook)
  (c++-ts-mode-hook c++-mode-hook)
  :init
  (when (treesit-language-available-p 'c)
    (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode)))
  (when (treesit-language-available-p 'cpp)
    (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))))

;;;;; cus-edit
(use-package cus-edit
  :ensure nil
  :custom
  (custom-file (expand-file-name "custom-file.el" user-emacs-directory))
  :config
  (load custom-file t))

;;;;; dashboard
(use-package dashboard
  :ensure t
  :demand t
  :bind (:repeat-map dashboard-line-navigation-repeat-map
                     ("n" . dashboard-next-line)
                     ("p" . dashboard-previous-line))
  :custom
  (dashboard-center-content t)
  (dashboard-set-footer nil)
  (dashboard-set-init-info nil)
  (dashboard-projects-backend 'project-el)
  (dashboard-items '((recents . 5)
                     (bookmarks . 5)
                     (projects . 5)
                     (agenda . 5)))
  :init
  ;; Display the dashboard in new emacsclient frames.
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  :config
  (dashboard-setup-startup-hook))

;;;;; diff-hl
(use-package diff-hl
  :ensure t
  :demand t
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh)
         (dired-mode . diff-hl-dired-mode)
         (conf-mode . diff-hl-margin-mode)
         (prog-mode . diff-hl-margin-mode)
         (text-mode . diff-hl-margin-mode))
  :custom
  ;; (diff-hl-margin-symbols-alist `((insert . ,(string #x2503)) ; U+2503
  ;;                                 (delete . ,(string #x2503))
  ;;                                 (change . ,(string #x2503))
  ;;                                 (unknown . "?")
  ;;                                 (ignored . "!")))
  (diff-hl-margin-symbols-alist '((insert . "+")
                                  (delete . "-")
                                  (change . "!")
                                  (unknown . "?")
                                  (ignored . "i")))
  :custom-face
  (diff-hl-change ((t (:foreground "#f5b041" :background unspecified :weight bold))))
  (diff-hl-delete ((t (:foreground "#ec7063" :background unspecified :weight bold))))
  (diff-hl-insert ((t (:foreground "#52be80" :background unspecified :weight bold))))
  (diff-hl-unknown ((t (:weight bold))))
  (diff-hl-ignored ((t (:weight bold))))
  :config
  ;; (require 'diff-hl-dired)
  ;; (require 'diff-hl-margin)
  (global-diff-hl-mode))

;;;;; dired
(use-package dired
  :ensure nil
  :commands dired)

;;;;; display-line-numbers
(use-package display-line-numbers
  :ensure nil
  :commands (global-display-line-numbers-mode
             display-line-numbers-mode)
  :custom
  (display-line-numbers-grow-only t))

;;;;; eat
(use-package eat
  :ensure t
  :commands (eat eat-project)
  :hook (eshell-load . eat-eshell-visual-command-mode))

;;;;; eglot
(use-package eglot
  :ensure nil
  :hook ((bash-ts-mode . eglot-ensure)
         ((c-mode c++-mode) . eglot-ensure)
         (js-base-mode . eglot-ensure)
         (nix-mode . eglot-ensure)
         (python-base-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (typst-mode . eglot-ensure))
  :custom
  (eglot-autoshutdown t)
  (eglot-workspace-configuration '(:nil (:formatting (:command ["nixpkgs-fmt"]))
                                        :nixd (:formatting (:command "nixpkgs-fmt"))))
  :config
  (add-to-list 'eglot-server-programs `(nix-mode
                                        . ,(eglot-alternatives '("nil" "nixd")))))

;;;;; eldoc
(use-package eldoc
  :ensure nil
  :custom
  (eldoc-echo-area-prefer-doc-buffer t))

;;;;; elec-pair
(use-package elec-pair
  :ensure nil
  :hook ((conf-mode . electric-pair-mode)
         (prog-mode . electric-pair-mode)))

;;;;; ellama
(use-package ellama
  :disabled
  :ensure t)

;;;;; elpy
(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))

;;;;; embark
(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)
         :map embark-collect-mode-map
         ("m" . embark-select)
         :map help-map
         ("C-h" . embark-prefix-help-command))
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  ;; Show the Embark target at point via Eldoc.  You may adjust the Eldoc
  ;; strategy, if you want to see the documentation from multiple providers.
  (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))


;;;;; embark-consult
(use-package embark-consult
  :ensure t
  :init
  (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode))

;;;;; envrc
(use-package envrc
  :if (executable-find "direnv")
  :ensure t
  :demand t
  :bind-keymap
  ("C-c e" . envrc-command-map)
  :config
  (envrc-global-mode))

;;;;; epg
(use-package epg
  :ensure nil
  :custom
  (epg-pinentry-mode 'loopback))


;;;;; eshell
(use-package eshell
  :ensure nil
  :commands eshell
  :init
  (add-hook 'eshell-mode-hook (lambda () (setq-local scroll-margin 0))))

;;;;; exec-path-from-shell
(use-package exec-path-from-shell
  :if (daemonp)
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;;;;; expand-region
(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region)
  :custom
  (expand-region-smart-cursor t))

;;;;; flyspell
(use-package flyspell
  :ensure nil
  :commands (flyspell-mode flyspell-prog-mode)
  :config
  (unbind-key "C-." flyspell-mode-map))

;;;;; helpful
(use-package helpful
  :ensure t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)
         ("C-c C-d" . helpful-at-point)
         ("C-h F" . helpful-function)))

;;;;; hl-line
(use-package hl-line
  :ensure nil
  :commands (hl-line-mode)
  :custom-face
  (hl-line ((t (:inherit shadow)))))

;;;;; ibuffer
(use-package ibuffer
  :ensure nil
  :bind ("C-x C-b" . ibuffer))

;;;;; js
(use-package js
  :ensure nil
  :mode (("\\.js[mx]?\\'" . js-mode)
         ("\\.json\\'" . js-json-mode))
  :init
  (when (treesit-language-available-p 'javascript)
    (add-to-list 'major-mode-remap-alist '(js-mode . js-ts-mode)))
  (when (treesit-language-available-p 'json)
    (add-to-list 'major-mode-remap-alist '(js-json-mode . json-ts-mode))))

;;;;; julia-mode
(use-package julia-mode
  :ensure t
  :mode "\\.jl\\'")

;;;;; just-mode
(use-package just-mode
  :ensure t
  :mode ("/[Jj]ustfile\\'"
         "\\.[Jj]ust\\(file\\)?\\'"))

;;;;; kbd-mode
(use-package kbd-mode
  :ensure nil
  :mode "\\.kbd\\'")

;;;;; latex
(use-package latex
  :ensure auctex
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :init
  (setq-default TeX-engine 'luatex)
  (setq TeX-parse-self t
        TeX-auto-save t
        TeX-view-program-selection '((output-pdf "PDF Tools")))
  (setq LaTeX-electric-left-right-brace t))

;;;;; ligature
(use-package ligature
  :ensure t
  :config
  (ligature-set-ligatures
   '(conf-mode prog-mode text-mode)
   '("<--" "<---" "<<-" "<-" "->" "->>" "-->" "--->"
     "<==" "<===" "<<=" "<=" "=>" "=>>" "==>" "===>" ">=" ">>="
     "<->" "<-->" "<--->" "<---->" "<=>" "<==>" "<===>" "<====>" "::" ":::" "__"
     "<~~" "</" "</>" "/>" "~~>" "==" "!=" "<>" "===" "!==" "!==="
     "<:" ":=" "*=" "*+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+*" "=*" "=:" ":>"
     "/*" "*/" "[|" "|]" "++" "+++" "<!--" "<!---" ))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode))

;;;;; markdown-mode
(use-package markdown-mode
  :ensure t
  :mode (("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode)))

;;;;; magit
(use-package magit
  :ensure t
  :after diff-hl
  :bind ("C-x g" . magit-status)
  :custom
  (magit-define-global-key-bindings nil)
  :init
  (setq transient-default-level 5))

;;;;; magit-extras
(use-package magit-extras
  :ensure magit
  :after project)

;;;;; marginalia
(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

;;;;; midnight
(use-package midnight
  :ensure nil
  :config
  (add-to-list 'clean-buffer-list-kill-regexps "\\`\\*helpful ")
  (midnight-mode))

;;;;; modus-themes
(use-package modus-themes
  :ensure t
  :custom
  (modus-themes-common-palette-overrides '((bg-line-number-active unspecified)
                                           (bg-line-number-inactive upspecified)
                                           (bg-mode-line-active unspecified)
                                           (bg-mode-line-inactive unspecified)
                                           (border-mode-line-active unspecified)
                                           (border-mode-line-inactive unspecified)
                                           (fringe unspecified)))
  (modus-themes-mixed-fonts t)
  :config
  (load-theme 'modus-operandi t))

(use-package emacs
  :ensure t
  :after modus-themes
  :custom-face
  (mode-line ((t (:overline "#000000"))))
  (mode-line-inactive ((t (:overline "#000000")))))

;;;;; mozc
(use-package mozc
  :if (and (executable-find "mozc_emacs_helper")
           (not (eq system-type 'windows-nt)))
  :ensure t
  :commands mozc-mode
  :custom
  (mozc-candidate-style 'echo-area)
  :init
  (setq default-input-method "japanese-mozc")
  (global-set-key [zenkaku-hankaku] #'toggle-input-method)
  (prefer-coding-system 'utf-8))

;;;;; nerd-icons
(use-package nerd-icons
  :ensure t
  :commands nerd-icons-insert
  :custom
  (nerd-icons-font-family "Iosevka Nerd Font"))

;;;;; nix-mode
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

;;;;; nix-ts-mode
;; Disabled until I figure out how to get indentation to work properly.
(use-package nix-ts-mode
  :disabled
  :if (treesit-language-available-p 'nix)
  :ensure t
  :commands nix-ts-mode
  :custom
  (nix-ts-mode-hook nix-mode-hook)
  :init
  (add-to-list 'major-mode-remap-alist '(nix-mode . nix-ts-mode)))

;;;;; olivetti
(use-package olivetti
  :ensure t
  :commands olivetti-mode
  :init
  (add-hook 'ovlivetti-mode (lambda ()
                              (diff-hl-mode -1))))

;;;;; orderless
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion))))))

;;;;; org
(use-package org
  :ensure nil
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         (:repeat-map org-heading-repeat-map
                      ("n" . org-next-visible-heading)
                      ("p" . org-previous-visible-heading)
                      ("f" . org-forward-heading-same-level)
                      ("b" . org-backward-heading-same-level)))
  :mode ("\\.org\\'" . org-mode)
  :custom
  (org-startup-with-inline-images t)
  (org-image-actual-width nil)
  (org-todo-keywords '((sequence "TODO" "WAITING" "|" "DONE" "CANCELLED")))
  (org-directory (if (eq system-type 'windows-nt)
                     (expand-file-name "Org" (getenv "OneDrive"))
                   "~/Org"))
  (org-agenda-files (list org-directory))
  (org-default-notes-file (expand-file-name "Org/notes.org" org-directory))

  (org-auto-align-tags nil)
  (org-tags-column 0)
  (org-catch-invisible-edits 'show-and-error)
  (org-special-ctrl-a/e t)
  (org-insert-heading-respect-content t)
  (org-edit-src-content-indentation 0)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)

  (org-agenda-tags-column 0)
  (org-agenda-block-separator ?-)
  (org-agenda-time-grid '((daily today require-timed)
                          (800 1000 1200 1400 1600 1800 2000)
                          " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"))
  ;; org-babel
  (org-babel-load-languages '((emacs-lisp . t)
                              (haskell . t)
                              (julia . t)
                              (python . t)
                              (shell . t)))

  ;; Org-capture templates
  ;; Should I keep only a couple of simple templates and let `tempel'
  ;; handle logic?
  (org-capture-templates `(("t" "TODO Task Entry" entry (file ,(expand-file-name "Org/tasks.org" org-directory))
                            "* TODO %?"
                            :empty-lines 1)
                           ("a" "Appointment/Meeting" entry (file ,(expand-file-name "Org/diary.org" org-directory))
                            "* %?\n%^{Scheduled for}T"
                            :empty-lines 1)))
  :init
  (add-hook 'org-mode-hook #'org-refresh-category-properties))

;;;;; org-appear
(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autoemphasis t)
  (org-appear-autoentities t)
  (org-appear-autolinks t))

;;;;; org-modern
(use-package org-modern
  :disabled
  :ensure t
  :hook (org-mode . org-modern-mode))

;;;;; org-reveal
(use-package ox-reveal
  :ensure t
  :after org)

;;;;; outline
(use-package outline
  :ensure nil
  :commands outline-minor-mode
  :custom
  (outline-minor-mode-cycle t))

;;;;; paren
(use-package paren
  :ensure nil
  :hook ((conf-mode . show-paren-mode)
         (prog-mode . show-paren-mode)
         (text-mode . show-paren-mode))
  :custom
  (show-paren-context-when-offscreen t))

;;;;; pdf-tools
(use-package pdf-tools
  ;; Haven't set up epdfinfo server on Windows yet
  :if (not (eq system-type 'windows-nt))
  :ensure t
  :config
  (pdf-tools-install))

;;;;; pixel-scroll
(use-package pixel-scroll
  :ensure nil
  :config
  (pixel-scroll-precision-mode))

;;;;; project
(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers '(".dir-locals.el" "flake.nix")))

;;;;; python
(use-package python
  :ensure nil
  :mode ("\\.py[iw]?\\'" . python-mode)
  :init
  (when (treesit-language-available-p 'python)
    (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode)))
  :custom
  (python-indent-guess-indent-offset-verbose nil))

;;;;; rainbow-mode
(use-package rainbow-mode
  :ensure t
  :commands rainbow-mode)

;;;;; recentf
(use-package recentf
  :ensure nil
  :config
  (recentf-mode))

;;;;; repeat
(use-package repeat
  :ensure nil
  :demand t
  :bind ((:repeat-map char-movement-repeat-map
                      ("f" . forward-char)
                      ("b" . backward-char))
         (:repeat-map word-movement-repeat-map
                      ("f" . forward-word)
                      ("b" . backward-word))
         (:repeat-map sexp-movement-repeat-map
                      ("f" . forward-sexp)
                      ("b" . backward-sexp))
         (:repeat-map line-navigation-repeat-map
                      ("n" . next-line)
                      ("p" . previous-line))
         (:repeat-map recenter-repeat-map
                      ("l" . recenter-top-bottom))
         (:repeat-map scroll-repeat-map
                      ("v" . scroll-up-command)
                      ("V" . scroll-down-command))
         (:repeat-map scroll-other-window-repeat-map
                      ("v" . scroll-other-window)
                      ("V" . scroll-other-window-down))
         (:repeat-map undo-redo-repeat-map
                      ("u" . undo)
                      ("r" . undo-redo))
         (:repeat-map isearch-repeat-map
                      ("s" . isearch-repeat-forward)
                      ("r" . isearch-repeat-backward)))
  :config
  ;; Unset `undo-repeat-map' before redefining it.
  (makunbound 'undo-repeat-map)

  (repeat-mode))


;;;;; rust-mode
(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :custom
  (rust-format-on-save t))

;;;;; rust-ts-mode
(use-package rust-ts-mode
  :if (treesit-language-available-p 'rust)
  :ensure nil
  :commands rust-ts-mode
  :init
  (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))
  :custom
  (rust-ts-mode-hook rust-mode-hook))

;;;;; savehist
(use-package savehist
  :ensure nil
  :config
  (savehist-mode))

;;;;; snow
(use-package snow
  :ensure t
  :commands snow
  :custom-face
  (snow-flake ((t (:family "DejaVu Sans Mono")))))

;;;;; spacious-padding
(use-package spacious-padding
  :ensure t
  :config
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'spacious-padding-mode)
    (when (display-graphic-p)
      (spacious-padding-mode))))

;;;;; tempel
(use-package tempel
  :ensure t
  :preface
  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert))
  :custom
  ;; Require trigger prefix before template name when completing.
  ;; (tempel-trigger-prefix "<")
  (tempel-path (expand-file-name "templates/*.eld" user-emacs-directory))
  :init
  (add-hook 'conf-mode-hook #'tempel-setup-capf)
  (add-hook 'prog-mode-hook #'tempel-setup-capf)
  (add-hook 'text-mode-hook #'tempel-setup-capf))

;;;;; treesit
(use-package treesit
  :ensure nil
  :commands my/treesit-install-language-grammars
  :init
  (defun my/treesit-install-language-grammars ()
    "install tree-sitter grammars"
    (interactive)
    (dolist (grammar
             '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
               (c . ("https://github.com/tree-sitter/tree-sitter-c"))
               (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
               (css . ("https://github.com/tree-sitter/tree-sitter-css"))
               (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
               (json . ("https://github.com/tree-sitter/tree-sitter-json"))
               (nix . ("https://github.com/nix-community/tree-sitter-nix"))
               (python . ("https://github.com/tree-sitter/tree-sitter-python"))
               (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
               (toml . ("https://github.com/ikatyang/tree-sitter-toml"))
               (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
               (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
               (typst . ("https://github.com/uben0/tree-sitter-typst"))
               (yaml . ("https://github.com/ikatyang/tree-sitter-yaml"))))
      (add-to-list 'treesit-language-source-alist grammar)
      (unless (treesit-language-available-p (car grammar))
        (treesit-install-language-grammar (car grammar))))))

;;;;; tr-ime
(use-package tr-ime
  :if (eq system-type 'windows-nt)
  :ensure t
  :init
  (setq default-input-method "W32-IME")
  :config
  (tr-ime-standard-install)
  (w32-ime-initialize)
  (wrap-function-to-control-ime 'universal-argument t nil)
  (wrap-function-to-control-ime 'read-string nil nil)
  (wrap-function-to-control-ime 'read-char nil nil)
  (wrap-function-to-control-ime 'read-from-minibuffer nil nil)
  (wrap-function-to-control-ime 'y-or-n-p nil nil)
  (wrap-function-to-control-ime 'yes-or-no-p nil nil)
  (wrap-function-to-control-ime 'map-y-or-n-p nil nil)
  (wrap-function-to-control-ime 'register-read-with-preview nil nil))

;;;;; typst-ts-mode
(use-package typst-ts-mode
  :if (treesit-language-available-p 'typst)
  :ensure nil
  :commands typst-ts-mode
  :custom
  (typst-ts-mode-hook typst-mode-hook))

;;;;; vertico
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  :config
  (vertico-mode))

;;;;; vundo
(use-package vundo
  :ensure t
  :commands vundo)

;;;;; web-mode
(use-package web-mode
  :ensure t
  :mode ("\\.phtml\\'"
         "\\.tpl\\.php\\'"
         "\\.tpl\\'"
         "\\.hbs\\'"
         "\\.blade\\.php\\'"
         "\\.jsp\\'"
         "\\.as[cp]x\\'"
         "\\.erb\\'"
         "\\.html?\\'"
         "/\\(views\\|html\\|theme\\|templates\\)/.*\\.php\\'"))

;;;;; whitespace
(use-package whitespace
  :ensure nil
  :commands (whitespace-mode
             whitespace-cleanup)
  :custom
  (whitespace-display-mappings '((space-mark 32
                                             [183]
                                             [46])
                                 (space-mark 160
                                             [9085]
                                             [95])
                                 (newline-mark 10
                                               [9166 10]
                                               [36 10])
                                 (tab-mark 9
                                           [8594 9]
                                           [92 9]))))

;;;;; whitespace-cleanup-mode
(use-package whitespace-cleanup-mode
  :ensure t
  :config
  (global-whitespace-cleanup-mode))

;;;;; yaml-mode
(use-package yaml-mode
  :ensure t
  :mode "\\.ya?ml\\'")

;;;;; yaml-ts-mode
(use-package yaml-ts-mode
  :disabled
  :if (treesit-language-available-p 'yaml)
  :ensure nil
  :commands yaml-ts-mode
  :custom
  (yaml-ts-mode-hook yaml-mode-hook)
  :init
  (add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode)))

;;;;; yuck-mode
(use-package yuck-mode
  :ensure t
  :mode ("\\.yuck\\'" . yuck-mode))

(provide 'init)

;;; init.el ends here

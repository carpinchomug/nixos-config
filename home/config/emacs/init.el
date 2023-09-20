;;; Use-package
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(require 'diminish)
;; (require 'vc-use-package)

;; Load packages eagerly when in the daemon mode.
(when (daemonp)
  (setq use-package-always-demand t))


;;; Default settings
(use-package emacs
  :config
  ;; Remove visual clutters.
  (tool-bar-mode -1)
  (blink-cursor-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (setq ring-bell-function 'ignore)
  (setq inhibit-startup-screen t)

  ;; Provide sane scrolling.
  (setq scroll-margin 0
        scroll-conservatively 10000
        scroll-preserve-screen-position t)

  ;; Show line and column numbers at the point in the mode line.
  (line-number-mode)
  (column-number-mode)

  ;; Turn on visual line mode in all buffers.
  (global-visual-line-mode)

  ;; Set the tab width to be 2-column wide.
  (setq-default tab-width 2)

  ;; Insert spaces for indentation.
  (setq-default indent-tabs-mode nil)

  ;; Wrap lines at 80 chararacters when a filling mode is enabled.
  (setq-default fill-column 80)

  ;; Use a box cursor by default and a bar cursor when region selection is
  ;; active.
  (setq-default cursor-type 'box)
  (add-hook 'activate-mark-mode (lambda () (setq cursor-type 'bar)))
  (add-hook 'deactivate-mark-hook (lambda () (setq cursor-type 'box)))

  ;; Store backup and auto-save files in dedicated directories.
  (let ((backup-dir "~/.config/emacs/backups/")
        (auto-save-dir "~/.config/emacs/auto-saves"))
    (dolist (dir (list backup-dir auto-save-dir))
      (unless (file-directory-p dir)
        (make-directory dir t))
      (setq backup-directory-alist `((".*" . ,backup-dir))
            auto-save-file-name-transforms `((".*" ,auto-save-dir t)))))

  ;; Store custom information in this file instead of `init.el'.
  (setq custom-file "~/.config/emacs/custom-file.el")
  (when (file-exists-p custom-file)
    (load custom-file))

  ;; Replace "yes or no " prompto with "y or n".
  (setq use-short-answers t))


;;; Frame
(use-package frame
  :config
  (defun setup-fonts ()
    (set-fontset-font t
                      'japanese-jisx0213.2004-1
                      "Sarasa Mono J")
    (set-fontset-font "fontset-standard"
                      nil
                      "Iosevka Aile")
    (set-fontset-font "fontset-standard"
                      'japanese-jisx0213.2004-1
                      "Sarasa UI J")
    (set-face-attribute 'default nil :fontset "fontset-default" :height 120)
    (set-face-attribute 'fixed-pitch nil :fontset "fontset-default" :height 1.0)
    (set-face-attribute 'variable-pitch nil :fontset "fontset-standard" :height 1.0))
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook
                (lambda () (setup-fonts)))
    (setup-fonts)))


;;; Pixel scroll
(use-package pixel-scroll
  :config
  (pixel-scroll-precision-mode))


;;; Recentf
(use-package recentf
  :config
  (recentf-mode))


;;; Savehist
(use-package savehist
  :config
  (savehist-mode))


;;; Loading environment variables
(use-package exec-path-from-shell
  :ensure t
  :if (daemonp)
  :config
  (exec-path-from-shell-initialize))


;;; Themes
(use-package modus-themes
  :ensure t
  :config
  (setq modus-themes-mixed-fonts t)
  (setq modus-operandi-palette-overrides '((fringe unspecified)
                                           (bg-line-number-inactive upspecified)
                                           (bg-line-number-active unspecified)))
  (load-theme 'modus-operandi t))


;;; Spacious padding
(use-package spacious-padding
  :ensure t
  :config
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook
                (lambda () (spacious-padding-mode)))
    (spacious-padding-mode)))


;;; Olivetti
(use-package olivetti
  :ensure t)


;;; Nerd icons
(use-package nerd-icons
  :ensure t
  :init
  (setq nerd-icons-font-family "Iosevka Nerd Font"))


;;; Dashboard
(use-package dashboard
  :ensure t
  :config
  ;; Hide mode line.
  (add-hook 'dashboard-mode-hook (lambda () (setq mode-line-format nil)))
  ;; Show dashboard in emacsclient frames.
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

  (setq dashboard-center-content t
        dashboard-set-footer nil
        dashboard-set-init-info nil
        dashboard-projects-backend 'project-el
        dashboard-items '((recents . 5)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)))
  (dashboard-setup-startup-hook))


;;; Ligature
(use-package ligature
  :ensure t
  :config
  (ligature-set-ligatures 'prog-mode '("<--" "<---" "<<-" "<-" "->" "->>" "-->" "--->"
                                       "<==" "<===" "<<=" "<=" "=>" "=>>" "==>" "===>" ">=" ">>="
                                       "<->" "<-->" "<--->" "<---->" "<=>" "<==>" "<===>" "<====>" "::" ":::" "__"
                                       "<~~" "</" "</>" "/>" "~~>" "==" "!=" "<>" "===" "!==" "!==="
                                       "<:" ":=" "*=" "*+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+*" "=*" "=:" ":>"
                                       "/*" "*/" "[|" "|]" "++" "+++" "<!--" "<!---" ))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode))


;;; Face remapping
(use-package face-remap
  :hook (org-mode . variable-pitch-mode))


;;; Display line numbers
(use-package display-line-numbers
  :hook (prog-mode . display-line-numbers-mode)
  :init
  (setq display-line-numbers-type 'relative
        display-line-numbers-current-absolute t
        display-line-numbers-grow-only t))


;;; Parentheses
(use-package paren
  :hook (prog-mode . show-paren-mode)
  :init
  (setq show-paren-context-when-offscreen t))


;;; Electric pair
(use-package elec-pair
  :hook ((prog-mode . electric-pair-mode)
         (org-mode . (lambda ()
                      (setq-local electric-pair-inhibit-predicate
                                  `(lambda (c)
                                     (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))))


;;; Whitespace
(use-package whitespace
  :init
  (setq
   ;; whitespace-style
   ;; '(face
   ;;   space-mark
   ;;   tab-mark
   ;;   newline-mark)
   whitespace-display-mappings
   '((space-mark 32
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


;;; Eldoc
(use-package eldoc
  :init
  (setq eldoc-echo-area-prefer-doc-buffer t))


;;; Which key
(use-package which-key
  :ensure t
  :config
  (which-key-mode))


;;; Helpful
(use-package helpful
  :ensure t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)
         ("C-c C-d" . helpful-at-point)
         ("C-h F" . helpful-function)))


;;; Consult
(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded due by `use-package'.
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

  ;; The :init configuration is always executed (Not lazy)
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

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 3. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  ;;;; 4. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 5. No project support
  ;; (setq consult-project-function nil)
  )


;;; Embark
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

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

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook (embark-collect-mode . consult-preview-at-point-mode))


;;; Vertico
(use-package vertico
  :ensure t
  :config
  (setq vertico-cycle t)
  (vertico-mode))


;;; Marginalia
(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))


;;; Corfu
(use-package corfu
  :ensure t
  :hook (eshell-mode . (lambda ()
                         (setq corfu-auto nil)
                         (corfu-mode)))
  :init
  (defun corfu-send-shell (&rest _)
    "Send completion candidate when inside comint/eshell."
    (cond
     ((and (derived-mode-p 'eshell-mode) (fboundp 'eshell-send-input))
      (eshell-send-input))
     ((and (derived-mode-p 'comint-mode)  (fboundp 'comint-send-input))
      (comint-send-input))))
  :config
  (setq corfu-auto t
        corfu-cycle t
        corfu-quit-no-match 'separator)
  ;; Enable indentation+completion using the TAB key.
  (setq tab-always-indent 'complete)
  ;; Tab cycle if there are only few candidates
  (setq completion-cycle-threshold 3)
  (advice-add #'corfu-insert :after #'corfu-send-shell)
  (global-corfu-mode))


;;; Cape
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block))


;;; Tempel
(use-package tempel
  :ensure t
  :after cape
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
  :hook ((conf-mode . tempel-setup-capf)
         (prog-mode . tempel-setup-capf)
         (text-mode . tempel-setup-capf))
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert))
  :init
  ;; Require trigger prefix before template name when completing.
  ;; (setq tempel-trigger-prefix "<")
  (setq tempel-path (expand-file-name "templates/*.eld" user-emacs-directory)))


;;; Orderless
(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))


;;; Evil
(use-package evil
  :ensure t
  :config
  (setq evil-default-state 'emacs)
  (evil-mode))


;;; Ace window
(use-package ace-window
  :ensure t
  :bind ("C-x o" . 'ace-window)
  :init
  (setq aw-background nil))


;;; Beacon
(use-package beacon
  :ensure t
  :config
  (add-to-list 'beacon-dont-blink-major-modes 'dashboard-mode)
  (add-to-list 'beacon-dont-blink-major-modes 'comint-mode)
  (add-to-list 'beacon-dont-blink-major-modes 'eshell-mode)
  (add-to-list 'beacon-dont-blink-major-modes 'eat-mode)
  (beacon-mode))


;;; Expand region
(use-package expand-region
  :ensure t
  :bind ("C-=" . 'er/expand-region)
  :init
  (setq expand-region-smart-cursor t))


;;; Mozc
(use-package mozc
  :ensure t
  :init
  (setq default-input-method "japanese-mozc")
  (global-set-key [zenkaku-hankaku] 'toggle-input-method)
  (prefer-coding-system 'utf-8))


;;; Dired
(use-package dired
  :init
  (setq dired-kill-when-opening-new-dired-buffer t))


;;; Eat
(use-package eat
  :ensure t
  :hook (eshell-load . eat-eshell-mode))


;;; Git
(use-package magit
  :ensure t
  :after diff-hl
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-define-global-key-bindings nil)
  (setq transient-default-level 5))

(use-package magit-extras
  :after project)


;;; Diff highlight
(use-package diff-hl
  :ensure t
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh)
         (dired-mode . diff-hl-dired-mode)
         (conf-mode . diff-hl-margin-mode)
         (prog-mode . diff-hl-margin-mode)
         (text-mode . diff-hl-margin-mode))
  :config
  (global-diff-hl-mode))


;;; Gpg
(use-package epg
  :init
  (setq epg-pinentry-mode 'loopback))


;;; Pass
(use-package pass
  :ensure t)


;;; Org
(use-package org
  :ensure t
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :init
  (setq org-startup-with-inline-images t
        org-todo-keywords '((sequence "TODO" "|" "DONE" "CANCELLED"))
        org-agenda-files '("~/org"))
  :config
  (add-to-list 'org-modules 'org-tempo t)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t))))

(use-package org-modern
  :ensure t
  :config
  (setq
   ;; Edit settings
   org-auto-align-tags nil
   org-tags-column 0
   org-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t
   
   ;; Org styling, hide markup etc.
   org-hide-emphasis-markers t
   org-pretty-entities t
   ;; Agenda styling
   org-agenda-tags-column 0
   org-agenda-block-separator ?-
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"))
  (global-org-modern-mode))

(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :init
  (setq org-appear-autoemphasis t
        org-appear-autoentities t
        org-appear-autolinks t))


;;; Language modes

;;;; CMake
(use-package cmake-mode
  :ensure t)


;;;; Nix
(use-package nix-mode
  :ensure t)


;;;; Python
(use-package python
  :init
  (setq python-indent-guess-indent-offset-verbose nil))


;;;; Rust
(use-package rust-mode
  :ensure t
  :init
  (setq rust-format-on-save t))


;;;; TeX
(use-package tex
  :ensure auctex
  :hook ((LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . TeX-fold-mode))
  :init
  (setq TeX-parse-self t)
  (setq TeX-auto-save t)
  (setq-default TeX-engine 'luatex)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (setq LaTeX-electric-left-right-brace t))


;;;; Yuck
(use-package yuck-mode
  :ensure t)


;;; Web mode
(use-package web-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist
               '("/\\(views\\|html\\|theme\\|templates\\)/.*\\.php\\'" . web-mode)))


;;; Tree-sitter
(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-install nil) ; let nix install language grammars
  (setq rust-ts-mode-hook rust-mode-hook)
  (global-treesit-auto-mode))


;;; Eglot
(use-package eglot
  :ensure t
  :hook ((bash-ts-mode
          c-mode c-ts-mode
          c++-mode c++-ts-mode
          js-mode js-ts-mode typescript-ts-mode tsx-ts-mode
          nix-mode nix-ts-mode
          python-mode python-ts-mode
          rust-mode rust-ts-mode)
         . eglot-ensure)
  :config
  (setq eglot-autoshutdown t)
  (add-to-list 'eglot-server-programs `((nix-mode nix-ts-mode)
                                        . ,(eglot-alternatives '("nil" "nixd"))))
  (setq-default eglot-workspace-configuration
                '(:nil (:formatting (:command ["nixpkgs-fmt"]))
                  :nixd (:formatting (:command "nixpkgs-fmt")))))


;;; Envrc
(use-package envrc
  :ensure t
  :demand t
  :bind-keymap
  ("C-c e" . envrc-command-map)
  :config
  (envrc-global-mode))

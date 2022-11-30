(require 'package)
(package-initialize)

(eval-when-compile
  (require 'use-package))


;; UI
;; Remove some UI components the frame
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)


;; Launch into a scratch buffer instead of the startup screen
(setq inhibit-startup-message t)

;; Prevent pop-up window when prompting
(setq use-dialog-box nil)

;; Set fonts
;; (add-to-list 'default-frame-alist
;;              '(font . "FiraCode Nerd Font-13"))
;; (set-fontset-font t 'japanese-jisx0208 "Noto Sans CJK JP")
(add-to-list 'default-frame-alist
           '(font . "FiraCode Nerd Font-13"))
(defun setup-font ()
  (set-fontset-font t 'japanese-jisx0208 "Noto Sans CJK JP"))

(add-hook 'after-init-hook 'setup-font)
(add-hook 'server-after-make-frame-hook 'setup-font)

;; Scroll line by line
(setq scroll-step 1)

;; Smooth scrolling
(pixel-scroll-precision-mode)
(setq pixel-scroll-precision-use-momentum t)


;; Generate backup files in the tmp directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))


;; Kill the current dired buffer when another dired buffer is created.
;; With this option turned off, a dired buffer is attached to each directory
;; I visit.
(setq dired-kill-when-opening-new-dired-buffer t)


;; Custom keybindings
;; Bind M-o to other-window
(global-set-key (kbd "M-o") 'other-window)


;; Activate eshell on startup
;; (add-hook 'emacs-startup-hook (lambda () (eshell)))


;; Run `M-x recentf-open-files` to open recent files
(recentf-mode)


(setq-default indent-tabs-mode nil)


;; Enable auto-pairing
(electric-pair-mode)


;; Display line numbers
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-current-absolute t)
(setq display-line-numbers-width-start t)
(setq display-line-numbers-grow-only t)

(dolist (mode '(c-mode-hook
                emacs-lisp-mode-hook
                js-mode-hook
                python-mode-hook
                sh-mode-hook
                text-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode))))


;; Keep command history
(setq history-length 25)
(savehist-mode)


;; Remember the last visited place in a file
;; (save-place-mode)


;; Revert buffers when the underlying file has changed
(global-auto-revert-mode)


;; (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
;; (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)


(load-theme 'modus-operandi t)
;; (load-theme 'material-light t)
;; (use-package doom-themes
;;   :config
;;   (load-theme 'doom-material t))

;; (use-package doom-modeline
;;   :init
;;   (doom-modeline-mode 1))

(use-package which-key
  :config
  (which-key-mode))


(use-package magit)


(use-package pdf-tools
  :init
  (pdf-tools-install))


;; Direnv
(use-package direnv
  :config
  (direnv-mode))


;; Org-mode
;; Turn of viaual line mode in org mode
(use-package org
  :hook (org-mode . visual-line-mode)
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (julia . t)
     (python . t)
     (shell . t)
     (jupyter . t))) ; jupyter must be added last

  (setq org-startup-with-inline-images t)
  (setq org-confirm-babel-evaluate nil)

  (setq org-edit-src-content-indentation 0)

  (setq org-babel-default-header-args:jupyter-python '((:session . "py")
                                                       (:kernel . "python3")))
  (setq org-babel-default-header-args:jupyter-julia '((:session . "jl")
                                                      (:kernel . "julia-1.8")))

  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("jl" . "src julia"))
  (add-to-list 'org-structure-template-alist '("jp" . "src jupyter-python"))
  (add-to-list 'org-structure-template-alist '("jj" . "src jupyter-julia")))


(use-package jupyter)


;; Julia mode
(use-package julia-mode
  :hook (julia-mode . display-line-numbers-mode))


;; Nix mode
;; Automatically activate nix mode for .nix files
(use-package nix-mode
  :hook (nix-mode . display-line-numbers-mode)
  :config
  (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode)))


;; Rust mode
(use-package rustic
  :hook (rustic-mode . display-line-numbers-mode)
  :config
  (setq rustic-lsp-client 'eglot))

;; LaTeX
(use-package latex
  :ensure auctex
  :hook ((LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . TeX-fold-mode))
  :init
  (setq TeX-engine 'luatex)
  (setq TeX-parse-self t) ; Enable parse on load.
  (setq TeX-auto-save t) ; Enable parse on save.
  (setq-default TeX-master nil)
  (setq TeX-force-default-mode t)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (setq TeX-source-correlate-start-server t)
  (setq LaTeX-electric-left-right-brace t))


;; Eglot
;; Add language mode hooks
(use-package eglot
  :hook (((rust-mode
           python-mode
           nix-mode
           LaTeX-mode tex-mode context-mode texinfo-mode bibtex-mode) . eglot-ensure)
         (eglot-managed-mode . (lambda ()
                                 (setq-local eldoc-documentation-strategy
                                             #'eldoc-documentation-compose))))
  :config
  (add-to-list 'eglot-server-programs
               '((tex-mode context-mode texinfo-mode bibtex-mode) . ("texlab"))))


(use-package eglot-jl
  :init
  (eglot-jl-init))

;; (add-hook 'eglot-managed-mode-hook
;;           (lambda ()
;;             (setq-local eldoc-documentation-strategy
;;                         #'eldoc-documentation-compose)))


(use-package corfu
  ;; Optional customizations
  :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect-first nil)    ;; Disable candidate preselection
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-echo-documentation nil) ;; Disable documentation in the echo area
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))
  :hook (eshell-mode . (lambda ()
                         (setq-local corfu-auto nil)
                         (corfu-mode)))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since Dabbrev can be used globally (M-/).
  ;; See also `corfu-excluded-modes'.
  :init
  (global-corfu-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)

  ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete))

(defun corfu-send-shell (&rest _)
  "Send completion candidate when inside comint/eshell."
  (cond
   ((and (derived-mode-p 'eshell-mode) (fboundp 'eshell-send-input))
    (eshell-send-input))
   ((and (derived-mode-p 'comint-mode)  (fboundp 'comint-send-input))
    (comint-send-input))))

(advice-add #'corfu-insert :after #'corfu-send-shell)

;; Silence the pcomplete capf, no errors or messages!
;; (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)

;; Ensure that pcomplete does not write to the buffer
;; and behaves as a pure `completion-at-point-function'.
;; (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify)


(use-package marginalia
  :config
  (marginalia-mode))


(use-package vertico
  :config
  (vertico-mode))


(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))


;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
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
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
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
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-recent-file
   consult--source-project-recent-file
   :preview-key (kbd "M-."))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  )


(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))


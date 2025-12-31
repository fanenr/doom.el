;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

(setq doom-font (font-spec :family "Cascadia Mono NF" :size 16))
(setq doom-variable-pitch-font (font-spec :family "Noto Sans" :size 18))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
(setq doom-theme 'doom-vibrant)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; map
(defconst my-j-map (make-sparse-keymap))
(defconst my-o-map (make-sparse-keymap))
(global-set-key (kbd "C-j") my-j-map)
(global-set-key (kbd "C-o") my-o-map)

(map! "C-z" nil
      "C-x C-z" nil

      ;; move line
      "M-p" #'drag-stuff-up
      "M-n" #'drag-stuff-down
      (:map markdown-mode-map
            "M-n" nil "M-p" nil)

      ;; resize window
      "C-<up>" #'enlarge-window
      "C-<down>" #'shrink-window
      "C-<left>" #'shrink-window-horizontally
      "C-<right>" #'enlarge-window-horizontally

      ;; treemacs
      "C-0" #'treemacs-select-window

      ;; centaur-tabs
      "C-." #'centaur-tabs-forward
      "C-," #'centaur-tabs-backward
      "C-<" #'centaur-tabs-move-current-tab-to-left
      "C->" #'centaur-tabs-move-current-tab-to-right

      ;; copilot-mode
      (:map copilot-completion-map
            "<tab>" #'copilot-accept-completion
            "C-<tab>" #'copilot-accept-completion-by-word)

      ;; quick access
      (:map my-o-map
            ;; copilot
            "C-c" #'copilot-mode
            ;; format
            "C-f" #'+format/buffer
            ;; eglot
            "C-r" #'eglot-reconnect
            ;; eldoc
            "C-g" #'eldoc-box-quit-frame
            "C-o" #'eldoc-box-help-at-point)

      ;; jump expr/stmt
      (:map my-j-map
            "C-f" #'forward-sexp
            "C-b" #'backward-sexp
            "C-n" #'forward-list
            "C-p" #'backward-list
            "C-e" #'forward-sentence
            "C-a" #'backward-sentence))

;; editor
(setq-default tab-width 8)

;; auto mode
(add-to-list 'auto-mode-alist '("\\.clangd$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.clang-tidy$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.clang-format$" . yaml-mode))

;; vterm hook
;; turn off centaur-tabs
(add-hook! vterm-mode
  (centaur-tabs-local-mode nil))

;; c/c++ hook
;; switch to GNU style
(add-hook! (c-mode c++-mode)
  (c-set-style "gnu")
  (setq tab-width 8
        c-basic-offset 2))

(add-hook! (c-ts-mode c++-ts-mode)
  (c-ts-mode-set-style 'gnu)
  (setq tab-width 8
        c-ts-mode-indent-offset 2))

;; before-save hook
;; trim trailing whitespaces
(setq delete-trailing-lines t)
(add-hook! before-save
  (delete-trailing-whitespace))

;; corfu
(after! corfu
  (custom-set-faces!
    '(corfu-current
      :bold t
      :foreground "#ffffff"
      :background "#4f4f4f"))
  (setq corfu-preview-current nil
        corfu-preselect 'directory))

;; magit
(after! magit
  (setq magit-diff-refine-hunk 'all
        magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")))

;; eglot
(after! eglot
  ;; cmake lsp
  (add-to-list 'eglot-server-programs
               '((cmake-mode cmake-ts-mode) .
                 ("neocmakelsp" "--stdio")))
  ;; c/c++ lsp
  (add-to-list 'eglot-server-programs
               '((c-mode c-ts-mode c++-mode c++-ts-mode) .
                 ("clangd"
                  "-j=4"
                  "--malloc-trim"
                  "--pch-storage=disk"
                  "--query-driver=/usr/bin/gcc,/usr/bin/g++"))))

;; apheleia
(after! apheleia
  ;; cmake formatter
  (set-formatter! 'neocmakelsp
    '("neocmakelsp" "--format" filepath) :modes '(cmake-mode)))

;; whitespace
(global-whitespace-mode t)
(after! whitespace
  (setq whitespace-style '(face tabs spaces tab-mark space-mark)))

;; eldoc-box
(use-package! eldoc-box
  :config
  (setq eldoc-box-max-pixel-width 800
        eldoc-box-max-pixel-height 400))

;; copilot
(use-package! copilot
  :config
  (add-to-list 'copilot-indentation-alist '(json-ts-mode 2))
  (add-to-list 'copilot-indentation-alist '(yaml-ts-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))

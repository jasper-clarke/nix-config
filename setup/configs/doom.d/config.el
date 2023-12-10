;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(global-visual-line-mode t)

(map! :leader
      (:prefix ("z" . "Undo / Redo")
       :desc "Undo"
       "[" #'undo
       "]" #'redo))

(map! :leader
      :desc "Recent Files"
      "r" #'helm-recentf)

(defun config-directory ()
  (interactive)
  (find-file "~/.config"))


(assoc-delete-all "Open org-agenda" +doom-dashboard-menu-sections)
(assoc-delete-all "Recently opened files" +doom-dashboard-menu-sections)
(assoc-delete-all "Open project" +doom-dashboard-menu-sections)
(assoc-delete-all "Jump to bookmark" +doom-dashboard-menu-sections)
(assoc-delete-all "Open private configuration" +doom-dashboard-menu-sections)
(assoc-delete-all "Open documentation" +doom-dashboard-menu-sections)


(setq doom-theme 'gruvbox-dark-soft)

(setq doom-font (font-spec :family "JetBrains Mono" :size 17))

;; The custom entries

;; (use-package ewal
;;   :init (setq ewal-use-built-in-always-p nil
;;               ewal-use-built-in-on-failure-p t
;;               ewal-built-in-palette "sexy-material"))
;; (use-package ewal-spacemacs-themes
;;   :init (progn
;;           (setq spacemacs-theme-underline-parens t
;;                 my:rice:font (font-spec
;;                               :family "JetBrains Mono"
;;                               :weight 'normal
;;                               :size 11.0))
;;           (show-paren-mode +1)
;;           (global-hl-line-mode)
;;           (set-frame-font my:rice:font nil t)
;;           (add-to-list  'default-frame-alist
;;                         `(font . ,(font-xlfd-name my:rice:font))))
;;   :config (progn
;;             (load-theme 'ewal-spacemacs-modern t)
;;             (enable-theme 'ewal-spacemacs-modern)))

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)

;;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-ayu-dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(add-hook! '+doom-dashboard-functions :append
  (insert "\n" (+doom-dashboard--center +doom-dashboard--width "If you find a Cabbage, never look it in the eyes!") "" ))

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

;; (setq fancy-splash-image (concat doom-user-dir "allusive.png"))

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

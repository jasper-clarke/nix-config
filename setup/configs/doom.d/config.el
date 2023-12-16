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

(setq doom-font (font-spec :family "JetBrains Mono" :size 28 :weight normal))

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

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(add-hook! '+doom-dashboard-functions :append
  (insert "\n" (+doom-dashboard--center +doom-dashboard--width "If you find a Cabbage, never look it in the eyes!") "" ))

;; (use-package! org-auto-tangle
;;   :defer t
;;   :hook (org-mode . org-auto-tangle-mode)
;;   :config
;;   (setq org-auto-tangle-default t))

;; (setq fancy-splash-image (concat doom-user-dir "allusive.png"))


;;; Code:

;; --------------------------------- remove things
(setq inhibit-startup-message t)
(setq initial-scratch-message ";; indigo")
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; --------------------------------- config things
(global-linum-mode t)
(set-frame-font "Space Mono 11" nil t)
(setq-default indent-tabs-mode t)
(setq tab-width 4)
(setq-default tab-width 4)
(set-window-margins (selected-window) 1 1)

;; --------------------------------- themes
(load "/home/indigo/.emacs.d/warm-theme.el")
(load-theme 'warm t)

;; -------------------------------- functions
(defun move-line-up ()
  "Move a line up."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  "Move a line down."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

;; --------------------------------- packages
(require 'package)
(setq package-enable-at-startup nil)

; MELPA
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package) ; install use-package if not installed
  (package-refresh-contents)
  (package-install 'use-package))

; --------------- installed packages

(use-package which-key
  :ensure t
  ;:config (which-key-mode))
  :config
  (progn
    (which-key-setup-side-window-right)
    (which-key-mode)
   )
)

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t))
  )

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode t)
)
(set-face-attribute 'flycheck-error nil :underline "#b24b50")
(set-face-attribute 'flycheck-warning nil :underline "#df8038")
(set-face-attribute 'flycheck-info nil :underline "#6b7d7a")
;;(set-face-attribute 'flycheck-info-postframe :foreground )


(use-package ace-window
  :ensure t
  :bind (("M-o" . ace-window)))
; M-o <?>
; x -> delete window
; m -> swap windows
; v/b -> slipt window vertical/horizontaly

(use-package all-the-icons
  :ensure t)
(use-package neotree
  :ensure t
  :config
  (progn
    (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))
  :bind (("C-\\" . 'neotree-toggle))
  )
(custom-set-faces
 '(neo-dir-link-face ((t (:foreground "#5f2f45"))))
 '(neo-file-link-face ((t (:foreground "#c3523f"))))
 '(neo-root-dir-face ((t (:foreground "#df8038")))))
; TAB -> to open file or unfold/fold directory
; C-c C-c -> change root directory
; C-c C-n -> create file or directory if ends with /
; C-c C-d -> delete file or directory
; C-c C-r -> rename file or directory
; C-c C-c -> change to root directory
; C-c C-p -> copy file or directory
; | -> open file on side

;; -------------------------------- keybindings
(global-set-key (kbd "C-<tab>") 'other-window)
(global-set-key (kbd "M-<up>") 'enlarge-window)
(global-set-key (kbd "M-<down>") 'shrink-window)
(global-set-key (kbd "M-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-<left>") 'shrink-window-horizontally)

(global-set-key (kbd "C-<up>") 'move-line-up)
(global-set-key (kbd "C-<down>") 'move-line-down)
;(global-set-key (kbd "C-r"), 'neotree-change-root)

(global-set-key (kbd "C-x C-b") 'ibuffer)

;;; Commentary:
;; ------------------------------- melpa things
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(flycheck which-key use-package neotree clues-theme auto-complete all-the-icons ace-window)))


;;; .emacs and here

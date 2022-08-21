;;; Code:

;; --------------------------------- remove things
(setq inhibit-splash-screen t)
(setq initial-scratch-message ";;;
;;; ░▒░░░░█░░▒█▒██▀░█▒░░▄▀▀░▄▀▄░█▄▒▄█▒██▀░░░▒░
;;; ░▀▀▒░░▀▄▀▄▀░█▄▄▒█▄▄░▀▄▄░▀▄▀░█▒▀▒█░█▄▄▒░░▀▀
")
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; --------------------------------- config things
(global-linum-mode t)
(set-frame-font "Space Mono 11" nil t)

(setq-default indent-tabs-mode t
              tab-width 4)

(add-hook 'python-mode-hook
  (lambda ()
    (setq indent-tabs-mode t)
    (setq python-indent 4)
    (setq tab-width 4)))

(set-window-margins (selected-window) 1 1)
(setq header-line t)
(setq header-line-format " ")
(setq-default line-spacing 0.1)
;; (customize-set-variable 'fill-column 80)
;; (global-display-fill-column-indicator-mode)

;; --------------------------------- modeline
(setq-default mode-line-format
	   (list
		'(:eval
		  (list

		   (propertize " ")
		   (when (buffer-modified-p)
			 (concat
			  (propertize (all-the-icons-octicon "pencil" :height 0.7 :v-adjust 0.2))
			  (propertize " ")))

		   (propertize "%b" 'help-echo (buffer-file-name))
		
		   (propertize " · ")
		   (propertize (all-the-icons-octicon "three-bars" :height 0.7 :v-adjust 0.1))
		   (propertize " %l:%c")
		
		   (propertize " · ")
		   (propertize (all-the-icons-octicon "checklist" :height 0.7 :v-adjust 0.1))
		   (propertize " %ikB")))
	
		'(:eval (when-let (vc vc-mode)
				  (list " · "
						(all-the-icons-octicon "git-branch" :height 0.7 :v-adjust 0.2)
						(propertize " ")
						(propertize (substring vc 5)))))

		(propertize " · ")
		'(:eval
		  (let* ((text (pcase flycheck-last-status-change
                (`finished (if flycheck-current-errors
                               (let ((count (let-alist (flycheck-count-errors flycheck-current-errors)
                                              (+ (or .warning 0) (or .error 0)))))
                                 (format "✖ %s Issue%s" count (unless (eq 1 count) "s")))
                             "✔ No Issues"))
                (`running     "⟲ Running")
                (`no-checker  "⚠ No Checker")
                (`not-checked "✖ Disabled")
                (`errored     "⚠ Error")
                (`interrupted "⛔ Interrupted")
                (`suspicious  ""))))
			(propertize text
                 'help-echo "Show Flycheck Errors"
                 'mouse-face '(:box 1)
                 'local-map (make-mode-line-mouse-map
                             'mouse-1 (lambda () (interactive) (flycheck-list-errors))))))
		
	   ))

;; --------------------------------- themes
(load "/home/indigo/.config/emacs/warm-theme.el")
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

(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
	(if (region-active-p)
       (setq beg (region-beginning) end (region-end))
       (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))


;; auto close html:
(defun my-sgml-insert-gt ()
  "Insert a `>' character and call `my-sgml-close-tag-if-necessary', leaving point where it is."
  (interactive)
  (insert ">")
  (save-excursion (my-sgml-close-tag-if-necessary)))

(defun my-sgml-close-tag-if-necessary ()
  "Call sgml-close-tag if the tag before point is an opening tag not followed by a matching closing tag."
  (when (looking-back "<\\s-*\\([^</> \t\r\n]+\\)[^</>]*>")
    (let ((tag (match-string 1)))
      (unless (and (not (sgml-unclosed-tag-p tag))
           (looking-at (concat "\\s-*<\\s-*/\\s-*" tag "\\s-*>")))
    (sgml-close-tag)))))

(eval-after-load "sgml-mode"
  '(define-key sgml-mode-map ">" 'my-sgml-insert-gt))

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

;; (use-package auto-complete
  ;; :ensure t
  ;; :init
  ;; (progn
    ;; (ac-config-default)
    ;; (global-auto-complete-mode t))
  ;; )

(use-package org)
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(use-package python)
;;(use-package flycheck-rust)

(use-package jedi
  :ensure t
  :init
  (add-hook 'python-mode-hook 'jedi:setup)
  (add-hook 'python-mode-hook 'jedi:ac-setup))
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode t)
)
(set-face-attribute 'flycheck-error nil :underline "#b24b50")
(set-face-attribute 'flycheck-warning nil :underline "#df8038")
(set-face-attribute 'flycheck-info nil :underline "#6b7d7a")
;;(set-face-attribute 'flycheck-info-postframe :foreground )

(use-package all-the-icons
  :ensure t)
(use-package neotree
  :ensure t
  :config
  (progn
    (setq neo-theme (if (display-graphic-p) 'icons 'ascii)))
  :bind (("C-\\" . 'neotree-toggle))
  )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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
(global-set-key (kbd "C-;") 'comment-or-uncomment-region-or-line)

(global-set-key (kbd "C-x C-b") 'ibuffer)   ; buffer window
(setq skeleton-pair t)                      ; auto-close-things
(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)


;;; Commentary:
;; ------------------------------- melpa things
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(indent-tabs-mode t)
 '(package-selected-packages
   '(racer rustic jedi flycheck use-package neotree clues-theme auto-complete all-the-icons ace-window))
 '(python-indent-def-block-scale 4)
 '(python-indent-guess-indent-offset nil)
 '(python-indent-offset 4))


;;; .emacs end here

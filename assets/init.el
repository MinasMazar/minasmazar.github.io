(add-to-list 'load-path "~/.emacs.d/vendor/") ; that's your sandbox
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t
      package-enable-at-startup t)
(package-initialize)

(use-package emacs
  :if nil
  :ensure nil
  :defer
  :hook ((after-init . toggle-frame-maximized)
	 (minibuffer-setup . (lambda ()
			       (local-set-key (kbd "C-o") #'switch-to-completions)
			       (local-set-key (kbd "C-n") #'switch-to-completions)
			       (local-set-key (kbd "C-c") #'switch-to-completions))))
  :custom
  (use-short-answers t)
  (enable-recursive-minibuffers t)
  (shr-inhibit-images t)
  (initial-buffer-choice #'eshell)
  :config
  (tool-bar-mode -1)
  ;; (menu-bar-mode -1)
  (savehist-mode 1)
  (recentf-mode 1)
  (ffap-bindings)
  (fido-vertical-mode 1)

  ;; Shared configuration
  (if (file-exists-p "~/Dropbox/minemacs/")
      (setq bookmark-file "~/Dropbox/minemacs/bookmarks"
  	    eshell-aliases-file "~/Dropbox/minemacs/eshell-aliases"
  	    custom-file "~/Dropbox/minemacs/custom.el"))
  (if (file-exists-p "~/Dropbox/minemacs/org")
      (setq org-agenda-files '("~/Dropbox/minemacs/org/")
  	    org-roam-directory "~/Dropbox/minemacs/org/roam/"))

  ;; Helpers
  (defun minemacs-files-in-emacs-subdir (subdir)
    (message "Scan files in emacs subdir %s" subdir)
    (let ((scan-dir (concat user-emacs-directory (format "%s/" subdir "/"))))
      (message "Scan files in dir %s" scan-dir)
      (if (file-exists-p scan-dir)
  	  (directory-files scan-dir t directory-files-no-dot-files-regexp))))

  ;; Modules
  (defun minemacs-modules-load ()
    "Load all modules '*.el' files in './.emacs.d/modules/'"
    (interactive)
    ;; TODO: locate-dominating-file
    (let ((modules (minemacs-files-in-emacs-subdir "modules")))
      (if modules (mapcar (lambda (module)
  			    (load  module 'noerror))
  			  modules))))

  ;; Contexts
  (defun minemacs-contexts ()
    (minemacs-files-in-emacs-subdir "contexts"))

  (defun minemacs-switch-context (&optional context)
    (interactive (list (completing-read "Context: " (minemacs-contexts))))
    (load context 'noerror)
    ;; (setq-local default-directory context)
    (hack-dir-local-variables-non-file-buffer))

  (load custom-file 'noerror)
  (minemacs-modules-load)
  :bind
  (("C-k" . #'execute-extended-command)
   ("C-l" . #'god-mode)
   ("s-k" . #'execute-extended-command)
   ("s--" . #'bookmark-jump)
   ("s-)" . #'kill-current-buffer)
   ("s-[" . #'previous-buffer)
   ("s-]" . #'next-buffer)
   ("s-N" . #'dired-jump)
   ("s-e" . #'dabbrev-expand)
   ("s-r" . #'repeat)
   ("s-w" . #'other-window)
   ("s-1" . #'delete-other-windows)
   ("s-2" . #'split-window-below)
   ("s-3" . #'split-window-right)
   ("s-0" . #'delete-window)
   :map key-translation-map
   ("s-m" . "\C-x")
   ("s-M" . "\C-c")
   :map isearch-mode-map
   ("C-p" . #'isearch-repeat-backward)
   ("C-n" . #'isearch-repeat-forward)
   ("<tab>" . #'isearch-repeat-forward)
   ("<S-tab>" . #'isearch-repeat-backward)
   :map completion-list-mode-map
   ("e" . #'switch-to-minibuffer)))

(use-package god-mode
  :ensure t
  :init
  (defun minemacs-god-mode-disabled ()
    (setq cursor-type 'bar))

  (defun minemacs-god-mode-enabled ()
    (setq cursor-type 'box))

  :hook ((god-mode-enabled . minemacs-god-mode-enabled)
  	 (god-mode-disabled . minemacs-god-mode-disabled))
  :bind
  (("C-k" . #'execute-extended-command)
   ("C-l" . #'god-local-mode)
   :map god-local-mode-map
   ("i" . #'god-local-mode)
   ("u" . #'undo)
   ("U" . #'redo)
   ("[" . #'backward-paragraph)
   ("]" . #'forward-paragraph))
  :config
  (god-mode-all 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

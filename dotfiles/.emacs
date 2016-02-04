;; Bootstrap Emacs config
;; Emacs Version: 24.4

;; == VARIABLES ==
(setq OSX_FONT "Ubuntu Mono-14")
(setq WIN_FONT "Consolas-12")

;; == WINDOW SETTINGS ==
;; align emacs window to the right
(setq default-frame-alist
    '((top . 30) (left . 900)
	(width . 140) (height . 70)))
;; set F5 for toggling fullscreen
(global-set-key (kbd "<f5>") 'toggle-frame-fullscreen)

;; == MUNDANE STUFF ==
;; personal info
(setq user-full-name "Kai Wolf")
(setq user-mail-address "kai.wolf@gmail.com")
;; set start directory
(setq default-directory "~/")
;; disable all audio alarms
(setq ring-bell-function 'ignore)
;; suppress start screen
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
;; hide scroll- and toolbar when in gui mode
(if (display-graphic-p) (scroll-bar-mode -1))
(if (display-graphic-p) (tool-bar-mode -1))
;; make no backup files
(setq make-backup-files nil)
;; follow symlinks and don't ask for it
(setq vc-follow-symlinks t)
;; no cursor blinking
(blink-cursor-mode 0)
;; show line and column numbers
(line-number-mode 1)
(column-number-mode 1)
(global-linum-mode 1)
;; word wrap mode
(if (display-graphic-p) (global-visual-line-mode t))

;; == EMACS CUSTOMIZATIONS ==
(add-to-list 'display-buffer-alist
                 '(".*Flycheck errors". ((display-buffer-pop-up-window) .
                                         ((inhibit-same-window . t)
                                          (inhibit-switch-frame . t)))))
(defun flymake-display-warning (warning) 
  "Display a warning to the user, using lwarn"
  (message warning))


;; == OS ADJUSTMENTS  ==
(if (eq system-type 'darwin) (setq ns-alternate-modifier (quote none)))
(if (eq system-type 'darwin) (setq ns-command-modifier (quote meta)))

;; == FONTS AND THEME ==
;; set default font depending on what OS is in use
(if (eq system-type 'darwin) (set-default-font OSX_FONT))
(if (eq system-type 'windows-nt) (set-default-font WIN_FONT))
;; set foreground and background color
(add-to-list 'default-frame-alist '(background-color . "#282828"))
(add-to-list 'default-frame-alist '(foreground-color . "#F0F0F0"))
;; highlight current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#666666")
(set-face-foreground 'highlight nil)

;; == ORGMODE CUSTOMIZATIONS ==
;; org-mode line wrapping
(add-hook 'org-mode-hook 'visual-line-mode)
;; org-mode indent bullets
(add-hook 'org-mode-hook 'org-indent-mode)

;; ===== LATEX SETTINGS =====
;; set texbin to emacs PATH
(getenv "PATH")
 (setenv "PATH" (concat  "/usr/texbin" ":"
(getenv "PATH")))
;; AucTeX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq TeX-PDF-mode t)
(setq LaTeX-command-style '(("" "%(PDF)%(latex) -file-line-error %S%(PDFout)")))
 
;; Use Skim as viewer, enable source <-> PDF sync
;; make latexmk available via C-c C-c
;; Note: SyncTeX is setup via ~/.latexmkrc (see below)
(add-hook 'LaTeX-mode-hook (lambda ()
  (push
    '("latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
      :help "Run latexmk on file")
    TeX-command-list)))
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))
 
;; use Skim as default pdf viewer
;; Skim's displayline is used for forward search (from .tex to .pdf)
;; option -b highlights the current line; option -g opens Skim in the background  
(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
      '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))

;; == PACKAGE MANAGEMENT ==
;; list of dependent packages
(setq package-list '(autopair
                     auto-complete
                     auto-complete-clang
                     clang-format
                     company
                     company-c-headers
                     cpputils-cmake
                     neotree
                     flymake-cppcheck
                     flycheck
                     org-mac-link
                     powerline))
;; melpa package manager and archives
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
;; activate all packages
(package-initialize)
;; fetch the list of available packages
(unless package-archive-contents
  (package-refresh-contents))
;; install missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))
;; load installed packages
(autopair-global-mode 1)
(setq clang-format-executable "/usr/local/bin/clang-format")
(powerline-default-theme)
(add-hook 'c-mode-common-hook
  (lambda ()
    (if (derived-mode-p 'c-mode 'c++-mode)
        (cppcm-reload-all))))
;; load default packages
(ido-mode 1)
(setq whitespace-line-column 80)
(setq whitespace-style '(face lines-tail))                            
(global-whitespace-mode 1)

;; == PROGRAMMING SETTINGS ==
;; make indentation commands use space only (never tab character)
(setq-default indent-tabs-mode nil)
;; set default tab char's display width to 4 spaces
(setq-default tab-width 4)
;; set standard indent to 4
(setq-default standard-indent 4)
(setq-default c-basic-offset 4)
;; enable all necessary modes when coding
(defun my-c-c++-mode-hook ()
  (company-mode 1)
  (auto-complete-mode 1)
  (flycheck-mode 1)
  (setq flycheck-clang-language-standard "c++11")
  (setq flymake-gui-warnings-enabled nil)
  (flymake-mode 1))
(add-hook 'c-mode-hook 'my-c-c++-mode-hook)
(add-hook 'c++-mode-hook 'my-c-c++-mode-hook)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'term-mode-hook
      (lambda ()
        (interactive)
        (set-window-dedicated-p (selected-window) 1)))

;; == CUSTOM KEYBINDINGS ==
(global-set-key (kbd "C-c t") 'neotree-dir)
(global-set-key (kbd "C-S-c") 'comment-or-uncomment-region)
(global-set-key (kbd "C-S-f") 'clang-format-region)
(global-set-key (kbd "<f2>") 'clang-format-buffer)
(global-set-key (kbd "<f8>") 'neotree-toggle)
(global-set-key (kbd "C-S-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-S-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-S-<down>") 'shrink-window)
(global-set-key (kbd "C-S-<up>") 'enlarge-window)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((TeX-master . t)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File name: ` ~/.emacs '
;;; ---------------------
;;;
;;; If you need your own personal ~/.emacs
;;; please make a copy of this file
;;; an placein your changes and/or extension.
;;;
;;; Copyright (c) 1997-2002 SuSE Gmbh Nuernberg, Germany.
;;;
;;; Author: Werner Fink, <feedback@suse.de> 1997,98,99,2002
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Test of Emacs derivates
;;; -----------------------
(if (string-match "XEmacs\\|Lucid" emacs-version)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; XEmacs
  ;;; ------
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (progn
     (if (file-readable-p "~/.xemacs/init.el")
        (load "~/.xemacs/init.el" nil t))
  )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; GNU-Emacs
  ;;; ---------
  ;;; load ~/.gnu-emacs or, if not exists /etc/skel/.gnu-emacs
  ;;; For a description and the settings see /etc/skel/.gnu-emacs
  ;;;   ... for your private ~/.gnu-emacs your are on your one.
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (if (file-readable-p "~/.gnu-emacs")
      (load "~/.gnu-emacs" nil t)
    (if (file-readable-p "/etc/skel/.gnu-emacs")
        (load "/etc/skel/.gnu-emacs" nil t)))

  ;; Custum Settings
  ;; ===============
  ;; To avoid any trouble with the customization system of GNU emacs
  ;; we set the default file ~/.gnu-emacs-custom
  (setq custom-file "~/.gnu-emacs-custom")
  (load "~/.gnu-emacs-custom" t t)
;;;
)
;;;


;;;; EGET ;;;;

;; Load path
(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
    (let* ((my-lisp-dir "~/.emacs.d/el/")
           (default-directory my-lisp-dir))
      (setq load-path (cons my-lisp-dir load-path))
      (normal-top-level-add-subdirs-to-load-path)))

;; No toolbar to work around KDE4/Emacs23 bug
(tool-bar-mode -1)

;; No splash
(setq inhibit-splash-screen t)

;; Noo beeeeep
(setq visible-bell t)

;; No ~~~backup
(setq make-backup-files nil)

;; Better uniqification of buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Scroll 1 line
(setq scroll-step 1)

;; No scroll bars
(setq scroll-bar-mode nil)

;; scrollning
(setq scroll-step 1)
(setq scroll-bar-width '(5)) ; ???
(scroll-bar-mode "right")
(mouse-wheel-mode t)

(setq mouse-wheel-scroll-amount '(10 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling

;; No tabs
;; I hate tabs
(setq-default indent-tabs-mode nil)

(setq untabify-modes
      '(emacs-lisp-mode
        casm-mode
        c-mode
        c++-mode
        python-mode
        xml-mode
        latex-mode))

(defun untabify-hook ()
  (when (member major-mode untabify-modes)
    (untabify (point-min) (point-max))))

(add-hook 'before-save-hook 'untabify-hook)

;;;; C mode hooks
(require 'cc-mode)

(setq-default c-basic-offset 2)
(setq-default c-default-style "linux")

(defun my-c-mode-common-hook ()
  ; (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (setq indent-tabs-mode nil)
  (setq c-indent-level 2)
  (setq c-default-style "linux")
  (setq c-basic-offset 2)

  (c-set-offset 'inline-open       0)  ;; No indent on opening { if inlined in class def
  (c-set-offset 'case-label        '+) ;; Indent case lables
  (c-set-offset 'statement-cont    0)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'innamespace       0)

  (setq c-tab-always-indent t)
  (define-key c-mode-base-map (kbd "RET") 'newline-and-indent))

(setq c-mode-common-hook nil)
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; Don't truncate split windows. If set to integer N, partial windows with fewer
;; columns than N will be truncated instead of wrapped.
(setq truncate-partial-width-windows nil)

;; Fill to column 100
(setq-default fill-column 100)

;;;; Highlight beyond fill column
(require 'highlight-beyond-fill-column)

;; Override custom-set-var for highlight-beyond-fill-column
(setq highlight-beyond-fill-column-in-modes (quote ("c-mode-common" "c++-mode" "python-mode")))
(setq highlight-beyond-fill-column-face '(:background "deep pink" :foreground "white"))

;; Color
(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-blue2)

;; Ido mode, scatter match on file open, buffer switch etc.
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching

;; Highlight
(global-font-lock-mode 1)

;; Func name
(which-func-mode t)
;;
;; Mode line
(line-number-mode 1)
(setq column-number-mode t)
(display-time-mode 0)
(setq default-mode-line-format
      '("-"
       mode-line-mule-info
       mode-line-modified
       mode-line-frame-identification
       mode-line-buffer-identification
       "  "
       (which-func-mode ("" which-func-format " -"))
       (line-number-mode "L%l ")
       (column-number-mode "C%c ")
       (-3 . "%p")
       "- "
       global-mode-string
       "("
       mode-name
       mode-line-process
       ;minor-mode-alist
       "%n"
       ")")
      )

(require 'usefull)

;; ;;;; Flymake syntax check
;; (require 'flymake)
;; (setq flymake-allowed-file-name-masks
;;       '(("\\.py\\'"         flymake-pylint-init)
;;         ;; ("\\.c\\'"          flymake-simple-make-init)
;;         ;; ("\\.cpp\\'"        flymake-simple-make-init)
;;         ("\\.xml\\'"        flymake-xml-init)
;;         ("\\.html?\\'"      flymake-xml-init)
;;         ("\\.cs\\'"         flymake-simple-make-init)
;;         ("\\.p[ml]\\'"      flymake-perl-init)
;;         ("\\.php[345]?\\'"  flymake-php-init)
;;         ;; ("\\.h\\'"          flymake-master-make-header-init flymake-master-cleanup)
;;         ("\\.java\\'"       flymake-simple-make-java-init flymake-simple-java-cleanup)
;;         ("[0-9]+\\.tex\\'"  flymake-master-tex-init flymake-master-cleanup)
;;         ("\\.tex\\'"        flymake-simple-tex-init)
;;         ("\\.idl\\'"        flymake-simple-make-init)))


;; Python:
;; pymacs,
;; auto-complete,
;; rope (python refactoring),
;; yasnippets (code template expansion thingy
(require 'python-stuff)
(require 'auto-complete)
;;;; Python mode hooks
(add-hook 'python-mode-hook
      (function (lambda ()
                  (add-hook 'before-save-hook 'delete-trailing-whitespace)
                  (set-variable 'py-indent-offset 4)
                  ;(set-variable 'py-smart-indentation t)
                  (set-variable 'indent-tabs-mode nil)
                  (define-key py-mode-map (kbd "RET") 'newline-and-indent))))
(setq auto-mode-alist
      (append
           '(("SConstruct" . python-mode)
             ("SConscript" . python-mode)
             ("\\.mak" . make-mode)
             ("\\.mk" . make-mode)
             ("\\.comp\\'" . xml-mode)
             ("\\.arch\\'" . xml-mode)
             ("\\.proc\\'" . xml-mode)
             ("\\.system\\'" . xml-mode))
       auto-mode-alist))
;;;
;;;; Winner mode, undo / redo window config with C-c left, C-c right
(when (fboundp 'winner-mode)
  (winner-mode 1))

(defun flymake-get-tex-args (file-name)
    (list "pdflatex" (list "-file-line-error" "-draftmode" "-interaction=nonstopmode" file-name)))

;; Key bindings ------------------------------------------------------
;; Usefull:
(global-set-key (kbd "C-S-l") 'recenter-all-other-window)
(global-set-key (kbd "C-Ö") 'recenter-high-all-other-window)
(global-set-key (kbd "M--") 'my-list-tags)

;; Non std:
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-.") 'other-window)
(global-set-key (kbd "M-C-s") 'search-forward-regexp)

;; unit test support
(require 'unit-test)
(define-key global-map (kbd "C-c u") 'run-unit-tests)
(define-key global-map (kbd "C-c o") 'goto-test-or-impl)

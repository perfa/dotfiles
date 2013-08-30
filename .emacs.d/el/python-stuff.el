
;; Requires pymacs, rope and pyflakes
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/el/yasnippet-0.6.1c/snippets")

(require 'auto-complete)
;; (define-key ac-complete-mode-map "\t" 'ac-complete)
;; (define-key ac-complete-mode-map "\r" nil)
(ac-set-trigger-key "TAB")
(setq ac-auto-start nil)
(setq yas/trigger-key "<backtab>")
(require 'auto-complete-yasnippet)

(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(require 'python-mode)
(add-hook 'python-mode-hook
      (lambda ()
        ;(define-key py-mode-map (kbd "<backtab>") 'yas/expand)
        ;(setq yas/after-exit-snippet-hook 'indent-according-to-mode)
        ;(smart-operator-mode t)
        (auto-complete-mode t)))
;; pymacs
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))
;; (pymacs-load "ropemacs" "rope-")
;; (setq ropemacs-enable-autoimport t)



;;Auto Syntax Error Hightlight
(when (load "flymake" t)
  (defun flymake-pylint-init (&optional trigger-type)
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
'flymake-create-temp-inplace))
(local-file (file-relative-name
temp-file
(file-name-directory buffer-file-name)))
(options (when trigger-type (list "--trigger-type" trigger-type))))
      (list "~/.emacs.d/el/pyflymake.py" (append options (list local-file))))))

(add-hook 'find-file-hook 'flymake-find-file-hook)

(provide 'python-stuff)

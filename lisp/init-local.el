;;; local --- local mode
;;; Code:
;;; Commentary:
;; Set load path
(push "~/.emacs.d/site-lisp" load-path)

;; custom path
(setq package-archives '(("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;;; Customize theme
(require-package 'moe-theme)
(load-theme 'moe-dark t)
;; go mode config

;; (require 'ox-odt)
(require-package 'sql-indent)
(add-hook 'sqlind-minor-mode-hook
          (lambda ()
            (setq sqlind-basic-offset 4)
            ))
(message "Init sql indent ok")

(require-package 'rjsx-mode)
(add-to-list 'auto-mode-alist '(".*\\.js" . rjsx-mode))
(add-hook 'rjsx-mode-hook
          (lambda ()
            (setq emmet-expand-jsx-className? t)
            (emmet-mode t)
            (prettier-js-mode)
            ))
(add-to-list 'auto-mode-alist '(".*\\.json" . json-mode))
(add-hook 'json-mode-hook
          (lambda ()
            (setq-local js-indent-level 4))
          )

(message "Init js ok")

(require-package 'yafolding)
(define-key yafolding-mode-map (kbd "C-c h") 'yafolding-hide-parent-element)
(define-key yafolding-mode-map (kbd "C-c t") 'yafolding-toggle-element)
(add-hook 'yaml-mode-hook 'yafolding-mode)
(require 'remote-copy-paste)
;; (require 'init-org-agenda)
(require 'init-go)
(require 'init-flyspell)
(setq debug-on-error nil)
;;; (setq display-line-numbers-mode nil)
(message "init local success")
(provide 'init-local)
;;; init-local.el ends here

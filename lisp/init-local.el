;;; local --- local mode
;;; Code:
;;; Commentary:
;; Set load path
(push "~/.emacs.d/site-lisp" load-path)

;; custom path
(setq package-archives '(("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu")
                         ("melpa" . "https://mirrors.tu[<8;56;66mna.tsinghua.edu.cn/elpa/melpa/")))

;;; Customize theme
(require-package 'moe-theme)
(load-theme 'moe-dark t)
;; go mode config
(require-package 'go-mode)
(require-package 'company-go)
(require-package 'golint)
(require-package 'go-playground)
(setq gofmt-command "goimports")
(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            )
          )
(message "Init go mode ok")

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

(require 'yafolding)
(define-key yafolding-mode-map (kbd "C-c h") 'yafolding-hide-parent-element)
(add-hook 'yaml-mode-hook 'yafolding-mode)
(require 'remote-copy-paste)
(require 'init-org-agenda)
(setq debug-on-error nil)
(message "init local success")
(provide 'init-local)
;;; init-local.el ends here

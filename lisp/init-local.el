;;; local --- local mode
;;; Code:
;;; Commentary:
;; Set load path
(push "~/.emacs.d/site-lisp" load-path)

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
(require-package 'eslintd-fix)
(add-to-list 'auto-mode-alist '(".*\\.js" . rjsx-mode))
(add-hook 'rjsx-mode-hook
          (lambda ()
            (setq emmet-expand-jsx-className? t)
            (emmet-mode t)
            (eslinted-fix-mode t)
            ))

(add-hook 'js2-mode-hook 'eslintd-fix-mode)
(message "Init js ok")

(require-package 'wanderlust)
(autoload 'wl-user-agent-compose "wl-draft" nil t)
(define-mail-user-agent
  'wl-user-agent
  'wl-user-agent-compose
  'wl-draft-send
  'wl-draft-kill
  'mail-send-hook
  )
(setq mail-user-agent 'wl-user-agent)
(setq message-mail-user-agent 'wl-user-agent)
(setq org-mime-library 'semi)


(require 'markdown-email)
(require 'remote-copy-paste)
(setq debug-on-error nil)
(message "init local success")
(provide 'init-local)
;;; init-local.el ends here

;;; local --- local mode
;;; Code:
;;; Commentary:

;; osx clipborad mode
(osx-clipboard-mode t)

;; go mode config
(require 'company-go)
(require 'golint)
(setq gofmt-command "goimports")
(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            )
          )


;; perform auto sync
(defun rsyncdev ()
  "Auto rsyncdev."
  (interactive)
  ( start-process-shell-command
    "rsync-to-dev"
    "*Messages*"
    "rsyncdev"))

(defun rsync-file (local-file)
  "rsync to devbox"
  (let ((remote-file (replace-regexp-in-string "/Users/chengyuhang/work"
                                               "rsync://106.75.101.26:1873/drwrong/work"
                                               local-file
                                               )))
    (start-process-shell-command
     "rsync-specific-file"
     "*Messages*"
     (concat "rsync -vz "
             (shell-quote-argument local-file)
             " "
             (shell-quote-argument remote-file)
             )
     )

    )
  )

(defun sync-tantan-file ()
  "Sync domob file auto."
  (when (string-match
         "/Users/chengyuhang/work/.*"
         buffer-file-name)
    (rsync-file buffer-file-name)
    (rsyncdev)
    )
  )

(define-minor-mode auto-rsync-mode
  :lighter "rsync"
  :global t
  (cond (auto-rsync-mode
         (add-hook 'after-save-hook 'sync-tantan-file))
        (t
         (remove-hook 'after-save-hook 'sync-tantan-file))))


(require 'ox-odt)

(require 'sql-indent)



(add-hook 'sqlind-minor-mode-hook
          (lambda ()
            (setq sqlind-basic-offset 4)
            ))

(add-to-list 'auto-mode-alist '(".*\\.js" . rjsx-mode))


(add-hook 'rjsx-mode-hook
          (lambda ()
            (setq emmet-expand-jsx-className? t)
            (emmet-mode t)
            (eslinted-fix-mode t)
            ))
(add-hook 'js2-mode-hook 'eslintd-fix-mode)



(setq debug-on-error nil)
(message "init local success")
(provide 'init-local)
;;; init-local.el ends here

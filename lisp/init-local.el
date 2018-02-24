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
    nil
    "rsyncdev"))

(defun sync-tantan-file ()
  "Sync domob file auto."
  (when (string-match
         "~/work/gopath/src/backend/.*"
         buffer-file-name)
    (rsyncdev))
  )

(define-minor-mode auto-rsync-mode
  :lighter "rsync"
  :global t
  (cond (auto-rsync-mode
         (add-hook 'after-save-hook 'sync-tantan-file))
        (t
         (remove-hook 'after-save-hook 'sync-tantan-file))))

(auto-rsync-mode t)

(require 'ox-odt)



(provide 'init-local)
;;; init-local.el ends here

;;; init-go.el --- init go lang
;;; Commentary:

;;; Code:
(require-package 'flycheck)
(require-package 'go-mode)
(require-package 'company-go)
(require-package 'golint)
(require-package 'go-playground)

(require 'go-mode)

(setq gofmt-command "goimports")
(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            )
          )
(message "Init go mode ok")

(defun go-add-comment (name)
  "Add comment following the golint rule start with NAME."
  (forward-line -1)
  (insert (concat "// " name " "))
  )


(defun processline (line)
  "Process a single LINE."
  (if (string-prefix-p "func" line)
      (progn
        (string-match "func\s+\\(([^)]+)\s+\\)?\\([^(]+\\)" line)
        (go-add-comment (match-string 2 line))
        )
    (progn
      (string-match "type\s+\\([^\s]+\\)" line)
      (go-add-comment (match-string 1 line))

      )
    )
  )

(defun golint-comment ()
  "Comment golint."
  (interactive)
  (processline (thing-at-point 'line))
  )

(require 'flycheck)
;; (setq flycheck-disabled-checkers '(
;;                                    go-vet))

(require-package 'use-package)
(use-package flycheck-golangci-lint
             :ensure t
             :hook (go-mode . flycheck-golangci-lint-setup))

(flycheck-define-checker go-vet
  "A Go syntax checker using the `go tool vet' command.

See URL `https://golang.org/cmd/go/' and URL
`https://golang.org/cmd/vet/'."
  :command ("go" "vet"
            (option "-printfuncs=" flycheck-go-vet-print-functions concat
                    flycheck-option-comma-separated-list)
            (option "-vettool=$(which shadow)" flycheck-go-vet-shadow)
            (option "-tags=" flycheck-go-build-tags)
            (eval (when (eq flycheck-go-vet-shadow 'strict) "-strict"))
            ".")
  :error-patterns
  ((warning line-start (file-name)  ":" line ":" column ": " (message) line-end))
  :modes go-mode
  ;; We must explicitly check whether the "vet" tool is available
  :predicate (lambda ()
               (let ((go (flycheck-checker-executable 'go-vet)))
                 (member "vet" (ignore-errors (process-lines go "tool")))))
  :next-checkers (go-build
                  go-test
                  ;; Fall back if `go build' or `go test' can be used
                  go-errcheck
                  go-unconvert
                  go-megacheck)
  :verify (lambda (_)
            (let* ((go (flycheck-checker-executable 'go-vet))
                   (have-vet (member "vet" (ignore-errors
                                             (process-lines go "tool")))))
              (list
               (flycheck-verification-result-new
                :label "go vet"
                :message (if have-vet "present" "missing")
                :face (if have-vet 'success '(bold error)))))))

(provide 'init-go )

;;; init-go ends here

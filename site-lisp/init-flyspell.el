;; init-flyspell.el
;; (require-package 'wucuo)


;; if (aspell installed) { use aspell}
;; else if (hunspell installed) { use hunspell }
;; whatever spell checker I use, I always use English dictionary
;; I prefer use aspell because:
;; 1. aspell is older
;; 2. looks Kevin Atkinson still get some road map for aspell:
;; @see http://lists.gnu.org/archive/html/aspell-announce/2011-09/msg00000.html
(defun flyspell-detect-ispell-args (&optional run-together)
  "If RUN-TOGETHER is true, spell check the CamelCase words.
Please note RUN-TOGETHER will make aspell less capable. So it should only be used in prog-mode-hook."
  (let* (args)
    (setq args (list "--sug-mode=ultra" "--lang=en_US"))
    (if run-together
        (setq args (append args '("--run-together" "--run-together-limit=16" "--run-together-min=2"))))
    args))

;; `ispell-cmd-args' contains *extra* arguments appending to CLI process
;; when (ispell-send-string). Useless!
;; `ispell-extra-args' is *always* used when start CLI aspell process
(setq-default ispell-extra-args (flyspell-detect-ispell-args t))

;; `ispell-cmd-args' contains *extra* arguments appending to CLI process
;; when (ispell-send-string). Useless!
;; `ispell-extra-args' is *always* used when start CLI aspell process
(setq-default ispell-extra-args (flyspell-detect-ispell-args t))
;; (setq ispell-cmd-args (flyspell-detect-ispell-args))
(defadvice ispell-word (around my-ispell-word activate)
  (let* ((old-ispell-extra-args ispell-extra-args))
    (ispell-kill-ispell t)
    ;; use emacs original arguments
    (setq ispell-extra-args (flyspell-detect-ispell-args))
    ad-do-it
    ;; restore our own ispell arguments
    (setq ispell-extra-args old-ispell-extra-args)
    (ispell-kill-ispell t)))

(defadvice flyspell-auto-correct-word (around my-flyspell-auto-correct-word activate)
  (let* ((old-ispell-extra-args ispell-extra-args))
    (ispell-kill-ispell t)
    ;; use emacs original arguments
    (setq ispell-extra-args (flyspell-detect-ispell-args))
    ad-do-it
    ;; restore our own ispell arguments
    (setq ispell-extra-args old-ispell-extra-args)
    (ispell-kill-ispell t)))


(defun go-check-symbol-is-same-file (specifier)
  "Check wheather is same with current file"
  (if (not (string-match "\\(.+\\):\\([0-9]+\\):\\([0-9]+\\)" specifier))
      t
    (string= (buffer-file-name) (match-string 1 specifier))
    )
  )
(defun go-check-symbol (point)
  "Judge if is symbol"
  (let ((file (car (godef--call point))))
    (if (not (godef--successful-p file))
        nil
      (not (go-check-symbol-is-same-file file))
      )
    )
  )


(defvar flyspell-font-face-to-check
  '(
    font-lock-string-face
    font-lock-doc-face
    font-lock-comment-face
    font-lock-builtin-face
    font-lock-function-name-face
    font-lock-variable-name-face
    font-lock-type-face

    ;; javascript
    js2-function-call
    js2-function-param
    js2-object-property
    js2-object-property-access

    ;; ReactJS
    rjsx-text
    rjsx-tag
    rjsx-attr)
  )

(defun go-mode-flyspell-verify ()
  "Function used for `flyspell-generic-check-word-predicate' in Go Mode"
  (let* ((case-fold-search nil)
         (current-font-face (get-text-property (- (point) 1) 'face))
         (font-matched (or (memq current-font-face flyspell-font-face-to-check)
                           (eq current-font-face nil)
                           ))
         subwords
         (word (thing-at-point 'word))
         (rlt t))
    (cond
     ((not font-matched)
      (setq rlt nil)
      )
     ((< (length word) 3)
      (setq rlt nil)
      )
     ((go-check-symbol (point))
      (setq rlt nil)
      )
     )
    rlt
    ))

(put 'go-mode 'flyspell-mode-predicate 'go-mode-flyspell-verify)
;; (setq wucuo-check-nil-font-face t)
;; ;; (setq flyspell-generic-check-word-predicate #'wucuo-generic-check-word-predicate)
;; ;; (setq wucuo-debug t)
(require 'flyspell-lazy)
(add-hook 'go-mode-hook (lambda ()
                          (flyspell-mode t)
                          (flyspell-lazy-mode t)))
(message "init flyspell success" )
(provide 'init-flyspell)
;; ;;; init-flyspell.el

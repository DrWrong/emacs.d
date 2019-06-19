;;; remote-copy-paste.el -- markdown email
;;; Commentary:
;;; Code:
(defun remote-cut-function (text &rest ignore)
  "Copy TEXT to the remote-clipboard.
This is set as the value of `interprogram-cut-function' by
`rempote-copy-paste-mode'.  It should only be used when Emacs is running in a
text terminal.  IGNORE some param."
  (with-temp-buffer
    (insert text)
    (with-demoted-errors "Error calling pbcopy: %S"
      (call-process-region (point-min) (point-max) "pbcopy-remote"))))

(defvar remote-paste-last-selected-text nil)

(defun remote-paste-function ()
  "Return the value of the remoe clipboard using \"pbpaste-remote\".
This is set as the value of `interprogram-paste-function' by
`remote-copy-paste-mode'.  It should only be used when Emacs is running in a
text terminal."
  (with-temp-buffer
    (with-demoted-errors "Error calling pbpaste: %S"
      (call-process "pbpaste-remote" nil t)
      (let ((text (buffer-substring-no-properties (point-min) (point-max))))
        ;; The following logic is adapted from `x-selection-value'
        ;; in `ns-win.el.gz'
        (cond
         ((or
           ;; Avoid copying an empty clipboard, or copying the same
           ;; text twice
           (not text)
           (eq text remote-paste-last-selected-text)
           (string= text "")
           (string= text (car kill-ring))) nil)
         ((string= text remote-paste-last-selected-text)
          ;; Record the newer string, so subsequent calls can use the `eq' test.
          (setq remote-paste-last-selected-text text)
          nil)
         (t
          (setq remote-paste-last-selected-text text)))))))


(defun blogpngpaste ()
  "Paste image when writting blog."
  (interactive)
  (call-process-region (point) (if mark-active (mark) (point)) "blog_img_paste" t t)
  )

;;###autoload
(define-minor-mode remote-clipboard-mode
  "Kill and yank using the OS X clipboard when running in a text terminal.
This mode allows Emacs to use the OS X system clipboard when
running in the terminal, making killing and yanking behave
similarly to a graphical Emacs.  It is not needed in a graphical
Emacs, where NS clipboard integration is built in.
It sets the variables `interprogram-cut-function' and
`interprogram-paste-function' to thin wrappers around the
\"pbcopy\" and \"pbpaste\" command-line programs.
Consider also customizing the variable
  `save-interprogram-paste-before-kill' to `t' for best results."
  :global t
  :lighter " Remote-Clipboard" :tag "Remote  Clipboard Mode"
  :group 'remote-clipboard
  (if remote-clipboard-mode
      (setq interprogram-cut-function #'remote-cut-function
            interprogram-paste-function #'remote-paste-function
            )
    ;; Turn off
    (setq interprogram-cut-function nil
          interprogram-paste-function nil)))

(remote-clipboard-mode t)
(setq save-interprogram-paste-before-kill t)

(provide 'remote-copy-paste)
;;; remote-copy-paste.el ends here

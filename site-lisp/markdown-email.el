;;; markdown-email.el -- markdown email
;;; Commentary:
;;; Code:
(require 'message)
(defun mimedown ()
  (interactive)
  (save-excursion
    (message-goto-body)
    (shell-command-on-region (point) (point-max) "mimedown.py" nil t)
    )
  )

(defun markdown-send ()
  (interactive)
  (let ((body (buffer-string)))
    (message-mail)
    (message-goto-body)
    (insert body)
    (mimedown)
    )
  )

(provide 'markdown-email)
;;; markdown-email.el ends here

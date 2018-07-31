;;; remote-copy-paste.el -- markdown email
;;; Commentary:
;;; Code:
(defun remotecopy ()
  "Copy from remtote clipboard."
  (interactive)
  (call-process-region (point) (mark) "pbcopy-remote")
  (setq deactivate-mark t)
  )

(defun remotepaste ()
  "Paste to remote clipboard."
  (interactive)
  (call-process-region (point) (if mark-active (mark) (point)) "pbpaste-remote" t t)
  )

(defun blogpngpaste ()
  "Paste image when writting blog"
  (interactive)
  (call-process-region (point) (if mark-active (mark) (point)) "blog_img_paste" t t)
  )

(provide 'remote-copy-paste)
;;; remote-copy-paste.el ends here

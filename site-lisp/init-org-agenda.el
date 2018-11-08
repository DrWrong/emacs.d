;;; local --- local mode
;;; Code:
;;; Commentary:
;; Set load path
(require-package 'org-caldav)
(require 'org-caldav)
(setq org-caldav-url "https://nextcloud-fi.webo.hosting/remote.php/dav/calendars/chengyuhang001%40163.com")
(setq org-caldav-debug-level 0)
(setq org-caldav-calendar-id "personal")
(setq org-caldav-inbox "~/org/schedule.org")
(setq org-agenda-files '("~/org"))

(defun org-sync-cal ()
  "Sync all agenda files."
  (interactive)
  (setq org-caldav-files (org-agenda-files t))
  (org-caldav-sync)
  )

(provide 'init-org-agenda)
;;; init-org-agenda.el ends here

;;; package -- Summary

;;; Commentary:

;; A simple "cron-job" that executes a backup script

;;; Code:
(defcustom laat/notes-backup-script nil
  "The backup script."
  :type 'file)

;;;###autoload
(defun laat/execute-backup-script ()
  "Execute the backup script."
  (interactive)
  (when laat/notes-backup-script (shell-command laat/notes-backup-script)))

;;;###autoload
(run-with-idle-timer 300 :repeat 'laat/execute-backup-script)

(provide 'notes-backup)
;;; notes-backup.el ends here

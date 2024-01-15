;;; package -- Summary

;;; Commentary:

;; A simple "cron-job" that executes a backup script

;;; Code:
(defcustom laat/notes-backup-script nil
  "The backup script."
  :type 'file
  :group 'notes-backup)

;;;###autoload
(defun laat/execute-backup-script ()
  "Execute the backup script."
  (interactive)
  (when laat/notes-backup-script
    (let* ((file-name (shell-quote-argument laat/notes-backup-script))
           (process (start-file-process-shell-command "notes-backup" "* notes-backup *" file-name)))
      (set-process-sentinel process
                            (lambda (process event)
                              (message (concat "notes-backup: " event))
                              (cond ((string-match-p "finished" event)
                                     (progn
                                       (kill-buffer "* notes-backup *")
                                       (message "notes-backup: complete")))))))))

;;;###autoload
(run-with-idle-timer 300 :repeat 'laat/execute-backup-script)

(provide 'notes-backup)
;;; notes-backup.el ends here

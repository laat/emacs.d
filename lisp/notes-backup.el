;;; flyspell-correct.el --- Correcting words with flyspell via custom interface  -*- lexical-binding: t; -*-
;;
;;; Commentary:

;; A simple "cron-job" that executes a backup script

;;; Code:
(defcustom laat/notes-backup-scripts nil
  "The backup script."
  :type '(repeat :tag "List of sync scripts" file)
  :group 'laat)

;;;###autoload
(defun laat/execute-backup-script ()
  "Execute the backup script."
  (interactive)
  (dolist (script laat/notes-backup-scripts)
    (let* ((file-name (shell-quote-argument script))
           (buff-name (concat "*notes-backup " file-name "*"))
           (process (start-file-process-shell-command "notes-backup" buff-name file-name)))
      (set-process-sentinel process
                            (lambda (_ event)
                              (message (concat "notes-backup " file-name " " event))
                              (cond ((string-match-p "finished" event)
                                     (progn
                                       (kill-buffer buff-name)
                                       (message (concat "notes-backup: " file-name " complete"))))))))))


;;;###autoload
(run-with-idle-timer 300 :repeat 'laat/execute-backup-script)

(provide 'notes-backup)
;;; notes-backup.el ends here

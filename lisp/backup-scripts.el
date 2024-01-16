;;; backup-scripts.el --- Correcting words with flyspell via custom interface  -*- lexical-binding: t; -*-
;;
;;; Commentary:

;; A simple "cron-job" that executes a backup script

;;; Code:
(defcustom laat/backup-scripts nil
  "The backup scripts to execute."
  :type '(repeat :tag "List of sync scripts" file)
  :group 'laat)

(defcustom laat/backup-idle-seconds 300
  "The number of seconds of idletime before executing the script."
  :type 'integer
  :group 'laat)

;;;###autoload
(defun laat/execute-backup-scripts ()
  "Execute the backup script."
  (interactive)
  (dolist (script laat/backup-scripts)
    (let* ((file-name (shell-quote-argument script))
           (buff-name (concat "*backup " file-name "*"))
           (process (start-file-process-shell-command "backup" buff-name file-name)))
      (set-process-sentinel process
                            (lambda (_ event)
                              (message (concat "backup " file-name " " event))
                              (cond ((string-match-p "finished" event)
                                     (progn
                                       (kill-buffer buff-name)
                                       (message (concat "backup: " file-name " complete"))))))))))


;;;###autoload
(run-with-idle-timer laat/backup-idle-seconds :repeat 'laat/execute-backup-scripts)

(provide 'backup-scripts)
;;; backup-scripts.el ends here

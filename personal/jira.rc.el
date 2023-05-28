(require 'org-jira)


(setq jiralib-url "http://jira.sarc.samsung.com")
(setq org-jira-working-dir "~/.emacs.d/org")
(setq jiralib-user-login-name "kyongjoo.oh")


(setq jiraname "gfxsw")
(setq org-jira-default-jql "project in (GFXSW) and updated >= startOfDay(-5)")
(setq org-jira-default-jql-custom "project in (GFXSW) and updated >= startOfMonth(-1) ORDER BY updated DESC")

(setq org-jira-worklog-sync-p nil)
(setq org-jira-deadline-duedate-sync-p nil)

(defun gfxjira ()
  (interactive)
  (setq jiraname "gfxsw")
  (setq org-jira-default-jql "project in (GFXSW) and updated >= startOfDay(-5)")
  (setq org-jira-default-jql-custom "project in (GFXSW) and updated >= startOfMonth(-1) ORDER BY updated DESC")
  )

(defun myjira ()
  (interactive)
  (setq jiraname "myjira")
  (setq org-jira-default-jql "project in (GFXSW) and assignee = currentUser() and resolution = unresolved")
  (setq org-jira-default-jql-custom "project in (GFXSW) and assignee = currentUser() and resolution = unresolved ORDER BY updated DESC")
  )

;;[2017-06-11 Sun 07:47] kjoh
;;'org-jira-get-issue-list' function override
(defun org-jira-get-issue-assignee (issue)
  (org-jira-find-value issue 'fields 'assignee))

(defun org-jira-get-issue-status (issue)
  (org-jira-find-value issue 'fields 'status))

(defun org-jira-get-issue-reporter (issue)
  (org-jira-find-value issue 'fields 'reporter))

(defun org-jira-get-issue-component (issue)
  (org-jira-find-value issue 'fields 'components))

(eval-after-load "org-jira"
  '(progn
     (defun org-jira-get-issues (issues)
       "Get list of ISSUES into an org buffer.

Default is get unfinished issues assigned to you, but you can
customize jql with a prefix argument.
See`org-jira-get-issue-list'"
       ;; If the user doesn't provide a default, async call to build an issue list
       ;; from the JQL style query
       (interactive
        (org-jira-get-issue-list org-jira-get-issue-list-callback))
       (let (project-buffer)
         (mapc (lambda (issue)
                 (let* ((proj-key (org-jira-get-issue-project issue))
                        (issue-id (org-jira-get-issue-key issue))
                        (issue-summary (org-jira-get-issue-summary issue))
                        (issue-headline issue-summary))
                   (let ((project-file (expand-file-name (concat proj-key ".org") org-jira-working-dir)))
                     (setq project-buffer (or (find-buffer-visiting project-file)
                                              (find-file project-file)))
                     (with-current-buffer project-buffer
                       (save-excursion
                         (org-jira-mode t)
                         (message issue-id) ;;kjoh
                         (widen)
                         (outline-show-all)
                         (goto-char (point-min))
                         (setq p (org-find-entry-with-id issue-id))
                         (save-restriction
                           (if (and p (>= p (point-min))
                                    (<= p (point-max)))
                               (progn
                                 (goto-char p)
                                 (forward-thing 'whitespace)
                                 (kill-line))
                             (goto-char (point-max))
                             (unless (looking-at "^")
                               (insert "\n"))
                             (insert "* "))
                           (let ((status (org-jira-get-issue-val 'status issue)))
                             (org-jira-insert (concat (cond (org-jira-use-status-as-todo
                                                             (upcase (replace-regexp-in-string " " "-" status)))
                                                            ((member status org-jira-done-states) "DONE")
                                                            ("TODO")) " "
                                                            issue-headline " :" (replace-regexp-in-string "-" "_" issue-id))))
                           (save-excursion
                             (unless (search-forward "\n" (point-max) 1)
                               (insert "\n")))
                           (org-narrow-to-subtree)
                           ;; (org-change-tag-in-region
                           ;;  (point-min)
                           ;;  (save-excursion
                           ;;    (forward-line 1)
                           ;;    (point))
                           ;;  (replace-regexp-in-string "-" "_" issue-id)
                           ;;  nil)

                           (mapc (lambda (entry)
                                   (let ((val (org-jira-get-issue-val entry issue)))
                                     (when (or (and val (not (string= val "")))
                                               (eq entry 'assignee)) ;; Always show assignee
                                       (org-jira-entry-put (point) (symbol-name entry) val))))
                                 '(assignee reporter type priority resolution status components created updated))

                           (org-jira-entry-put (point) "ID" (org-jira-get-issue-key issue))

                           ;; Insert the duedate as a deadline if it exists
                           (when org-jira-deadline-duedate-sync-p
                             (let ((duedate (org-jira-get-issue-val 'duedate issue)))
                               (when (> (length duedate) 0)
                                 (org-deadline nil duedate))))

                           (mapc (lambda (heading-entry)
                                   (ensure-on-issue-id
                                    issue-id
                                    (let* ((entry-heading (concat (symbol-name heading-entry) (format ": [[%s][%s]]" (concat jiralib-url "/browse/" issue-id) issue-id))))
                                      (setq p (org-find-exact-headline-in-buffer entry-heading))
                                      (if (and p (>= p (point-min))
                                               (<= p (point-max)))
                                          (progn
                                            (goto-char p)
                                            (org-narrow-to-subtree)
                                            (goto-char (point-min))
                                            (forward-line 1)
                                            (delete-region (point) (point-max)))
                                        (if (org-goto-first-child)
                                            (org-insert-heading)
                                          (goto-char (point-max))
                                          (org-insert-subheading t))
                                        (org-jira-insert entry-heading "\n"))

                                      (org-jira-insert (replace-regexp-in-string "^" "  " (org-jira-get-issue-val heading-entry issue))))))
                                 '(description))
                           ;;(org-jira-update-comments-for-current-issue)

                           ;; only sync worklog clocks when the user sets it to be so.
                           (when org-jira-worklog-sync-p
                             (org-jira-update-worklogs-for-current-issue))
                           )))
                     )))
               issues)
         (switch-to-buffer project-buffer)))


     (defun org-jira-get-issues-headonly (issues)
       "Get list of ISSUES, head only.

The default behavior is to return issues assigned to you and unresolved.

With a prefix argument, allow you to customize the jql.  See
`org-jira-get-issue-list'."

       (interactive
        (org-jira-get-issue-list-custom))

       (let* ((issues-file (expand-file-name (concatenate 'string jiraname "-issues-headonly.org") org-jira-working-dir))
              (issues-headonly-buffer (or (find-buffer-visiting issues-file)
                                          (find-file issues-file))))
         (with-current-buffer issues-headonly-buffer
           (widen)
           (delete-region (point-min) (point-max))

           (mapc (lambda (issue)
                   (let* ((issue-id (org-jira-get-issue-key issue))
                          (issue-summary (org-jira-get-issue-summary issue))
                          (issue-status (cdr (assoc 'name (org-jira-get-issue-status issue))))
                          (issue-assignee (org-jira-get-issue-assignee issue))
                          (issue-reporter (org-jira-get-issue-reporter issue))
                          (issue-component (ignore-errors (cdr (assoc 'name (aref (org-jira-get-issue-component issue) 0)))))
                          (todo (if (or (equal issue-status "In Progress") (equal issue-status "Open"))
                                    "TODO"
                                  issue-status)))
                     (org-jira-insert (format "- [jira:%s] %s:%s, %s => %s (%s)\n" issue-id  issue-component issue-summary (cdr (assoc 'name issue-reporter)) (cdr (assoc 'name issue-assignee)) todo))))
                 issues))
         (switch-to-buffer issues-headonly-buffer)))

     

     (defun org-jira-get-issue-list (&optional callback)
       "Get list of issues, using jql (jira query language), invoke CALLBACK after.
Default is unresolved issues assigned to current login user; with
a prefix argument you are given the chance to enter your own
jql."
       (let ((jql org-jira-default-jql))
         (when current-prefix-arg
           (setq jql (read-string "Jql: "
                                  (if org-jira-jql-history
                                      (car org-jira-jql-history)
                                    "assignee = currentUser() and resolution = unresolved")
                                  'org-jira-jql-history
                                  "assignee = currentUser() and resolution = unresolved")))
         (list (jiralib-do-jql-search jql 10000 callback))))

     (defun org-jira-get-issue-list-custom (&optional callback)
       "Get list of issues, using jql (jira query language), invoke CALLBACK after.
Default is unresolved issues assigned to current login user; with
a prefix argument you are given the chance to enter your own
jql."
       (let ((jql org-jira-default-jql-custom))
         (when current-prefix-arg
           (setq jql (read-string "Jql: "
                                  (if org-jira-jql-history
                                      (car org-jira-jql-history)
                                    "assignee = currentUser() and resolution = unresolved")
                                  'org-jira-jql-history
                                  "assignee = currentUser() and resolution = unresolved")))
         (list (jiralib-do-jql-search jql 10000 callback))))))




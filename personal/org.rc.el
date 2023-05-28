(require 'org)

(setq org-image-actual-width nil)

(setq org-directory "~/.emacs.d/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/.emacs.d/org/inbox.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/MobileOrg/")
;;(setq org-mobile-files "~/org/refile.org")
(setq org-mobile-files (quote ("~/.emacs.d/org/refile.org")))


(global-set-key "\C-cc" 'org-capture)
;;(global-set-key (kbd "<f1>") 'org-agenda)
(global-unset-key (kbd "<f4>"))
(global-set-key (kbd "<f4> h") 'bh/hide-other)
(global-set-key (kbd "<f4> H") 'bh/hide-all)
(global-set-key (kbd "<f4> c") 'calendar)
(global-set-key (kbd "<f4> t") 'bh/insert-inactive-timestamp)
(global-set-key (kbd "<f4> I") 'bh/punch-in)
(global-set-key (kbd "<f4> O") 'bh/punch-out)
(global-set-key (kbd "<f4> j") 'org-clock-goto)
;;(global-set-key (kbd "<f4> l") 'bh/clock-in-last-task)
(global-set-key (kbd "<f4> l") (lambda ()
                                 (interactive)
                                 (org-clock-in '(4))))
(global-set-key (kbd "<f4> p") 'bh/save-then-publish)
(global-set-key (kbd "<f4> n") 'bh/narrow)
(global-set-key (kbd "<f4> w") 'bh/widen)
;;(global-set-key (kbd "<f4> <f4>") 'org-sync)
;;(global-set-key (kbd "<f4> <f4>") 'my-org-screenshot)
(setq org-src-fontify-natively nil)

(setq org-startup-indented t)
(setq org-yank-adjusted-subtrees t)
(setq org-return-follows-link t)
(setq org-tab-follows-link t)


(setq org-id-track-globally nil)

;; Make TAB the yas trigger key in the org-mode-hook and enable flyspell mode and autofill
(add-hook 'org-mode-hook
          (lambda ()
            ;;(make-variable-buffer-local 'yas/trigger-key)
            ;;(org-set-local 'yas/trigger-key [tab])
            ;;(define-key yas/keymap [tab] 'yas/next-field-group)
            (flyspell-mode 1)
            ;;(local-set-key "\M-\C-g" 'org-plot/gnuplot)
            (org-defkey org-mode-map "\C-c["    'undefined)
            (org-defkey org-mode-map "\C-c]"    'undefined)
            (org-defkey org-mode-map [(control tab)] nil)
            ))

;; (add-hook 'org-agenda-mode-hook
;;           (lambda ()
;;             (org-defkey org-agenda-mode-map ":"    'undefined)))

(defun bh/hide-other ()
  (interactive)
  (save-excursion
    (org-back-to-heading)
    (org-shifttab)
    (org-reveal)
    (org-cycle)))

(defun bh/hide-all ()
  (interactive)
  (save-excursion
    (org-back-to-heading)
    (org-shifttab)
    ))

(defun bh/set-truncate-lines ()
  "Toggle value of truncate-lines and refresh window display."
  (interactive)
  (setq truncate-lines (not truncate-lines))
  ;; now refresh window display (an idiom from simple.el):
  (save-excursion
    (set-window-start (selected-window)
                      (window-start (selected-window)))))

(defun bh/make-org-scratch ()
  (interactive)
  (find-file "/tmp/publish/scratch.org")
  (gnus-make-directory "/tmp/publish"))

(defun bh/switch-to-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))

(defun bh/untabify ()
  (interactive)
  (untabify (point-min) (point-max)))


(setq org-agenda-files (list "~/.emacs.d/org/refile.org"
                             "~/.emacs.d/org/study.org"
                             "~/.emacs.d/org/emacs.org"
                             "~/.emacs.d/org/office.org"
                             "~/.emacs.d/org/org.org"
                             "~/.emacs.d/org/todo.org"
                             ))

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "STARTED(S)" "|" "DONE(d!/!)")
              ;;(sequence "WAITING(w@/!)" "SOMEDAY(S!)" "|" "CANCELLED(c@/!)" "PHONE")
              (sequence "WAITING(w@/!)" "SOMEDAY(s!)" "|" "CANCELLED(c@/!)" "NOTE")
              (sequence "OPEN(O!)" "|" "CLOSED(C!)"))))

(setq org-use-fast-todo-selection t)
(setq org-fast-tag-selection-include-todo t)
;;(setq org-treat-S-cursor-todo-selection-as-state-change nil)
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("SOMEDAY" ("WAITING" . t))
              ("NEXT" ("NEXT" .t))
              (done ("WAITING"))
              ("TODO" ("WAITING") ("CANCELLED") ("NEXT"))
              ("NEXT" ("WAITING"))
              ("DONE" ("WAITING") ("CANCELLED") ("NEXT")))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "OrangeRed3" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("STARTED" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("SOMEDAY" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("OPEN" :foreground "blue" :weight bold)
              ("CLOSED" :foreground "forest green" :weight bold)
              ("NOTE" :foreground "forest green" :weight bold))))


(setq org-default-notes-file "~/.emacs.d/org/study.org")
;; Capture templates for: TODO tasks, Notes, appointments, phone
;; calls, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/.emacs.d/org/todo.org")
;;               "* TODO %?\n%U\n%a\n  %i" :clock-in t :clock-resume t
                 "* TODO [%<%Y%m%d>] %?\nDEADLINE: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%U\n %i" :clock-in t :clock-resume t)
              ("n" "note" entry (file "~/.emacs.d/org/study.org")
               "* NOTE [%<%Y%m%d>] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%U\n%a\n  %i" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/.emacs.d/org/diary.org")
               "* %?\n%U\n  %i" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/.emacs.d/org/refile.org")
               "* TODO Review %c\n%U\n  %i" :immediate-finish t)
              ("h" "Habit" entry (file "~/.emacs.d/org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %t\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n  %i"))))

;; Remove empty LOGBOOK drawers on clock out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)



                                        ; Targets include this file and any file contributing to the agenda -
                                        ; up to 2 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 2)
                                 (org-agenda-files :maxlevel . 2))))

                                        ; Stop using paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path nil)

                                        ; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

                                        ; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

                                        ; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)



;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)


;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (
              (" " "Agenda"
               ((agenda "" ((org-agenda-ndays 'week)))
                (agenda "" ((org-agenda-ndays 'month)))
                )
               nil)
              ;; ("D" "Done Tasks" todo "DONE"
              ;;  ((org-agenda-overriding-header "Done tasks"))
              ;;  (org-agenda-skip-function 'bh/skip-projects))
              ;; ("N" "Notes" tags "NOTE"
              ;;  ((org-agenda-overriding-header "Notes")
              ;;   (org-tags-match-list-sublevels t)))
              )))

(setq org-tags-match-list-sublevels nil)


;; (defun bh/weekday-p ()
;;   (let ((wday (nth 6 (decode-time))))
;;     (and (< wday 6)
;;          (> wday 0))))

;; (defun bh/working-p ()
;;   (let ((hour (nth 2 (decode-time))))
;;     (and (bh/weekday-p)
;;          (or (and (>= hour 8) (<= hour 11))
;;              (and (>= hour 13) (<= hour 16))))))

;; (defun bh/mark-p ()
;;   (let ((hour (nth 2 (decode-time))))
;;     (or (and (bh/weekday-p)
;;              (or (= hour 8)
;;                  (and (>= hour 16) (<= hour 21))))
;;         (and (not (bh/weekday-p))
;;              (>= hour 9)
;;              (<= hour 21)))))

;; (defun bh/org-auto-exclude-function (tag)
;;   "Automatic task exclusion in the agenda with / RET"
;;   (and (cond
;;         ((string= tag "@farm")
;;          t)
;;         ((string= tag "mark")
;;          (not (bh/mark-p)))
;;         ((or (string= tag "@errand") (string= tag "phone"))
;;          (let ((hour (nth 2 (decode-time))))
;;            (or (< hour 8) (> hour 21))))
;;         (t
;;          (if (bh/working-p)
;;              (setq tag "PERSONAL")
;;            (setq tag "WORK"))
;;          (unless (member (concat "-" tag) org-agenda-filter)
;;            tag)))
;;        (concat "-" tag)))

;;(setq org-agenda-auto-exclude-function 'bh/org-auto-exclude-function)

;;;;;;;;;;;;;;;;;;;
;; clock setup
;;;;;;;;;;;;;;;;;;;
;;
;; Resume clocking tasks when emacs is restarted
;;(org-clock-persistence-insinuate)
;;
;; Small windows on my Eee PC displays only the end of long lists which isn't very useful
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change task to STARTED when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-started)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
;;(setq org-clock-persist (quote history))
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)


(setq bh/keep-clock-running nil)

(defun bh/clock-in-to-started (kw)
  "Switch task from TODO or NEXT to STARTED when clocking in.
Skips capture tasks."
  (if (and (member (org-get-todo-state) (list "TODO" "NEXT"))
           (not (and (boundp 'org-capture-mode) org-capture-mode)))
      "STARTED"))

(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (let ((parent-task (save-excursion (org-back-to-heading) (point))))
    (while (org-up-heading-safe)
      (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
        (setq parent-task (point))))
    (goto-char parent-task)
    parent-task))

(defun bh/clock-in-and-set-project-as-default (pom)
  "Clock in the current task and set the parent project (if any) as the
default clocking task.  Agenda filter tags are set from the default task"
  ;; Find the parent project task if any and set that as the default
  (save-excursion
    (save-excursion
      (org-with-point-at pom
        (bh/find-project-task)
        (org-clock-in '(16))))
    (save-excursion
      (org-with-point-at pom
        (org-clock-in nil)))))

(defun bh/set-agenda-restriction-lock ()
  "Set filter to tags of POM, current task, or current project and refresh"
  (interactive)
  ;;
  ;; We're in the agenda
  ;;
  (let* ((pom (org-get-at-bol 'org-hd-marker))
         (tags (org-with-point-at pom (org-get-tags-at))))
    (if (equal major-mode 'org-agenda-mode)
        (if tags
            (org-with-point-at pom
              (bh/find-project-task)
              (org-agenda-set-restriction-lock))
          (org-agenda-remove-restriction-lock))
      (if (equal org-clock-default-task (org-id-find "F2066C5F-AD62-435F-A6F1-F910EEDA9E5D" 'marker))
          (org-agenda-remove-restriction-lock)
        (org-with-point-at pom
          (bh/find-project-task)
          (org-agenda-set-restriction-lock))))))

(defun bh/punch-in ()
  "Start continuous clocking and set the default task to the project task
of the selected task.  If no task is selected set the Organization task as
the default task."
  (interactive)
  (setq bh/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; We're in the agenda
      ;;
      (let* ((marker (org-get-at-bol 'org-hd-marker))
             (tags (org-with-point-at marker (org-get-tags-at))))
        (if tags
            (bh/clock-in-and-set-project-as-default marker)
          (bh/clock-in-organization-task-as-default)))
    ;;
    ;; We are not in the agenda
    ;;
    (save-restriction
      (widen)
                                        ; Find the tags on the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)))
          (bh/clock-in-and-set-project-as-default nil)
        (bh/clock-in-organization-task-as-default))))
  (bh/set-agenda-restriction-lock))

(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun bh/clock-in-organization-task-as-default ()
  (interactive)
  (save-restriction
    (widen)
    (org-with-point-at (org-id-find "F2066C5F-AD62-435F-A6F1-F910EEDA9E5D" 'marker)
      (org-clock-in '(16)))))

(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running
             (not org-clock-clocking-in)
             (marker-buffer org-clock-default-task)
             (not org-clock-resolving-clocks-due-to-idleness))
    (bh/clock-in-default-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

(require 'org-id)
(defun bh/clock-in-task-by-id (id)
  "Clock in a task by id"
  (save-restriction
    (widen)
    (org-with-point-at (org-id-find id 'marker)
      (org-clock-in nil))))

(defun bh/clock-in-last-task (arg)
  "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
         (cond
          ((eq arg 4) org-clock-default-task)
          ((and (org-clock-is-active)
                (equal org-clock-default-task (cadr org-clock-history)))
           (caddr org-clock-history))
          ((org-clock-is-active) (cadr org-clock-history))
          ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
          (t (car org-clock-history)))))
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))


(setq org-time-stamp-rounding-minutes (quote (1 1)))

(setq org-agenda-clock-consistency-checks
      (quote (:max-duration "4:00"
                            :min-duration 0
                            :max-gap 0
                            :gap-ok-around ("4:00"))))

(defun bh/clock-in-bzflagt-task ()
  (interactive)
  (bh/clock-in-task-by-id "dcf55180-2a18-460e-8abb-a9f02f0893be"))

(defun bh/resume-clock ()
  (interactive)
  (if (marker-buffer org-clock-interrupted-task)
      (org-with-point-at org-clock-interrupted-task
        (org-clock-in))
    (org-clock-out)))

;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Agenda log mode items to display (clock time only by default)
(setq org-agenda-log-mode-items (quote (clock)))

;; Agenda clock report parameters
(setq org-agenda-clockreport-parameter-plist
      (quote (:link t :maxlevel 5 :fileskip0 t :compact t)))

                                        ; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

                                        ; global Effort estimate values
(setq org-global-properties (quote (("Effort_ALL" . "0:10 0:30 1:00 2:00 3:00 4:00 5:00 6:00 7:00 8:00"))))

                                        ; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("@errand" . ?e)
                            ("@office" . ?o)
                            ("@home" . ?h)
                            (:endgroup)
                            ("WAITING" . ?w)
                            ("CANCELLED" . ?c)
                            ("NEXT" . ?n)
                            ("PERSONAL" . ?P)
                            ("WORK" . ?W)
                            ("ORG" . ?O)
                            ("NOTE" . ?N)
                            ("HABIT" . ?H)
                            ("FLAGGED" . ??))))

                                        ; Allow setting single tags without the menu
;;(setq org-fast-tag-selection-single-key (quote expert))

                                        ; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)



;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
;; (setq org-capture-templates
;;       (quote (...
;;               ("p" "Phone call" entry (file "~/git/org/refile.org")
;;                "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
;;               ...)))

;; (require 'bbdb)
;; (require 'bbdb-com)

;; (global-set-key (kbd "<f9> p") 'bh/phone-call)

;; ;;
;; ;; Phone capture template handling with BBDB lookup
;; ;; Adapted from code by Gregory J. Grubbs
;; (defun bh/phone-call ()
;;   "Return name and company info for caller from bbdb lookup"
;;   (interactive)
;;   (let* (name rec caller)
;;     (setq name (completing-read "Who is calling? "
;;                                 (bbdb-hashtable)
;;                                 'bbdb-completion-predicate
;;                                 'confirm))
;;     (when (> (length name) 0)
;;       ; Something was supplied - look it up in bbdb
;;       (setq rec
;;             (or (first
;;                  (or (bbdb-search (bbdb-records) name nil nil)
;;                      (bbdb-search (bbdb-records) nil name nil)))
;;                 name)))

;;     ; Build the bbdb link if we have a bbdb record, otherwise just return the name
;;     (setq caller (cond ((and rec (vectorp rec))
;;                         (let ((name (bbdb-record-name rec))
;;                               (company (bbdb-record-company rec)))
;;                           (concat "[[bbdb:"
;;                                   name "]["
;;                                   name "]]"
;;                                   (when company
;;                                     (concat " - " company)))))
;;                        (rec)
;;                        (t "NameOfCaller")))
;;     (insert caller)))



(setq org-agenda-ndays 1)

(setq org-stuck-projects (quote ("" nil nil "")))


(defun bh/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
        (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (while (and (not is-subproject) (org-up-heading-safe))
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq is-subproject t))))
    (and is-a-task is-subproject)))

(defun bh/is-project-p ()
  "Any task with a todo keyword subtask and is not a subtask of another project
This does not support projects with subprojects"
  (let ((has-subtask)
        (subtree-end (save-excursion (org-end-of-subtree t)))
        (is-subproject (bh/is-subproject-p))
        (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (forward-line 1)
      (while (and (not has-subtask)
                  (< (point) subtree-end)
                  (re-search-forward "^\*+ " subtree-end t))
        (when (member (org-get-todo-state) org-todo-keywords-1)
          (setq has-subtask t))))
    (and is-a-task has-subtask (not is-subproject))))

(defun bh/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  (let* ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
         (subtree-end (save-excursion (org-end-of-subtree t)))
         (has-next (save-excursion
                     (forward-line 1)
                     (and (< (point) subtree-end)
                          (re-search-forward "^\\*+ \\(NEXT\\|STARTED\\) " subtree-end t)))))
    (if (and (bh/is-project-p) (not has-next))
        nil ; a stuck project, has subtasks but no next task
      next-headline)))

(defun bh/skip-non-project-trees ()
  "Skip trees that are not projects"
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (bh/is-project-p)
        nil
      subtree-end)))

(defun bh/skip-non-subprojects ()
  "Skip trees that are not projects"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (if (bh/is-subproject-p)
        nil
      next-headline)))

(defun bh/skip-project-trees-and-habits ()
  "Skip trees that are projects"
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (cond
     ((bh/is-project-p)
      subtree-end)
     ((org-is-habit-p)
      subtree-end)
     (t
      nil))))

(defun bh/skip-projects ()
  "Skip trees that are projects"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (cond
     ((bh/is-project-p)
      next-headline)
     (t
      nil))))

(defun bh/skip-projects-and-habits ()
  "Skip trees that are projects and tasks that are habits"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (cond
     ((bh/is-project-p)
      next-headline)
     ((org-is-habit-p)
      next-headline)
     (t
      nil))))



;;;;;;;;;;;;;;;;;;;;;;;
;; archive setup
;;;;;;;;;;;;;;;;;;;;;;
(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")

(defun bh/skip-non-archivable-tasks ()
  "Skip trees that are not available for archiving"
  (let ((next-headline (save-excursion (outline-next-heading))))
    ;; Consider only tasks with done todo headings as archivable candidates
    (if (member (org-get-todo-state) org-done-keywords)
        (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
               (daynr (string-to-int (format-time-string "%d" (current-time))))
               (a-month-ago (* 60 60 24 (+ daynr 1)))
               (last-month (format-time-string "%Y-%m-" (time-subtract (current-time) (seconds-to-time a-month-ago))))
               (this-month (format-time-string "%Y-%m-" (current-time)))
               (subtree-is-current (save-excursion
                                     (forward-line 1)
                                     (and (< (point) subtree-end)
                                          (re-search-forward (concat last-month "\\|" this-month) subtree-end t)))))
          (if subtree-is-current
              subtree-end ; Has a date in this month or last month, skip it
            nil))  ; available to archive
      (or next-headline (point-max)))))



;;;;;;;;;;;;;;;;;;;;;;;;;
;; publish
;;;;;;;;;;;;;;;;;;;;;;;;;
(setq org-ditaa-jar-path "~/.emacs.d/kjoh/ditaa.jar")
(setq org-plantuml-jar-path "~/.emacs.d/kjoh/plantuml.jar")

(if (display-graphic-p)
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images))


(org-babel-do-load-languages 'org-babel-load-languages (quote ((emacs-lisp . t)
                                       (dot . t)
                                       (ditaa . t)
                                       (R . t)
                                       (python . t)
                                       (ruby . t)
                                       (gnuplot . t)
                                       (clojure . t)
                                       (shell . t)
                                       (ledger . t)
                                       (org . t)
                                       (plantuml . t)
                                       (latex . t))))

(setq org-src-lang-modes
      (quote (("ocaml" . tuareg)
               ("elisp" . emacs-lisp)
               ("ditaa" . artist)
               ("asymptote" . asy)
               ("dot" . fundamental)
               ("sqlite" . sql)
               ("plantuml" . fundamental)
               ("calc" . fundamental))))
                                        ; Do not prompt to confirm evaluation
                                        ; This may be dangerous - make sure you understand the consequences
                                        ; of setting this -- see the docstring for details
(setq org-confirm-babel-evaluate nil)
;; Don't enable this because it breaks access to emacs from my Android phone
(setq org-startup-with-inline-images nil)

;; ; experimenting with docbook exports - not finished
;; (setq org-export-docbook-xsl-fo-proc-command "fop %s %s")
;; (setq org-export-docbook-xslt-proc-command "xsltproc --output %s /usr/share/xml/docbook/stylesheet/nwalsh/fo/docbook.xsl %s")
;; ;
;; ; Inline images in HTML instead of producting links to the image
(setq org-export-html-inline-images t)
;; ; Do not use sub or superscripts - I currently don't need this functionality in my documents
(setq org-export-with-sub-superscripts nil)
;; ; Use org.css from the norang website for export document stylesheets
(setq org-export-html-style-extra "<link rel=\"stylesheet\" href=\"file:///Users/kjoh/source.css\" type=\"text/css\" />")
(setq org-export-html-style-include-default nil)
;; ; Do not generate internal css formatting for HTML exports
(setq org-export-htmlize-output-type 'css)
;; ; Export with LaTeX fragments
(setq org-export-with-LaTeX-fragments 'dvipng)


;; ; List of projects
;; ; norang       - http://www.norang.ca/
;; ; doc          - http://doc.norang.ca/
;; ; org-mode-doc - http://doc.norang.ca/org-mode.html and associated files
;; ; org          - miscellaneous todo lists for publishing
;; (setq org-publish-project-alist
;;       ;
;;       ; http://www.norang.ca/  (norang website)
;;       ; norang-org are the org-files that generate the content
;;       ; norang-extra are images and css files that need to be included
;;       ; norang is the top-level project that gets published
;;       (quote (("norang-org"
;;                :base-directory "~/git/www.norang.ca"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs"
;;                :recursive t
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function org-publish-org-to-html
;;                :style-include-default nil
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :style "<link rel=\"stylesheet\" href=\"norang.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ("norang-extra"
;;                :base-directory "~/git/www.norang.ca/"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive t
;;                :author nil)
;;               ("norang"
;;                :components ("norang-org" "norang-extra"))
;;               ;
;;               ; http://doc.norang.ca/  (norang website)
;;               ; doc-org are the org-files that generate the content
;;               ; doc-extra are images and css files that need to be included
;;               ; doc is the top-level project that gets published
;;               ("doc-org"
;;                :base-directory "~/git/doc.norang.ca/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :recursive nil
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-publish-org-to-html org-publish-org-to-org)
;;                :style-include-default nil
;;                :style "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ("doc-extra"
;;                :base-directory "~/git/doc.norang.ca/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive nil
;;                :author nil)
;;               ("doc"
;;                :components ("doc-org" "doc-extra"))
;;               ("doc-private-org"
;;                :base-directory "~/git/doc.norang.ca/private"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs/private"
;;                :recursive nil
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-publish-org-to-html org-publish-org-to-org)
;;                :style-include-default nil
;;                :style "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :auto-sitemap t
;;                :sitemap-filename "index.html"
;;                :sitemap-title "Norang Private Documents"
;;                :sitemap-style "tree"
;;                :author-info nil
;;                :creator-info nil)
;;               ("doc-private-extra"
;;                :base-directory "~/git/doc.norang.ca/private"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs/private"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive nil
;;                :author nil)
;;               ("doc-private"
;;                :components ("doc-private-org" "doc-private-extra"))
;;               ;
;;               ; Miscellaneous pages for other websites
;;               ; org are the org-files that generate the content
;;               ("org-org"
;;                :base-directory "~/git/org/"
;;                :publishing-directory "/ssh:www-data@www:~/org"
;;                :recursive t
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function org-publish-org-to-html
;;                :style-include-default nil
;;                :style "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ;
;;               ; http://doc.norang.ca/  (norang website)
;;               ; org-mode-doc-org this document
;;               ; org-mode-doc-extra are images and css files that need to be included
;;               ; org-mode-doc is the top-level project that gets published
;;               ; This uses the same target directory as the 'doc' project
;;               ("org-mode-doc-org"
;;                :base-directory "~/git/org-mode-doc/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :recursive t
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-publish-org-to-html org-publish-org-to-org)
;;                :plain-source t
;;                :htmlized-source t
;;                :style-include-default nil
;;                :style "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ("org-mode-doc-extra"
;;                :base-directory "~/git/org-mode-doc/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive t
;;                :author nil)
;;               ("org-mode-doc"
;;                :components ("org-mode-doc-org" "org-mode-doc-extra"))
;;               ;
;;               ; http://doc.norang.ca/  (norang website)
;;               ; org-mode-doc-org this document
;;               ; org-mode-doc-extra are images and css files that need to be included
;;               ; org-mode-doc is the top-level project that gets published
;;               ; This uses the same target directory as the 'doc' project
;;               ("tmp-org"
;;                :base-directory "/tmp/publish/"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs/tmp"
;;                :recursive t
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-publish-org-to-html org-publish-org-to-org)
;;                :plain-source t
;;                :htmlized-source t
;;                :style-include-default t
;;                :auto-sitemap t
;;                :sitemap-filename "index.html"
;;                :sitemap-title "Test Publishing Area"
;;                :sitemap-style "tree"
;;                :author-info nil
;;                :creator-info nil)
;;               ("tmp-extra"
;;                :base-directory "/tmp/publish/"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs/tmp"
;;                :base-extension "png"
;;                :publishing-function org-publish-attachment
;;                :recursive t
;;                :author nil)
;;               ("tmp"
;;                :components ("tmp-org" "tmp-extra")))))

;; ; I'm lazy and don't want to remember the name of the project to publish when I modify
;; ; a file that is part of a project.  So this function saves the file, and publishes
;; ; the project that includes this file
;; ;
;; ; It's bound to C-S-F12 so I just edit and hit C-S-F12 when I'm done and move on to the next thing
;; (defun bh/save-then-publish ()
;;   (interactive)
;;   (save-buffer)
;;   (org-save-all-org-buffers)
;;   (org-publish-current-project))

;; (global-set-key (kbd "C-s-<f12>") 'bh/save-then-publish)


(setq org-export-babel-evaluate nil)

(setq org-export-latex-listings t)

(setq org-export-html-xml-declaration (quote (("html" . "")
                                              ("was-html" . "<?xml version=\"1.0\" encoding=\"%s\"?>")
                                              ("php" . "<?php echo \"<?xml version=\\\"1.0\\\" encoding=\\\"%s\\\" ?>\"; ?>"))))

(setq org-export-allow-BIND t)


;;;;;;;;;;;;;;;;;;;;
;; reminder setup
;;;;;;;;;;;;;;;;;;;
                                        ; Erase all reminders and rebuilt reminders for today from the agenda
(defun bh/org-agenda-to-appt ()
  (interactive)
  (setq appt-time-msg-list nil)
  (org-agenda-to-appt))

                                        ; Rebuild the reminders everytime the agenda is displayed
(add-hook 'org-finalize-agenda-hook 'bh/org-agenda-to-appt)

                                        ; This is at the end of my .emacs - so appointments are set up when Emacs starts
(bh/org-agenda-to-appt)

                                        ; Activate appointments so we get notifications
(appt-activate t)

                                        ; If we leave Emacs running overnight - reset the appointments one minute after midnight
(run-at-time "24:01" nil 'bh/org-agenda-to-appt)


;;(global-set-key (kbd "<f5>") bh/narrow)
(defun bh/narrow ()
  (interactive)
  (org-narrow-to-subtree)
;;  (org-show-todo-tree nil)
  )
;;(global-set-key (kbd "<S-f5>") 'bh/widen)
(defun bh/widen ()
  (interactive)
  (widen)
  (org-reveal))

(setq org-show-entry-below (quote ((default))))

;; Always hilight the current agenda line
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))

;; ;; The following custom-set-faces create the highlights
;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(highlight ((t (:background "cyan"))))
;;  '(hl-line ((t (:inherit highlight :background "darkseagreen2"))))
;;  '(org-mode-line-clock ((t (:background "grey75" :foreground "red" :box (:line-width -1 :style released-button)))) t))

;; Keep tasks with dates on the global todo lists
(setq org-agenda-todo-ignore-with-date nil)

;; Keep tasks with deadlines on the global todo lists
(setq org-agenda-todo-ignore-deadlines nil)

;; Keep tasks with scheduled dates on the global todo lists
(setq org-agenda-todo-ignore-scheduled nil)

;; Keep tasks with timestamps on the global todo lists
(setq org-agenda-todo-ignore-timestamp nil)

;; Remove completed deadline tasks from the agenda view
(setq org-agenda-skip-deadline-if-done nil)

;; Remove completed scheduled tasks from the agenda view
(setq org-agenda-skip-scheduled-if-done nil)

;; Remove completed items from search results
(setq org-agenda-skip-timestamp-if-done nil)


(setq org-agenda-include-diary nil)
(setq org-agenda-diary-file "~/.emacs.d/org/diary.org")

(setq org-agenda-insert-diary-extract-time t)

;; Include agenda archive files when searching for things
(setq org-agenda-text-search-extra-files (quote (agenda-archives)))

;; Show all future entries for repeating tasks
(setq org-agenda-repeating-timestamp-show-all t)

;; Show all agenda dates - even if they are empty
(setq org-agenda-show-all-dates t)

;; Sorting order for tasks on the agenda
(setq org-agenda-sorting-strategy
      (quote ((agenda habit-down time-up user-defined-up priority-down effort-up category-keep)
              (todo category-up priority-down effort-up)
              (tags category-up priority-down effort-up)
              (search category-up))))

;; Start the weekly agenda today
(setq org-agenda-start-on-weekday nil)

;; Enable display of the time grid so we can see the marker for the current time
(setq org-agenda-time-grid (quote((daily today remove-match)
                                  #("----------------" 0 16
                                    (org-heading t))
                                  (800 1000 1200 1400 1600 1800 2000))))

;; Display tags farther right
(setq org-agenda-tags-column -102)

;;
;; Agenda sorting functions
;;
(setq org-agenda-cmp-user-defined 'bh/agenda-sort)

(defun bh/agenda-sort (a b)
  "Sorting strategy for agenda items.
Late deadlines first, then scheduled, then non-late deadlines"
  (let (result num-a num-b)
    (cond
                                        ; time specific items are already sorted first by org-agenda-sorting-strategy

                                        ; non-deadline and non-scheduled items next
     ((bh/agenda-sort-test 'bh/is-not-scheduled-or-deadline a b))

                                        ; deadlines for today next
     ((bh/agenda-sort-test 'bh/is-due-deadline a b))

                                        ; late deadlines next
     ((bh/agenda-sort-test-num 'bh/is-late-deadline '< a b))

                                        ; scheduled items for today next
     ((bh/agenda-sort-test 'bh/is-scheduled-today a b))

                                        ; pending deadlines last
     ((bh/agenda-sort-test-num 'bh/is-pending-deadline '< a b))

                                        ; late scheduled items next
     ((bh/agenda-sort-test-num 'bh/is-scheduled-late '> a b))

                                        ; finally default to unsorted
     (t (setq result nil)))
    result))

(defmacro bh/agenda-sort-test (fn a b)
  "Test for agenda sort"
  `(cond
                                        ; if both match leave them unsorted
    ((and (apply ,fn (list ,a))
          (apply ,fn (list ,b)))
     (setq result nil))
                                        ; if a matches put a first
    ((apply ,fn (list ,a))
     (setq result -1))
                                        ; otherwise if b matches put b first
    ((apply ,fn (list ,b))
     (setq result 1))
                                        ; if none match leave them unsorted
    (t nil)))

(defmacro bh/agenda-sort-test-num (fn compfn a b)
  `(cond
    ((apply ,fn (list ,a))
     (setq num-a (string-to-number (match-string 1 ,a)))
     (if (apply ,fn (list ,b))
         (progn
           (setq num-b (string-to-number (match-string 1 ,b)))
           (setq result (if (apply ,compfn (list num-a num-b))
                            -1
                          1)))
       (setq result -1)))
    ((apply ,fn (list ,b))
     (setq result 1))
    (t nil)))

(defun bh/is-not-scheduled-or-deadline (date-str)
  (and (not (bh/is-deadline date-str))
       (not (bh/is-scheduled date-str))))

(defun bh/is-due-deadline (date-str)
  (string-match "Deadline:" date-str))

(defun bh/is-late-deadline (date-str)
  (string-match "In *\\(-.*\\)d\.:" date-str))

(defun bh/is-pending-deadline (date-str)
  (string-match "In \\([^-]*\\)d\.:" date-str))

(defun bh/is-deadline (date-str)
  (or (bh/is-due-deadline date-str)
      (bh/is-late-deadline date-str)
      (bh/is-pending-deadline date-str)))

(defun bh/is-scheduled (date-str)
  (or (bh/is-scheduled-today date-str)
      (bh/is-scheduled-late date-str)))

(defun bh/is-scheduled-today (date-str)
  (string-match "Scheduled:" date-str))

(defun bh/is-scheduled-late (date-str)
  (string-match "Sched\.\\(.*\\)x:" date-str))


(setq org-enforce-todo-dependencies t)
(setq org-hide-leading-stars t)
(setq org-odd-levels-only nil)
;;(setq org-cycle-separator-lines 2)
(setq org-blank-before-new-entry
      '((heading . t) (plain-list-item . nil)))

(setq org-insert-heading-respect-content nil)
(setq org-reverse-note-order nil)
(setq org-show-following-heading t)
(setq org-show-hierarchy-above t)
(setq org-show-siblings nil)

;; (setq org-special-ctrl-a/e 'reversed)
;; (setq org-special-ctrl-k t)
;; (setq org-yank-adjusted-subtrees t)

(setq org-id-method (quote uuidgen))
(setq org-deadline-warning-days 30)
(setq org-table-export-default-format "orgtbl-to-csv")

;; (setq org-link-frame-setup ((vm . vm-visit-folder)
;;                             (gnus . org-gnus-no-new-news)
;;                             (file . find-file-other-window)))

(setq org-log-done (quote time))
(setq org-log-into-drawer t)

                                        ;(setq org-clock-sound "/usr/local/lib/tngchime.wav")



;; habit
                                        ; Enable habit tracking (and a bunch of other modules)
(setq org-modules (quote (org-bbdb org-bibtex org-crypt org-gnus org-id org-info org-jsinfo org-habit org-inlinetask org-irc org-mew org-mhe org-protocol org-rmail org-vm org-wl org-w3m)))
                                        ; global STYLE property values for completion
(setq org-global-properties (quote (("STYLE_ALL" . "habit"))))
                                        ; position the habit graph on the agenda to the right of the default
(setq org-habit-graph-column 50)

(setq global-auto-revert-mode t)

;; crypt
;; (require 'org-crypt)
;; ; Encrypt all entries before saving
;; (org-crypt-use-before-save-magic)
;; (setq org-tags-exclude-from-inheritance (quote ("crypt")))
;; ; GPG key to use for encryption
;; (setq org-crypt-key "F0B66B40")


;;;;;;;;;;;;;;;;
;; speed command
;;;;;;;;;;;;;;;;
(setq org-use-speed-commands t)
(setq org-speed-commands-user (quote (("1" . delete-other-windows)
                                      ("2" . split-window-vertically)
                                      ("3" . split-window-horizontally)
                                      ("h" . hide-other)
                                      ("k" . org-kill-note-or-show-branches)
                                      ("q" . bh/show-org-agenda)
                                      ("r" . org-reveal)
                                      ("s" . org-save-all-org-buffers)
                                      ("z" . org-add-note)
                                      ("c" . self-insert-command)
                                      ("C" . self-insert-command)
                                      ("J" . org-clock-goto))))

(defun bh/show-org-agenda ()
  (interactive)
  (switch-to-buffer "*Org Agenda*")
  (delete-other-windows))




(setq require-final-newline nil)

(defun bh/insert-inactive-timestamp ()
  (interactive)
  (org-insert-time-stamp nil t t nil nil nil))

;;(add-hook 'org-insert-heading-hook 'bh/insert-inactive-timestamp)
                                        ;(global-set-key (kbd "<f9> t") 'bh/insert-inactive-timestamp)
(setq org-export-with-timestamps nil)


(setq org-return-follows-link nil)

(defun bh/prepare-meeting-notes ()
  "Prepare meeting notes for email
   Take selected region and convert tabs to spaces, mark TODOs with leading >>>, and copy to kill ring for pasting"
  (interactive)
  (let (prefix)
    (save-excursion
      (save-restriction
        (narrow-to-region (region-beginning) (region-end))
        (untabify (point-min) (point-max))
        (goto-char (point-min))
        (while (re-search-forward "^\\( *-\\\) \\(TODO\\|DONE\\): " (point-max) t)
          (replace-match (concat (make-string (length (match-string 1)) ?>) " " (match-string 2) ": ")))
        (goto-char (point-min))
        (kill-ring-save (point-min) (point-max))))))

;;(setq org-remove-highlights-with-change nil)
;;(add-to-list 'Info-default-directory-list "~/git/org-mode/doc")

(setq org-read-date-prefer-future nil)

(setq org-list-demote-modify-bullet (quote (("+" . "-")
                                            ("*" . "-")
                                            ("1." . "-")
                                            ("1)" . "-"))))
(setq org-tags-match-list-sublevels t)
(setq org-agenda-persistent-filter t)
;;(setq split-width-threshold 9999)

(setq org-link-mailto-program (quote (compose-mail "%a" "%s")))
(setq org-agenda-skip-additional-timestamps-same-entry t)
(setq org-table-use-standard-references (quote from))
                                        ; Overwrite the current window with the agenda
(setq org-agenda-window-setup 'current-window)
(setq org-clone-delete-id t)
(setq org-enable-priority-commands t)
(setq org-cycle-include-plain-lists nil)

;;(setq org-use-sub-superscripts nil)
;; (setq org-emphasis-alist (quote (("*" bold "<b>" "</b>")
;;                                  ("/" italic "<i>" "</i>")
;;                                  ("_" underline "<span style=\"text-decoration:underline;\">" "</span>")
;;                                  ("=" org-code "<code>" "</code>" verbatim)
;;                                  ("~" org-verbatim "<code>" "</code>" verbatim))))



;; (defun org-summary-todo (n-done n-not-done)
;;   "switching entry to DONE when all subentries are done, to TODO otherwise"
;;   (let (org-log-done org-log-states)  ; turn off logging
;;     (org-todo (if (= n-not-done 0) "DONE" "TODO"))
;;     ))

;; (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)


(defun org-dblock-write:image (params)
  (let ((file (plist-get params :file)))
     (clear-image-cache file)
     (insert-image (create-image file) )))


(if (not (member "/usr/texbin" exec-path))
    (setq exec-path (cons "/usr/texbin" exec-path)))


(setq org-export-with-sub-superscripts nil)


;; -- Display images in org mode
;; enable image mode first
;;(iimage-mode t)
(turn-on-iimage-mode)
(iimage-mode-buffer t)
;; add the org file link format to the iimage mode regex
(add-to-list 'iimage-mode-image-regex-alist
  (cons (concat "\\[\\[file:\\(~?" iimage-mode-image-filename-regex "\\)\\]")  1))
;;  add a hook so we can display images on load
(if (display-graphic-p)
    (add-hook 'org-mode-hook '(lambda () (org-turn-on-iimage-in-org))))
;; function to setup images for display on load
(defun org-turn-on-iimage-in-org ()
  "display images in your org file"
  (interactive)
  (turn-on-iimage-mode)
  (set-face-underline-p 'org-link nil))
;; function to toggle images in a org bugger
(defun org-toggle-iimage-in-org ()
  "display images in your org file"
  (interactive)
  (if (face-underline-p 'org-link)
      (set-face-underline-p 'org-link nil)
      (set-face-underline-p 'org-link t))
  (call-interactively 'iimage-mode))


;; (defadvice org-archive-subtree
;;   (before add-inherited-tags-before-org-archive-subtree activate)
;;   "add inherited tags before org-archive-subtree"
;;   (org-set-tags-to (org-get-tags-at)))

;; (add-hook 'org-after-tags-change-hook
;;           (lambda ()
;;             (org-set-tags-to (org-get-tags-at))))

(defun org-clock-out-maybe ()
   "Stop a currently running clock."
   (org-clock-out nil t)
   (org-save-all-org-buffers))

(add-hook 'kill-emacs-hook 'org-clock-out-maybe)


;; (add-hook 'after-init-hook (lambda ()
;;                              (org-mobile-pull)
;;                              (org-mobile-push)))


(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (org-display-inline-images)
  (setq filename
        (concat
         (make-temp-name
          (concat (file-name-nondirectory (buffer-file-name))
                  "_imgs/"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (unless (file-exists-p (file-name-directory filename))
    (make-directory (file-name-directory filename)))
  ; take screenshot
  (if (eq system-type 'darwin)
      (call-process "screencapture" nil nil nil "-i" filename))
  (if (eq system-type 'gnu/linux)
      (call-process "import" nil nil nil filename))
  ; insert into file if correctly taken
  (if (file-exists-p filename)
    (insert (concat "[[file:" filename "]]"))))

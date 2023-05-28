;;Copy Line Command
(defun copy-line (n)
  "Copy N lines at point to the kill-ring."
  (interactive "p")
  (kill-ring-save (line-beginning-position) (line-beginning-position (1+ n))))

(defun copy-line-2 (n)
  "Copy N lines at point to the kill-ring."
  (interactive "p")
  (save-excursion
    (back-to-indentation)
    (kill-ring-save (point) (line-beginning-position (1+ n)))))

;;; vi emulation of the % command
(defun goto-match-paren (arg)
  "Go to the matching  if on (){}[], similar to vi style of % "
  (interactive "p")
  ;; first, check for "outside of bracket" positions expected by
  ;; forward-sexp, etc.
  (cond ((looking-at "[\[\(\{]") (forward-sexp))
        ((looking-back "[\]\)\}]" 1) (backward-sexp))
        ;; now, try to succeed from inside of a bracket
        ((looking-at "[\]\)\}]") (forward-char) (backward-sexp))
        ((looking-back "[\[\(\{]" 1) (backward-char) (forward-sexp))
        (t nil)))


;;; Tab completion everywhere
(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding
point."
  (interactive "*P")
  (if (and
       (or (bobp) (= ?w (char-syntax (char-before))))
       (or (eobp) (not (= ?w (char-syntax (char-after))))))
      (dabbrev-expand arg)
    (indent-according-to-mode)))


(defun show-file-path ()
  "Put the current file name on the clipboard"
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))

(defun show-dir-name()
  "Put the current file name on the clipboard"
  (interactive)
  (let ((dirname default-directory))
    (when dirname
      (with-temp-buffer
        (insert dirname)
        (clipboard-kill-region (point-min) (point-max)))
      (message dirname))))

(defun show-file-name ()
  "Show the full path file name in the minibuffer. And yank it into kill-ring"
  (interactive)
  (let ((filename (buffer-name)))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))


;;; random number
(defun insert-random-number ()
  "Insert a random number between 0 to 999999."
  (interactive)
  (insert (number-to-string (random 999999))))


;;; get my gtd file quickly
(defun gtd ()
  (interactive)
  (find-file "~/Dropbox/org/todo.org"))


(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive)
  ;; (if (buffer-modified-p)
  ;;     (revert-buffer t nil)
  ;;   (revert-buffer t t)
  ;;   )
  (revert-buffer t t))

(defun kj/m-return ()
  (interactive)
  (end-of-line)
  (newline-and-indent))

(defun kj/copy-sexp ()
  (interactive)
  (let (modp buffer-modified-p)
    (beginning-of-thing 'sexp)
    (kill-sexp)
    (yank)
    (if (not modp)
        (set-buffer-modified-p nil))
    ))

(defun kj/mark-sexp ()
  (interactive)
  (beginning-of-thing 'sexp)
  (mark-sexp))



;;(defun kj/go-chromium-proj ()
;;  (interactive)
;;  (find-file "~/Work/chromium/src/net/url_request/url_request.cc")
;;  (find-file "~/Work/chromium/src/net/http/http_cache.cc"))


(defalias 'home (lambda ()
                  (interactive)
                  (find-file "~/.emacs.d/personal/_myconf.el")))


(defalias 'doc (lambda ()
                  (interactive)
                  (find-file "c:/Work/document/")))

(defalias 'work (lambda ()
                  (interactive)
                  (find-file "c:/Work")))

(defalias 'drop (lambda ()
                  (interactive)
                  (find-file "~/Dropbox")))

(defalias 'org (lambda ()
                  (interactive)
                  (find-file "~/org")))

(defalias 'down (lambda ()
                 (interactive)
                 (find-file "~/Downloads")))

(defalias 'dd (lambda ()
                 (interactive)
                 (find-file "/Volumes/stash/")))

(defun goto-column-number (number)
  "Untabify, and go to a column number within the current line (1 is beginning
of the line). from http://communitygrids.blogspot.com/2007/11/emacs-goto-column-function.html"
  (interactive "nColumn number ( - 1 == C) ? ")
  (beginning-of-line)
;  (untabify (point-min) (point-max))
  (while (> number 1)
    (if (eolp)
       ;(insert ? )
        nil
      (forward-char))
    (setq number (1- number))))

(defun kj/middle-of-line()
  "move middle of the line"
  (interactive)
  (let ((middle))
    (end-of-line)
    (setq middle (/ (current-column) 2))
;;    (message "%d" middle)
    (goto-column-number (1+ middle))
  )
)

(defalias 'en5 (lambda ()
                  (interactive)
                  (enlarge-window 5)))

(defalias 'en10 (lambda ()
                  (interactive)
                  (enlarge-window 10)))



(defun bdiff (beg end)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-min))))
  (if (equal major-mode 'dired-mode)
      (mkm/ediff-marked-pair 0)
    (let ((dirs (buffer-substring-no-properties beg end)))
      (if (= (length dirs) 0)
          (call-interactively 'ediff-buffers)
        (progn
          (setq dirs (replace-regexp-in-string "\n" " " dirs))
          (setq dir (split-string dirs " " ))
          (if (file-directory-p (nth 0 dir))
              (ediff-directories (nth 0 dir)
                                 (nth 1 dir) nil)
            (ediff-files (nth 0 dir)
                         (nth 1 dir))))))))

(defun mkm/ediff-marked-pair (&optional n)
  "Run ediff-files on a pair of files marked in dired buffer"
  (interactive "p")
  (let* ((marked-files (dired-get-marked-files nil nil))
         (other-win (get-window-with-predicate
                     (lambda (window)
                       (with-current-buffer (window-buffer window)
                         (and (not (eq window (selected-window)))
                              (eq major-mode 'dired-mode))))))
         (other-marked-files (and other-win
                                  (with-current-buffer (window-buffer other-win)
                                    (dired-get-marked-files nil)))))
    (if (> n 1)
        (cond ((= (length marked-files) 2)
               (setq cmd (concat "bc " (nth 0 marked-files) " " (nth 1 marked-files) " &"))
               (message cmd)
               (shell-command cmd)
               )
              ((and (= (length marked-files) 1)
                    (= (length other-marked-files) 1))
               (setq cmd (concat "bc " (nth 0 marked-files) " " (nth 0 other-marked-files) " &"))
               (message cmd)
               (shell-command cmd))
              (t (error "mark exactly 2 files, at least 1 locally")))
      (cond ((= (length marked-files) 2)
             (if (file-directory-p (nth 0 marked-files))
                 (ediff-directories (nth 0 marked-files)
                                    (nth 1 marked-files) nil)
               (ediff-files (nth 0 marked-files)
                            (nth 1 marked-files))))
            ((and (= (length marked-files) 1)
                  (= (length other-marked-files) 1))
             (if (file-directory-p (nth 0 marked-files))
                 (ediff-directories (nth 0 marked-files)
                                    (nth 0 other-marked-files) nil)
               (ediff-files (nth 0 marked-files)
                            (nth 0 other-marked-files))))
            (t (error "mark exactly 2 files, at least 1 locally"))))))



(defun dired-file-path ()
  (interactive)
  (save-window-excursion
    (condition-case ex
        (if (dired-get-marked-files)
            (mapc (lambda (filename)
                    (with-temp-buffer
                      (insert filename)
                      (clipboard-kill-region (point-min) (point-max)))
                    (message filename))
                  (dired-get-marked-files))
          (error nil))
      ('error ;; caught error
       (progn
         (with-temp-buffer
           (insert default-directory)
           (clipboard-kill-region (point-min) (point-max)))
         (message default-directory))))))


(defun mrc-dired-do-command (command)
  "Run COMMAND on marked files. Any files not already open will be opened.
After this command has been run, any buffers it's modified will remain
open and unsaved."
  (interactive "CRun on marked files M-x ")
  (save-window-excursion
    (mapc (lambda (filename)
            (find-file filename)
            (call-interactively command))
          (dired-get-marked-files))))


(defun dired-nuke ()
  (interactive)
  (mrc-dired-do-command   'delete-trailing-whitespace)
  (mrc-dired-do-command   'save-buffer))


;; mark navigation
(defun buffer-order-next-mark (arg)
  (interactive "p")
  (when (mark)
    (let* ((p (point))
           (m (mark))
           (n p)
           (count (if (null arg) 1 arg))
           (abscount (abs count))
           (rel
            (funcall
             (if (< 0 count) 'identity 'reverse)
             (sort (cons (cons 0 p)
                         (cons (cons (- m p) m)
                               (if mark-ring
                                   (mapcar (lambda (mrm)
                                             (cons (- mrm p) mrm))
                                           mark-ring)
                                 nil)))
                   (lambda (c d) (< (car c) (car d))))))
           (cur rel))
      (while (and (numberp (caar cur)) (/= (caar cur) 0))
        (setq cur (cdr cur)))
      (while (and (numberp (caadr cur)) (= (caadr cur) 0))
        (setq cur (cdr cur)))
      (while (< 0 abscount)
        (setq cur (cdr cur))
        (when (null cur) (setq cur rel))
        (setq abscount (- abscount 1)))
      (when (number-or-marker-p (cdar cur))
        (goto-char (cdar cur))))))

(defun buffer-order-prev-mark (arg)
  (interactive "p")
  (buffer-order-next-mark
   (if (null arg) -1 (- arg))))


(fset 'asfunc
   "\C-[sofunction\C-m\C-xo")

;; compile command
;; temp alias for build simple
(defalias 'simple (lambda ()
                  (interactive)
                  (compile "cd /home/kjoh/Work/curl-7.21.7/docs/examples; make simple")))

(defun hello ()
   (interactive)
   (insert "안녕하세요. 오경주입니다.")
   )

(defun bye ()
   (interactive)
   (insert "감사합니다.
좋은 하루 보내세요.")
   )


(defun bracket ()
  (interactive)
  (insert "【】《》〖〗"))

(defun corner ()
  (interactive)
  (insert "「」『』"))

(defun arrow ()
  (interactive)
  (insert "⇦⇨⇧⇩"))


(defun digraph ()
  (interactive)
  (insert "
  digraph G {
    rankdir=LR;
    node[shape=rect];
    AAA->BBB[label=hahaha];
    bbb->BBB[constraint=false,style=invis,minlen=0.0];
    {rank=same;BBB;bbb};
  }")
  )

(defalias 'dot 'digraph)

(defun dita-template ()
  "ditaa tempalte."
  (interactive)
  (insert "
    +-----------+        +---------+
    |    PLC    |        |         |
    |  Network  +<------>+   PLC   +<---=---------+
    |    cRED   |        |  c707   |              |
    +-----------+        +----+----+              |
                              ^                   |
                              |                   |
                              |  +----------------|-----------------+
                              |  |                |                 |
                              v  v                v                 v
      +----------+       +----+--+--+      +-------+---+      +-----+-----+       Windows clients
      |          |       |          |      |           |      |           |      +----+      +----+
      | Database +<----->+  Shared  +<---->+ Executive +<-=-->+ Operator  +<---->|cYEL| . . .|cYEL|
      |   c707   |       |  Memory  |      |   c707    |      | Server    |      |    |      |    |
      +--+----+--+       |{d} cGRE  |      +------+----+      |   c707    |      +----+      +----+
         ^    ^          +----------+             ^           +-------+---+
         |    |                                   |
         |    +--------=--------------------------+
         v
+--------+--------+
|                 |
| Millwide System |            -------- Data ---------
| cBLU            |            --=----- Signals ---=--
+-----------------+
")
)

(defun makefile-template ()
  "makefile template"
  (interactive)
  (insert "
MAKEFLAGS=-r

CC := gcc
CXX := g++
AR := ar
LD := ld
STRIP := strip

LDFLAGS :=
LIBS :=  -lm
INCLUDES := -I.

CFLAGS := -g -Wall
depfile = $(depsdir)/$@.d
DEPFLAGS = -MMD -MF $(depfile)

srcdir := .
builddir := out
depsdir := $(builddir)/.deps
obj := $(builddir)/obj

all_deps :=

OBJS := \
	$(obj)/cmain.o \
	$(obj)/cppmain.o \


all_deps += $(OBJS)

# Suffix rules, putting all outputs into $(obj).
$(obj)/%.o: $(srcdir)/%.c
	@mkdir -p $(dir $@) $(dir $(depfile))
	$(CC) $(CFLAGS) $(INCLUDES) $(DEPFLAGS) -c $< -o $@

# Suffix rules, putting all outputs into $(obj).
$(obj)/%.o: $(srcdir)/%.cpp
	@mkdir -p $(dir $@) $(dir $(depfile))
	$(CXX) $(CFLAGS) $(INCLUDES) $(DEPFLAGS) -c $< -o $@


$(builddir)/prog1: $(OBJS)
	$(CXX) $(LDFLAGS) $(LIBS) -o $@ $^

all_deps += $(builddir)/prog1

.PHONY: all
all: $(builddir)/prog1

clean:
	@rm -rf $(builddir)


d_files := $(wildcard $(foreach f,$(all_deps),$(depsdir)/$(f).d))
ifneq ($(d_files),)
  $(shell cat $(d_files) > $(depsdir)/all.deps)
  include $(depsdir)/all.deps
endif
"))

(defun image-name ()
  "thisandthat."
  (interactive)
  (insert (concat "img-"(substring (shell-command-to-string "date +%s") 3 -1) ".png")))

(defun mark-ring-remove ()
  "delete mark-ring"
  (interactive)
  (setq mark-ring nil)
)

(defalias 'mrr 'mark-ring-remove)

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))

;;(defun smart-beginning-of-line ()
;;  "Move point to first non-whitespace character or beginning-of-line.
;;Move point to the first non-whitespace character on this line.
;;If point was already at that position, move point to beginning of line."
;;  (interactive)
;;  (let ((oldpos (point)))
;;    (back-to-indentation)
;;    (and (= oldpos (point))
;;         (beginning-of-line))))
;;
;;(global-set-key [home] 'smart-beginning-of-line)
;;(global-set-key "\C-a" 'smart-beginning-of-line)

(defun unpop-to-mark-command ()
  "Unpop off mark ring into the buffer's actual mark.
Does not set point.  Does nothing if mark ring is empty."
  (interactive)
  (let ((num-times (if (equal last-command 'pop-to-mark-command) 2
                     (if (equal last-command 'unpop-to-mark-command) 1
                       (error "Previous command was not a (un)pop-to-mark-command")))))
    (dotimes (x num-times)
      (when mark-ring
        (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
        (set-marker (mark-marker) (+ 0 (car (last mark-ring))) (current-buffer))
        (when (null (mark t)) (ding))
        (setq mark-ring (nbutlast mark-ring))
        (goto-char (mark t)))
      (deactivate-mark))))

(defmacro my-unpop-to-mark-advice ()
  "Enable reversing direction with un/pop-to-mark."
  `(defadvice ,(key-binding (kbd "C-SPC")) (around my-unpop-to-mark activate)
     "Unpop-to-mark with negative arg"
     (let* ((arg (ad-get-arg 0))
            (num (prefix-numeric-value arg)))
       (cond
        ;; Enabled repeated un-pops with C-SPC
        ((eq last-command 'unpop-to-mark-command)
         (if (and arg (> num 0) (<= num 4))
             ad-do-it ;; C-u C-SPC reverses back to normal direction
           ;; Otherwise continue to un-pop
           (setq this-command 'unpop-to-mark-command)
           (unpop-to-mark-command)))
        ;; Negative argument un-pops: C-- C-SPC
        ((< num 0)
         (setq this-command 'unpop-to-mark-command)
         (unpop-to-mark-command))
        (t
         ad-do-it)))))
(my-unpop-to-mark-advice)

(defalias 'nuke 'delete-trailing-whitespace)
(defalias 'gl 'goto-line)
(defalias 'gchar 'goto-char)
(defalias 'cr 'comment-or-uncomment-region)
(defalias 'line 'linum-mode)
(defalias 'oow  'ido-find-file-other-window)
(defalias 'mbar  'menu-bar-mode)
(defalias 'dbl  'delete-blank-lines)
(defalias 'qrr  'query-replace-regexp)
(defalias 'fnd  'find-name-dired)

;;tags
(defalias 'visittag  'visit-tags-table)
(defalias 'resettag  'tags-reset-tags-tables)
(defalias 'fft 'ido-find-file-in-tag-files)


;; alias for adjusting window-size
(defalias 'enlar  'enlarge-window)
(defalias 'shrin  'shrink-window)
(defalias 'enlar2 'enlarge-window-horizontally)
(defalias 'shrin2 'shrink-window-horizontally)

;; aias for cedet
;;(defalias 'global-check 'cedet-gnu-global-version-check)
;;(defalias 'global-test  'semanticdb-test-gnu-global)
;;(defalias 'global-create 'cedet-gnu-global-create/update-database)
;;(defalias 'cscope-check' 'cedet-cscope-version-check)
;;(defalias 'cscope-test  'semanticdb-test-cscope)
;;(defalias 'cscope-create 'cedet-cscope-create/update-database)
;;(defalias 'dblist 'semanticdb-test-current-database-list)
;;(defalias 'transpath 'semanticdb-find-test-translate-path)
;;(defalias 'cenv  'semantic-c-describe-environment)
;;(defalias 'adebug  'semantic-analyze-debug-assist)
;;(defalias 'acurrent  'semantic-analyze-current-context)
;;(defalias 'idlefunc  'semantic-debug-idle-function)
;;(defalias 'idlewfunc  'semantic-debug-idle-work-function)
;;(defalias 'findtag 'semantic-symref-find-tags-by-name)
;;(defalias 'searchtag 'semantic-adebug-searchdb)
;;(defalias 'sss 'semantic-symref-symbol)
;;(defalias 'ss 'semantic-symref)


;;; ediff
;;;(defalias 'bdiff   'ediff-buffers)
(defalias 'rdiff   'ediff-revision)
(defalias 'dirdiff 'ediff-directories)

;;; compile
(defalias 'cc  'compile)

(defalias 'fn  'show-file-name)
(defalias 'fp  'show-file-path)
(defalias 'fd  'show-dir-name)
(defalias 'irn 'insert-random-number)
(defalias 'sim  'set-input-method)

(defalias 'hex  'hexl-mode)
(defalias 'hex-exit  'hexl-mode-exit)

(defalias 'brap  'browse-url-at-point)

(defalias 'dchar 'describe-char)

(defalias 'bmshowall   'bm-show-all)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  functions on eshell
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun eshell/emacs (&rest args)
  "Open a file in emacs. Some habits die hard."
  (if (null args)
      ;; If I just ran "emacs", I probably expect to be launching
      ;; Emacs, which is rather silly since I'm already in Emacs.
      ;; So just pretend to do what I ask.
      (bury-buffer)
    ;; We have to expand the file names or else naming a directory in an
    ;; argument causes later arguments to be looked for in that directory,
    ;; not the starting directory
    (mapc #'find-file (mapcar #'expand-file-name (eshell-flatten-list (reverse args))))))

(defun eshell/cdroot (&rest args)
  (if (projectile-project-root)
      (eshell/cd (projectile-project-root))))


(defun kjoh/dired-do-rename (&optional args)
  (interactive "P")
  (if (null args)
      (setq dired-dwim-target nil)
    (setq dired-dwim-target t))
  (dired-do-rename args)
  (setq dired-dwim-target t))

(defun kjoh/dired-do-copy (&optional args)
  (interactive "P")
  (setq dired-dwim-target t)
  (dired-do-copy args))

(defun runvi ()
  (interactive)
  (let (filename (file-truename buffer-file-name))
    (setq cmd (format "/Applications/MacVim.app/Contents/MacOS/MacVim %s" (file-truename buffer-file-name)))
    (save-window-excursion
      (async-shell-command cmd))))

(defun narrow-or-widen-dwim ()
  "If the buffer is narrowed, it widens. Otherwise, it narrows to region, or Org subtree."
  (interactive)
  (cond ((buffer-narrowed-p) (widen))
	((region-active-p) (narrow-to-region (region-beginning) (region-end)))
	((equal major-mode 'org-mode) (org-narrow-to-subtree))
	((equal major-mode 'c-mode) (narrow-to-defun))
	((equal major-mode 'c++-mode) (narrow-to-defun))
	((equal major-mode 'emacs-lisp-mode) (narrow-to-defun))
	(t (error "Please select a region to narrow to"))))

(defun org-sync()
  (interactive)
  (org-mobile-pull)
  (org-mobile-push))

(eval-after-load "smartparens"
  '(progn

     (defun sp-backward-up-sexp (&optional arg interactive)
       "Move backward out of one level of parentheses.

With ARG, do this that many times.  A negative argument means
move forward but still to a less deep spot.

The argument INTERACTIVE is for internal use only.

If called interactively and `sp-navigate-reindent-after-up' is
enabled for current major-mode, remove the whitespace between
beginning of the expression and the first \"thing\" inside the
expression.

Examples:

  (foo (bar baz) quux| blab) -> |(foo (bar baz) quux blab)

  (foo (bar |baz) quux blab) -> |(foo (bar baz) quux blab) ;; 2

  (                  -> |(foo bar baz)
​    foo |bar baz)"
       (interactive "p\np")
       (push-mark)
       (setq arg (or arg 1))
       (sp-up-sexp (- arg) interactive))))

(defun kjoh/revert-all-file-buffers ()
  "Refresh all open buffers from their respective files."
  (interactive)
  (let* ((list (buffer-list))
         (buffer (car list)))
    (while buffer
      (let ((filename (buffer-file-name buffer)))
        ;; Revert only buffers containing files, which are not modified;
        ;; do not try to revert non-file buffers like *Messages*.
        (when (and filename
                   (not (buffer-modified-p buffer)))
          (if (file-exists-p filename)
              ;; If the file exists, revert the buffer.
              (with-current-buffer buffer
                (revert-buffer :ignore-auto :noconfirm :preserve-modes))
            ;; If the file doesn't exist, kill the buffer.
            (let (kill-buffer-query-functions) ; No query done when killing buffer
              (kill-buffer buffer)
              (message "Killed non-existing file buffer: %s" filename)))))
      (setq buffer (pop list)))
    (message "Finished reverting buffers containing unmodified files.")))

(defalias 'rab   'kjoh/revert-all-file-buffers)

(defun kjoh/eshell ()
  (interactive)
  (let ((buffername (concat "<eshell>" (substring (pwd) 10 nil))))
    (when buffername
      (setq eshell-buffer-name buffername)
      (eshell))))

(defun kjoh/shell ()
  (interactive)
  (let ((buffername (concat "<shell>" (substring (pwd) 10 nil))))
    (when buffername
      (shell buffername))))

(global-set-key (kbd "C-x m") 'kjoh/shell)

(defun gitcomment ()
  "Put the current file name on the clipboard"
  (interactive)
  (with-temp-buffer
    (insert "XXX: Remove files

Remove useless file
[JIRA] XXX-327")
    (clipboard-kill-region (point-min) (point-max))))

(defun watcherlist ()
  "Put the current file name on the clipboard"
  (interactive)
  (with-temp-buffer
    (insert "kyongjoo.oh,")
    (clipboard-kill-region (point-min) (point-max))))

(defun watcheralllist ()
  "Put the current file name on the clipboard"
  (interactive)
  (with-temp-buffer
    (insert "kyongjoo.oh,")
    (clipboard-kill-region (point-min) (point-max))))


(defun published ()
  "Put the current file name on the clipboard"
  (interactive)
  (with-temp-buffer
    (insert "<h2><font color=green>manual published</font></h2>")
    (clipboard-kill-region (point-min) (point-max))))


(defun really-kill-emacs ()
  "Like `kill-emacs', but ignores `kill-emacs-hook'."
  (interactive)
  (let (kill-emacs-hook)
    (kill-emacs)))


(eval-after-load "rx"
  '(progn
     (setq rx--delayed-evaluation t)
     (message "rx modificated - kjoh")
     (defun rx--translate-regexp (body)
       "Translate the `regexp' form.  Return (REGEXP . PRECEDENCE)."
       (unless (and body (null (cdr body)))
         (error "rx `regexp' form takes exactly one argument"))
       (let ((arg (car body)))
         (cond ((stringp arg)
                ;; Generate the regexp when needed, since rx isn't
                ;; necessarily present in the byte-compilation environment.
                (unless rx--regexp-atomic-regexp
                  (setq rx--regexp-atomic-regexp
                        ;; Match atomic (precedence t) regexps: may give
                        ;; false negatives but no false positives, assuming
                        ;; the target string is syntactically correct.
                        (rx-to-string
                         '(seq
                           bos
                           (or (seq "["
                                    (opt "^")
                                    (opt "]")
                                    (* (or (seq "[:" (+ (any "a-z")) ":]")
                                           (not (any "]"))))
                                    "]")
                               anything
                               (seq "\\"
                                    (or anything
                                        (seq (any "sScC_") anything)
                                        (seq "("
                                             (* (or (not (any "\\"))
                                                    (seq "\\" (not (any ")")))))
                                             "\\)"))))
                           eos)
                         t)))
                (cons (list arg)
                      (if (string-match-p rx--regexp-atomic-regexp arg) t nil)))
               (rx--delayed-evaluation
                (cons (list arg) nil))
               (t (error "rx `regexp' form with non-string argument")))))))
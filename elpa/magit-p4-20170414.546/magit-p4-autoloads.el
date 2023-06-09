;;; magit-p4-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "magit-p4" "magit-p4.el" (22832 12976 522402
;;;;;;  85000))
;;; Generated autoloads from magit-p4.el

(autoload 'magit-p4-clone "magit-p4" "\
Clone given DEPOT-PATH.

   The first argument is P4 depot path to clone.  The TARGET-DIR argument
   is directory which will hold the Git repository.

\(fn DEPOT-PATH &optional TARGET-DIR)" t nil)

(autoload 'magit-p4-sync "magit-p4" "\
Synchronize with default and/or given DEPOT-PATH.

   The optional argument is P4 depot path which will be synchronized with.
   If not present, git-p4 will try to synchronize with default depot path which
   has been cloned to before.

\(fn &optional DEPOT-PATH)" t nil)

(autoload 'magit-p4-rebase "magit-p4" "\
Run git-p4 rebase.

\(fn)" t nil)

(autoload 'magit-p4-submit "magit-p4" "\
Run git-p4 submit.

\(fn)" t nil)

(autoload 'magit-p4-run-git-with-editor "magit-p4" "\
Similar to magit-run-git-with-editor, but also exports
P4EDITOR and uses custom process filter `magit-p4-process-filter'.

\(fn &rest ARGS)" nil nil)
 (autoload 'magit-p4-popup "magit-p4" nil t)

(autoload 'magit-p4-mode "magit-p4" "\
P4 support for Magit

\(fn &optional ARG)" t nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; magit-p4-autoloads.el ends here

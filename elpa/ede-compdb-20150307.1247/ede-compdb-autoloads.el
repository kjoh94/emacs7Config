;;; ede-compdb-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (ede-ninja-load-project ede-compdb-load-project)
;;;;;;  "ede-compdb" "ede-compdb.el" (21994 52345 0 0))
;;; Generated autoloads from ede-compdb.el

(autoload 'ede-compdb-load-project "ede-compdb" "\
Create an instance of option `ede-compdb-project' for DIR.

\(fn DIR)" nil nil)

(autoload 'ede-ninja-load-project "ede-compdb" "\
Create an instance of option `ede-ninja-project' for DIR.

\(fn DIR)" nil nil)

(eval-after-load "ede/auto" '(ede-add-project-autoload (ede-project-autoload "compdb" :name "Compilation DB" :file 'ede-compdb :proj-file "compile_commands.json" :load-type 'ede-compdb-load-project :class-sym 'ede-compdb-project)))

(eval-after-load "ede/auto" '(ede-add-project-autoload (ede-project-autoload "ninja" :name "Ninja" :file 'ede-compdb :proj-file "build.ninja" :load-type 'ede-ninja-load-project :class-sym 'ede-ninja-project)))

;;;***

;;;### (autoloads nil nil ("ede-compdb-pkg.el") (21994 52345 451533
;;;;;;  0))

;;;***

(provide 'ede-compdb-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ede-compdb-autoloads.el ends here

(require 'smart-mode-line)
(sml/setup)

(sml/apply-theme 'dark)
;;(sml/apply-theme 'light)
;;(sml/apply-theme 'respectful)

(setq sml/shorten-modes t)
(setq sml/shorten-directory t)

(setq sml/name-width 20)
(setq sml/mode-width 'full)

(setq sml/hidden-modes '(" AC" " Pre" " SP" " SP/s"" mate" " Plugged" " Gtags" " Abbrev" " Fill" " Guide"
                     " Smrt" " Ifdef" " hs" " ws" " Irony" "Irony" " Helm Gtags"))

;;(add-to-list 'sml/replacer-regexp-list '("^~/Dropbox/Projects/In-Development/" ":ProjDev:") t)
;;(add-to-list 'sml/replacer-regexp-list '("^~/Documents/Work/" ":Work:") t)

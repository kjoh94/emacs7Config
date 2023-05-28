(require 'ido-vertical-mode)

(setq ido-vertical-decorations
  '("\n » "                             ; left bracket around prospect list
    ""                                  ; right bracket around prospect list
    "\n   "                             ; separator between prospects, depends on `ido-separator`
    "\n   ..."                          ; inserted at the end of a truncated list of prospects
    "["                                 ; left bracket around common match string
    "]"                                 ; right bracket around common match string
    " [No match]"
    " "
    " [Not readable]"
    " [Too big]"
    " [Confirm]"
    "\n"                             ; left bracket around the sole remaining completion
    ""                                  ; right bracket around the sole remaining completion
    ))

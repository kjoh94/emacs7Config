 Change variable `mode-line-position' so that the following changes
 are made to the mode line:

 1. Highlight the column number when the current column is greater
    than limit `modelinepos-column-limit'.  Face
    `modelinepos-column-warning' is used for the highlighting.

 2. Make `size-indication-mode' show the size of the region,
    instead of the buffer size, whenever the region is active.

 3. Make `size-indication-mode' show the current command currently
    acts specially because the region is active (Emacs 23+).

 For #2: When the region is active, the mode line displays some
 information that you can customize - see option
 `modelinepos-style'.  Customization choices for this include (a)
 the number of chars, (b) the number of chars and number of lines,
 and (c) anything else you might want.  Choice (b) is the default.

 For (c), you provide a `format' expression as separate components:
 the format string and the sexp arguments to be evaluated and
 plugged into the string.  The number of sexp args depends on the
 format string that you use: one for each `%' construct.

 Choice (c) is provided so that you can choose alternative
 formatting styles.  For example, instead of ` 256 ch, 13 l', you
 could show ` (256 chars, 13 lines)'.  But (c) can really show
 information at all.  It need not have anything to do with the
 region, but it is nevertheless shown when the region is active.

 Option `modelinepos-empty-region-flag' determines whether to show
 the active-region indication when the active region is empty.  By
 default it is t, meaning indicate an empty active region.

 For #3, certain standard Emacs commands restrict their scope to
 the region when it is active.  Some of these are handled here by
 highlighting the region indication in the mode line specially
 (using face `modelinepos-region-acting-on' instead of face
 `modelinepos-region').  The region-restricted commands defined in
 standard library `replace.el' are handled this way.

 If you also use my library `isearch+.el', which I recommend, then
 (for Emacs 24.3+) Isearch commands too can optionally be
 restricted to the active region, and they too are handled by the
 special mode-line highlighting.  This includes `M-%' and `C-M-%'
 during Isearch, which invoke query-replacement.  Not only is the
 Isearch region indicated in the mode line, but the
 query-replacement command is invoked from Isearch with that region
 active, so it too is limited to that scope.

 Note: Loading this library changes the default definition of
       `mode-line-position'.

 To use this library, put this in your Emacs init file (~/.emacs):

   (require 'modeline-posn)

 To show the column number highlighting, turn on Column Number
 mode.  You can do that in your Emacs init file this way:

   (column-number-mode 1)

 To show the buffer and region size indication in the mode line,
 turn on Size Indication.  You can do that in your Emacs init file
 this way:

   (size-indication-mode 1) ; Turn on Size Indication mode.

 You can customize `modelinepos-column-limit' or bind it to
 different values for different modes.


 Faces defined here:

   `modelinepos-column-warning', `modelinepos-region',
   `modelinepos-region-acting-on' (Emacs 23+).

 User options defined here:

   `modelinepos-column-limit', `modelinepos-empty-region-flag',
   `modelinepos-style', `use-empty-active-region' (Emacs < 23).

 Non-interactive functions defined here:

   `modelinepos-show-region-p', `use-region-p' (Emacs < 23).

 Non-option variables defined here:

   `modelinepos-region-acting-on' (Emacs 23+).


 ***** NOTE: The following commands defined in `simple.el' have
             been REDEFINED HERE:

   `size-indication-mode'.


 ***** NOTE: The following variables defined in `bindings.el' have
             been REDEFINED HERE:

   `mode-line-position'.


 ***** NOTE: The following functions defined in `isearch+.el' have
             been ADVISED HERE:

   `isearch-mode' (Emacs 24.3+).

 ***** NOTE: The following functions defined in `isearch.el' have
             been ADVISED HERE, if you use library `isearch+.el':

   `isearch-query-replace' (Emacs 24.3+),
   `isearch-query-replace-regexp' (Emacs 24.3+).

 ***** NOTE: The following functions defined in `replace.el' have
             been ADVISED HERE:

   `keep-lines-read-args', `map-query-replace-regexp',
   `perform-replace', `query-replace-read-args',
   `query-replace-read-from', `query-replace-read-to',
   `replace-dehighlight'.

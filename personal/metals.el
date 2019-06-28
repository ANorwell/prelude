(require 'use-package)

(setq use-package-always-defer t
      use-package-always-ensure t)

(use-package lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  :hook (scala-mode . lsp)
  :config (setq lsp-prefer-flymake nil))

(defun company-indent-for-tab-command (&optional arg)
  "Indent the current line or region, or insert a tab, as appropriate.
This function either inserts a tab, or indents the current line,
or performs symbol completion, depending on `tab-always-indent'.
The function called to actually indent the line or insert a tab
is given by the variable `indent-line-function'.

If a prefix argument is given, after this function indents the
current line or inserts a tab, it also rigidly indents the entire
balanced expression which starts at the beginning of the current
line, to reflect the current line's indentation.

In most major modes, if point was in the current line's
indentation, it is moved to the first non-whitespace character
after indenting; otherwise it stays at the same position relative
to the text.

If `transient-mark-mode' is turned on and the region is active,
this function instead calls `indent-region'.  In this case, any
prefix argument is ignored."
  (interactive "P")
  (cond
   ;; The region is active, indent it.
   ((use-region-p)
    (indent-region (region-beginning) (region-end)))
   ((or ;; indent-to-left-margin is only meant for indenting,
	;; so we force it to always insert a tab here.
	(eq indent-line-function 'indent-to-left-margin)
	(and (not tab-always-indent)
	     (or (> (current-column) (current-indentation))
		 (eq this-command last-command))))
    (insert-tab arg))
   (t
    (let ((old-tick (buffer-chars-modified-tick))
          (old-point (point))
	  (old-indent (current-indentation)))

      ;; Indent the line.
      (or (not (eq (indent--funcall-widened indent-line-function) 'noindent))
          (indent--default-inside-comment)
          (when (or (<= (current-column) (current-indentation))
                    (not (eq tab-always-indent 'complete)))
            (indent--funcall-widened (default-value 'indent-line-function))))

      (cond
       ;; If the text was already indented right, try completion.
       ((and (eq tab-always-indent 'complete)
             (eq old-point (point))
             (eq old-tick (buffer-chars-modified-tick)))
        (company-complete-common))

       ;; If a prefix argument was given, rigidly indent the following
       ;; sexp to match the change in the current line's indentation.
       (arg
        (let ((end-marker
               (save-excursion
                 (forward-line 0) (forward-sexp) (point-marker)))
              (indentation-change (- (current-indentation) old-indent)))
          (save-excursion
            (forward-line 1)
            (when (and (not (zerop indentation-change))
                       (< (point) end-marker))
              (indent-rigidly (point) end-marker indentation-change))))))))))

(require 'helm)


(use-package lsp-ui
  :config (progn
            (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
            (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
            )
  :bind
  (:map global-map
        ("<tab>" . company-indent-for-tab-command)
        ("s-j" . helm-imenu))
  :commands lsp-ui-mode
  )

(use-package company-lsp)
(push 'company-lsp company-backends)

(global-set-key (kbd "s-j") #'helm-imenu)
(global-set-key (kbd "s-k") #'flycheck-list-errors)
(global-set-key (kbd "s-d") #'lsp-treemacs-errors-list)
(global-set-key (kbd "C-c C-l") #'lsp-ui-imenu)

(setq xref-prompt-for-identifier '(not xref-find-definitions
                                       xref-find-definitions-other-window
                                       xref-find-definitions-other-frame
                                       xref-find-references))

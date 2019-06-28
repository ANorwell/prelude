(setq default-frame-alist '((font . "Source Code Variable-15")))

(setq whitespace-line-column 120) ;; limit line length
(setq ag-reuse-window 't)

(toggle-scroll-bar -1)

(add-hook 'prelude-prog-mode-hook (lambda () (smartparens-mode -1)) t)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))


;; key bindings
(global-set-key (kbd "s-i") 'projectile-ag)
(global-set-key (kbd "s-g") 'projectile-find-file)
(global-set-key (kbd "s-g") 'projectile-find-file)
(global-set-key (kbd "s-s") 'sbt-hydra)


(defun open-notes-file ()
  (interactive)
  (find-file "~/Documents/notes.org"))
(global-set-key (kbd "s-n") 'open-notes-file)

(defun open-todo-file ()
  (interactive)
  (find-file "~/Documents/todo.org"))
(global-set-key (kbd "s-b") 'open-todo-file)


(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;;;;;;;;;;; OUTLINE

(global-set-key [C-M-left] 'hide-body)
(global-set-key [C-M-right] 'show-all)
(global-set-key [M-up] 'outline-previous-heading)
(global-set-key [M-down] 'outline-next-heading)
(global-set-key [M-left] 'hide-entry)
(global-set-key [M-right] 'show-entry)
(global-set-key (kbd "C-M-S-<left>") 'hide-entry)
(global-set-key (kbd "C-M-S-<right>") 'show-entry)

(electric-pair-mode 1)

(add-hook 'scala-mode-hook
          '(lambda ()
             (outline-minor-mode)
             (setq outline-regexp "[\s\r\t]*\\(class\\|def\\|package\\|import\\|case class\\|case object\\|object\\|trait\\|abstract\\|mixin\\|protected def\\|sealed\\|override\\|private def\\|describe\\|it(\\)")
             (subword-mode)
             (electric-pair-mode 1)
             (local-set-key (kbd "C-,") 'spec-buffer-switch)))

(add-hook 'web-mode-hook
          '(lambda ()
             (outline-minor-mode)
             (electric-pair-mode 1)
             (setq outline-regexp " *\\(private funct\\|public funct\\|funct\\|class\\|#head\\)")))

(add-hook 'php-mode-hook
          '(lambda ()
             (outline-minor-mode)
             (electric-pair-mode 1)
             (subword-mode)
             (setq outline-regexp " *\\(private funct\\|public funct\\|funct\\|class\\|#head\\)")))

(add-hook 'c++-mode-hook
          '(lambda ()
             (outline-minor-mode)
             (electric-pair-mode 1)
             (setq outline-regexp "^[^\s\r\t\n]")
             (hide-sublevels 1)))

(add-hook 'python-mode-hook
          '(lambda ()
             (outline-minor-mode)
             (electric-pair-mode 1)
             (setq outline-regexp " *\\(def \\|clas\\|#hea\\)")
             (hide-sublevels 1)))

(add-hook 'enh-ruby-mode-hook
          '(lambda ()
             (outline-minor-mode)
             (setq outline-regexp " *\\(def \\|clas\\|require\\|describe\\|public\\|private\\|protected\\|context\\|module\\|require\\|should\\|xshould\\)")
             (subword-mode)
             (electric-pair-mode 1)
             (yard-mode)
             (local-set-key (kbd "C-,") 'rails-test-buffer-switch)))

(add-hook 'ruby-mode-hook
          '(lambda ()
             (outline-minor-mode)
             (setq outline-regexp " *\\(def \\|clas\\|require\\|describe\\|public\\|private\\|context\\|module\\|require\\|should\\)")
             (subword-mode)
             (electric-pair-mode 1)
             (yard-mode)
             (local-set-key (kbd "C-,") 'rails-test-buffer-switch)))


(add-hook 'js-mode-hook
          '(lambda ()
             (outline-minor-mode)
             (electric-pair-mode 1)
             (setq outline-regexp " *\\(function\\|describe(\\|it(\\)")))

(add-hook 'js2-mode-hook
          '(lambda ()
             (outline-minor-mode)
             (electric-pair-mode 1)
             (electric-indent-local-mode -1)
             (setq outline-regexp " *\\(.*function\\|describe(\\|it(\\|.*: *{\\|.*= *{\\)")))

(defun toggle-ignore-on ()
  (interactive)
  (replace-regexp "\\(\\s-+\\)it(" "\\1ignore("))

(defun toggle-ignore-off ()
  (interactive)
  (replace-regexp "\\(\\s-+\\)ignore(" "\\1it("))

(defun toggle-ignore ()
  (interactive)
  (save-excursion
    (goto-char 0)
    (if (search-forward-regexp "^\\s-+\\(ignore\\)" nil t)
        (progn
          (print "toggling off!!!!!!")
          (goto-char 0)
          (toggle-ignore-off))
      (print "toggling on!!!")
      (toggle-ignore-on))))
(global-set-key (kbd "C-c C-t") 'toggle-ignore)



(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; (require 'persp-projectile)
;; (persp-mode)

(use-package spaceline)
(require 'spaceline-config)
(spaceline-spacemacs-theme)

;;;;;;;;;;;;;;;;;;;;;;;;;;
(server-start)

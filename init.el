(setq ns-use-srgb-colorspace t)
(require 'package)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages
  '(starter-kit
    starter-kit-lisp
    starter-kit-bindings
    starter-kit-ruby
    starter-kit-js
    js2-mode
    coffee-mode
    ispell
;color-theme-blackboard
;color-theme-solarized
)
  "A list of packages to ensure are installed at launch.")

(defun inf-ruby-keys ())
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(require 'flowdock)
(require 'switch-window)
(require 'project-grep)
(require 'ruby-test)
(require 'env)
(remove-hook 'prog-mode-hook 'esk-turn-on-idle-highlight-mode)
(remove-hook 'prog-mode-hook 'esk-pretty-lambdas)
(remove-hook 'prog-mode-hook 'esk-local-comment-auto-fill)
(remove-hook 'ruby-mode-hook 'esk-paredit-nonlisp)

(global-auto-revert-mode 1)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'feature-mode)
(require 'find-file-in-git-repo)

(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

(add-to-list 'load-path "/Users/dalcorn/.emacs.d/elpa/ecb-alexott")
(require 'ecb)

(require 'mmm-auto)
(setq mmm-global-mode 'auto)

(mmm-add-mode-ext-class 'html-erb-mode "\\.html\\.erb\\'" 'erb)
(mmm-add-mode-ext-class 'html-erb-mode "\\.jst\\.ejs\\'" 'ejs)
(mmm-add-mode-ext-class 'html-erb-mode nil 'html-js)
(mmm-add-mode-ext-class 'html-erb-mode nil 'html-css)

(add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . html-erb-mode))
(add-to-list 'auto-mode-alist '("\\.jst\\.ejs\\'"  . html-erb-mode))

(add-to-list 'hs-special-modes-alist
	     '(ruby-mode
	       "\\(def\\|do\\|{\\)" "\\(end\\|end\\|}\\)" "#"
	       (lambda (arg) (ruby-end-of-block)) nil))


(add-to-list 'hs-special-modes-alist
                 `(ruby-mode
                   ,(rx (or "def" "class" "module" "{" "[" "describe" "context")) ; Block start
                   ,(rx (or "}" "]" "end"))                  ; Block end
                   ,(rx (or "#" "=begin"))                   ; Comment start
                   ruby-forward-sexp nil))

;;; http://stackoverflow.com/questions/10946219/emacs-compilation-mode-wont-see-bash-alias
;;; can result in some slowdowns due to .bashrc being unnecessarily loaded in other places
(setq shell-command-switch "-ic")

(setq stack-trace-on-error t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ag-highlight-search nil)
 '(ag-reuse-buffers t)
 '(auto-save-default nil)
 '(coffee-tab-width 2)
 '(comint-process-echoes t)
 '(custom-safe-themes
   (quote
    ("337047491f7db019df2ba54483408d7d7faea0bda61e4c4f5e8cf2f4e3264478" default)))
 '(dirtree-windata (quote (frame left 0.1 delete)))
 '(ecb-layout-window-sizes
   (quote
    (("left13"
      (ecb-directories-buffer-name 0.09116022099447514 . 0.98989898989899)))))
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1))
 '(ecb-source-path
   (quote
    ("/Users/dalcorn/devel"
     (#("/Users/dalcorn/devel/knovation/icurio" 0 37
        (help-echo "Mouse-2 toggles maximizing, mouse-3 displays a popup-menu"))
      "icurio"))))
 '(erc-fill-column 70)
 '(erc-keywords
   (quote
    ("Build failed" "deployed \\S +" "Build succeeded" "succeeded")))
 '(erc-modules
   (quote
    (autojoin button completion fill irccontrols list match menu move-to-prompt netsplit networks noncommands notify readonly replace ring stamp track)))
 '(erc-timestamp-format-left "[%H:%M] ")
 '(erc-timestamp-format-right nil)
 '(grep-files-aliases
   (quote
    (("all" . "* .*")
     ("el" . "*.el")
     ("ch" . "*.[ch]")
     ("c" . "*.c")
     ("cc" . "*.cc *.cxx *.cpp *.C *.CC *.c++")
     ("cchh" . "*.cc *.[ch]xx *.[ch]pp *.[CHh] *.CC *.HH *.[ch]++")
     ("hh" . "*.hxx *.hpp *.[Hh] *.HH *.h++")
     ("h" . "*.h")
     ("l" . "[Cc]hange[Ll]og*")
     ("m" . "[Mm]akefile*")
     ("tex" . "*.tex")
     ("texi" . "*.texi")
     ("asm" . "*.[sS]")
     (backbone . "*.rb *.rake *.erb *.eco *.html *.coffee"))))
 '(hippie-expand-try-functions-list
   (quote
    (try-expand-all-abbrevs try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-lisp-symbol-partially try-complete-lisp-symbol try-expand-line)))
 '(ispell-program-name "/usr/local/bin/ispell")
 '(magit-restore-window-configuration t)
 '(magit-set-upstream-on-push (quote askifnotset))
 '(make-backup-files nil)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("marmalade" . "http://marmalade-repo.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/"))))
 '(ruby-deep-arglist nil)
 '(ruby-deep-indent-paren nil)
 '(ruby-deep-indent-paren-style nil)
 '(speedbar-update-flag t)
 '(speedbar-use-images nil)
 '(visible-bell nil)
 '(wg-mode-line-on nil)
 '(wg-morph-on nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#f2f1f0" :foreground "#404040" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 140 :width normal :foundry "nil" :family "Menlo"))))
 '(erc-keyword-face ((t (:foreground "cornflower blue" :weight bold))))
 '(erc-timestamp-face ((t (:foreground "gray56" :weight bold))))
 '(hl-line ((t (:background "#eee"))))
 '(magit-item-highlight ((t (:background "#222222"))))
 '(mode-line ((t (:background "khaki3" :foreground "#4c4c4c" :weight bold))))
 '(mode-line-buffer-id ((t (:background "khaki"))))
 '(show-paren-match ((t (:background "#006666")))))

(defun silent-bell () (interactive) (message "DING"))
(setq ring-bell-function 'silent-bell)

(set-face-attribute 'default nil :height 180)
(set-face-attribute 'default nil :foundry "apple" :family "Menlo")

(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)
(global-set-key (kbd "s-t") 'find-file-in-git-repo)

;;; (require 'color-theme-blackboard) (color-theme-blackboard)
;(require 'color-theme)
;;(require 'color-theme-blackboard)
;(require 'color-theme-solarized)
;(color-theme-solarized 'light)
(load-theme 'soft-morning)

;;(if (featurep 'ns-win) (ns-toggle-fullscreen))
(global-linum-mode 1)

(defun reset-window-to-zero ()
  "Set the window's frame position to 0,0"
  (interactive) (set-frame-position (selected-frame) 0 0 ))

(setq ruby-use-smie nil)
(server-start t t)

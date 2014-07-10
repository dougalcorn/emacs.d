(require 'highlight-indentation-current-column-mode)
(define-globalized-minor-mode global-highlight-indentation-current-column-mode
  highlight-indentation-current-column-mode highlight-indentation-current-column-mode)

(global-highlight-indentation-current-column-mode 1)

;;;(add-hook 'ruby-mode-hook 'robe-mode)

;;; /usr/local/Cellar/go/1.1.2/libexec/misc/emacs/go-mode.el

;; go mode
(setq load-path (cons "/usr/local/Cellar/go/1.1.2/libexec/misc/emacs" load-path))
(require 'go-mode-load)
(defun dka-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq tab-width 2))
(add-hook 'go-mode-hook 'dka-go-mode-hook)

(require 'ansi-color)

(defun ansi-colorize-current-buffer ()
  "Colorize ansi escape sequences in the current buffer."
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

(setq wg-prefix-key (kbd "C-c w"))
(workgroups-mode 1)

(eval-after-load "shell"
  '(define-key shell-mode-map (kbd "<up>") 'comint-previous-input))
(eval-after-load "shell"
  '(define-key shell-mode-map (kbd "<down>") 'comint-next-input))
(setq comint-process-echoes t)

(add-hook 'projectile-mode-hook 'projectile-rails-on)

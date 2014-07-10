;;; Environment variables

;; PATH/exec-path
;;(setq exec-path nil) (setenv "PATH" "")

(mapcar (lambda (dir)
          (setq exec-path (cons dir exec-path))
          (setenv "PATH" (concat dir ":" (getenv "PATH"))))
        (list "/usr/local/share/npm/bin"
              "/usr/local/bin"
              (concat (getenv "HOME") "/.rbenv/bin")
              (concat (getenv "HOME") "/.rbenv/shims")
              "/Applications/Emacs.app/Contents/MacOS/bin"))

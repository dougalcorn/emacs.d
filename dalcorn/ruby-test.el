;;; ruby-test.el --- Run individual ruby tests/specs in various ways

;; Copyright (C) 2011 Doug Alcorn

;; Author: Doug Alcorn
;; URL:
;; Version: 0.2
;; Created: 2011-03-29
;; Keywords: project, ruby, test, compile, rspec, rvm, rbenv

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This file allows you to run your project's tests in various
;; ways. It detects rspec, test-unit, and cucumber based on
;; filename. Runs the tests with compilation mode. This gives you the
;; benefit of re-compile and using compilation mode for syntax
;; highlighting and clickability.

;; There are other ways to do all this, but I'm trying to keep it as
;; simple as possible here for ease in maintenance.

;;; Todo:

;; - merge in support for rake? (or not)

(require 'which-func)
(require 'project-local-variables)
(require 'dirvars)
(require 'compile)

(defvar rspec-version 2 "Version of rspec to use as the spec runner. Version 1 requires the spec runner to be simply `spec'. Version 2 uses `rspec'.")
(defun ruby-is-spec() (string-match "_spec.rb$" buffer-file-name))
(defun ruby-is-test() (string-match "_test.rb$" buffer-file-name))
(defun ruby-is-cucumber() (string-match ".feature$" buffer-file-name))

(defun ruby-test-suite (&optional args)
  (interactive)
  (compile (ruby-rvm-compile "")))

(defun ruby-test-file (&optional args)
  "Run the entire file with the appropriate test runner"
  (interactive)
  (compile (ruby-rvm-compile (concat (buffer-file-name) args))))

(defun ruby-test-function(&optional args)
  "Try to determine the current context and just test that piece of this file"
  (interactive)
  (let* ((function-name (which-function))
         (func-spec
         (cond
          ((ruby-is-spec) (concat " --line " (number-to-string (line-number-at-pos))))
          ((ruby-is-cucumber) (concat ":" (number-to-string (line-number-at-pos))))
          (t (concat " --name \"/"
                     (or
                      ;; look for Class#method and just return the function name part
                      (and (string-match "#\\(.*\\)" function-name) (match-string 1 function-name))
                      ;; rely on which-function/imenu to find the test function name
                      function-name) "/\"")))))
    (compile (ruby-rvm-compile (concat (buffer-file-name) func-spec)))))

(defun ruby-run-spec(&optional args)
  "The actual compile command to run an individual rspec (either file or function)"
  (let ((ruby-compile-command (concat (buffer-file-name) args)))
    (compile (ruby-rvm-compile ruby-compile-command))))

(defun ruby-run-cucumber(&optional args)
  "The actual compile command to run an individual cucumber (either file or function)"
  (let ((ruby-compile-command (concat (buffer-file-name) args)))
    (compile (ruby-rvm-compile ruby-compile-command))))

(defun ruby-run-test(&optional args)
  "The actual compile command to run an individual rails test (either file or function)"
  (let ((ruby-compile-command (concat (buffer-file-name) args)))
    (compile (ruby-rvm-compile ruby-compile-command))))

(defun ruby-rvm-compile(command)
  (let* ((log-file (if (ruby-is-cucumber) "cucumber.log" "test.log"))
         (rm-log (if (file-exists-p (concat (ruby-test-project-root) "log/" log-file))
                     (concat "rm -f log/" log-file "; ")))
         (runner (cond
                  ((and (eq rspec-version 1) (ruby-is-spec)) "spec ")
                  ((ruby-is-test) "ruby -Itest")
                  ((ruby-is-cucumber) "cucumber --no-color ")
                  (t "rspec --no-color -Ispec ")))
         (local-bin (if (file-directory-p (concat (ruby-test-project-root) "bin")) "bin/"))
         (bundle (if (and (not local-bin)
                          (file-exists-p (concat (ruby-test-project-root) "Gemfile"))) "bundle exec "))
         (rvm (if (file-exists-p (concat (ruby-test-project-root) ".rbenv-version")) ""
                (if (file-exists-p (concat (ruby-test-project-root) ".rvmrc")) "source .rvmrc; "))))
  (concat "cd " (ruby-test-project-root) "; " rm-log rvm bundle local-bin runner command)))

(defun ruby-test-project-root()
  (file-name-directory (plv-find-project-file default-directory "")))

(provide 'ruby-test)

;;; This is probably bad form, but I've had problems with other
;;; libraries putting junk in the comopilation-* alists. Rather and
;;; add-to-list or try to smart manage it, I'm just blowing away what
;;; was there and setting it "correctly" for ruby. Unfortunately, this
;;; needs to be tweaked from time to fime as the various testing
;;; frameworks change the format of their back traces.

(setq compilation-error-regexp-alist
      '(("\\(\\([^ \n\t:\[]+[a-zA-Z]\\):\\([0-9]+\\)\\)" 2 3 nil 2 1)
;        ("\\[\\(\\([^:]+[a-zA-Z]\\):\\([0-9]+\\)\\)\\]:" 2 3 nil 2 1)
        ("\\(\\[/\\)?\\(\\([^:]+[a-zA-Z]\\):\\([0-9]+\\)\\)\\]:" 3 4 nil 2 1)
        ("\\(\\([^ \n\t:\[]+\\):\\([0-9]+\\)\\):*\\s *[wW]arning: " 2 3 nil 1 1)
        ("\\(config.gem: .*\\)" nil nil nil 1 nil)
        ))
(setq compilation-mode-font-lock-keywords
      '(("ruby -I\\(.*\\(test/[^)]+\\)\\)+" (2 font-lock-function-name-face))
        ("rspec -I\\(.*\\(spec/[^)]+\\)\\)+" (2 font-lock-function-name-face))
        ("\\(rake .*\\)" (1 font-lock-function-name-face))
        ("\\(<i>.*</i>\\)" (1 font-lock-comment-face))
        ("^\\(test[^\(]+\\)" (1 font-lock-function-name-face))
        ("^\\(test[^\(]+\\)(\\([^\)]+\\))" (2 font-lock-constant-face))
        ("^[.EF]*\\([EF]\\)[.EF]*\nFinished" (1 compilation-error-face))
        ("\\([1-9][0-9]* \\(failure\\|errors\\)\\)" (1 compilation-error-face))
        ("^[ \t]*\\(.*examples?, 0 failures\\)" (1 compilation-info-face))
        ("^[ \t]*\\(.*, 0 failures, 0 errors\\)" (1 compilation-info-face))))

;;; ruby-test.el ends here

;;; All this below here is to dynamically rename the *complation* buffer with each run
;;; I found this a little annoying and so have turned it off
(defun comp-mult-name (mjr-mode)
  "Suitable for assignment to compilation-buffer-name-function"
  (concat "*" (downcase mjr-mode)
          " " (file-name-nondirectory
               (substring (if (buffer-file-name)
                              (file-name-directory (buffer-file-name))
                            (expand-file-name default-directory))
                          0 -1)) "*"))

(setq
 ;; Usually compile the same way so don't ask unless I give prefix arg
 compilation-read-command nil
 compilation-buffer-name-function	nil)

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

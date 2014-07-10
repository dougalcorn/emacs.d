;; (require 'sr-speedbar)

;; (defun ad-advised-definition-p (function))


;; (defun nm-speedbar-expand-line-list (&optional arg)
;;   (when arg
;;     (message (car arg))
;;     (re-search-forward (concat " " (car arg) "$"))
;;     (speedbar-expand-line (car arg))
;;     (speedbar-next 1) ;; Move into the list.
;;     (nm-speedbar-expand-line-list (cdr arg))))

;; (defun nm-speedbar-open-current-buffer-in-tree ()
;;   (interactive)
;;   (let* ((root-dir (plv-project-root-dir))
;;          (original-buffer-file-directory (file-name-directory (buffer-file-name)))
;;          (relative-buffer-path (car (cdr (split-string original-buffer-file-directory root-dir))))
;;          (parents (butlast (split-string relative-buffer-path "/"))))
;;     (save-excursion
;;       (sr-speedbar-open) ;; <--- or whatever speedbar you have e.g. (speedbar 1)
;;       (set-buffer speedbar-buffer)
;;       (beginning-of-buffer)
;;       (nm-speedbar-expand-line-list parents))))

;; (defun dka-speedbar-expand-line-directory-decentents (&optional arg)
;;   "Expand the line under the cursor and all decendents that are directories.
;; Optional argument ARG indicates that any cache should be flushed."
;;   (interactive)
;;   (speedbar-expand-line arg)
;;   (save-excursion
;;     (speedbar-next 1)
;;     (let ((err nil))
;;       (while (not err)
;;         (condition-case nil
;;             (progn
;;               (if (file-directory-p (speedbar-line-file)) (dka-speedbar-expand-line-directory-decentents arg))
;;               (speedbar-restricted-next 1))
;;           (error (setq err t)))))))

;; (provide 'my-speedbar)

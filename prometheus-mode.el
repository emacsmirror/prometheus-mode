;;; prometheus-mode.el --- Major mode for viewing and editing Prometheus dump files

;; Copyright © 2023, by Peter Hoeg

;; Author: Peter Hoeg (peter@hoeg.com)
;; Version: 0.0.1
;; Created: 2023
;; Keywords: languages
;; Homepage: https://hoeg.com
;; Package-Requires: ((emacs "24.3"))

;; This file is not part of GNU Emacs.

;;; License:

;; You can redistribute this program and/or modify it under the terms of the GNU
;; General Public License version 2.

;;; Commentary:

;; Add support for Prometheus files in Emacs.

;;; Code:

(require 'imenu)
(require 'rx)

(defvar prometheus-mode-line-numbers 't "Enable line numbers by default.")

(defun prometheus-mode--build-imenu ()
  "Build imenu."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (setq imenu-generic-expression `((nil
                                      ,(if (re-search-forward (rx bol "#" (optional space) "HELP") nil 'noerror)
                                           (rx bol "#" (optional space) "HELP" space (group (one-or-more (any alnum blank punct))) eol)
                                         (rx bol "#" (optional space) "TYPE" space (group (one-or-more (any alnum blank punct))) eol))
                                      1))))
  (imenu--generic-function imenu-generic-expression))

;;;###autoload
(define-derived-mode prometheus-mode fundamental-mode "Prometheus"
  "Major mode for viewing Prometheus data files."

  (setq-local comment-start "#"
              comment-end ""
              font-lock-defaults `(((,(rx
                                       bol
                                       "#" (optional space) "HELP" space
                                       (one-or-more (any alphanumeric "_")) space
                                       (group (one-or-more (any alphanumeric blank punctuation)))
                                       eol) . (1 'font-lock-comment-face))
                                    (,(rx
                                       bol
                                       "#" (optional space) "TYPE" space
                                       (one-or-more (any alphanumeric "_")) space
                                       (group (or "counter" "gauge" "summary" "untyped"))
                                       (optional space)
                                       eol) .(1 'font-lock-type-face))
                                    (,(rx
                                       bol
                                       (optional
                                        "#" (optional space) (or "HELP" "TYPE") space)
                                       (group (one-or-more (any alphanumeric "_")))
                                       (or space "{")) . (1 'font-lock-keyword-face))
                                    (,(rx
                                       (or "{" ",")
                                       (group (one-or-more (any alphanumeric "_")))
                                       "=") . 'font-lock-variable-name-face)
                                    (,(rx (group (one-or-more (any digit ".")))) . 'font-lock-constant-face)
                                    (,(rx (or "HELP" "TYPE")) . 'font-lock-builtin-face)
                                    ))
              imenu-sort-function #'imenu--sort-by-name
              imenu-create-index-function #'prometheus-mode--build-imenu
              imenu-max-item-length nil)
  (add-hook 'prometheus-mode-hook
            (lambda ()
              (when prometheus-mode-line-numbers
                (display-line-numbers-mode))
              (read-only-mode))))

(provide 'prometheus-mode)

;; Local Variables:
;; coding: utf-8
;; End:

;;; prometheus-mode.el ends here

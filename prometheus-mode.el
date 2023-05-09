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

(require 'generic-x)

(defvar prometheus-mode-hook nil "Prometheus hooks.")

(defun prometheus-mode-h ()
  "Run hooks for Prometheus sub modes."
  (run-hooks 'prometheus-mode-hook))

(add-hook 'prometheus-mode-hook #'display-line-numbers-mode)
(add-hook 'prometheus-mode-hook (lambda ()
                                  (setq imenu-generic-expression `(
                                                                   ("Item" ,(rx bol "#" (optional space) "HELP" space (group (one-or-more ascii))) 1)
                                                                   ("Type" ,(rx bol "#" (optional space) "TYPE" space (group (one-or-more ascii))) 1)))))

(define-generic-mode 'prometheus-mode
  '()
  '()
  `((,(rx bol
          (optional
           "#" (optional space) (or "HELP" "TYPE") space)
          (group (one-or-more (any alphanumeric "_")))
          (or space "{")) . (1 'font-lock-keyword-face))
    ("[{,]\\([a-zA-Z]+\\)=" . 'font-lock-variable-name-face)
    ("[0-9]+" . 'font-lock-constant-face)
    (,(regexp-opt '("HELP" "TYPE") 'words) . 'font-lock-builtin-face)
    (,(regexp-opt '("counter" "gauge") 'words) . 'font-lock-type-face))
  nil
  '(prometheus-mode-h)
  "A mode for Prometheus files.")

(provide 'prometheus-mode)

;; Local Variables:
;; coding: utf-8
;; End:

;;; prometheus-mode.el ends here

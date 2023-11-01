;;; early-init.el --- Early initialisation configuration  -*- lexical-binding: t; -*-

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Configuration made here is loaded early in the initialisation
;; process before the package system and GUI are initialised. Don't
;; abuse this file; most configuration should be done in `init.el'.

;;; Code:

(defun nixp ()
  "Return t if emacs is installed with nix."
  (string-prefix-p "/nix/store/" invocation-directory))

;; Let nix manage elisp packages.
(when (nixp)
  (setq package-enable-at-startup nil))

(provide 'early-init)

;;; early-init.el ends here

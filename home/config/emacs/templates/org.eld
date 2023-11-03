org-mode

(title "#+title: ")
(author "#+author: ")
(date "#+date: ")

(el "#+begin_src emacs-lisp" n> r> n> "#+end_src" :post (org-edit-src-code))
(hs "#+begin_src haskell" n> r> n> "#+end_src" :post (org-edit-src-code))
(jl "#+begin_src julia" n> r> n> "#+end_src" :post (org-edit-src-code))
(py "#+begin_src python" n> r> n> "#+end_src" :post (org-edit-src-code))

(task "* TODO " p n q
      :post (progn
              (if (y-or-n-p "Set a scheduled date? ")
                  (call-interactively 'org-schedule))
              (if (y-or-n-p "Set a deadline? ")
                  (call-interactively 'org-deadline))))

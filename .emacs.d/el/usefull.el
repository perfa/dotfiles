(defun recenter-other-window ()
  "works like recenter-top-bottom but does it to the other window"
  (interactive)
  (let ((current-window (selected-window)))
    (other-window 1)
    (recenter-top-bottom)
    (select-window current-window)))

(defun recenter-proc (window)
  (if (eq current-window window)
      ()
    (select-window window)
    (recenter-top-bottom)))

(defun recenter-high-proc (window)
  (if (eq current-window window)
      ()
    (select-window window)
    (recenter 10)))

(defun recenter-all-other-window ()
  "works like recenter-top-bottom but does it to the other window"
  (interactive)
  (let ((current-window (selected-window)))
    (walk-windows 'recenter-proc)
    (select-window current-window)))

(defun recenter-high-all-other-window ()
  "works like recenter-top-bottom but does it to the other window"
  (interactive)
  (let ((current-window (selected-window)))
    (walk-windows 'recenter-high-proc)
    (select-window current-window)))

(defun temp-buff (name)
  "creates a new temporary buffer named \"name\" if none exists and switches to it"
  (interactive
   (list (read-buffer "Name of temp buffer: " "tmp")))
  (if (eq (get-buffer name) nil)
      (switch-to-buffer (get-buffer-create name))
    (message (concat "Buffer \"" name "\" already exists"))))

(defun my-list-tags (tag-reg-exp)
  "Lists all tags matching argument reg exp"
  (interactive
   (list (read-buffer "List tags matching reg exp: " (current-word))))
  (tags-apropos tag-reg-exp))


(provide 'usefull)

   
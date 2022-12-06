(define input
  (call-with-input-file "adv06.txt" read-line))

(define (different lst)
  (or (null? lst)
      (let ((x (car lst)))
        (and (not (any (lambda (y) (eq? x y)) (cdr lst)))
             (different (cdr lst))))))

(define (adv06 data len)
  (let loop ((i len))
    (if (different (string->list (substring data (- i len) i)))
        i
        (loop (+ i 1)))))

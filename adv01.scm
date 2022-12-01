(define input
  (call-with-input-file "adv01.txt"
    (lambda (f)
      (let loop ((acc '()))
        (let ((line (read-line f)))
          (cond ((eof-object? line) (list (reverse acc)))
                ((string=? line "") (cons (reverse acc) (loop '())))
                (else (loop (cons (string->number line) acc)))))))))

(define (adv01 data)
  (fold max 0 (map (lambda (l) (fold + 0 l)) data)))

(define (adv01b data)
  (fold + 0 (take (sort (map (lambda (l) (fold + 0 l)) data) >) 3)))

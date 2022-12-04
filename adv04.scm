(define input
  (call-with-input-file "adv04.txt"
    (lambda (f)
      (let loop ()
        (let ((line (read-line f)))
          (if (eof-object? line)
              '()
              (let ((split (map string->number (string-split line #[-,]))))
                (cons (cons (cons (car split) (cadr split))
                            (cons (caddr split) (cadddr split)))
                      (loop)))))))))

(define (contains? a b)
  (or (and (<= (car a) (car b))
           (>= (cdr a) (cdr b)))
      (and (<= (car b) (car a))
           (>= (cdr b) (cdr a)))))

(define (adv04 data)
  (count (lambda (pair)
           (contains? (car pair) (cdr pair)))
         data))

(define (overlaps? a b)
  (and (<= (car a) (cdr b))
       (>= (cdr a) (car b))))

(define (adv04b data)
  (count (lambda (pair)
           (overlaps? (car pair) (cdr pair)))
         data))

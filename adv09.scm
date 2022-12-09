(define input
  (call-with-input-file "adv09.txt"
    (lambda (f)
      (let loop ()
        (let ((dir (read f)))
          (if (eof-object? dir)
              '()
              (cons (cons dir (read f))
                    (loop))))))))

(define (delta cmd)
  (case (car cmd)
    ((U) (list 0 (cdr cmd)))
    ((D) (list 0 (- (cdr cmd))))
    ((L) (list (- (cdr cmd)) 0))
    ((R) (list (cdr cmd) 0))))

(define (step pos dir forward?)
  (map (lambda (x d)
         (cond ((< d 0) (if forward? (- x 1) (+ x 1)))
               ((> d 0) (if forward? (+ x 1) (- x 1)))
               (else x)))
       pos dir))

(define (move cmd state)
  (let* ((pos (car state))
         (visits (cdr state))
         (d (delta cmd))
         (n (- (vector-length pos) 1)))
    (letrec ((move-tail!
              (lambda (i)
                (let ((d (map - (vector-ref pos (- i 1)) (vector-ref pos i))))
                  (when (> (fold max 0 (map abs d)) 1)
                    (let ((newpos (step (vector-ref pos i) d #t)))
                      (vector-set! pos i newpos)
                      (when (and (= i n) (not (member newpos visits)))
                        (set! visits (cons newpos visits)))))))))
      (let loop ((d d))
        (if (equal? d '(0 0))
            (cons pos visits)
            (begin
              (vector-set! pos 0 (step (vector-ref pos 0) d #t))
              (for-each move-tail! (iota n 1))
              (loop (step d d #f))))))))

(define (tail-visits moves len)
  (cdr (fold move (cons (make-vector len '(0 0)) '((0 0))) moves)))

(define (adv09 data)
  (length (tail-visits data 2)))

(define (adv09b data)
  (length (tail-visits data 10)))

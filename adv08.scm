(define input
  (call-with-input-file "adv08.txt"
    (lambda (f)
      (let loop ((acc '()))
        (let ((line (read-line f)))
          (if (eof-object? line)
              (list->vector (reverse acc))
              (loop (cons (vector-map (lambda (c)
                                        (- (char->integer c)
                                           (char->integer #\0)))
                                      (string->vector line))
                          acc))))))))

;;; 2D grid support

(define (get grid x y)
  (vector-ref (vector-ref grid x) y))

(define (grid-size grid)
  (vector-length grid))

(define (iota2 n)
  (concatenate
   (map (lambda (x)
          (map (lambda (y) (cons x y)) (iota n)))
        (iota n))))

(define (grid-fold f op init grid)
  (fold (lambda (xy a)
          (op (f grid (car xy) (cdr xy)) a))
        init (iota2 (grid-size grid))))

;;; Interesting part

(define (hidden? grid x y)
  (let* ((n (grid-size grid))
         (h (get grid x y))
         (check (lambda (i j di dj)
                  (let loop ((i i) (j j))
                    (and (not (and (= i x) (= j y)))
                         (or (>= (get grid i j) h)
                             (loop (+ i di) (+ j dj))))))))
    (and (check 0 y 1 0) (check (- n 1) y -1 0)
         (check x 0 0 1) (check x (- n 1) 0 -1))))

(define (adv08 data)
  (grid-fold (lambda (g x y) (if (hidden? g x y) 0 1))
             + 0 data))

(define (scenic-score grid x y)
  (let* ((n (grid-size grid))
         (h (get grid x y))
         (score (lambda (di dj)
                  (let loop ((i (+ x di)) (j (+ y dj)))
                    (cond ((or (< i 0) (= i n) (< j 0) (= j n)) 0)
                          ((>= (get grid i j) h) 1)
                          (else (+ 1 (loop (+ i di) (+ j dj)))))))))
    (* (score 1 0) (score -1 0)
       (score 0 1) (score 0 -1))))

(define (adv08b data)
  (grid-fold scenic-score max 0 data))

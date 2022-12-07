(define input
  (call-with-input-file "adv07.txt"
    (lambda (f)
      (let loop ()
        (let ((line (read-line f)))
          (if (eof-object? line)
              '()
              (let ((s (string-split line " ")))
                (cons (cond ((#/^\$ cd/ line) (list 'cd (caddr s)))
                            ((#/^\$ ls/ line) '(ls))
                            ((#/^dir/ line) (list 'dir (cadr s)))
                            (else (list 'file (cadr s) (string->number (car s)))))
                      (loop)))))))))

(define (find-parent tree node)
  (and (list? tree)
       (if (memq node tree)
           tree
           (any (lambda (n)
                  (find-parent n node))
                (cdr tree)))))

(define (build-tree data)
  (let ((root (list "/")))
    (let loop ((data data) (pwd root))
      (if (null? data)
          root
          (let ((cmd (car data)))
            (case (car cmd)
              ((cd) (cond ((string=? (cadr cmd) "/")
                           (loop (cdr data) root))
                          ((string=? (cadr cmd) "..")
                           (loop (cdr data) (find-parent root pwd)))
                          (else
                           (set-cdr! pwd (cons (list (cadr cmd)) (cdr pwd)))
                           (loop (cdr data) (cadr pwd)))))
              ((ls) (loop (cdr data) pwd))
              ((dir) (loop (cdr data) pwd))
              ((file)
               (set-cdr! pwd (cons (caddr cmd) (cdr pwd)))
               (loop (cdr data) pwd))))))))

(define (size tree)
  (if (list? tree)
      (fold + 0 (map size (cdr tree)))
      tree))

(define (sum-sizes tree)
  (if (list? tree)
      (let ((s (size tree)))
        (+ (if (< s 100000) s 0)
           (fold + 0 (map sum-sizes (cdr tree)))))
      0))

(define (adv07 data)
  (let ((tree (build-tree data)))
    (sum-sizes tree)))

(define (minimal tree n)
  (and (list? tree)
       (let ((s (size tree)))
         (and (>= s n)
              (fold (lambda (a b) (if (and a (< a b)) a b))
                    s
                    (map (lambda (t) (minimal t n)) (cdr tree)))))))

(define (adv07b data)
  (let ((tree (build-tree data)))
    (minimal tree (- 30000000 (- 70000000 (size tree))))))

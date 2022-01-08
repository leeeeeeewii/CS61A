(define-macro (def func args body)
    `(define ,func (lambda ,args ,body))
)

(define (tail-replicate x n)
    (define (f x n res)
        (if (= n 0)
            res
            (f x (- n 1) (cons x res))
        )
    )
    (f x n nil)
)

(define (exp b n)
    (define (f b n res)
        (if (= n 0)
            res
            (f b (- n 1) (* b res))
        )
    )
    (f b n 1)
)

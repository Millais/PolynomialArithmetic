; --CM20221 Assignment 1--
; Patrick Millais: pm515
; Written in SBCL, a Common Lisp implementation.

; In this representation, polynomials are represented by a list of terms.
; Each term is represented as: (coeffecient xexponent yexponent zcomponent ...)
; e.g 3x^2 = (3 2), -2y^3 (-2 0 3), 4xz^2 = (4 1 0 2)
; Therefore, a list of terms is 2xy + x^2 + 3 = ((2 1 1) (1 2) (3))


;; gets the coeffecient of a term: (3 1) -> 3
(defun coeffecient (term)
	(car term))

;; gets the various variable's exponents in a term: (1 2 1) -> (2 1)
(defun varexp (term)
	(cdr term))

;; return 0, rather than nil, if the polynomial list passed in is nil.
(defun nilcheck (polys)
	(if (equal polys nil) '((0)) polys))

;; returns an empty list if the argument is 0
;; otherwise returns the value passed in.
(defun zerocheck (term)
	(if (equal (coeffecient term) 0) ()  term))

;; maps the zerocheck function to all terms in the argument
(defun removezeros (polys)
	(map 'list (lambda (x) (zerocheck x)) polys))

;; adds two polynomial lists together
(defun p+ (p1 p2)
	(collectterms (append p1 p2)))

;; subtracts the second polynomial list from the first polynomial list
(defun p- (p1 p2)
	(collectterms (append p1 (negateall p2))))

;; multiply the two polynomial lists together.
(defun p* (p1 p2)
	(collectterms (multiply p1 p2 ())))

;; add the two terms together: (4 1) (-2 1) -> (2 1)
(defun term+ (t1 t2)
	(cons (+ (coeffecient t1) (coeffecient t2)) (varexp t1)))

;; multiply the two terms together: (3 2) (2 2) -> (6 4)
(defun term* (t1 t2)
	(cons(* (car t1) (car t2)) (addexp (varexp t1) (varexp t2) ())))

;; add the lists e1 and e2 together such that: (1 0 2 1) (2 1) -> (3 1 2 1)
(defun addexp (e1 e2 result)
	(cond
		((and (equal nil (car e1))  (equal nil (car e2))) (reverse result))						;reverse the results list so exponents are returned in the correct order
		((equal nil (car e1)) (addexp (cdr e1) (cdr e2) (cons (car e2) result)))
		((equal nil (car e2)) (addexp (cdr e1) (cdr e2) (cons (car e1) result)))
		((addexp (cdr e1) (cdr e2) (cons(+ (car e1) (car e2)) result)))))

;; multiplies poly1 and poly2 together
;; e.g ((2 1) (2 1 1)) ((3 2) (1 0 1)) -> ((6 3) (6 3 1) (2 1 2) (2 1 1))
(defun multiply (poly1 poly2 results)
	(if (equal poly1 nil) 
			results
			(multiply (cdr poly1) poly2 
								(append (multiplylist (car poly1) poly2 ()) results))))

;; recursively multiplies a single term along a list of terms
(defun multiplylist (term oldlist returnlist)
	(if (equal oldlist nil) 
			returnlist
			(multiplylist term (cdr oldlist) 
										(cons (term* term (car oldlist)) returnlist))))

;; negates a term: (3 1 0) -> (-3 1 0)
(defun negate (term)
	(append (list (*(coeffecient term) -1)) (varexp term)))

;; maps the negate function to all terms in the argument
;; e.g ((3 2 0) (2 1 1)) -> ((-3 2 0) (-2 1 1))
(defun negateall (poly)
	(map 'list (lambda (x) (negate x)) poly))

;; collects like terms
;; then formats the list correctly to remove unnecessary 0s and nils
(defun collectterms (polys)
	(nilcheck(remove nil (removezeros (collect (cdr polys) (list(car polys)))))))

;; collects like terms via recursion
;; e.g ((1 2) (2 3) (2 2)) -> ((3 2) (2 3))
(defun collect (oldPolys newPolys)
	(cond((equal oldPolys nil) newPolys)   														;base case: when oldPolys is nil, return newPolys
		((equal (varexp(car oldPolys)) (varexp(car newPolys)))
			(collect (cdr oldPolys)
							 (cons(term+ (car oldPolys) (car newPolys)) (cdr newPolys))))
		((NOT (equal (varexp(car oldPolys)) (varexp(car newPolys)))) 							;if coeffecient of first items in each list aren't equal
			(collect (cdr oldPolys) (newlist (car oldPolys) newPolys ()))))) 					;recurse with reduced oldPolys and the term positioned correctly in newPolys

;; adds the term in the correct position of the list
;; e.g term: (1 3) list: ((2 1) (2 3)) -> ((2 1) (3 3))
;; e.g term: (1 3) list: ((2 1) (2 4)) -> ((2 1) (2 4) (1 3))
(defun newlist (term oldlist returnlist)
	(cond ((equal oldlist nil) (cons term returnlist)) 											;base case: when oldlist is nil, return returnlist
		((equal (varexp term) (varexp(car oldList))) 																	
			(append returnlist(cons(term+ term (car oldlist)) (cdr oldlist)))) 					
		((NOT(equal (varexp term) (varexp(car oldList))))
			(newlist term (cdr oldlist) (cons (car oldlist) returnlist )))))					;cons first term of oldlist to returnlist and recurse

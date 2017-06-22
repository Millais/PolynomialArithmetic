## Polynomial Arithmetic using Common Lisp

An assignment to determine a representation for polynomials, and to implement simple polynomial arithmetic using this representation (as part of [CM20214](http://www.bath.ac.uk/catalogues/2014-2015/cm/CM20214.html): *Advanced Programming Principles*).

This assignment came with three requirements:
* Implement the three polynomial arithmetic operations: + - and \*. These must be named p+, p- and p*.
* Expand and collect together like terms. For example: summing (x+y, x) must return 2x + y, rather than x + y + x.
* p+, p- and p* must be functions that take two polynomial arguments, and return a polynomial in the chosen representation. For example: 
  * p1: x + y + 1
  * p2: 2xy + x + z
  * (p+ p1 p2): 2xy + 2x + y + z + 1
  * (p- (p+ p1 p2) p2): x + y + 1
  
This coursework also required pure functional programming: no side-effects, no assignments, and referential transparency.


### Representation 

Polynomials are represented by a list of terms adhering to the following specification:
> (coefficient xexp yexp zexp ... )

Some examples:
> 2xy<sup>2</sup> = (2 1 2)

> 7xz<sup>2</sup> = (7 1 0 2)

> 3xy<sup>5</sup>a<sup>2</sup> = (3 1 5 0 2)

> xyz = (1 1 1 1)

See the pdf for further explanation, examples, and test cases.

### Running 

###### Simple Example
(2x + y + z) + (3x + 5y - z) 

**=** (5x + 6y)

> (p+’((2 1) (1 0 1) (1 0 0 1)) ‘((3 1) (5 0 1) (-1 0 0 1)))

> \> ((5 1) (6 0 1))

###### Complex Example
((3x<sup>2</sup> + 2yz<sup>2</sup>) * (20y -x<sup>2</sup>)) * (3y +4x)

**=** -12x<sup>5</sup> +240x<sup>3</sup>y - 8x<sup>3</sup>yz<sup>2</sup> + 160xy<sup>2</sup>z<sup>2</sup> - 9x<sup>4</sup>y + 180x<sup>2</sup>y<sup>2</sup> - 6x<sup>2</sup>y<sup>2</sup>z<sup>2</sup> + 120y<sup>3</sup>z<sup>2</sup>

> (p*(p* ‘((3 2) (2 0 1 2)) ‘((20 0 1) (-1 2))) ‘((3 0 1) (4 1)))

> \> ((-12 5) (240 3 1) (-8 3 1 2) (160 1 2 2) (-9 4 1) (180 2 2) (-6 2 2 2) (120 0 3 2))

___

Graded as a strong first.

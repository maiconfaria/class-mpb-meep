;;Example of MPB input file for calculating modes for a range of 1D Slab's widths. 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Some constants
(define pi 3.14159)
(define pi2 (* 2 pi))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First, we shall define some parameters describing our structure in (um).
(define-param n-Si 3.473)
(define-param n-SiO2 1.444)
(define Si (make dielectric (index n-Si)))    ; the waveguide dielectric constant
(define SiO2 (make dielectric (index n-SiO2)))  ; the surrounding low-dielectric material
(define-param W 0.350)                         ; the thickness of the waveguide (um)
(define-param l 1.550)                         ; light wavelength in vacuum (um)
(define-param omega (/ 1 l))                   ; frequency corresponding to 1.55um
(define-param LY 22)  ; the size of the computational cell in the y direction
; the computational cell size must be bigger than the wavelenght and the guide width

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Define the structure and the computational cell
; Here we define the size of the computational cell. Since it is 2d,
; it has no-size in the z direction. Because it is a waveguide in the
; x direction, then the eigenproblem at a given k has no-size in the
; x direction as well.

(set! geometry-lattice (make lattice (size no-size LY no-size)))
; the default-material is what fills space where we haven't placed objects
(set! default-material SiO2)
; a list of geometric objects to create structures in our computational cell:

(set! geometry
(list (make block                                   ; a dielectric block (a rectangle)
(center 0 0 0)                                      ; centered at origin
(size infinity W infinity)                          ; block is finite only in y direction
(material Si))))

;; You should make the resolution fine enough so that the pixels
;; are much smaller than the minor structure's size dimension and 
;; and also smaller than the wavelenght. 
(set-param! resolution 32)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Output bands at omega in a beta hint range. In this unit system c=1.
(define beta-min  (* omega 1.2 ))
(define beta-max (* omega n-Si ))
(define beta-guess (/ (+ beta-min beta-max) 2) )
 
; Looks for beta given a omega( light frequency) using newton-method search with a tolerance of 1e-4
(find-k NO-PARITY omega 1 4 (vector3 1) 1e-4            ; k stands for beta propagation constant
	beta-guess beta-min beta-max output-dpwr)       ; output, for instance, the time-averaged electric-field energy density (a.u) 


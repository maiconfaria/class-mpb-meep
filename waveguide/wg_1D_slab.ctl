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
(define-param W 0.220)                         ; the thickness of the waveguide (um)
(define-param l 1.550)                         ; light wavelength in vacuum (um)
(define-param omega (/ 1 l))                   ; frequency corresponding to 1.55um
(define-param LY (* l 20))  ; the size of the computational cell in the y direction
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
(set-param! resolution 64)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; However, suppose we now want to get the *fields* at a given k. To do this,
; we'll call the run function again, this time giving it an option to output the modes.

;; (set! k-points (list (vector3 k 0 0))) ; compute only a single k now
;; ; output-efield-z does just what it says. There are also options
;; ; to output any other field component we care to examine.
;; (run-te output-efield-z)


; Output the x component of the Poynting vector for num-bands bands at omega
(define beta-min  (* omega n-SiO2 ))
(define beta-max (* omega n-Si ))
(define beta-guess (/ (+ beta-min beta-max) 2) )

(find-k NO-PARITY omega 1 num-bands (vector3 1) 1e-4            ; k stands for beta propagation constant
	beta-guess beta-min beta-max)



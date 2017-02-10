;;Example of MPB input file for calculating modes for a range of 1D Slab's widths. 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Some constants
(define pi 3.14159)
(define pi2 (* 2 pi))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First, we shall define some parameters describing our structure in (um). 
;; (define-param eps-hi 12.061729)             ; the waveguide dielectric constant
;; (define-param eps-lo 2.085136)              ; the surrounding low-dielectric material
(define Si (make dielectric (index 3.473)))
(define SiO2 (make dielectric (index 1.444)))
(define-param W 0.220)                    ; the thickness of the waveguide (um)
(define-param l 1.550)                  ; light wavelength in vacuum (um)

(define-param LY 40)  ; the size of the computational cell in the y direction
; the computational cell size must be bigger than the wavelenght and the guide width
(define k (/ pi2 l))    ; wavenumber k 

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

;; MPB discretizes space with a given resolution.
;; Here, we set
;; a resolution of 32 pixels per unit distance. Thus, with LY=10
;; our comptuational cell will be 320 pixels wide. 
;; You should make the resolution fine enough so that the pixels
;; are much smaller than the minor structure's size dimension and 
;; and also smaller than the wavelenght. 

(set-param! resolution 128)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; k-points is the list of k (beta) values that MPB computes eigenmodes at.
; (vector3 x y z) specifies a vector. 
(set! k-points (list (vector3 k 0 0) ) )
; we also need to specify how many eigenmodes we want to compute, given
; by "num-bands":
(set-param! num-bands 4)
; It is better compute only one symmetry of mode each time.
; We calculate TM (E in z direction) modes,
; and separately compute even and odd modes with respect to the
; y=0 mirror symmetry plane.
;; (display-group-velocities)
(run-te-yeven)
(run-te-yodd)
; (If we don't have y=0 mirror symmetry we should just use run-tm).


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; However, suppose we now want to get the *fields* at a given k. To do this,
; we'll call the run function again, this time giving it an option to output the modes.

;; (set! k-points (list (vector3 k 0 0))) ; compute only a single k now
;; ; output-efield-z does just what it says. There are also options
;; ; to output any other field component we care to examine.
;; (run-te output-efield-z)




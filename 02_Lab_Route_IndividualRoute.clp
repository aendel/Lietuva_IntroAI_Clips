(deftemplate fragment  (slot from_street_name) (slot to_street_name))
(deftemplate car (slot location))
(deftemplate obstacles (slot location) (slot tlights) (slot cars)
                                      (slot pedestrians) (slot spec_service))

(deffacts init-facts
  (fragment (from_street_name "Via Pacinotti,147") (to_street_name "Piazza S.Vito Martire,2"))
  (fragment (from_street_name "Piazza S.Vito Martire,2") (to_street_name "Via Principe di Piemonte,3"))
  (fragment (from_street_name "Via Principe di Piemonte,3") (to_street_name "Via Marsala,2"))
  (fragment (from_street_name "Via Marsala,2") (to_street_name "SP5i,1"))
  (fragment (from_street_name "SP5i,1") (to_street_name "Via Pitrè,6"))
  (fragment (from_street_name "Via Pitrè,6") (to_street_name "Via Palermo,142"))
  (fragment (from_street_name "Via Palermo,142") (to_street_name "Via Palermo,46"))
  (fragment (from_street_name "Via Palermo,46") (to_street_name "Via Pacinotti,228"))
  (car(location nil))
)

(defrule r0 "When your location is 'nil' you start from your home."
  ?p <- (car (location nil))
  =>
  (modify ?p (location "Via Pacinotti,147"))
)

(defrule r1 "GO until the end"
  ?car <- (car (location ?location))
  ?to <- (fragment (from_street_name ?location) (to_street_name ?unknown))
  =>
  (modify ?car (location ?unknown))
)

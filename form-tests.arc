; Examples of various forms, including file uploads.
;
; To run:
;   arc> (load "form-tests.arc")
;   arc> (asv)
;   ready to serve port 8080
;
; Now test at http://localhost:8080/form-tests.
(def form-action (req)
  (prn "<br><br>x: " (arg req "x"))
  (tag hr)
  (tag h3
    (prn "properties"))
  (each (k v) (alref req!args "name")
    (if (~iso k "contents")
      (prn k ": " v)))
  (tag pre
    (prn:arg req "name")))

(defop form_target req
  (form-action req))

(defop form-tests req
  (tag h2
    (prn "various form tests"))

  (tag h3
    (prn "fnid form (not multipart)"))
  (aform form-action
    (prn 'x)
    (gentag input name 'x)
    (br)
    (submit "submit"))

  (tag h3
    (prn "fnid multipart form"))
  (aform-multi form-action
    (gentag input type 'file name 'name)
    (br)
    (prn 'x)
    (gentag input name 'x)
    (br)
    (submit "submit"))

  (tag h3
    (prn "static multipart form"))
  (form-multi "form_target"
    (gentag input type 'file name 'name)
    (br)
    (submit "submit")))

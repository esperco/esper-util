let base64url_decode s =
  try
    Cryptokit.(transform_string
                 (Base64.decode ())
                 (String.map
                    (function
                      | '-' -> '+'
                      | '_' -> '/'
                      | c    -> c)
                    s)
    )
  with Cryptokit.Error Cryptokit.Bad_encoding ->
    invalid_arg ("base64url_decode: " ^ s)

let base64url_encode s =
  String.map
    (function
      | '+' -> '-'
      | '/' -> '_'
      | c   -> c)
    (Cryptokit.(transform_string (Base64.encode_compact ()) s))

let base64compact_pad_encode s =
  Cryptokit.(transform_string (Base64.encode_compact_pad ()) s)

let base64_encode s =
  Cryptokit.(transform_string (Base64.encode_multiline ()) s)

let base64_decode s =
  Cryptokit.(transform_string (Base64.decode ()) s)

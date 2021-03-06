(*
  Conversion from/to RFC-3339 compatible date of the form YYYY-MM-DD.
*)
type t = private {
  year : int;
  month : int;
  day : int;
  string : string;
}

val create : year:int -> month:int -> day:int -> t

val compare : t -> t -> int
val now : unit -> t
val is_past : t -> bool
val is_future : t -> bool

val of_float : float -> t
val to_float : t -> float

val day_of_the_week : t -> int
  (* Return the day of the week, as an int ranging from 0 (Sunday)
     to 6 (Saturday). *)

val add : t -> int -> t
val sub : t -> int -> t
  (* Add or subtract a number of days *)

val next_day : t -> t
val previous_day : t -> t

val of_string : string -> t
val of_string_opt : string -> t option
val to_string : t -> string

val wrap : string -> t
val unwrap : t -> string

val format : fmt:string -> t -> string
  (* Format a time using Netdate.format. See documentation at URL below.
     http://projects.camlcity.org\
       /projects/dl/ocamlnet-3.2/doc/html-main/Netdate.html
  *)

val tests : (string * (unit -> bool)) list

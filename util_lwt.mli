(* Bind to 2 threads running concurrently *)
val bind2 : 'a Lwt.t -> 'b Lwt.t -> ('a -> 'b -> 'c Lwt.t) -> 'c Lwt.t

(* Bind to 3 threads running concurrently *)
val bind3 :
  'a Lwt.t ->
  'b Lwt.t -> 'c Lwt.t -> ('a -> 'b -> 'c -> 'd Lwt.t) -> 'd Lwt.t

(* Bind to 4 threads running concurrently *)
val bind4 :
  'a Lwt.t ->
  'b Lwt.t ->
  'c Lwt.t -> 'd Lwt.t -> ('a -> 'b -> 'c -> 'd -> 'e Lwt.t) -> 'e Lwt.t

(* Bind to 5 threads running concurrently *)
val bind5 :
  'a Lwt.t ->
  'b Lwt.t ->
  'c Lwt.t ->
  'd Lwt.t ->
  'e Lwt.t -> ('a -> 'b -> 'c -> 'd -> 'e -> 'f Lwt.t) -> 'f Lwt.t

(* Bind to 6 threads running concurrently *)
val bind6 :
  'a Lwt.t ->
  'b Lwt.t ->
  'c Lwt.t ->
  'd Lwt.t ->
  'e Lwt.t ->
  'f Lwt.t -> ('a -> 'b -> 'c -> 'd -> 'e -> 'f -> 'g Lwt.t) -> 'g Lwt.t

(* Combine the result of 2 threads running concurrently into a tuple *)
val join2 : 'a Lwt.t -> 'b Lwt.t -> ('a * 'b) Lwt.t

(* Combine the result of 3 threads running concurrently into a tuple *)
val join3 : 'a Lwt.t -> 'b Lwt.t -> 'c Lwt.t -> ('a * 'b * 'c) Lwt.t

(* Combine the result of 4 threads running concurrently into a tuple *)
val join4 :
  'a Lwt.t -> 'b Lwt.t -> 'c Lwt.t -> 'd Lwt.t -> ('a * 'b * 'c * 'd) Lwt.t

(* Combine the result of 5 threads running concurrently into a tuple *)
val join5 :
  'a Lwt.t ->
  'b Lwt.t ->
  'c Lwt.t -> 'd Lwt.t -> 'e Lwt.t -> ('a * 'b * 'c * 'd * 'e) Lwt.t

(* true iff at least one input evaluates to true *)
val or_ : bool Lwt.t list -> bool Lwt.t

(* true iff all inputs evaluate to true *)
val and_ : bool Lwt.t list -> bool Lwt.t

(* Map elements of a list from left to right until a match is found *)
val find_map_left : 'a list -> ('a -> 'b option Lwt.t) -> 'b option Lwt.t

(* Map elements of a list from right to left until a match is found *)
val find_map_right : 'a list -> ('a -> 'b option Lwt.t) -> 'b option Lwt.t

val map_default : 'b -> 'a option -> ('a -> 'b Lwt.t) -> 'b Lwt.t

(* Repeat for n times *)
val repeat : int -> (int -> unit Lwt.t) -> unit Lwt.t

val iter_stream : int -> 'a Lwt_stream.t -> ('a -> unit Lwt.t) -> unit Lwt.t
(*
   Parallel iteration over a stream.
   At most chunk_size (first parameter) items are processed at the same time.

   See also Util_conc.iter_stream, which returns the element out of order,
   but is faster if some items take longer to process than others.
*)

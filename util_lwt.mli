(*
   Utilities complementing lwt
*)

(* Simple conditional without having to write 'else return ()' *)
val do_if : bool -> (unit -> unit Lwt.t) -> unit Lwt.t

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
  'c Lwt.t ->
  'd Lwt.t ->
  'e Lwt.t -> ('a * 'b * 'c * 'd * 'e) Lwt.t

(* Combine the result of 5 threads running concurrently into a tuple *)
val join6 :
  'a Lwt.t ->
  'b Lwt.t ->
  'c Lwt.t ->
  'd Lwt.t ->
  'e Lwt.t ->
  'f Lwt.t -> ('a * 'b * 'c * 'd * 'e * 'f) Lwt.t

(* true iff at least one input evaluates to true *)
val or_ : bool Lwt.t list -> bool Lwt.t

(* true iff all inputs evaluate to true *)
val and_ : bool Lwt.t list -> bool Lwt.t

(* Map elements of a list from left to right until a match is found *)
val find_map_left : 'a list -> ('a -> 'b option Lwt.t) -> 'b option Lwt.t

(* Map elements of a list from right to left until a match is found *)
val find_map_right : 'a list -> ('a -> 'b option Lwt.t) -> 'b option Lwt.t

val map_default : 'b -> 'a option -> ('a -> 'b Lwt.t) -> 'b Lwt.t
val option_map : 'a option -> ('a -> 'b Lwt.t) -> 'b option Lwt.t

val with_retries :
  float list ->
  (int -> 'a option Lwt.t) ->
  (int * 'a) option Lwt.t
  (* [with_retries delays f] executes [f i] where [i] is the
     zero-based attempt number. If [f] returns [None],
     it sleeps and retries later. The amount of sleep between each
     attempt is specified by [delays].
     Returns the result of [f] if any and the number of retries
     performed. 0 is returned if [f] is successful the first time.
  *)

val repeat_s : int -> (unit -> 'a Lwt.t) -> 'a Lwt.t
  (* Repeat the same job sequentially a number of times and return
     the result of the last iteration. *)

val repeat_p : int -> (unit -> 'a Lwt.t) -> 'a Lwt.t
  (* Run the same job in parallel a number of times and return
     the result of one of the jobs. *)

val infinite_loop : (unit -> unit Lwt.t) -> 'a Lwt.t
  (* Infinite loop that doesn't introduce a memory leak. *)

val with_timeout : float -> (unit -> 'a Lwt.t) -> 'a option Lwt.t
  (* Create a job and cancel it if it doesn't finish within
     the specified time (timeout in seconds). *)

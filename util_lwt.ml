open Lwt

let do_if bool f =
  if bool then f ()
  else return ()

let bind2 a b func =
  a >>= fun a' ->
  b >>= fun b' ->
  func a' b'

let bind3 a b c func =
  a >>= fun a' ->
  b >>= fun b' ->
  c >>= fun c' ->
  func a' b' c'

let bind4 a b c d func =
  a >>= fun a' ->
  b >>= fun b' ->
  c >>= fun c' ->
  d >>= fun d' ->
  func a' b' c' d'

let bind5 a b c d e func =
  a >>= fun a' ->
  b >>= fun b' ->
  c >>= fun c' ->
  d >>= fun d' ->
  e >>= fun e' ->
  func a' b' c' d' e'

let bind6 a b c d e f func =
  a >>= fun a' ->
  b >>= fun b' ->
  c >>= fun c' ->
  d >>= fun d' ->
  e >>= fun e' ->
  f >>= fun f' ->
  func a' b' c' d' e' f'

let join2 a b =
  bind2 a b (fun a b -> return (a, b))

let join3 a b c =
  bind3 a b c (fun a b c -> return (a, b, c))

let join4 a b c d =
  bind4 a b c d (fun a b c d -> return (a, b, c, d))

let join5 a b c d e =
  bind5 a b c d e (fun a b c d e -> return (a, b, c, d, e))

let join6 a b c d e f =
  bind6 a b c d e f (fun a b c d e f -> return (a, b, c, d, e, f))

let or_ l =
  Lwt_list.exists_p (fun x -> x) l

let and_ l =
  Lwt_list.for_all_p (fun x -> x) l

let rec find_map_left l f =
  match l with
  | [] -> return None
  | x :: tl ->
      f x >>= function
      | None -> find_map_left tl f
      | Some y as result -> return result

let find_map_right l f =
  find_map_left (List.rev l) f

let map_default default opt f =
  match opt with
  | None -> return default
  | Some x -> f x

let option_map opt f =
  match opt with
  | None -> return None
  | Some x -> f x >>= fun y -> return (Some y)

let gethostbyname hostname =
  catch
    (fun () ->
       Lwt_unix.gethostbyname hostname
    )
    (fun e ->
       match Trax.unwrap e with
       | Not_found ->
           failwith ("Cannot resolve host " ^ hostname)
       | e ->
           Trax.raise __LOC__ e
    )

let with_retries delays f =
  let rec loop i delays =
    f i >>= function
    | None ->
        (match delays with
         | delay :: delays ->
             Lwt_unix.sleep delay >>= fun () ->
             loop (i+1) delays
         | [] ->
             return None
        )
    | Some result -> return (Some (i, result))
  in
  loop 0 delays

let rec repeat_s n f =
  if n <= 0 then
    invalid_arg "repeat"
  else
    f () >>= fun result ->
    if n = 1 then
      return result
    else
      repeat_s (n-1) f

let rec repeat_p n f =
  if n <= 0 then
    invalid_arg "repeat"
  else
    let l = BatList.init n (fun _ -> ()) in
    Lwt_list.map_p f l >>= function
    | result :: _ -> return result
    | [] -> assert false

let rec infinite_loop f =
  (* Do not use the (>>=) operator because it is expanded by Trax
     into something that produces a call trace, resulting
     in a useless giant trace growing with each recursive call. *)
  Lwt.bind (f ()) (fun () -> infinite_loop f)

let with_timeout timeout f =
  let job =
    f () >>= fun x ->
    return (Some x)
  in
  let sleep =
    Lwt_unix.sleep timeout >>= fun () ->
    return None
  in
  (* Cancel the thread that doesn't finish first *)
  Lwt.pick [ sleep; job ]

open Async.Std

module Deferred_intf = Async_kernel.Deferred_intf
module Deferred = Deferred

let return = return
let (>>=) = (>>=)
let (>>|) = (>>|)
let (>>=?) = (>>=?)
let (>>|?) = (>>|?)
let fail = raise
let raise = `Use_fail_instead

module Pipe = struct
  include Pipe

  let read r = read r

  let junk r =
    read r >>= function
    | `Ok _ | `Eof -> Deferred.unit

  (* Author: Stephen Weeks. See here:
     https://groups.google.com/forum/#!topic/ocaml-core/6vskwLlFnS0 *)
  let rec peek_deferred r =
    match peek r with
    | Some x -> return (`Ok x)
    | None ->
      values_available r
      >>= function
      | `Eof -> return `Eof
      | `Ok -> peek_deferred r

  let map = map
  let fold r ~init ~f = fold r ~init ~f
  let iter r ~f = iter r ~f
end

module Reader = struct
  include Reader
  let open_file ?buf_len file = open_file ?buf_len file
  let with_file ?buf_len file ~f = with_file ?buf_len file ~f
end

module Writer = struct
  include Writer
  let with_file ?perm ?append file ~f = with_file ?perm ?append file ~f
  let write t x = write t x; Deferred.unit
  let write_char t x = write_char t x; Deferred.unit
  let write_line t x = write_line t x; Deferred.unit
end

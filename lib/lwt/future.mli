open Core.Std
open Lwt

include Future_unix.Std.FUTURE
  with type 'a Deferred.t = 'a Lwt.t
  and type 'a Pipe.Reader.t = 'a Lwt_stream.t
  and type Reader.t = Lwt_io.input_channel
  and type Writer.t = Lwt_io.output_channel

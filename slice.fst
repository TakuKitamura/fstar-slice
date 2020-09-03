module Slice

open LowStar.BufferOps
open FStar.HyperStack.ST
open LowStar.Printf

module B = LowStar.Buffer
module U32 = FStar.UInt32

// #set-options "--z3rlimit 1000 --max_fuel 0 --max_ifuel 0 --detail_errors"

noeq type struct_slice = {
  sliced: B.buffer U32.t;
  sliced_length: U32.t;
}

val slice_logic: 
  original: B.buffer U32.t ->
  original_length: U32.t ->
  sliced: B.buffer U32.t ->
  sliced_length: U32.t ->
  from: U32.t ->
  to: U32.t ->
  Stack (struct_slice) (requires fun h0 -> 
    B.live h0 original /\
    B.live h0 sliced /\
    B.length original = U32.v original_length /\
    B.length sliced = U32.v sliced_length 
  )
  (ensures fun _ r h1 -> 
  B.length r.sliced = U32.v r.sliced_length /\ 
  (if (from = to) then U32.v sliced_length = U32.v r.sliced_length else true) /\
  B.live h1 r.sliced
  )
let rec slice_logic original original_length sliced sliced_length from to =
  if U32.(
      from <^ original_length && // original.(from)
      to >=^ sliced_length && // to -^ sliced_length >= 0
      from >=^ to -^ sliced_length && // fixed_first_from
      to >^ from // sliced.(sliced_index)
    ) then
    ( 
      let original_el: U32.t = original.(from) in
      let fixed_first_from = U32.(to -^ sliced_length) in
      let sliced_index: U32.t = U32.(from -^ fixed_first_from) in
      sliced.(sliced_index) <- original_el;
      let next_from_index: U32.t = U32.(from +^ 1ul) in
      slice_logic original original_length sliced sliced_length next_from_index to 
    )
  else if (from = to) then
    {
      sliced = sliced;
      sliced_length = sliced_length;
    }
  else
    {
      sliced = B.null;
      sliced_length = 0ul;
    }

val slice:
  original: B.buffer U32.t ->
  original_length: U32.t ->
  from: U32.t ->
  to : U32.t ->
  Stack (struct_slice) (requires fun h0 -> 
    B.live h0 original /\
    B.length original = U32.v original_length
  )
  (ensures fun h0 r h1 -> B.length r.sliced = U32.v r.sliced_length)
let slice original original_length from to =
  let sliced_length: U32.t = if U32.(from <^ to) then U32.(to -^ from) else 0ul in
  if (sliced_length = 0ul) then
      {
        sliced = B.null;
        sliced_length = sliced_length;
      }
  else
    (
      push_frame ();
      let sliced: B.buffer U32.t = B.alloca 0ul sliced_length in
      let sliced_struct: struct_slice = 
        slice_logic original original_length sliced sliced_length from to in
      pop_frame ();
      sliced_struct
    )

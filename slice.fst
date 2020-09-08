module Slice

open LowStar.BufferOps
open FStar.HyperStack.ST
open LowStar.Printf

module B = LowStar.Buffer
module U32 = FStar.UInt32

val slice_logic: 
  original: B.buffer U32.t ->
  original_length: U32.t ->
  sliced: B.buffer U32.t ->
  sliced_length: U32.t ->
  from: U32.t ->
  to: U32.t ->
  Stack (sliced_length: unit) (requires fun h0 -> 
    B.live h0 original /\
    B.live h0 sliced /\
    B.length original = U32.v original_length /\ 
    B.length sliced = U32.v original_length 
  )
  (ensures fun _ _ _ -> true)
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
  else
    ()

val slice:
  original: B.buffer U32.t ->
  original_length: U32.t ->
  sliced: B.buffer U32.t ->
  from: U32.t ->
  to : U32.t ->
  Stack (sliced_length: U32.t) (requires fun h0 -> 
    B.live h0 original /\
    B.live h0 sliced /\
    B.length original = U32.v original_length /\
    B.length sliced = U32.v original_length
  )
  (ensures fun h0 sliced_length h1 -> 
    U32.v sliced_length <= B.length sliced /\
    B.live h1 sliced
  )
let slice original original_length sliced from to =
  let sliced_length: U32.t = if U32.(from <^ to) then U32.(to -^ from) else 0ul in 
    slice_logic original original_length sliced sliced_length from to;
  if (U32.(sliced_length <=^ original_length)) then
    sliced_length
  else
    0ul
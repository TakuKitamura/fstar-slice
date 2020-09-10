module Slice

open LowStar.BufferOps
open FStar.HyperStack.ST
open LowStar.Printf

module B = LowStar.Buffer
module U32 = FStar.UInt32

val slice_logic: 
  array: B.buffer U32.t ->
  array_length: U32.t ->
  sliced: B.buffer U32.t ->
  sliced_length: U32.t ->
  start: U32.t ->
  stop: U32.t ->
  Stack (sliced_length: unit) (requires fun h0 -> 
    B.live h0 array /\
    B.live h0 sliced /\
    B.length array = U32.v array_length /\ 
    B.length sliced = U32.v array_length 
  )
  (ensures fun _ _ _ -> true)
let rec slice_logic array array_length sliced sliced_length start stop =
  if U32.(
      start <^ array_length && // array.(start)
      stop >=^ sliced_length && // stop -^ sliced_length >= 0
      start >=^ stop -^ sliced_length && // fixed_first_start
      stop >^ start // sliced.(sliced_index)
    ) then
    ( 
      let array_el: U32.t = array.(start) in
      let fixed_first_start = U32.(stop -^ sliced_length) in
      let sliced_index: U32.t = U32.(start -^ fixed_first_start) in
      sliced.(sliced_index) <- array_el;
      let next_start_index: U32.t = U32.(start +^ 1ul) in
      slice_logic array array_length sliced sliced_length next_start_index stop 
    )
  else
    ()

val slice:
  array: B.buffer U32.t ->
  array_length: U32.t ->
  sliced: B.buffer U32.t ->
  start: U32.t ->
  stop : U32.t ->
  Stack (sliced_length: U32.t) (requires fun h0 -> 
    B.live h0 array /\
    B.live h0 sliced /\
    B.length array = U32.v array_length /\
    B.length sliced = U32.v array_length
  )
  (ensures fun h0 sliced_length h1 -> 
    U32.v sliced_length <= B.length sliced /\
    B.live h1 sliced
  )
let slice array array_length sliced start stop =
  let sliced_length: U32.t = if U32.(start <^ stop) then U32.(stop -^ start) else 0ul in 
    slice_logic array array_length sliced sliced_length start stop;
  if (U32.(sliced_length <=^ array_length)) then
    sliced_length
  else
    0ul
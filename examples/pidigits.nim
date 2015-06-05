## pidigits from computer language benchmark game.
## Ported from original C version by Mr Ledrug, see:
## http://benchmarksgame.alioth.debian.org/u64q/program.php?test=pidigits&lang=gcc&id=1

import bignum, strutils, os

var
  tmp1 = newInt()
  tmp2 = newInt()
  acc  = newInt()
  den  = newInt(1)
  num  = newInt(1)

proc extractDigit(nth: int): int =
  # joggling between tmp1 and tmp2, so GMP won't have to use temp buffers
  discard tmp1.mul(num, nth)
  discard tmp2.add(tmp1, acc)
  discard tmp1.`div`(tmp2, den)
  tmp1.toInt

proc eliminateDigit(d: int) =
  discard acc.submul(den, d)
  acc *= 10
  num *= 10

proc nextTerm(k: int) =
  var k2 = k * 2 + 1
  discard acc.addmul(num, 2)
  acc *= k2
  den *= k2
  num *= k

proc pidigits =
  if paramCount() == 0: quit("Use: " & paramStr(0) & " <number>")

  var
    d = 0
    k = 0
    i = 0
    n = paramStr(1).parseInt

  if n < 0: quit("Invalid number: " & $n, 2)

  while i < n:
    k.inc
    nextTerm(k)
    if num > acc: continue

    d = extractDigit(3)
    if d != extractDigit(4): continue

    stdout.write(d)
    i.inc
    if i mod 10 == 0: echo "\t:" & $i
    eliminateDigit(d)

pidigits()

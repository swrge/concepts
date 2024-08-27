from std/typetraits import supportsCopyMem
from std/hashes import Hash, hash
from std/sets import HashSet
from std/tables import Table
import macros
import ./pconcepts




## atoms

type
  Nilable* = concept c
    c is ref | ptr | pointer 
    default(typeof(c)) == nil

  Comparable* = concept c
    (c == c) is bool
    (c < c) is bool

  Swapable* = concept c
    swap(c, c)

  Appendable* = concept c, type T
    c.add(T)

  HasDollarSign = concept c
    `$`(c) is string

  ToString = concept c
    toString(c) is string

  Stringable* = HasDollarSign | ToString

  HasAtSign* = concept c, type T
      `@`(c) is seq[T]

  Hashable* {.explain.} = concept c
    hash(c) is Hash
    c == c is bool

  Trivial* = concept type C
    ## A `Trivial` type generally fulfills the following requirements:
    ## - 
    supportsCopyMem(C)

  Variant* = concept type C
    isVariant(C) 



# containers
type
  #Indexable*[T] = concept c, var v
  #  ## Generic type for all indexable types.
  #  type idx = typeof(low(c))
  #  high(c) is idx
  #  c[idx] is lent T
  #  v[idx] is var T
  #  v[idx] = T

  Indexable*[T] = concept c, var v, type Index
    ## Generic type for all indexable types.
    Index is Ordinal
    typeof(low(c)) is Index # yep, i need all that ceremony for supporting most index types 
    typeof(high(c)) is Index
    c[Index] is lent T
    c[Index] = T
  
  
  Iterable*[T] = concept c
    ## Generic type for all Iterable types.
    ## To NOT be confused with `system.iterable[T]`
    c is Indexable[T]
    typeof(items(c)) is lent T
    typeof(mitems(c)) is var T

  Collection*[T] = concept c, var v
    typeof(c.items) is lent T
    typeof(v.mitems) is var T

    c.len() is int
    c.contains(T) is bool

    type Index = typeof(low(c)) # yep, i need all that ceremony for supporting all index types
    c.high() is Index
    var idx: Index
    c[idx] is lent T
    v[idx] = T
  
  Routine*[T, R] = concept p
    type P = typeof(p)
    # parameters validation
    when arity(P) == 0:
      T is void
    elif arity(P) == 1:
      T isnot tuple
      paramTypeAt(p, 0) is T
    else:
      T is tuple
      paramsAsTuple(p) is T
      arity(P) == arity(T)

    # return type validation
    returnType(p) is R
    


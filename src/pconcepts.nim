import macros, typetraits

macro returnType*(p: proc): untyped =
  ## Gets the return type of a procedure
  if p.getTypeInst[0][0].kind == nnkEmpty:
    ident"void"
  else:
    p.getTypeInst[0][0]


macro paramTypeAt*(p: proc, ind: static int): untyped =
  ## Gets a parameter at a specific index, returns void if not found
  let params = p.getTypeImpl[0]
  if params.len - 1 <= 0: 
    ident"void"
  elif ind in 0..<params.len:
    params[ind + 1][^2]
  else:
    ident"void"

macro call*(p: proc, t: tuple): untyped =
  ## Attempts to invoke a procedure with a given tuple, akin to macros.unpackVarargs
  result = newCall(p)
  for i, _ in t.getTypeInst():
    result.add nnkBracketExpr.newTree(t, newLit i)
    
macro paramsAsTuple*(p: proc): untyped =
  ## Creates a tuple typedesc for the parameters of a given procedure
  result = nnkTupleConstr.newTree()
  for x in p.getTypeImpl()[0][1..^1]:
    result.add x[^2]

proc isVariant*(t: typedesc): bool {.compileTime.} =
  ## Determines if a type is an object variant.
  var tDesc = getType(t)
  if tDesc.kind == nnkBracketExpr: tDesc = getType(tDesc[1])
  if tDesc.kind != nnkObjectTy:
    return false
  for child in tDesc[2].children:
    if child.kind == nnkRecCase: return true
  return false
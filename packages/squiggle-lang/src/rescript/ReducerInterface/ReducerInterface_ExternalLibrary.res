module ExpressionValue = ReducerInterface_ExpressionValue

type expressionValue = ExpressionValue.expressionValue

module Sample = {
  // In real life real libraries should be somewhere else
  /*
    For an example of mapping polymorphic custom functions. To be deleted after real integration
 */
  let customAdd = (a: float, b: float): float => {a +. b}
}

/*
  Map external calls of Reducer
*/
let env: GenericDist_GenericOperation.env = {
  sampleCount: 100,
  xyPointLength: 100,
}

let dispatch = (call: ExpressionValue.functionCall, chain): result<expressionValue, 'e> =>
  switch call {
  | ("add", [EvNumber(a), EvNumber(b)]) => Sample.customAdd(a, b)->EvNumber->Ok
  | ("add", [EvDist(a), EvDist(b)]) => {
    let x = GenericDist_GenericOperation.Output.toDistR(
      GenericDist_GenericOperation.run(~env, FromDist(ToDistCombination(Algebraic, #Add, #Dist(b)), a))
    )
    switch x {
      | Ok(thing) => Ok(EvDist(thing))
      | Error(err) => Error(Reducer_ErrorValue.RETodo("")) // TODO:
    }
  }
  | ("add", [EvNumber(a), EvDist(b)]) => {
    let x = GenericDist_GenericOperation.Output.toDistR(
      GenericDist_GenericOperation.run(~env, FromDist(ToDistCombination(Algebraic, #Add, #Dist(b)), a))
    )
    switch x {
      | Ok(thing) => Ok(EvDist(thing))
      | Error(err) => Error(Reducer_ErrorValue.RETodo("")) // TODO:
    }
  }
  | call => chain(call)

  /*
If your dispatch is too big you can divide it into smaller dispatches and pass the call so that it gets called finally.

The final chain(call) invokes the builtin default functions of the interpreter.

Via chain(call), all MathJs operators and functions are available for string, number , boolean, array and record
 .e.g + - / * > >= < <= == /= not and or sin cos log ln concat, etc.

// See https://mathjs.org/docs/expressions/syntax.html
// See https://mathjs.org/docs/reference/functions.html

Remember from the users point of view, there are no different modules:
// "doSth( constructorType1 )"
// "doSth( constructorType2 )"
doSth gets dispatched to the correct module because of the type signature. You get function and operator abstraction for free. You don't need to combine different implementations into one type. That would be duplicating the repsonsibility of the dispatcher.
*/
  }

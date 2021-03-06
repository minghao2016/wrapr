
test_pipe_quote_name <- function() {
  q1 <- x %.>% quote
  e1 <- quote(x)
  RUnit::checkEquals(e1, q1)


  x <- -5

  q2 <- x %.>% quote
  RUnit::checkEquals(e1, q2)

  v0 <- x %.>% abs
  RUnit::checkEquals(5, v0)

  # would like x %.>% substitute to equal
  # as.name("x").  Instead we have the slightly weaker
  # (x %.>% substitute) == substitute(x)
  # as both substitute quotes or un-quotes depending
  # if the eval environment is Global or not.

  vA <- substitute(x) # -5 in test, as.name("x") if run in global env
  vB <- x %.>% substitute # -5 in test, as.name("x") if run in global env
  RUnit::checkEquals(vA, vB)

  f1 <- function() {
    x <- -5

    v1 <- substitute(x)
    v1
  }
  v1 <- f1()
  RUnit::checkEquals(-5, v1)

  f2 <- function() {
    x <- -5

    v2 <- x %.>% substitute
    v2
  }
  v2 <- f2()
  RUnit::checkEquals(-5, v2)
  RUnit::checkEquals(v1, v2)


  invisible(NULL)
}
Locum
================

The [`wrapr dot arrow
pipe`](https://journal.r-project.org/archive/2018/RJ-2018-042/index.html)
was designed to both be an effective [`R`](https://www.r-project.org)
function application pipe *and* also an experimental test-bed for pipe
effects.

Let’s take a look at implementing a new effect from a user perspective.
The idea we want to implement is delayed evaluation through a collecting
object we call a “locum” or stand-in. The locum is intended to collect
operations without executing them, for later use.

Let’s start loading the `wrapr` package and defining our new `locum`
class and its display methods.

``` r
library(wrapr)


mk_locum <- function() {
  locum <- list(stages = list())
  class(locum) <- 'locum'
  return(locum)
}


format.locum <- function(x, ...) {
  args <- list(...)
  locum <- x
  start_name <- 'locum()'
  if('start' %in% names(args)) {
    start_name <- format(args[['start']])
  }
  stage_strs <- vapply(
    locum$stages,
    function(si) {
      format(si$pipe_right_arg)
    }, character(1))
  stage_strs <- c(list(start_name), 
                  stage_strs)
  return(paste(stage_strs, 
               collapse = " %.>%\n   "))
}


as.character.locum <- function(x, ...) {
  return(format(x, ...))
}


print.locum <- function(x, ...) {
  cat(format(x, ...))
}
```

Using the `wrapr` `apply_left` interface we can define an object that
collects pipe stages from the left.

``` r
apply_left.locum <- function(
  pipe_left_arg,
  pipe_right_arg,
  pipe_environment,
  left_arg_name,
  pipe_string,
  right_arg_name) {
  locum <- pipe_left_arg
  capture <- list(
    pipe_right_arg = force(pipe_right_arg),
    pipe_environment = force(pipe_environment),
    left_arg_name = force(left_arg_name),
    pipe_string = force(pipe_string),
    right_arg_name = force(right_arg_name))
  locum$stages <- c(locum$stages, list(capture))
  return(locum)
}
```

We can now use the `locum` to collect the operations, and then print
them.

``` r
y <- 4
p <- mk_locum() %.>% 
  sin(.) %.>% 
  cos(.) %.>% 
  atan2(., y)

print(p)
```

    ## locum() %.>%
    ##    sin(.) %.>%
    ##    cos(.) %.>%
    ##    atan2(., y)

We can use `wrapr`’s `apply_right` interface to define how the `locum`
itself operates on values.

``` r
apply_right.locum <- function(
  pipe_left_arg,
  pipe_right_arg,
  pipe_environment,
  left_arg_name,
  pipe_string,
  right_arg_name) {
  force(pipe_left_arg)
  locum <- pipe_right_arg
  for(s in locum$stages) {
    pipe_left_arg <- pipe_impl(
      pipe_left_arg,
      s$pipe_right_arg,
      s$pipe_environment,
      pipe_string = s$pipe_string) 
  }
  return(pipe_left_arg)
}
```

And we can now replace the `locum` with the value we want to apply the
pipeline to.

``` r
5 %.>% p
```

    ## [1] 0.1426252

This yields the same answer as the following function application.

``` r
atan2(cos(sin(5)), 4)
```

    ## [1] 0.1426252

We can also add later intended arguments to the pipeline formatting.

``` r
print(p, 'start' = 5)
```

    ## 5 %.>%
    ##    sin(.) %.>%
    ##    cos(.) %.>%
    ##    atan2(., y)

The idea is: `wrapr` dot arrow pipe is designed for expansion through
the `apply_right`, `apply_left` `S3` interfaces, and the
`apply_right_S4` `S4` interface. And users can access the implementation
through the `pipe_impl` function. [This
example](https://github.com/WinVector/wrapr/blob/master/Examples/Locum/Locum.md)
and [the formal
article](https://journal.r-project.org/archive/2018/RJ-2018-042/index.html)
should give users a good place to start.
[`rquery`](https://github.com/WinVector/rquery),
[`rqdatatable`](https://github.com/WinVector/rqdatatable), and
[`cdata`](https://github.com/WinVector/cdata) already use the extension
interfaces to implement interesting features.
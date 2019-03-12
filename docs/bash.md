# bash tutorial


## Functions

These are all the ways to create a function in bash. The first method is preferred.

```sh

echo_hello() {
  echo ${1:-"hello world"}
}

echo_hello
echo_hello "lol"


function echo_hello2 {
  echo ${1:-"hello world 2"}
}

echo_hello2
echo_hello2 "lol"


function echo_hello3() {
  echo ${1:-"hello world 3"}
}

echo_hello3
echo_hello3 "lol"

```

## Logical Comparisons

The `[[` brackets `]]` are keywords. They are supported in newer versions of bash.

```sh
is_less_than() {
  if [[ "$1" < "$2" ]]; then
    echo 1
  else
    echo 0
  fi
}

is_less_than 1 2
is_less_than 2 1
```

This is the postfix and well-supported version of testing logical comparisons.
The `[` bracket `]` is an operator and a synonym of test.

`[ "$1" < "$2" ]` will fail because `<` will try to redirect `"$2"` into `"$1"`

```sh
is_less_than_postfix() {
  if [ "$1" -lt "$2" ]; then
    echo 1
  else
    echo 0
  fi
}

is_less_than_postfix 1 2
is_less_than_postfix 2 1
```

This is equivalent to the example above.
```sh
is_less_than_test() {
  if test "$1" -lt "$2"; then
    echo 1
  else
    echo 0
  fi
}

is_less_than_test 1 2
is_less_than_test 2 1
```

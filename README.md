# copyfail

Unminified version of [copy-fail exploit](https://copy.fail/) with a few improvements.

I've done this just to understand better the vulnerability and the exploit.
Some parts are still confusing and need better comments.

## Improvements

- unminified code
- auto checks whether the exploit worked or not
- try all `su` binaries it can find, not only `/usr/bin/env`
- .asm of the exploit payload
- tests to ensure any changes don't break the exploit
- using constants like `AF_*`, `SOCK_*`, `ALG_*`, `SOL_*`, to make it easier to read

## Running

```bash
python exploit.py
```

## Testing

Run all tests:

```bash
./test.sh
```

Test exploit.py:

```bash
TEST=1 python exploit.py
```

`TEST=1` will force flushing the `su` binary RAM cache, avoiding false positives from previous executions.


Test the disassembled payload:

```bash
./payload_test.sh
```

#!/usr/env/bin bash

set -eu

echo "> assemble"
nasm -f bin payload.asm -o payload.rebuilt.elf

echo "> compare payloads"
cmp -s payload.original.elf payload.rebuilt.elf

echo "> payload is identical"
sha256sum payload.original.elf payload.rebuilt.elf

#!/usr/bin/bash

cargo build --release
./target/release/runner solve "$(date +%Y)" "$(date +%d)"

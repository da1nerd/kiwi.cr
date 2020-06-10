# Kiwi
[![GitHub release](https://img.shields.io/github/release/neutrinog/kiwi-crystal.svg)](https://github.com/neutrinog/kiwi-crystal/releases)
[![Build Status](https://travis-ci.org/neutrinog/kiwi-crystal.svg?branch=master)](https://travis-ci.org/neutrinog/kiwi-crystal)

A Crystal port of the [Java implementation](https://github.com/alexbirkett/kiwi-java) of the Cassowary constraint solving algorithm

In other words, this is an algorithm to calculate constraint based GUI layouts.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  kiwi:
    github: neutrinog/kiwi-crystal
```

## Usage

```crystal
require "kiwi"

solver = Kiwi::Solver.new
x = Kiwi::Variable.new("x")
solver.add_constraint(x + 2 == 20)
solver.update_variables
puts x.value # => 18
```

## Benchmark

```crystal
crystal run --release spec/benchmark.cr
```

## Contributing

1. Fork it (<https://github.com/neutrinog/kiwi-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [neutrinog](https://github.com/neutrinog) Joel Lonbeck - creator, maintainer
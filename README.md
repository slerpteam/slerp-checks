# SlerpChecks

**Custom Credo checks to use in your project**

## Checks
# SlerpChecks.Warning.MockCheck
Checks for usage of the Mock library and suggests using Hammox instead:
```
{SlerpChecks.Warning.MockCheck, []}
```

## Installation

```elixir
def deps do
  [
    {:slerp_checks, github: "slerpteam/slerp-checks", branch: "main", only: [:dev, :test]}
  ]
end
```

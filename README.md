# SlerpChecks

**Custom Credo checks to use in your project**

## Checks
# SlerpChecks.Warning.MockCheck
Checks for usage of the Mock library and suggests using Hammox instead:
```
{SlerpChecks.Warning.MockCheck, []}
```

# SlerpChecks.Warning.StrictApplicationCalls
Checks for application config calls that provide defaults or don't throw an error (i.e. fetch_env, get_env and compile_env)
```
{SlerpChecks.Warning.StrictApplicationCalls, []}
```

# SlerpChecks.Warning.EnvCallOutsideOfRuntime
Checks for environment variable fetches outside of runtime.exs
```
{SlerpChecks.Warning.EnvCallOutsideOfRuntime, []}
```

## Installation

```elixir
def deps do
  [
    {:slerp_checks, github: "slerpteam/slerp-checks", branch: "main", only: [:dev, :test]}
  ]
end
```

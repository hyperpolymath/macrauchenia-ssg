# Check Command

Run all quality checks before committing.

```bash
just check
```

This runs:
1. `deno lint` - Lint all adapters
2. `deno fmt --check` - Verify formatting

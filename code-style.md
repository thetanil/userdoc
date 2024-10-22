# Code Style Guide

## Go

### File Structure
- Organize code into packages.
- Use meaningful package names.
- Keep the `main` package minimal.

### Naming Conventions
- Use `CamelCase` for type names and method names.
- Use `mixedCaps` for variable names and function names.
- Use all caps with underscores for constants.

### Formatting
- Use `gofmt` to format your code.
- Use tabs for indentation.

### Comments
- Use `//` for single-line comments.
- Use `/* ... */` for multi-line comments.
- Document all exported functions and types.

### Error Handling
- Check for errors and handle them appropriately.
- Return errors using the `error` type.

## POSIX sh Scripts

### File Structure
- Use `.sh` extension for shell scripts.
- Start scripts with `#!/bin/sh`.

### Naming Conventions
- Use `snake_case` for variable names.
- Use all caps for environment variables.

### Formatting
- Indent with 4 spaces.
- Use `;` to separate commands on the same line.

### Comments
- Use `#` for comments.
- Place comments on their own line when possible.

### Error Handling
- Check the exit status of commands using `$?`.
- Use `set -e` to exit on errors.

### Best Practices
- Quote variables to prevent word splitting.
- Use `$(...)` for command substitution instead of backticks.
- Avoid using `eval` when possible.

## GitHub Actions

### File Structure
- Use `.yml` or `.yaml` extension for GitHub Actions workflow files.
- Place workflow files in the `.github/workflows` directory.

### Naming Conventions
- Use `snake_case` for job and step names.
- Use `UPPER_CASE` for environment variables.
- Use `kebab-case` for workflow inputs.

### Formatting
- Indent with 2 spaces.
- Use double quotes for strings.

### Comments
- Use `#` for comments.
- Place comments on their own line when possible.

### Best Practices
- Use `actions/checkout@v2` to check out the repository.
- Use specific versions for actions to ensure consistency.
- Use secrets for sensitive data.
- Use matrix builds to test across multiple environments.
- Keep workflows DRY (Don't Repeat Yourself) by using reusable workflows or composite actions.


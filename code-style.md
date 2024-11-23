# Code Style Guide

## sh

### POSIX sh

- all shell scripts should be in posix sh

### General Best Practices
- **Use `#!/bin/sh`**: Ensure all scripts start with the shebang `#!/bin/sh`.
- **Use `set -e`**: Exit immediately if a command exits with a non-zero status.
- **Quote Variables**: Always quote variables to prevent word splitting.
- **Use `$(...)` for Command Substitution**: Prefer `$(...)` over backticks for command substitution.
- **Check Exit Status**: Always check the exit status of commands using `$?`.
- **Use Meaningful Variable Names**: Use `snake_case` for variable names.
- **Use Functions**: Encapsulate code in functions for reusability and readability.
- **Use `readonly` for Constants**: Declare constants using `readonly` to prevent modification.

### Sourcing Configuration Files
- **Source Configuration Files**: Use `. ./config.sh` to source shared configuration files.
- **Allow Environment Variable Overrides**: Allow variables to be overridden by environment variables in the caller's environment.

### Example
Here is an example of a script following these best practices, including sourcing a configuration file and allowing environment variable overrides:

```sh
#!/bin/sh
set -e

# Source config.sh
. ./config.sh

# Allow environment variable overrides
BUILDROOT="${BUILDROOT:-$(realpath .)}"
CACHEPATH="${CACHEPATH:-$(realpath ./build/cache)}"
KERNELVER="${KERNELVER:-6.12}"
SRCPATH="${SRCPATH:-$(realpath src)}"
OUTPUTPATH="${OUTPUTPATH:-$(realpath ./build/output)}"
INPUTPATH="${INPUTPATH:-$(realpath ./build/input)}"
INSTALLMEM="${INSTALLMEM:-512M}"
RUNMEM="${RUNMEM:-512M}"
KERNELCONFIG="${KERNELCONFIG:-$(realpath ./src/qemu-kernel-config)}"

# Example function
example_function() {
    echo "BUILDROOT: $BUILDROOT"
    echo "CACHEPATH: $CACHEPATH"
    echo "KERNELVER: $KERNELVER"
    echo "SRCPATH: $SRCPATH"
    echo "OUTPUTPATH: $OUTPUTPATH"
    echo "INPUTPATH: $INPUTPATH"
    echo "INSTALLMEM: $INSTALLMEM"
    echo "RUNMEM: $RUNMEM"
    echo "KERNELCONFIG: $KERNELCONFIG"
}

# Call the example function
example_function
```

This script sources the configuration file config.sh and allows the variables to be overridden by environment variables in the caller's environment.

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


# UserDoc Design Document

## Overview

**UserDoc** is a service for building static sites from runnable markdown
documents. It is a public website where users can edit code in the browser using
tools like Gitea and commit it to Git. Users can also use any editor and Git to
push code to the service. On push, hooks will trigger a job to build the branch
into a static site. Hosting of the static site is provided as part of the
service.

## Key Features

- **Markdown-Based**: Pages are created as markdown where any code cell written
  in any language can be built and executed. The output of the code execution
  may be included in the page.
- **Integration with Git**: Users can edit and push code using Git.
- **Automated Builds**: On push, hooks trigger a job to build the branch into a
  static site.
- **Hosting**: Static site hosting is provided as part of the service.

## Project Structure

```txt
projectroot/
├── build ---------------- mounted in nano vm for each build task
│   ├── md --------------- same as root md but with exec outputs
│   │   ├── index.md
│   │   └── module1
│   │       └── index.md
│   ├── release
│   │   └── module1 ------ nano vm executable
│   ├── src
│   │   └── module1
│   │       └── main.c
│   └── www -------------- srv serves with browsersync
│       ├── index.html
│       └── module1
│           └── index.html
├── md ------------------- watched by taskfile for build trigger
│   ├── index.md
│   └── module1
│       └── index.md
├── static
│   └── img
│       └── favicon.svg
└── Taskfile.yml
```

## Workflow

### File Changes in `md` Directory

- watcher task detects, triggers, calls rsync with checksum and syncs all files
  to prjroot/build. rsync echos list, and cmd calls core build task on file.
- TODO: what if there are deps between updated files? need to call build on full
  set.

### build changeset in `build/md`

- userdoc builder is called in VM with build/ mounted and changed filename set
  as args
- Code is extracted and written into `build/src`
- md snippets are executed from top to botton unless they specify otherwise
  - code fence args { "use": "json" }
  - code is built with docker for cell type
  - build with params from user? gcc -o sadf -l libdep | killme
  - args about how output should be presented (hidden, cell below, collapsed)
  - outputs merged into md and returned for saving to prjroot/md (triggers
    another build)
- Markdown is rendered to `build/www`

### File Changes in `src` Directory

- The build task in `src/Taskfile.yml` is executed.

### End of Task

- Break recursive disk mounting.

### File Changes in `build/release` Directory

- Run task to assign outputs to `/md` (triggers re-build).

### File Changes in `build/www` Directory

- `srv` triggers BrowserSync on page changes.
# sentencedebugger

Complex multi-stage sentence debugger in SWI-Prolog.

## What this project does

`sentencedebugger` turns a natural-language pipeline description or an explicit list of operations into a structured debug report. It helps you see:

- the stages the sentence resolves to
- where actual behaviour first diverges from expected behaviour
- dependencies between stages
- likely causes
- suggested repairs
- a minimal failing example

## Complete command showcase

All commands below are written against the current checkout at `/home/runner/work/sentencedebugger/sentencedebugger`.

### 1. Load the debugger for interactive use

```bash
swipl -q -s /home/runner/work/sentencedebugger/sentencedebugger/main.pl
```

Use this when you want an interactive Prolog REPL with the exported predicates loaded.

### 2. Debug a natural-language sentence

At the Prolog prompt, run:

```prolog
debug_sentence(
    "Read the list, remove duplicates, sort the remaining numbers, add them, and return the total.",
    [3,1,3,2],
    6,
    Report
).
```

Use this when the pipeline starts as plain English. `Report` is unified with the full machine-readable debug structure.

### 3. Debug a sentence through the generic `debug/4` entry point

```prolog
debug(
    sentence(
        "Read the list, remove duplicates, sort the remaining numbers, add them, and return the total.",
        [3,1,3,2],
        6
    ),
    [],
    [],
    Report
).
```

Use this when you want the same sentence-based behaviour through the common API shared by all debugger entry points.

### 4. Debug an explicit pipeline

```prolog
debug(
    pipeline(
        simple_bug,
        [read_list, remove_duplicates_buggy, sort_numbers, sum_numbers, return],
        [3,3,1,2],
        6
    ),
    [],
    [],
    Report
).
```

Use this when you already know the exact operation list and want to inspect a buggy stage directly.

### 5. Debug a predicate-style specification

```prolog
debug(
    predicate(
        custom_pipeline,
        [read_list, remove_duplicates_buggy, sum_numbers, return],
        [1,1,2],
        3
    ),
    [],
    [],
    Report
).
```

Use this when you want to label and debug a predicate-oriented pipeline without starting from a sentence.

### 6. Write a sentence debug report to a file

```prolog
debug_sentence_to_file(
    "Read the list, remove duplicates, sort the remaining numbers, add them, and return the total.",
    [2,2,1],
    3,
    '/home/runner/work/sentencedebugger/sentencedebugger/report_sentence.txt'
).
```

Use this when you want a saved report. The file contains a human-readable section followed by a `MACHINE_READABLE_REPORT` term.

### 7. Write a pipeline debug report to a file

```prolog
debug_predicate_to_file(
    pipeline([read_list, remove_duplicates_buggy, sum_numbers, return]),
    [1,1,2],
    3,
    '/home/runner/work/sentencedebugger/sentencedebugger/report_predicate.txt'
).
```

Use this when the pipeline is already explicit and you want the report on disk instead of only in memory.

### 8. Run the bundled example programs

Each example loads `/home/runner/work/sentencedebugger/sentencedebugger/main.pl`, executes its `run/0` predicate, and prints the resulting report term.

```bash
swipl -q -g run -t halt -s /home/runner/work/sentencedebugger/sentencedebugger/examples/simple_bug.pl
swipl -q -g run -t halt -s /home/runner/work/sentencedebugger/sentencedebugger/examples/nested_bug.pl
swipl -q -g run -t halt -s /home/runner/work/sentencedebugger/sentencedebugger/examples/cascading_bug.pl
swipl -q -g run -t halt -s /home/runner/work/sentencedebugger/sentencedebugger/examples/multiple_independent_bugs.pl
```

Use these when you want ready-made scenarios that demonstrate different failure shapes.

### 9. Run the automated test suite

```bash
swipl -q -f none -s /home/runner/work/sentencedebugger/sentencedebugger/tests/run_tests.pl
```

Use this to verify the repository's current behaviour.

## Exported predicates at a glance

| Predicate | Best for | Result |
| --- | --- | --- |
| `debug_sentence/4` | Natural-language pipeline debugging | Returns a report term |
| `debug_sentence_to_file/4` | Sentence debugging with saved output | Writes a formatted report file |
| `debug_predicate_to_file/4` | Explicit pipeline debugging with saved output | Writes a formatted report file |
| `debug/4` | Unified API for `sentence(...)`, `pipeline(...)`, and `predicate(...)` specifications | Returns a report term |

## Notes about the report

The generated report includes:

- the original specification
- the provided input
- expected and actual results
- the functional decomposition
- per-stage comparison statuses
- the first divergence
- dependencies and inferred causes
- suggested repairs
- a minimal failing example

# EL2026 - Embedded Linux Diploma Laboratory Exercises

This repository contains Python and C++ laboratory exercises for the Embedded Linux Diploma EL2026 program. Labs are organized by sessions and tested automatically via a flexible CI pipeline that adapts to your progress.

## How the Pipeline Works

Both the Python and C++ pipelines are **session-aware** — they auto-discover all `session*` directories under `python/` and `cpp/` and run them with a **gate-check** pattern:

- **Gate check**: Each session's `lab1_*` file is built/run first as an entry check
- **If gate passes** → all remaining labs in that session are tested (failures here are reported as errors)
- **If gate fails** → the entire session is **skipped** (you haven't started it yet, so it won't break your pipeline)

This means:
- A student on session 2 won't fail CI because sessions 3+ aren't solved
- A student on session 5 can push without worrying about future sessions
- New sessions can be added anytime without modifying any scripts

## Repository Structure

```
python/
├── session1/
│   ├── lab1_list_count.py          # Count occurrences in lists
│   ├── lab2_vowel_or_not.py        # Vowel checking functions
│   ├── lab3_access_env.py          # Environment variable access
│   ├── lab4_area_circle.py         # Circle area calculations
│   └── lab5_accumulator.py         # Accumulator patterns
├── session2/
│   ├── lab1_get_your_location.py   # Geolocation with APIs
│   ├── lab2_lists_problems.py      # Advanced list operations
│   ├── lab3_tuple_problems.py      # Tuple manipulation
│   └── lab4_set_problems.py        # Set operations and theory
└── session3/
    ├── lab1_dictionary_problems.py # Dictionary data structures
    ├── lab2_parse_file.py          # File parsing and processing
    └── template_data.txt           # Sample data for parsing

cpp/
├── session1/
│   ├── lab1_ascii_print.cpp        # ASCII table generation
│   ├── digit_sum.cpp               # Sum of digits
│   ├── max_three_numbers.cpp       # Maximum of three numbers
│   ├── right_triangle.cpp          # Right triangle checks
│   └── vowel_checker.cpp           # Vowel checking
├── session2/
│   ├── lab1_array_max.cpp          # Array maximum
│   ├── lab2_array_search.cpp       # Array searching
│   ├── lab3_array_delete.cpp       # Array element deletion
│   ├── lab4_array_merge.cpp        # Array merging
│   └── lab5_even_odd.cpp           # Even/odd classification
├── session3/
│   ├── lab1_all_even.cpp           # All-even predicate
│   ├── lab2_any_even.cpp           # Any-even predicate
│   └── lab3_string_class.cpp       # Custom string class
├── session4/
│   └── lab1_function_backtrace.cpp # RAII function backtrace
└── session5/
    └── lab1_logging_system.cpp     # Logging system with levels
```

## Getting Started

### Prerequisites
- Python 3.9 or higher
- g++ with C++17 support (g++ 12 or higher recommended)
- Git
- pip packages: `pylint`, `requests`

### Setup

```bash
git clone <your-fork-url>
cd EL2026
pip install pylint requests
sudo apt-get install -y build-essential g++
```

## Running Tests

### Run all Python sessions
```bash
chmod +x run_python.sh
./run_python.sh
```

### Run all C++ sessions
```bash
chmod +x run_cpp.sh
./run_cpp.sh
```

### Run individual labs
```bash
# Python
python python/session1/lab1_list_count.py
pylint --disable=C0301 python/session1/lab1_list_count.py

# C++
g++ -Wall -Wextra -std=c++17 cpp/session1/lab1_ascii_print.cpp -o lab1
./lab1
```

## CI/CD

Both pipelines run on every push and pull request, and each reports a single required status check (**Python** / **C++**):

- The **Python** pipeline tests across Python 3.9–3.13.
- The **C++** pipeline builds and runs every lab with `g++ -Wall -Wextra -std=c++17`, tested across g++ 12–14. Compiler warnings are shown but non-blocking.

Because unsolved sessions are skipped (not failed), a team working only on C++ always gets a green **Python** check and vice versa — the two tracks never block each other.

### Status meanings
- **🟩 Passed** — session fully solved
- **🟨 Skipped** — gate check failed (you haven't started this session yet — this is OK)
- **🟥 Failed** — gate passed but one or more labs in the session have errors

## Best Practices

- Work on feature branches (`git checkout -b session1/lab1-solution`)
- Don't modify test cases or function signatures
- Test frequently with `./run_python.sh` / `./run_cpp.sh` before pushing
- Each session is independent — complete them in order at your own pace

# Global agent instructions

## 1. General Rule 
- Never use the em dash "—". Use plain dash "-" instead
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- Prefer quality, simplicity, robustness, scalability, and long-term maintainability over ease of implementation.
- If something is unclear and multiple interpretations exist, present them - don't pick silently.

## 2. Focus and Minimalist Execution
- For one-off or infrequent operational work, start with the simplest direct end-to-end path.
- Don't build abstractions or automation beyond what's needed.
- If something clearly looks off, and if it is not directly related to what you are doing, surface it but don't get distracted trying to fix it immediately. Focus on what was asked.

## 3. Engineering Excellence
- Don't leave lint warnings, failing tests, or flaky tests unaddressed when you encounter them
- Run the full test suite before considering any code change complete.
- Don't write tests unless explicitly asked, or unless you're fixing a bug (where a reproducing test is required).
- When fixing a bug: confirm the reproducing test fails before the fix and passes after.
- Don't write tests that only assert code runs without errors - tests must verify actual behavior or outcomes.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible. This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.

## 4. Safeguards
- Before using "dynamic workflows", "ultra code" or any harness feature that immediately spawns a large swarm of subagents, always explain the tradeoffs and ask the user for explicit approval.


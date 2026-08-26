# Global agent instructions

## 1. Before Coding
- Never use the em dash "—". Use plain dash "-" instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- If something is unclear and multiple interpretations exist, present them - don't pick silently.

## 2. Focus and Minimalist Execution
- For one-off or infrequent operational work, start with the simplest direct end-to-end path.
- If not explicitly requested, do not build abstractions, wrappers, control planes, policy layers, custom verifiers, or automation unless the direct path exposes a concrete blocker or repeated need that justifies the added machinery.
- If something clearly looks off, and if it is not directly related to what you are doing, surface it but don't get distracted trying to fix it immediately. Focus on what was asked.

## 3. Engineering Excellence
- Apply high standard to engineering excellence: lint, test failures, and test flakiness.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible. This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.

## 4. Safeguards
- Before using "dynamic workflows", "ultra code" or any harness feature that immediately spawns a large swarm of subagents, always explain the tradeoffs and ask the user for explicit approval.


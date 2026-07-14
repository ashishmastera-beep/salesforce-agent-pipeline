# Apex Best Practices (read before writing Apex)
- Bulkify: design for 200 records; no SOQL/DML in loops; use maps for lookups.
- Security: `with sharing` default; check CRUD/FLS; bind variables in SOQL (no string concat).
- Batch/Queueable: idempotent execute(), stateful only when needed, chain via finish().
- Errors: try/catch with meaningful messages; never swallow exceptions silently.
- Tests: @isTest + @TestSetup factory, Assert class with messages, bulk + negative scenarios, no SeeAllData.

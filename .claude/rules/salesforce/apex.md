- Bulkify everything; no SOQL/DML inside loops.
- One trigger per object; logic lives in handler classes.
- Use `with sharing` unless the spec explicitly says otherwise; enforce FLS/CRUD (Security.stripInaccessible).
- Batch classes: implement Database.Batchable<SObject>, keep scope idempotent and re-runnable.
- Every class change requires/updates a *Test class: @isTest, TestSetup data factory, meaningful asserts,
  no SeeAllData, cover bulk (200 records) and negative paths.

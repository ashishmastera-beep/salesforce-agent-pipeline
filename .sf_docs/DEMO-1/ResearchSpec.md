# ResearchSpec - DEMO-1

## Story Summary
Update the nightly Account review batch so that when an Account is flagged as "Needs review", it also stamps Account.Last_Reviewed__c to the current date. Update tests to validate:
- flagged Accounts get Last_Reviewed__c = Date.today()
- non-flagged Accounts keep Last_Reviewed__c as null
- bulk behavior (200+ records)
- one negative scenario

## Evidence From Codebase
1. Existing batch class already identifies Accounts with no open Opportunities and updates Description.
- force-app/main/default/classes/AccountReviewBatch.cls
- Current behavior:
  - start(): Query Accounts where Id NOT IN open Opportunity AccountIds
  - execute(): Set Description and perform one bulk update on scope
  - finish(): empty

2. Existing test class currently validates Description-only behavior for one flagged and one skipped Account.
- force-app/main/default/classes/AccountReviewBatchTest.cls
- Current gaps:
  - no Last_Reviewed__c assertions
  - no explicit 200+ bulk scenario
  - no explicit negative scenario test

3. Target field already exists in metadata and is type Date.
- force-app/main/default/objects/Account/fields/Last_Reviewed__c.field-meta.xml

4. Repo Apex standards require bulk-safe logic and bulk/negative test coverage.
- SalesforceBestPracticeDocs/Apex_Best_Practices.md

## Solution Options Considered
1. Minimal in-place update in existing execute loop (chosen).
- Set both Description and Last_Reviewed__c inside the existing loop
- Keep one update scope DML per execute invocation
- Pros: smallest diff, preserves current query strategy and batch shape
- Cons: still relies on NOT IN subquery pattern already present

2. Refactor into helper/service class now.
- Pros: better long-term extensibility
- Cons: unnecessary scope expansion for DEMO-1 and larger review surface

3. Add conditional write checks (only update when changed).
- Pros: may reduce no-op updates in reruns
- Cons: extra branching complexity for limited value in this story

## Chosen Design Rationale
Choose Option 1 to satisfy DEMO-1 with minimal risk:
- Keeps existing bulkification characteristics
- Requires no metadata additions
- Directly addresses all acceptance points through focused test expansion

## Risks And Mitigations
1. Risk: Date-sensitive assertions can fail around day boundaries in long-running tests.
- Mitigation: compare to Date.today() within same test transaction after Test.stopTest().

2. Risk: Bulk test may accidentally qualify/unqualify wrong Accounts.
- Mitigation: explicitly create separate cohorts (no-opportunity vs open-opportunity) and assert each cohort independently.

## Open Questions
OQ1 (soft): Should execute() also set Last_Reviewed__c for Accounts already containing the same review Description from prior runs?
- Recommended answer: Yes. Always stamp Date.today() for all Accounts selected by the batch query to reflect latest review date.

OQ2 (soft): Should the negative scenario be "no qualifying Accounts" or "mixed data with zero expected updates for the protected cohort"?
- Recommended answer: Use "no qualifying Accounts" as the explicit negative test because it is deterministic and easy to maintain.

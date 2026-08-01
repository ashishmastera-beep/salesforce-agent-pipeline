# TechnicalSpec - DEMO-1

## Scope
Implement DEMO-1 by modifying existing Apex only:
- Update AccountReviewBatch to stamp Account.Last_Reviewed__c = Date.today() whenever it flags an Account.
- Expand AccountReviewBatchTest to validate flagged vs non-flagged Last_Reviewed__c behavior, bulk scale (200+), and a negative scenario.

## Components To Modify
1. Apex class
- force-app/main/default/classes/AccountReviewBatch.cls

2. Apex test class
- force-app/main/default/classes/AccountReviewBatchTest.cls

No new metadata components are required.

## Detailed Design
### 1) AccountReviewBatch.cls
Current class shape remains unchanged:
- with sharing
- implements Database.Batchable<SObject>
- start(), execute(), finish() signatures unchanged

Required execute() behavior update:
- For each Account in scope that is already selected by start() criteria (no open Opportunities):
  - set Description = "Needs review - no open opportunities" (preserve current meaning)
  - set Last_Reviewed__c = Date.today()
- Keep one bulk DML update for the scope list.
- No SOQL/DML in loops.

Notes:
- start() query logic remains the selector for which records are flagged.
- finish() remains intentionally empty.

### 2) AccountReviewBatchTest.cls
Retain @TestSetup and add/adjust tests to cover all required scenarios.

Test Case A: flagged vs non-flagged field assertions
- Seed data:
  - one Account without open Opportunity (expected flagged)
  - one Account with open Opportunity (expected not flagged)
- Execute batch in test context.
- Assert:
  - flagged Account Description contains "Needs review"
  - flagged Account Last_Reviewed__c == Date.today()
  - non-flagged Account Description is null
  - non-flagged Account Last_Reviewed__c is null

Test Case B: bulk coverage (200+)
- Seed data:
  - at least 210 Accounts with no open Opportunities (expected flagged)
  - at least 20 Accounts with open Opportunities (expected not flagged)
- Execute batch.
- Assert:
  - all flagged cohort records have non-null Description containing "Needs review"
  - all flagged cohort records have Last_Reviewed__c == Date.today()
  - all open-opportunity cohort records keep Last_Reviewed__c null

Test Case C: negative scenario (no qualifying Accounts)
- Seed data:
  - all Accounts have at least one open Opportunity
- Execute batch.
- Assert:
  - no Account has Last_Reviewed__c populated
  - no Account has Description set by the batch
- Purpose: validates safe behavior when zero records match start() filter.

## Acceptance Criteria Mapping
1. "Stamp Last_Reviewed__c on flagged accounts"
- Satisfied by execute() update in AccountReviewBatch.

2. "Test validates field set for flagged and null for non-flagged"
- Satisfied by Test Case A.

3. "Cover bulk (200+)"
- Satisfied by Test Case B with >=210 qualifying records.

4. "Cover a negative scenario"
- Satisfied by Test Case C where no records qualify.

## Deployment Notes
- Deploy existing modified Apex class and test class only.
- Run Apex tests including AccountReviewBatchTest.
- Confirm all assertions pass in target org.

## Open Questions
OQ1 (soft): Should we preserve the existing Description text exactly (including punctuation/character style), or normalize to ASCII-only text in this same story?
- Recommended answer: Preserve existing business message semantics and avoid non-functional text churn unless explicitly requested.

OQ2 (soft): Should the batch execute scope size be pinned in tests (for example 100 or 200) to force multiple execute invocations?
- Recommended answer: Yes, execute with a scope that ensures more than one chunk for the bulk dataset to validate true batch chunking behavior.

Ready for development - run the sf-developer agent.

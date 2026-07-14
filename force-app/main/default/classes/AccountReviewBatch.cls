/**
 * Nightly batch: flags Accounts with no open Opportunities as needing review.
 * DEMO-1 will extend this to also stamp a Last_Reviewed__c date.
 */
public with sharing class AccountReviewBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Description
            FROM Account
            WHERE Id NOT IN (SELECT AccountId FROM Opportunity WHERE IsClosed = false)
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account acc : scope) {
            acc.Description = 'Needs review — no open opportunities';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        // Intentionally empty for the demo
    }
}

@isTest
private class AccountReviewBatchTest {

    @TestSetup
    static void makeData() {
        insert new Account(Name = 'NoOpp Co');
        Account withOpp = new Account(Name = 'HasOpp Co');
        insert withOpp;
        insert new Opportunity(Name = 'Open Deal', AccountId = withOpp.Id,
                               StageName = 'Prospecting', CloseDate = Date.today().addDays(30));
    }

    @isTest
    static void flagsAccountsWithoutOpenOpps() {
        Test.startTest();
        Database.executeBatch(new AccountReviewBatch());
        Test.stopTest();

        Account flagged = [SELECT Description FROM Account WHERE Name = 'NoOpp Co'];
        Account skipped = [SELECT Description FROM Account WHERE Name = 'HasOpp Co'];
        Assert.isTrue(flagged.Description != null && flagged.Description.contains('Needs review'),
                      'Account without open opps should be flagged');
        Assert.isNull(skipped.Description, 'Account with open opp must not be flagged');
    }
}

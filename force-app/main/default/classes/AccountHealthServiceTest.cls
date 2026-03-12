@IsTest
private class AccountHealthServiceTest {
    @IsTest
    static void updateHealthScores_calculatesExpectedScores() {
        // Create 4 accounts that represent the target scoring combinations.
        Account highHigh = new Account(
            Name = 'High High',
            AnnualRevenue = 1500000,
            Last_90_Day_Wins__c = 150000
        );
        Account midLow = new Account(
            Name = 'Mid Low',
            AnnualRevenue = 500000,
            Last_90_Day_Wins__c = 10000
        );
        Account lowZero = new Account(
            Name = 'Low Zero',
            AnnualRevenue = 100000,
            Last_90_Day_Wins__c = 0
        );
        Account zeroZero = new Account(
            Name = 'Zero Zero'
        );

        // Insert test data and gather IDs for a single bulk service call.
        insert new List<Account>{ highHigh, midLow, lowZero, zeroZero };

        Set<Id> accountIds = new Set<Id>{
            highHigh.Id, midLow.Id, lowZero.Id, zeroZero.Id
        };

        // Execute the method under test.
        Test.startTest();
        AccountHealthService.updateHealthScores(accountIds);
        Test.stopTest();

        // Query updated records to validate computed Health_Score__c values.
        Map<Id, Account> refreshed = new Map<Id, Account>([
            SELECT Id, Name, Health_Score__c
            FROM Account
            WHERE Id IN :accountIds
        ]);

        // Validate representative scoring outcomes from each bucket combination.
        System.assertEquals(
            100,
            Integer.valueOf(refreshed.get(highHigh.Id).Health_Score__c),
            'Expected 50 (revenue) + 50 (wins) = 100'
        );
        System.assertEquals(
            40,
            Integer.valueOf(refreshed.get(midLow.Id).Health_Score__c),
            'Expected 30 (revenue) + 10 (wins) = 40'
        );
        System.assertEquals(
            10,
            Integer.valueOf(refreshed.get(lowZero.Id).Health_Score__c),
            'Expected 10 (revenue) + 0 (wins) = 10'
        );
        System.assertEquals(
            0,
            Integer.valueOf(refreshed.get(zeroZero.Id).Health_Score__c),
            'Expected 0 (revenue) + 0 (wins) = 0'
        );
    }

    @IsTest
    static void updateHealthScores_handlesNullAndEmptyInputs() {
        // Confirm guard clauses safely return without throwing exceptions.
        Test.startTest();
        AccountHealthService.updateHealthScores(null);
        AccountHealthService.updateHealthScores(new Set<Id>());
        Test.stopTest();

        System.assert(true, 'Method should safely return for null/empty input.');
    }
}

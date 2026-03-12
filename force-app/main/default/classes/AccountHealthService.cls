public with sharing class AccountHealthService {
    // Recalculates Health_Score__c for all provided Account records in bulk.
    public static void updateHealthScores(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : [
            SELECT Id, AnnualRevenue, Last_90_Day_Wins__c
            FROM Account
            WHERE Id IN :accountIds
        ]) {
            // Health score is the sum of revenue and recent wins buckets.
            Integer revenueScore = calculateRevenueScore(acc.AnnualRevenue);
            Integer recentWinsScore = calculateRecentWinsScore(acc.Last_90_Day_Wins__c);
            Integer totalScore = revenueScore + recentWinsScore;

            accountsToUpdate.add(new Account(
                Id = acc.Id,
                Health_Score__c = totalScore
            ));
        }

        // Perform one bulk DML update for all recalculated accounts.
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    // Maps AnnualRevenue into the required score buckets: 0, 10, 30, or 50.
    private static Integer calculateRevenueScore(Decimal annualRevenue) {
        if (annualRevenue == null || annualRevenue == 0) {
            return 0;
        } else if (annualRevenue > 0 && annualRevenue < 250000) {
            return 10;
        } else if (annualRevenue >= 250000 && annualRevenue < 1000000) {
            return 30;
        }
        return 50;
    }

    // Maps Last_90_Day_Wins__c into the required score buckets: 0, 10, 30, or 50.
    private static Integer calculateRecentWinsScore(Decimal last90DayWins) {
        if (last90DayWins == null || last90DayWins == 0) {
            return 0;
        } else if (last90DayWins > 0 && last90DayWins < 25000) {
            return 10;
        } else if (last90DayWins >= 25000 && last90DayWins < 100000) {
            return 30;
        }
        return 50;
    }
}

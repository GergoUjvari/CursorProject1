# CursorProject1 Salesforce DX Guide

This repository contains Salesforce metadata and Apex automation for Account health scoring, Opportunity rollups, and proactive follow-up actions.

## What Is Implemented

- Custom fields on `Account`:
  - `AlternativeAccountName__c` (Formula Text)
  - `Health_Score__c` (Number)
  - `Revenue_Tier__c` (Formula Text)
  - `Last_90_Day_Wins__c` (Currency)
- Custom field on `Opportunity`:
  - `Discount__c` (Percent)
- Validation rule on `Opportunity`:
  - `Discount_Cannot_Exceed_30`
- Record-triggered flow:
  - `Account_Health_Score_Proactive_Checkin`
- Apex service and tests:
  - `AccountHealthService`
  - `AccountHealthServiceTest`
- Opportunity trigger pattern and tests:
  - `OpportunityTrigger`
  - `OpportunityTriggerHandler`
  - `OpportunityTriggerHandlerTest`

## Prerequisites

- Salesforce CLI (`sf`)
- Access to the target org (alias examples used in this project: `myDev`, `OrgCursorProject1`)
- Node.js only if you use local JS tooling commands

## Project Structure

- `force-app/main/default/objects/` - object metadata (fields, validation rules)
- `force-app/main/default/flows/` - flow metadata
- `force-app/main/default/classes/` - Apex classes and tests
- `force-app/main/default/triggers/` - Apex triggers
- `force-app/main/default/layouts/` - page layouts
- `force-app/main/default/profiles/` - profile FLS/layout assignments

## Common Commands

Use the commands below from the project root.

### Deploy metadata

```bash
sf project deploy start --source-dir force-app/main/default --target-org myDev
```

### Run a specific test class with coverage

```bash
sf apex run test --tests AccountHealthServiceTest --target-org myDev --code-coverage --wait 20
```

### Run multiple specific tests

```bash
sf apex run test --tests AccountHealthServiceTest,OpportunityTriggerHandlerTest --target-org myDev --code-coverage --wait 20
```

### Retrieve metadata from org

```bash
sf project retrieve start --metadata "Flow:Account_Health_Score_Proactive_Checkin" --target-org myDev
```

## Development Best Practices

- Keep all trigger logic out of triggers; use handler/service classes.
- Always write bulk-safe code (no SOQL/DML inside loops).
- Recalculate rollups using aggregate queries instead of incremental math when possible.
- Add focused unit tests for happy path and edge cases (insert/update/delete/reparent).
- Do not use `SeeAllData=true` in unit tests.
- Keep profile changes minimal; prefer permission sets for long-term maintainability.
- Validate deployments in org and run tests before pushing commits.

## Suggested Git Workflow

- Work on feature branches.
- Keep commits small and focused by area (for example, service class vs trigger changes).
- Use clear commit messages that explain intent.
- Open PRs for review before merging to `main`.

## Reference Docs

- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)

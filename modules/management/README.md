# Management Module

This module deploys the management module to the `Management` Resource Group.

It currently consists of:


Planned Resources are:

- An Automation Account
- A DDoS Protection Plan
- A Log Analytics Workspace with solutions
- A Storage Account
- An Azure Function that will:
    - delete all resources groups and resources once a day
    - Add shutdown times to all VM´s
- Cost Management
    - a budget with alerts
- Create an Azure Firewall Base Policy



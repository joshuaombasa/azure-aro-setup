# Deploying Azure Red Hat OpenShift (ARO) using Azure Portal

This document provides a step-by-step guide to deploying an Azure Red Hat OpenShift (ARO) cluster using the Azure Portal.

## Prerequisites
- **Azure Subscription**: Ensure you have a valid subscription.
- **Permissions**: You need permissions to create resources like resource groups, virtual networks, and ARO clusters.

---

## Steps to Deploy ARO

### Step 1: Register the Red Hat OpenShift Resource Provider
1. Go to the **Azure Portal** ([https://portal.azure.com](https://portal.azure.com)).
2. In the search bar, type **Subscriptions** and select your subscription.
3. Under **Settings**, select **Resource providers**.
4. Search for `Microsoft.RedHatOpenShift`.
5. Click **Register** if it is not already registered.

---

### Step 2: Create a Resource Group
1. In the Azure Portal, search for **Resource groups** and select **Create**.
2. Fill in the **Create a resource group** pane:
   - **Subscription**: Select your subscription.
   - **Resource group name**: Enter `aro-resource-group`.
   - **Region**: Select `East US` (or your preferred region).
3. Click **Review + create**, then **Create** to confirm.

---

### Step 3: Create a Virtual Network with Subnets
1. In the Azure Portal, go to **Virtual networks** and select **Create**.
2. Fill in the **Create virtual network** pane:
   - **Subscription** and **Resource Group**: Choose the ones created in Step 2.
   - **Name**: Enter `aro-vnet`.
   - **Region**: Ensure it matches your resource group region.
3. In the **IP Addresses** tab:
   - **Address space**: Enter `10.0.0.0/9`.
4. In the **Subnets** section:
   - **Add subnet**:
     - **Name**: `master-subnet`
     - **Address range**: `10.0.0.0/24`
   - **Add another subnet**:
     - **Name**: `worker-subnet`
     - **Address range**: `10.0.1.0/24`
5. Click **Review + create**, then **Create** to finalize.

---

### Step 4: Create the ARO Cluster
1. In the Azure Portal, search for **Azure Red Hat OpenShift** and select **Create**.
2. Fill in the **Create Azure Red Hat OpenShift** pane:
   - **Subscription** and **Resource Group**: Select the ones created in Step 2.
   - **Cluster name**: Enter `aro-cluster`.
   - **Region**: Choose the same region as in Step 2.
3. In the **Networking** tab:
   - **Virtual network**: Select `aro-vnet` created in Step 3.
   - **Master subnet**: Select `master-subnet`.
   - **Worker subnet**: Select `worker-subnet`.
4. Set **API server visibility** and **Ingress visibility** to **Public** as required.
5. Click **Review + create**, then **Create** to start deployment.

---

### Step 5: Retrieve Cluster Credentials
1. Once deployment is complete, navigate to your ARO cluster resource in the Azure Portal.
2. In the **Overview** page, locate the **Console URL** and click to open the OpenShift web console.
3. Use the **Kubeadmin password** from the **Access control** section to log in.

---

## Summary
Your Azure Red Hat OpenShift (ARO) cluster is now set up and accessible. You can manage your cluster via the OpenShift web console or by using the `oc` CLI.

For further management, refer to the [ARO Documentation](https://learn.microsoft.com/en-us/azure/openshift/).

---

### License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

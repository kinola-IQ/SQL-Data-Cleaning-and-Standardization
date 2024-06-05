## Data Cleaning Script

### Intended Purpose

The intended purpose of this SQL script is to clean and standardize data within the `NashvilleHousingData` table. This process involves updating and formatting various columns, handling missing or duplicate data, and ensuring consistency in the data to adhere to best data handling practices.

### Key Objectives

1. **Standardizing Data Formats**: Ensuring consistent formats for dates and text fields.
2. **Populating Missing Data**: Using joins and update statements to fill in missing values.
3. **Breaking Down Compound Data**: Splitting address fields into separate components (address, city, state).
4. **Standardizing Categorical Data**: Converting 'Y' and 'N' values to 'Yes' and 'No'.
5. **Identifying and Handling Duplicates**: Detecting duplicate records and isolating unique records.
6. **Creating Views for Reporting**: Setting up views for easy visualization and reporting of cleaned data.

### Section Objectives

1. **Standardizing Date Format**
   - **Objective**: Alter the `SaleDate` column to ensure it has a `DATE` data type.

2. **Populating Property Address**
   - **Objective**: Use an `UPDATE` statement to fill in missing property addresses.
  
3. **Verifying Property Address Update**
   - **Objective**: Check if any `PropertyAddress` fields are still null.
  
4. **Breaking Down Address into Specific Columns**
   - **Objective**: Split the `PropertyAddress` into separate `address` and `city` columns.
 
5. **Breaking Down Owner Address**
   - **Objective**: Split the `OwnerAddress` into `address`, `city`, and `state` columns.

6. **Standardizing Categorical Data**
   - **Objective**: Convert 'Y' and 'N' in the `SoldAsVacant` column to 'Yes' and 'No'.

7. **Creating Save Points**
   - **Objective**: Create save points to facilitate rollback in case of errors.

8. **Identifying Duplicates**
   - **Objective**: Identify duplicate records based on specific fields.

9. **Filtering Duplicates into a Temporary Table**
   - **Objective**: Use a Common Table Expression (CTE) to filter out duplicates and store unique records in a temporary table.
  
10. **Creating a View for Visualization**
    - **Objective**: Create a view of the cleaned data for easier access and reporting.

### Precautionary Steps Taken

- **Use of Transactions**: use of transactions (`begin TRANSACTION datacleaning` and `SAVE TRANSACTION savepoint`) to ensure data integrity and provide rollback capabilities in case of errors during the cleaning process.
- **Interim Verification Steps**: The script includes several `SELECT` statements to verify the intermediate results of updates and transformations, ensuring that each step of the cleaning process is executed correctly.
- **Handling of Missing and Duplicated Data**: The script addresses common data issues such as missing values and duplicate records comprehensively, ensuring a clean and reliable dataset.

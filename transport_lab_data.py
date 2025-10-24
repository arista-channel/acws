#!/usr/bin/env python3
"""
Lab Assignment Data Transport Script

This script transports data from atlanta_lab_assignment.csv to lab_assignment.csv
while preserving the column structure and handling all data fields properly.

Features:
- Replaces empty/blank fields with '-' for consistent formatting
- Trims whitespace from all fields
- Creates automatic backups before processing
- Provides detailed verification and reporting

Usage: python transport_lab_data.py
"""

import csv
import os
import shutil
from datetime import datetime

def transport_lab_data():
    """Transport data from atlanta_lab_assignment.csv to lab_assignment.csv"""

    # File paths
    source_file = 'data/atlanta_lab_assignment.csv'
    target_file = 'data/lab_assignment.csv'
    backup_file = f'data/lab_assignment_backup_{datetime.now().strftime("%Y%m%d_%H%M%S")}.csv'

    print("🚀 Lab Assignment Data Transport")
    print("=" * 40)

    # Check if source file exists
    if not os.path.exists(source_file):
        print(f"❌ Error: Source file '{source_file}' not found!")
        return False

    # Create backup of target file if it exists
    if os.path.exists(target_file):
        shutil.copy2(target_file, backup_file)
        print(f"📋 Backup created: {backup_file}")

    try:
        # Read source data
        print(f"📖 Reading source data from: {source_file}")
        with open(source_file, 'r', newline='', encoding='utf-8') as source:
            reader = csv.reader(source)
            source_data = list(reader)

        # Process data: replace empty fields with '-'
        print("🔄 Processing data: replacing empty fields with '-'")
        processed_data = []
        empty_field_count = 0

        for row_index, row in enumerate(source_data):
            processed_row = []
            for field_index, field in enumerate(row):
                # Replace empty fields with '-' (skip header row)
                if row_index == 0:  # Header row - keep as is
                    processed_row.append(field)
                else:  # Data rows - replace empty with '-'
                    if field.strip() == '':
                        processed_row.append('-')
                        empty_field_count += 1
                    else:
                        processed_row.append(field.strip())  # Also trim whitespace
            processed_data.append(processed_row)

        print(f"✅ Replaced {empty_field_count} empty fields with '-'")

        # Write to target file
        print(f"📝 Writing processed data to: {target_file}")
        with open(target_file, 'w', newline='', encoding='utf-8') as target:
            writer = csv.writer(target)
            writer.writerows(processed_data)
        
        # Verify the transport
        print("✅ Data transport completed successfully!")
        print(f"📊 Transported {len(processed_data) - 1} student records (plus header)")

        # Show summary
        print("\n📋 Transport Summary:")
        print("-" * 20)

        if len(processed_data) > 1:
            header = processed_data[0]
            print(f"Columns: {len(header)}")
            print(f"Records: {len(processed_data) - 1}")
            print(f"Empty fields replaced: {empty_field_count}")

            # Show first few records for verification
            print("\n🔍 Sample Records (after processing):")
            for i, row in enumerate(processed_data[1:4], 1):  # Show first 3 records
                if len(row) >= 3:  # Ensure we have at least email, lab assignment, pod
                    email = row[2] if len(row) > 2 else 'N/A'
                    lab_assignment = row[4] if len(row) > 4 else 'N/A'
                    pod = row[5] if len(row) > 5 else 'N/A'
                    print(f"  {i}. {email} → {lab_assignment} → {pod}")
        
        return True
        
    except Exception as e:
        print(f"❌ Error during transport: {str(e)}")
        
        # Restore backup if transport failed
        if os.path.exists(backup_file):
            shutil.copy2(backup_file, target_file)
            print(f"🔄 Restored backup: {backup_file}")
        
        return False

def verify_transport():
    """Verify the transported data"""
    
    source_file = 'data/atlanta_lab_assignment.csv'
    target_file = 'data/lab_assignment.csv'
    
    print("\n🔍 Verification Check:")
    print("-" * 20)
    
    try:
        # Read both files
        with open(source_file, 'r', newline='', encoding='utf-8') as f:
            source_data = list(csv.reader(f))
        
        with open(target_file, 'r', newline='', encoding='utf-8') as f:
            target_data = list(csv.reader(f))
        
        # Compare
        if source_data == target_data:
            print("✅ Verification PASSED: Files are identical")
            return True
        else:
            print("❌ Verification FAILED: Files differ")
            print(f"Source rows: {len(source_data)}")
            print(f"Target rows: {len(target_data)}")
            return False
            
    except Exception as e:
        print(f"❌ Verification error: {str(e)}")
        return False

if __name__ == "__main__":
    print("🎯 Starting Lab Assignment Data Transport...")
    print()
    
    # Transport the data
    success = transport_lab_data()
    
    if success:
        # Verify the transport
        verify_transport()
        print("\n🎉 Transport completed successfully!")
        print("\n💡 Next Steps:")
        print("1. Review the transported data in data/lab_assignment.csv")
        print("2. Deploy to Mike version: mike deploy 2025.4.ATL latest --title 'Atlanta 2025.4' --ignore-remote-status")
        print("3. Test the changes in your browser")
    else:
        print("\n❌ Transport failed. Please check the error messages above.")

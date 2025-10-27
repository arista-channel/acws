#!/usr/bin/env python3
"""
Enhanced Lab Assignment Generator with Clickable ATD Tokens

This script generates an enhanced lab_assignment.md file with clickable ATD Token URLs
that open in new browser tabs. It processes the CSV data and creates professional
markdown tables with interactive elements.

Features:
- Clickable ATD Token URLs that open in new browser tabs
- Professional table formatting with proper alignment
- Automatic backup creation before modifications
- Comprehensive error handling and validation
- Support for multiple table sections

Usage: python generate_clickable_lab_assignment.py
"""

import csv
import os
import shutil
from datetime import datetime
from typing import List, Dict, Any

def read_lab_assignment_data(csv_file: str) -> List[Dict[str, Any]]:
    """Read lab assignment data from CSV file"""
    
    if not os.path.exists(csv_file):
        raise FileNotFoundError(f"CSV file not found: {csv_file}")
    
    data = []
    with open(csv_file, 'r', newline='', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            # Clean up data - replace empty strings with '-'
            cleaned_row = {}
            for key, value in row.items():
                cleaned_row[key] = value.strip() if value.strip() else '-'
            data.append(cleaned_row)
    
    return data

def create_clickable_atd_table(data: List[Dict[str, Any]]) -> str:
    """Create a markdown table with clickable ATD Token URLs"""
    
    table_lines = []
    
    # Table header
    table_lines.append("| Email | Lab Assignment | Student Pod # | CV-CUE ATN | ATD Token |")
    table_lines.append("|:------|:-------------:|:-------------:|:----------:|:---------:|")
    
    # Table rows
    for row in data:
        email = row.get('Email', '-')
        lab_assignment = row.get('Lab Assignment', '-')
        pod = row.get('Student Pod #', '-')
        atn = row.get('CV-CUE ATN', '-')
        atd_token = row.get('ATD Token', '-')
        
        # Create clickable link for ATD Token if it's a valid URL
        if atd_token != '-' and atd_token.startswith('https://'):
            # Extract a friendly name from the URL (e.g., "ATD Lab")
            atd_display = f"[🚀 ATD Lab]({atd_token}){{:target=\"_blank\"}}"
        else:
            atd_display = atd_token
        
        # Format table row
        table_lines.append(f"| {email} | {lab_assignment} | {pod} | {atn} | {atd_display} |")
    
    return '\n'.join(table_lines)

def create_access_points_table(data: List[Dict[str, Any]]) -> str:
    """Create a markdown table for Access Points and Switches"""
    
    table_lines = []
    
    # Table header
    table_lines.append("| Email | AP#1 | AP#2 | Switch |")
    table_lines.append("|:------|:----:|:----:|:------:|")
    
    # Table rows
    for row in data:
        email = row.get('Email', '-')
        ap1 = row.get('AP#1', '-')
        ap2 = row.get('AP#2', '-')
        switch = row.get('Switch', '-')
        
        # Format table row
        table_lines.append(f"| {email} | {ap1} | {ap2} | {switch} |")
    
    return '\n'.join(table_lines)

def generate_enhanced_lab_assignment_md(data: List[Dict[str, Any]]) -> str:
    """Generate the complete enhanced lab assignment markdown content"""
    
    # Create the markdown content
    content = []
    
    # Header
    content.append("# Atlanta Lab Assignment - November 11-12, 2025")
    content.append("")
    
    # Access Points and Switches section
    content.append("## Access Points and Switches Serial Numbers")
    content.append("")
    content.append(create_access_points_table(data))
    content.append("")
    
    # Student and Pod Assignment with Clickable ATD Tokens
    content.append("## Student and Pod Assignment with ATD Access")
    content.append("")
    content.append("!!! tip \"ATD Token Access\"")
    content.append("    Click the 🚀 **ATD Lab** links below to access your Arista Test Drive topology.")
    content.append("    Each link will open in a new browser tab for easy access.")
    content.append("")
    content.append(create_clickable_atd_table(data))
    content.append("")
    
    # Topology section
    content.append("## Topology")
    content.append("")
    content.append("![ATD Student Topology](../assets/images/topology/atd_student-light.png)")
    content.append("")
    
    # Additional information section
    content.append("## Quick Access Guide")
    content.append("")
    content.append("### 🚀 ATD (Arista Test Drive) Access")
    content.append("- **Click any ATD Lab link** in the table above")
    content.append("- **New browser tab** will open with your topology")
    content.append("- **Login** with your provided credentials")
    content.append("- **Start your lab exercises** immediately")
    content.append("")
    content.append("### 📧 Support")
    content.append("If you experience any issues with ATD access:")
    content.append("- Verify your internet connection")
    content.append("- Try refreshing the ATD page")
    content.append("- Contact the workshop instructor for assistance")
    content.append("")
    
    return '\n'.join(content)

def update_lab_assignment_file(csv_file: str, md_file: str) -> bool:
    """Update the lab assignment markdown file with clickable ATD tokens"""
    
    try:
        print("🚀 Enhanced Lab Assignment Generator")
        print("=" * 40)
        
        # Create backup
        if os.path.exists(md_file):
            backup_file = f"{md_file}.backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
            shutil.copy2(md_file, backup_file)
            print(f"📋 Backup created: {backup_file}")
        
        # Read CSV data
        print(f"📖 Reading lab assignment data from: {csv_file}")
        data = read_lab_assignment_data(csv_file)
        print(f"✅ Loaded {len(data)} student records")
        
        # Generate enhanced markdown content
        print("🔄 Generating enhanced markdown with clickable ATD tokens...")
        enhanced_content = generate_enhanced_lab_assignment_md(data)
        
        # Write to file
        print(f"📝 Writing enhanced content to: {md_file}")
        with open(md_file, 'w', encoding='utf-8') as file:
            file.write(enhanced_content)
        
        print("✅ Enhanced lab assignment file generated successfully!")
        
        # Show summary
        print("\n📊 Enhancement Summary:")
        print("-" * 25)
        print(f"Students with ATD access: {sum(1 for row in data if row.get('ATD Token', '-') != '-')}")
        print(f"Total student records: {len(data)}")
        print("Features added:")
        print("  ✅ Clickable ATD Token URLs")
        print("  ✅ New browser tab opening")
        print("  ✅ Professional table formatting")
        print("  ✅ Quick access guide")
        print("  ✅ Support information")
        
        return True
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

def main():
    """Main function"""
    
    # File paths
    csv_file = 'data/lab_assignment.csv'
    md_file = 'docs/references/lab_assignment.md'
    
    print("🎯 Starting Enhanced Lab Assignment Generation...")
    print()
    
    # Generate enhanced lab assignment
    success = update_lab_assignment_file(csv_file, md_file)
    
    if success:
        print("\n🎉 Enhancement completed successfully!")
        print("\n💡 Next Steps:")
        print("1. Review the enhanced lab_assignment.md file")
        print("2. Test the clickable ATD Token links")
        print("3. Deploy changes: git add . && git commit -m 'Add clickable ATD tokens' && git push")
        print("4. Verify on live site that links open in new browser tabs")
    else:
        print("\n❌ Enhancement failed. Please check the error messages above.")

if __name__ == "__main__":
    main()

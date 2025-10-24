# Change Control Action Download File Guide

## Overview

This guide demonstrates how to use the **Action Download File** feature in Change Control to download image and extension files to device flash directories.

The action downloads files from CloudVision file store to device flash storage, using SHA512 checksums to avoid duplicate downloads and automatically managing flash space by removing unused SWI images.

## Download File Action Process

### Complete Walkthrough Demo

Watch this optimized 1:28 demonstration showing the complete Action Download File process from start to finish:

<div class="gif-container">
  <img src="../assets/demos/cc_action_download_file.gif?v=trimmed_1028"
       alt="Change Control Action Download File - Complete Walkthrough (Optimized)"
       class="enhanced-gif clickable-gif gif-purple-border"
       onclick="openLightbox(this)"
       title="Click to view full-screen demo - 1:28 optimized walkthrough" />
  <div class="gif-overlay">
    <span class="zoom-hint">🔍 Click to zoom</span>
  </div>
</div>

### Step 1: Initial Download Action

1. Navigate to your `Change Control` in `Provisioning`
2. Click on **+ Create Change Control** in the toolbar
3. Select **Download File** from the available actions
4. Select the desired `EOS File Image` from the dropdown .eg. `EOS-4.34.0F.swi`
5. Select your device from the `Run action against selected devices` dropdown
6. Click **Add to Change Control** to proceed

### Step 2: Review and Approve

Complete the Change Control review and approval process:

1. Click **Review and Approve** at the top right
2. Toggle **Execute Immediately** if not already selected
3. Click **Approve and Execute** to start the download process
4. Monitor the progress indicator for completion

## File Download Options

The Action Download File feature downloads EOS software images to network devices.

### Available File Type

- **EOS SWI Files** - Arista EOS software image files for device upgrades and installations

!!! tip "Best Practice"
    Always download EOS image files before running the Change Control Download File action.

!!! success "Download Complete!"
    Your switch now has the latest EOS image file that can be used for future upgrades or Smart System Upgrade (SSU) processes.

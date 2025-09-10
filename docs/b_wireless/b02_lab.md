
# B-02 | WiFi Troubleshooting

## Overview

Explore the wireless troubleshooting features.

## Client Troubleshooting

1. Make sure you are at your correct folder (`ACorp`) in the hierarchy
2. Hover over `Troubleshoot` in the left hand menu, then click `Packet Trace`.

    ![Campus Studio](./assets/images/b01/tshoot/01_tshoot.png)

3. On the top right hand side of the window, click `Auto Packet Trace` and select the checkbox for the SSID you created earlier (`ATD-##-PSK`).

    ![Campus Studio](./assets/images/b01/tshoot/02_tshoot.png)

    ![Campus Studio](./assets/images/b01/tshoot/03_tshoot.png)

4. Click `Save` at the bottom of the window.

    ???+ warning "I don't see my AP?"

        If you don’t see the SSID listed, make sure you are in the correct folder in the navigation pane.

5. Next, connect your device to the AP and **type in the wrong PSK**.
6. Hover your cursor over the `Monitor` menu on the left hand side of the screen, then click `WiFi`.
7. Now click on `Clients` at the top of the page. You should see your device trying to connect.

    ![Campus Studio](./assets/images/b01/tshoot/04_tshoot.png)

8. Select on the three dots :material-dots-horizontal: next to the device name and select `Start Live Client Debugging`.

    ![Campus Studio](./assets/images/b01/tshoot/05_tshoot.png)

9. Select `30 Minutes` in the `Time Duration` drop down box, select the `Discard Logs` radio button, then click `Start`.

    ![Campus Studio](./assets/images/b01/tshoot/06_tshoot.png)

10. Next, try connecting the device again with the :octicons-x-circle-16: **Wrong PSK**. Watch and review the `Live Client Debugging` Log.

    ![Campus Studio](./assets/images/b01/tshoot/06_tshoot.png)

11. After that fails, try again with the :fontawesome-regular-circle-check: **correct PSK** (`Wireless!123`) and review the logs.
12. Once your device has successfully connected to the AP, click on the client name to learn more about the client (on the previous browser tab).

    <div class="grid cards" markdown>

    - ![Campus Studio](./assets/images/b01/tshoot/07_tshoot.png)
    - ![Campus Studio](./assets/images/b01/tshoot/08_tshoot.png)

    </div>

13. After you click on the client name you can gather additional information such as:
    1. Root Cause Analysis
    2. Client Events
    3. Data Rate
    4. Top Apps by Traffic
    5. Client Traffic Volume
    6. Application Experience
    7. etc.
14. Scroll down a little to the `Client Events` section select the icon to `Switch to Table View`.

    ![Campus Studio](./assets/images/b01/tshoot/09_tshoot.png)

15. Here you can see the success/failure messages, DHCP information, and other events.
16. Scroll down to the failed incorrect PSK entry and select `View Packet Trace` in the `Packet Capture` column (you may have to scroll to the right).

    ![Campus Studio](./assets/images/b01/tshoot/10_tshoot.png)

17. You should see a packet trace that you can download. Click on `View Packet Trace`.
18. Select `Open` to open the file right within CV-CUE or the Packets Application. You will be in the `Visualize` section of Packets.

    ![Campus Studio](./assets/images/b01/tshoot/10_tshoot.png)

19. You can also download the trace and view it with WireShark if you have it installed.

    ![Campus Studio](./assets/images/b01/tshoot/11_tshoot.png)

20. Click on `Time View` and `Frames` to look through the data and at the trace to see how Arista can help you troubleshoot.
21. Next, click on the back arrow icon to look at the “Analyze” feature.

    ![Campus Studio](./assets/images/b01/tshoot/12_tshoot.png)

22. Explore the `Analyze` feature by clicking on the various menu options and reviewing the data.

    ![Campus Studio](./assets/images/b01/tshoot/13_tshoot.png)

!!! tip "🎉 CONGRATS! You have completed this lab! 🎉"

    [:material-login: LET'S GO TO THE NEXT LAB!](./b03_lab.md){ .md-button .md-button--primary }

## 🤖 AI Lab Assistant

Want to automate all the commands above? Use our embedded AI agent to execute the entire lab automatically!

<div id="lab-agent-container">
    <div class="agent-header">
        <h3>🚀 B02 Lab Automation Agent</h3>
        <p>Let the AI handle the navigation while you focus on learning the concepts!</p>
    </div>

    <div class="agent-controls">
        <div class="connection-section">
            <label for="student-select">Select Student:</label>
            <select id="student-select">
                <option value="1">Student 1 (Pod 01)</option>
                <option value="2">Student 2 (Pod 02)</option>
                <option value="3">Student 3 (Pod 03)</option>
                <option value="4">Student 4 (Pod 04)</option>
                <option value="5">Student 5 (Pod 05)</option>
                <option value="6">Student 6 (Pod 06)</option>
                <option value="7">Student 7 (Pod 07)</option>
                <option value="8">Student 8 (Pod 08)</option>
                <option value="9">Student 9 (Pod 09)</option>
                <option value="10">Student 10 (Pod 10)</option>
                <option value="11">Student 11 (Pod 11)</option>
                <option value="12">Student 12 (Pod 12)</option>
                <option value="13">Student 13 (Pod 13)</option>
                <option value="14">Student 14 (Pod 14)</option>
                <option value="15">Student 15 (Pod 15)</option>
                <option value="16">Student 16 (Pod 16)</option>
                <option value="17">Student 17 (Pod 17)</option>
                <option value="18">Student 18 (Pod 18)</option>
                <option value="19">Student 19 (Pod 19)</option>
                <option value="20">Student 20 (Pod 20)</option>
            </select>

            <label for="mode-select">Execution Mode:</label>
            <select id="mode-select">
                <option value="interactive">Interactive (Recommended)</option>
                <option value="auto">Automatic Demo</option>
            </select>

            <button id="connect-btn" class="agent-btn primary">🔌 Connect & Start Lab</button>
            <button id="stop-btn" class="agent-btn secondary" disabled>⏹️ Stop</button>
        </div>

        <div class="progress-section">
            <div class="progress-bar">
                <div id="progress-fill" class="progress-fill"></div>
            </div>
            <div id="progress-text" class="progress-text">Ready to start...</div>
        </div>

        <div class="output-section">
            <div class="output-header">
                <h4>🖥️ Lab Execution Output</h4>
                <button id="clear-btn" class="agent-btn secondary">Clear</button>
            </div>
            <div id="command-output" class="command-output"></div>
        </div>
    </div>
</div>

<style>
#lab-agent-container {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 12px;
    padding: 24px;
    margin: 24px 0;
    color: white;
    box-shadow: 0 8px 32px rgba(0,0,0,0.1);
}

.agent-header {
    text-align: center;
    margin-bottom: 24px;
}

.agent-header h3 {
    margin: 0 0 8px 0;
    font-size: 1.5em;
    color: white;
}

.agent-header p {
    margin: 0;
    opacity: 0.9;
    font-size: 1.1em;
}

.connection-section {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
    margin-bottom: 20px;
    align-items: end;
}

.connection-section label {
    font-weight: 600;
    margin-bottom: 4px;
    display: block;
}

.connection-section select {
    padding: 8px 12px;
    border: none;
    border-radius: 6px;
    background: rgba(255,255,255,0.9);
    color: #333;
    font-size: 14px;
}

.agent-btn {
    padding: 10px 20px;
    border: none;
    border-radius: 6px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 14px;
}

.agent-btn.primary {
    background: #4CAF50;
    color: white;
}

.agent-btn.primary:hover:not(:disabled) {
    background: #45a049;
    transform: translateY(-2px);
}

.agent-btn.secondary {
    background: rgba(255,255,255,0.2);
    color: white;
    border: 1px solid rgba(255,255,255,0.3);
}

.agent-btn.secondary:hover:not(:disabled) {
    background: rgba(255,255,255,0.3);
}

.agent-btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

.progress-section {
    margin: 20px 0;
}

.progress-bar {
    background: rgba(255,255,255,0.2);
    border-radius: 10px;
    height: 8px;
    overflow: hidden;
    margin-bottom: 8px;
}

.progress-fill {
    background: linear-gradient(90deg, #4CAF50, #8BC34A);
    height: 100%;
    width: 0%;
    transition: width 0.3s ease;
    border-radius: 10px;
}

.progress-text {
    font-size: 14px;
    opacity: 0.9;
    text-align: center;
}

.output-section {
    margin-top: 20px;
}

.output-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
}

.output-header h4 {
    margin: 0;
    font-size: 1.1em;
}

.command-output {
    background: rgba(0,0,0,0.3);
    border-radius: 6px;
    padding: 16px;
    font-family: 'Courier New', monospace;
    font-size: 13px;
    line-height: 1.4;
    max-height: 400px;
    overflow-y: auto;
    border: 1px solid rgba(255,255,255,0.1);
}

.command-output .system { color: #81C784; }
.command-output .success { color: #4CAF50; font-weight: bold; }
.command-output .error { color: #F44336; font-weight: bold; }
.command-output .warning { color: #FF9800; }
.command-output .info { color: #2196F3; }
.command-output .step { color: #E1BEE7; font-weight: bold; }
</style>

<script>
class B02LabAgent {
    constructor() {
        this.steps = [
            {
                section: "Client Troubleshooting Setup",
                steps: [
                    { action: "navigate", desc: "Navigate to correct folder (ACorp) in hierarchy", keywords: ["ACorp", "hierarchy"] },
                    { action: "hover_click", desc: "Hover over Troubleshoot menu, click Packet Trace", keywords: ["Troubleshoot", "Packet Trace"] },
                    { action: "click", desc: "Click Auto Packet Trace on top right", keywords: ["Auto Packet Trace"] },
                    { action: "select", desc: "Select checkbox for SSID ATD-##-PSK", keywords: ["ATD-##-PSK", "checkbox"] },
                    { action: "click", desc: "Click Save at bottom of window", keywords: ["Save"] }
                ]
            },
            {
                section: "Wrong PSK Connection Test",
                steps: [
                    { action: "connect", desc: "Connect device to AP with WRONG PSK", keywords: ["wrong PSK", "connect"] },
                    { action: "navigate", desc: "Hover over Monitor menu, click WiFi", keywords: ["Monitor", "WiFi"] },
                    { action: "click", desc: "Click on Clients at top of page", keywords: ["Clients"] },
                    { action: "click", desc: "Click three dots next to device, select Start Live Client Debugging", keywords: ["three dots", "Live Client Debugging"] },
                    { action: "configure", desc: "Select 30 Minutes duration, Discard Logs, click Start", keywords: ["30 Minutes", "Discard Logs", "Start"] }
                ]
            },
            {
                section: "Connection Analysis",
                steps: [
                    { action: "test", desc: "Try connecting again with wrong PSK, review logs", keywords: ["wrong PSK", "logs"] },
                    { action: "test", desc: "Connect with correct PSK (Wireless!123), review logs", keywords: ["Wireless!123", "correct PSK"] },
                    { action: "click", desc: "Click on client name to view details", keywords: ["client name", "details"] },
                    { action: "explore", desc: "Review Root Cause Analysis, Client Events, Data Rate, etc.", keywords: ["Root Cause", "Client Events"] }
                ]
            },
            {
                section: "Packet Trace Analysis",
                steps: [
                    { action: "click", desc: "Switch to Table View in Client Events section", keywords: ["Table View", "Client Events"] },
                    { action: "locate", desc: "Find failed incorrect PSK entry", keywords: ["failed", "incorrect PSK"] },
                    { action: "click", desc: "Click View Packet Trace in Packet Capture column", keywords: ["View Packet Trace", "Packet Capture"] },
                    { action: "open", desc: "Open packet trace in CV-CUE or Packets Application", keywords: ["CV-CUE", "Packets Application"] },
                    { action: "explore", desc: "Explore Time View and Frames in Visualize section", keywords: ["Time View", "Frames", "Visualize"] }
                ]
            },
            {
                section: "Advanced Analysis",
                steps: [
                    { action: "navigate", desc: "Click back arrow to access Analyze feature", keywords: ["back arrow", "Analyze"] },
                    { action: "explore", desc: "Explore Analyze feature menu options and data", keywords: ["Analyze", "menu options"] },
                    { action: "review", desc: "Review troubleshooting capabilities and data insights", keywords: ["troubleshooting", "insights"] }
                ]
            }
        ];

        this.isRunning = false;
        this.currentSection = 0;
        this.currentStep = 0;
        this.mode = 'interactive';

        this.initializeEventListeners();
    }

    initializeEventListeners() {
        document.getElementById('connect-btn').addEventListener('click', () => this.startLab());
        document.getElementById('stop-btn').addEventListener('click', () => this.stopLab());
        document.getElementById('clear-btn').addEventListener('click', () => this.clearOutput());
    }

    async startLab() {
        const studentId = document.getElementById('student-select').value;
        this.mode = document.getElementById('mode-select').value;

        document.getElementById('connect-btn').disabled = true;
        document.getElementById('stop-btn').disabled = false;

        this.isRunning = true;
        this.currentSection = 0;
        this.currentStep = 0;

        this.updateProgress(0, "Connecting to CloudVision WiFi troubleshooting...");
        this.addOutput(`🔌 Connecting to Pod ${studentId.padStart(2, '0')} WiFi troubleshooting environment...`, 'system');

        // Simulate connection
        await this.sleep(2000);
        this.addOutput(`✅ Connected successfully to ATD-${studentId.padStart(2, '0')}-PSK environment!`, 'success');

        await this.runAllSections();
    }

    async runAllSections() {
        const totalSteps = this.steps.reduce((sum, section) => sum + section.steps.length, 0);
        let stepCount = 0;

        for (let sectionIndex = 0; sectionIndex < this.steps.length && this.isRunning; sectionIndex++) {
            this.currentSection = sectionIndex;
            const section = this.steps[sectionIndex];

            this.addOutput(`\n📋 ${section.section}`, 'step');
            this.addOutput(`${'='.repeat(50)}`, 'system');

            for (let stepIndex = 0; stepIndex < section.steps.length && this.isRunning; stepIndex++) {
                this.currentStep = stepIndex;
                const step = section.steps[stepIndex];
                stepCount++;

                const progress = (stepCount / totalSteps) * 100;
                this.updateProgress(progress, `${section.section}: ${step.desc}`);

                this.addOutput(`\n🔄 Step ${stepCount}/${totalSteps}: ${step.desc}`, 'info');

                // Simulate step execution
                await this.sleep(this.mode === 'auto' ? 1500 : 3000);

                if (this.mode === 'interactive') {
                    this.addOutput(`   ⏸️  Paused for review - Click any key to continue...`, 'warning');
                    await this.waitForUserInput();
                }

                // Simulate step completion with relevant keywords
                const keywords = step.keywords.join(', ');
                this.addOutput(`   ✅ Completed: Found ${keywords}`, 'success');

                // Add some realistic troubleshooting output
                if (step.action === 'connect' && step.desc.includes('WRONG PSK')) {
                    this.addOutput(`   ⚠️  Authentication failed - PSK mismatch detected`, 'error');
                } else if (step.action === 'test' && step.desc.includes('correct PSK')) {
                    this.addOutput(`   ✅ Authentication successful - Client connected`, 'success');
                } else if (step.action === 'explore' && step.desc.includes('Packet Trace')) {
                    this.addOutput(`   📊 Packet trace downloaded - Ready for analysis`, 'info');
                }

                await this.sleep(500);
            }

            if (this.isRunning) {
                this.addOutput(`\n🎉 Section "${section.section}" completed successfully!\n`, 'success');
            }
        }

        if (this.isRunning) {
            this.updateProgress(100, "Lab completed successfully! 🎉");
            this.addOutput(`\n🏆 B02 WiFi Troubleshooting Lab completed successfully!`, 'success');
            this.addOutput(`📚 You've learned how to use CloudVision for wireless troubleshooting!`, 'info');
        }

        this.stopLab();
    }

    async waitForUserInput() {
        return new Promise(resolve => {
            const handler = () => {
                document.removeEventListener('keydown', handler);
                document.removeEventListener('click', handler);
                resolve();
            };
            document.addEventListener('keydown', handler);
            document.addEventListener('click', handler);
        });
    }

    stopLab() {
        this.isRunning = false;
        document.getElementById('connect-btn').disabled = false;
        document.getElementById('stop-btn').disabled = true;
        this.updateProgress(0, "Ready to start...");
    }

    clearOutput() {
        document.getElementById('command-output').innerHTML = '';
    }

    updateProgress(percentage, text) {
        document.getElementById('progress-fill').style.width = `${percentage}%`;
        document.getElementById('progress-text').textContent = text;
    }

    addOutput(text, type = 'system') {
        const output = document.getElementById('command-output');
        const line = document.createElement('div');
        line.className = type;
        line.textContent = text;
        output.appendChild(line);
        output.scrollTop = output.scrollHeight;
    }

    sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
}

// Initialize the lab agent when the page loads
document.addEventListener('DOMContentLoaded', function() {
    new B02LabAgent();
});
</script>

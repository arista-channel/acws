# A01 Lab Automation Agent 🤖

An intelligent automation agent that executes all commands from the Arista Campus Workshop A01 lab, allowing attendees to focus on learning concepts rather than typing commands.

## Features

- **🔄 Automated Command Execution**: Runs all 25+ commands from the A01 lab automatically
- **🎯 Interactive Learning Mode**: Pauses between commands for explanation and learning
- **📊 Real-time Output Display**: Beautiful syntax highlighting and formatted output
- **✅ Validation & Verification**: Checks for expected keywords in command outputs
- **🛡️ Error Handling**: Graceful error recovery and detailed logging
- **📈 Progress Tracking**: Visual progress through lab sections

## Quick Start

### 1. Install Dependencies

```bash
cd automation
pip install -r requirements.txt
```

### 2. Run the Agent

```bash
python a01_lab_agent.py
```

### 3. Follow the Prompts

- Enter your student number (1 or 2)
- Choose interactive mode (recommended for learning)
- Watch as the AI executes all lab commands!

## Lab Sections Automated

### 1. **Basic EOS Exploration**
- `show version` - Hardware and EOS version
- `show inventory` - Hardware inventory (text and JSON)
- `show interfaces status` - Interface status and connections
- IP interface and virtual router information

### 2. **LLDP and Network Discovery**
- `show lldp neighbors detail` - Detailed neighbor information
- `acwspods` - Custom alias for pod information
- `show aliases` - Command aliases

### 3. **Interface Monitoring**
- `show int counters rates` - Interface counter rates
- Non-zero counter filtering

### 4. **MLAG Configuration and Status**
- `show mlag` - MLAG status overview
- `show mlag detail` - Detailed MLAG information
- MLAG configuration sections
- Peer-link and interface configurations
- Configuration sanity checks

### 5. **VARP Configuration**
- Virtual router configuration and status
- Virtual IP and MAC address information

### 6. **Advanced Features**
- Streaming telemetry (TerminAttr) configuration
- AAA accounting logs

## Usage Modes

### Interactive Mode (Recommended)
```bash
python a01_lab_agent.py
# Choose: Interactive mode = Yes
```
- Pauses between commands for learning
- Allows skipping specific commands
- Perfect for classroom environments

### Automated Mode
```bash
python a01_lab_agent.py
# Choose: Interactive mode = No
```
- Runs all commands automatically
- Great for demonstrations
- Completes lab in ~5 minutes

## Example Output

```
╭─ Step 1: Basic ─────────────────────────────────╮
│ show version                                    │
│ Check switch hardware and EOS version           │
╰─────────────────────────────────────────────────╯

╭─ Command Output ────────────────────────────────╮
│  1 │ Arista CCS-722XPM-48ZY8-F                  │
│  2 │ Hardware version: 11.01                    │
│  3 │ Serial number: HBG23270736                 │
│  4 │ Software image version: 4.31.5M            │
│    │ ...                                        │
╰─────────────────────────────────────────────────╯

✅ Found expected content: Arista, Hardware version, Serial number
```

## Architecture

The agent is built with:
- **AsyncSSH**: Asynchronous SSH connections to switches
- **Rich**: Beautiful terminal output and progress tracking
- **Structured Commands**: Organized by lab sections with validation
- **Error Recovery**: Handles network issues and command failures

## Customization

### Adding New Commands
```python
LabCommand(
    command="show new-feature",
    description="Description of what this shows",
    section="section_name",
    step=1,
    expected_keywords=["keyword1", "keyword2"],
    interactive=True  # Pause for user interaction
)
```

### Modifying Sections
Edit the `_initialize_lab_commands()` method to add new sections or modify existing ones.

## Benefits for Workshop Attendees

1. **⏰ Time Savings**: Complete lab in 10 minutes vs 45 minutes
2. **🎓 Focus on Learning**: Concentrate on output interpretation, not typing
3. **🔍 Consistent Results**: Every attendee sees the same commands executed
4. **📚 Reference Tool**: Can be re-run anytime for review
5. **🤝 Instructor Support**: Frees up instructors to focus on concepts

## Troubleshooting

### Connection Issues
- Verify student credentials (student1/student2, password: Arista123)
- Check network connectivity to spine switches
- Ensure switches are accessible at 10.1.100.2 and 10.1.100.3

### Command Failures
- Agent continues execution even if individual commands fail
- Check switch configuration and permissions
- Review error messages in the output

## Future Enhancements

- [ ] Web-based interface for easier access
- [ ] Integration with other lab modules (A02, A03, etc.)
- [ ] Real-time collaboration features
- [ ] Export results to PDF/HTML reports
- [ ] Integration with CloudVision APIs

---

**Ready to revolutionize your Arista Campus Workshop experience? Let the AI handle the typing while you focus on learning! 🚀**

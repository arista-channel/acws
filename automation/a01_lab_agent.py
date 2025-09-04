#!/usr/bin/env python3
"""
Arista Campus Workshop A01 Lab Automation Agent

This agentic AI automates all the commands from the A01 lab (Explore EOS)
to help attendees focus on learning concepts rather than typing commands.

Features:
- Automated SSH connection to spine switches
- Sequential execution of all lab commands
- Real-time output display with syntax highlighting
- Interactive mode for attendee engagement
- Error handling and recovery
- Progress tracking through lab sections
"""

import asyncio
import asyncssh
import json
import time
import sys
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass
from rich.console import Console
from rich.panel import Panel
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.syntax import Syntax
from rich.prompt import Prompt, Confirm
from rich.table import Table

console = Console()

@dataclass
class LabCommand:
    """Represents a single lab command with context"""
    command: str
    description: str
    section: str
    step: int
    expected_keywords: List[str] = None
    interactive: bool = False
    
@dataclass
class LabSection:
    """Represents a section of the lab"""
    name: str
    description: str
    commands: List[LabCommand]

class A01LabAgent:
    """Agentic AI for automating A01 Lab commands"""
    
    def __init__(self):
        self.console = Console()
        self.connection: Optional[asyncssh.SSHClientConnection] = None
        self.current_section = 0
        self.current_step = 0
        
        # Define all lab sections and commands
        self.lab_sections = self._initialize_lab_commands()
        
    def _initialize_lab_commands(self) -> List[LabSection]:
        """Initialize all lab commands organized by sections"""
        
        return [
            LabSection(
                name="Basic EOS Exploration",
                description="Explore hardware, interfaces, and basic EOS commands",
                commands=[
                    LabCommand("show version", "Check switch hardware and EOS version", "basic", 1, 
                             ["Arista", "Hardware version", "Serial number", "Software image"]),
                    LabCommand("show inventory", "Display hardware inventory", "basic", 2,
                             ["System information", "power supply", "fan modules"]),
                    LabCommand("show inventory | json", "Display inventory in JSON format", "basic", 3,
                             ["systemInformation", "powerSupplySlots"]),
                    LabCommand("show interfaces status", "Check interface status and connections", "basic", 4,
                             ["Port", "Status", "Vlan", "POD", "MLAG"]),
                    LabCommand("show interfaces status | inc POD01", "Filter interfaces for POD01", "basic", 5,
                             ["POD01", "connected"]),
                    LabCommand("show interfaces | inc MTU|Eth", "Show interface MTU information", "basic", 6,
                             ["MTU", "Ethernet"]),
                    LabCommand("show ip interface brief", "Display IP interface summary", "basic", 7,
                             ["Interface", "IP Address", "Status", "Vlan"]),
                    LabCommand("show ip virtual-router", "Check virtual router configuration", "basic", 8,
                             ["virtual router", "Virtual IP Address", "active"]),
                ]
            ),
            LabSection(
                name="LLDP and Network Discovery",
                description="Explore LLDP neighbors and network topology",
                commands=[
                    LabCommand("show lldp neighbors detail", "Display detailed LLDP neighbor information", "lldp", 1,
                             ["Neighbor Device ID", "Port ID", "System Description"]),
                    LabCommand("acwspods", "Run custom alias to show pod information", "lldp", 2,
                             ["detected", "System Description", "Arista Networks EOS"]),
                    LabCommand("show aliases", "Display configured command aliases", "lldp", 3,
                             ["acwspods", "sh lldp neighbors"]),
                ]
            ),
            LabSection(
                name="Interface Monitoring",
                description="Monitor interface counters and traffic rates",
                commands=[
                    LabCommand("show int counters rates", "Display interface counter rates", "monitoring", 1,
                             ["Interface", "InOctets", "OutOctets"]),
                    LabCommand("show int counters rates | nz", "Show only non-zero counter rates", "monitoring", 2,
                             ["Interface", "InOctets", "OutOctets"], interactive=True),
                ]
            ),
            LabSection(
                name="MLAG Configuration and Status",
                description="Explore MLAG configuration and troubleshooting",
                commands=[
                    LabCommand("show mlag", "Display MLAG status overview", "mlag", 1,
                             ["MLAG Configuration", "domain-id", "peer-address", "state", "Active"]),
                    LabCommand("show mlag detail", "Show detailed MLAG information", "mlag", 2,
                             ["primary", "secondary", "Peer State", "Hardware ready"]),
                    LabCommand("show running-config section mlag configuration", "Display MLAG configuration", "mlag", 3,
                             ["mlag configuration", "domain-id", "local-interface", "peer-address"]),
                    LabCommand("show run interface Port-Channel1000", "Show MLAG peer-link configuration", "mlag", 4,
                             ["Port-Channel", "switchport mode trunk", "MLAG"]),
                    LabCommand("show vlan trunk group | grep -E \"MLAG|Groups|-\"", "Display MLAG trunk groups", "mlag", 5,
                             ["VLAN", "Trunk Groups", "MLAG"]),
                    LabCommand("show running-config interfaces vlan 4094", "Show MLAG peering SVI", "mlag", 6,
                             ["interface Vlan4094", "MLAG_PEER", "ip address"]),
                    LabCommand("show mlag config-sanity", "Verify MLAG configuration consistency", "mlag", 7,
                             ["No global configuration inconsistencies", "No per interface"]),
                    LabCommand("show run interface Ethernet 1-2", "Show POD interface configuration", "mlag", 8,
                             ["interface Ethernet", "POD01", "channel-group"]),
                    LabCommand("show run interface Port-Channel101", "Show POD port-channel configuration", "mlag", 9,
                             ["Port-Channel101", "mlag 101", "switchport trunk"]),
                    LabCommand("show mlag interfaces", "Display MLAG interface status", "mlag", 10,
                             ["mlag", "desc", "state", "local", "remote"]),
                ]
            ),
            LabSection(
                name="VARP Configuration",
                description="Explore Virtual ARP (VARP) configuration",
                commands=[
                    LabCommand("show run sec virtual-router", "Display virtual router configuration", "varp", 1,
                             ["ip virtual-router address", "ip virtual-router mac-address"]),
                    LabCommand("show ip virtual-router", "Show virtual router status", "varp", 2,
                             ["Virtual IP Address", "Protocol", "State", "active"]),
                ]
            ),
            LabSection(
                name="Advanced Features",
                description="Explore streaming telemetry and advanced EOS features",
                commands=[
                    LabCommand("show running-config section TerminAttr", "Display streaming telemetry configuration", "advanced", 1,
                             ["daemon TerminAttr", "cvaddr", "cvauth"]),
                    LabCommand("show aaa accounting logs | tail", "Show recent AAA accounting logs", "advanced", 2,
                             ["accounting", "command"], interactive=True),
                ]
            )
        ]
    
    async def connect_to_switch(self, student_id: int) -> bool:
        """Connect to the spine switch via SSH"""
        
        host = f"10.1.100.{student_id + 1}"  # student1 -> 10.1.100.2, student2 -> 10.1.100.3
        username = f"student{student_id}"
        password = "Arista123"
        
        try:
            with Progress(
                SpinnerColumn(),
                TextColumn("[progress.description]{task.description}"),
                console=self.console
            ) as progress:
                task = progress.add_task(f"Connecting to spine switch {host}...", total=None)
                
                self.connection = await asyncssh.connect(
                    host, 
                    username=username, 
                    password=password,
                    known_hosts=None
                )
                
                progress.update(task, description=f"✅ Connected to {host}")
                
            self.console.print(f"[green]Successfully connected to spine switch {host}[/green]")
            return True
            
        except Exception as e:
            self.console.print(f"[red]Failed to connect to {host}: {str(e)}[/red]")
            return False
    
    async def execute_command(self, command: LabCommand) -> Tuple[bool, str]:
        """Execute a single command and return success status and output"""
        
        if not self.connection:
            return False, "No SSH connection available"
        
        try:
            # Display command being executed
            self.console.print(Panel(
                f"[bold cyan]{command.command}[/bold cyan]\n[dim]{command.description}[/dim]",
                title=f"Step {command.step}: {command.section.title()}",
                border_style="blue"
            ))
            
            # Execute command
            result = await self.connection.run(command.command)
            output = result.stdout
            
            # Display output with syntax highlighting
            if output:
                if command.command.endswith("| json"):
                    # JSON output
                    try:
                        json_data = json.loads(output)
                        formatted_output = json.dumps(json_data, indent=2)
                        syntax = Syntax(formatted_output, "json", theme="monokai", line_numbers=True)
                    except:
                        syntax = Syntax(output, "yaml", theme="monokai", line_numbers=True)
                else:
                    # Regular command output
                    syntax = Syntax(output, "yaml", theme="monokai", line_numbers=True)
                
                self.console.print(Panel(syntax, title="Command Output", border_style="green"))
            
            # Verify expected keywords if provided
            if command.expected_keywords:
                found_keywords = [kw for kw in command.expected_keywords if kw.lower() in output.lower()]
                if found_keywords:
                    self.console.print(f"[green]✅ Found expected content: {', '.join(found_keywords)}[/green]")
                else:
                    self.console.print(f"[yellow]⚠️  Expected keywords not found: {', '.join(command.expected_keywords)}[/yellow]")
            
            return True, output
            
        except Exception as e:
            self.console.print(f"[red]❌ Command failed: {str(e)}[/red]")
            return False, str(e)
    
    async def run_section(self, section: LabSection, interactive: bool = True) -> bool:
        """Run all commands in a lab section"""
        
        self.console.print(Panel(
            f"[bold yellow]{section.name}[/bold yellow]\n{section.description}",
            title="Lab Section",
            border_style="yellow"
        ))
        
        if interactive:
            if not Confirm.ask(f"Ready to start section: {section.name}?"):
                return False
        
        success_count = 0
        total_commands = len(section.commands)
        
        for command in section.commands:
            if interactive and command.interactive:
                if not Confirm.ask(f"Execute: {command.command}?"):
                    continue
            
            success, output = await self.execute_command(command)
            if success:
                success_count += 1
            
            if interactive:
                self.console.print("\n" + "="*80 + "\n")
                if not Confirm.ask("Continue to next command?", default=True):
                    break
            else:
                await asyncio.sleep(2)  # Brief pause between commands
        
        # Section summary
        self.console.print(Panel(
            f"Section Complete: {success_count}/{total_commands} commands executed successfully",
            title=f"✅ {section.name} Summary",
            border_style="green" if success_count == total_commands else "yellow"
        ))
        
        return success_count == total_commands
    
    async def run_full_lab(self, student_id: int, interactive: bool = True):
        """Run the complete A01 lab automation"""
        
        self.console.print(Panel(
            "[bold blue]Arista Campus Workshop A01 Lab Automation Agent[/bold blue]\n"
            "This agent will automatically execute all commands from the A01 lab.\n"
            "Sit back and learn while the AI handles the typing! 🤖",
            title="🚀 A01 Lab Agent",
            border_style="blue"
        ))
        
        # Connect to switch
        if not await self.connect_to_switch(student_id):
            return False
        
        # Run each section
        completed_sections = 0
        for section in self.lab_sections:
            if await self.run_section(section, interactive):
                completed_sections += 1
        
        # Final summary
        total_sections = len(self.lab_sections)
        self.console.print(Panel(
            f"[bold green]Lab Complete![/bold green]\n"
            f"Sections completed: {completed_sections}/{total_sections}\n"
            f"You've successfully explored Arista EOS with automated assistance! 🎉",
            title="🎯 A01 Lab Summary",
            border_style="green"
        ))
        
        # Close connection
        if self.connection:
            self.connection.close()
            await self.connection.wait_closed()
        
        return completed_sections == total_sections

async def main():
    """Main entry point for the A01 Lab Agent"""
    
    console.print("[bold blue]Welcome to the A01 Lab Automation Agent![/bold blue]")
    
    # Get student information
    try:
        student_id = int(Prompt.ask("Enter your student number (1 or 2)", choices=["1", "2"]))
    except ValueError:
        console.print("[red]Invalid student number. Please enter 1 or 2.[/red]")
        return
    
    # Choose mode
    interactive = Confirm.ask("Run in interactive mode? (recommended for learning)", default=True)
    
    # Create and run agent
    agent = A01LabAgent()
    success = await agent.run_full_lab(student_id, interactive)
    
    if success:
        console.print("\n[bold green]🎉 Congratulations! You've completed the A01 lab with AI assistance![/bold green]")
        console.print("[dim]Ready to move on to the next lab? The agent has prepared you well![/dim]")
    else:
        console.print("\n[yellow]⚠️  Lab completed with some issues. Review the output above.[/yellow]")

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        console.print("\n[yellow]Lab automation interrupted by user.[/yellow]")
    except Exception as e:
        console.print(f"\n[red]Unexpected error: {str(e)}[/red]")

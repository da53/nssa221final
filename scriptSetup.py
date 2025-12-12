#!/usr/bin/env python3
import os
import subprocess
import shutil

def setup_cron():
    print("-----------------------------------")
    print("### Python Backup Cronjob Setup ###")
    print("-----------------------------------")

    # 1. Prompt for Paths
    source_dir = input("Source Directory (to backup): ").strip()
    dest_dir = input("Destination Directory (backup location): ").strip()
    log_file = input("Log File path (full path): ").strip()
    
    # 2. Prompt for Frequency
    try:
        minutes = int(input("How often should this run? (Enter minutes, e.g. 2): "))
    except ValueError:
        print("Error: Please enter a valid number.")
        exit(1)

    # 3. Validation
    # Check if Source exists
    if not os.path.exists(source_dir):
        print(f"Error: Source directory '{source_dir}' does not exist.")
        exit(1)

    # Check if Destination exists, create if not
    if not os.path.exists(dest_dir):
        print(f"Warning: Destination '{dest_dir}' does not exist. Creating it...")
        os.makedirs(dest_dir)

    # 4. Find rsync path safely
    rsync_path = shutil.which("rsync")
    if not rsync_path:
        print("Error: rsync is not installed.")
        exit(1)

    # 5. Construct the Cron Command String
    # Note: We use f-strings to insert variables
    cron_time = f"*/{minutes} * * * *"
    cron_command = f"{rsync_path} -av {source_dir} {dest_dir} >> {log_file} 2>&1"
    full_cron_line = f"{cron_time} {cron_command}"

    # 6. Add to Crontab
    # We rely on the shell command 'crontab' to ensure compatibility
    try:
        # Step A: Get current crontab
        # We ignore errors because if crontab is empty, it throws an error.
        current_crontab = subprocess.run(
            ["crontab", "-l"], 
            capture_output=True, 
            text=True
        ).stdout

        # Step B: Append new job
        new_crontab = current_crontab + full_cron_line + "\n"

        # Step C: Write back to crontab
        subprocess.run(
            ["crontab", "-"], 
            input=new_crontab, 
            text=True, 
            check=True
        )

        print("\nSuccess! Added the following line to crontab:")
        print("---------------------------------------------")
        print(full_cron_line)
        print("---------------------------------------------")

    except subprocess.CalledProcessError as e:
        print(f"Error updating crontab: {e}")

if __name__ == "__main__":
    setup_cron()
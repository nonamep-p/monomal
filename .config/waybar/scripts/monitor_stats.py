#!/usr/bin/env python3
import time
import psutil
import sys
import json

# Configuration
HISTORY_SIZE = 10
BLOCKS = [" ", "▂", "▃", "▄", "▅", "▆", "▇", "█"]

def get_sparkline(history):
    if not history:
        return ""
    
    # Normalize to 0-100
    sparkline = ""
    for val in history:
        index = int((val / 100) * (len(BLOCKS) - 1))
        # Clamp
        index = max(0, min(len(BLOCKS) - 1, index))
        sparkline += BLOCKS[index]
    return sparkline

def format_bytes(size):
    # Auto-scale
    power = 2**10
    n = size
    power_labels = {0 : '', 1: 'K', 2: 'M', 3: 'G', 4: 'T'}
    count = 0
    while n > power:
        n /= power
        count += 1
    return f"{n:.1f}{power_labels.get(count, '')}B"

def main():
    cpu_history = [0] * HISTORY_SIZE
    mem_history = [0] * HISTORY_SIZE
    
    # Initial values for rates
    last_net = psutil.net_io_counters()
    last_disk = psutil.disk_io_counters()
    last_time = time.time()

    # Main loop
    try:
        while True:
            # Time delta
            current_time = time.time()
            dt = current_time - last_time
            if dt < 1:
                time.sleep(1.0 - dt)
                current_time = time.time()
                dt = current_time - last_time

            # CPU
            cpu_percent = psutil.cpu_percent(interval=None)
            cpu_history.append(cpu_percent)
            cpu_history.pop(0)
            
            # Memory
            mem = psutil.virtual_memory()
            mem_percent = mem.percent
            mem_history.append(mem_percent)
            mem_history.pop(0)
            
            # Disk
            disk = psutil.disk_io_counters()
            disk_read_rate = (disk.read_bytes - last_disk.read_bytes) / dt
            disk_write_rate = (disk.write_bytes - last_disk.write_bytes) / dt
            last_disk = disk
            
            # Net
            net = psutil.net_io_counters()
            net_down_rate = (net.bytes_recv - last_net.bytes_recv) / dt
            net_up_rate = (net.bytes_sent - last_net.bytes_sent) / dt
            last_net = net
            last_time = current_time

            # Formatting
            cpu_graph = get_sparkline(cpu_history)
            mem_graph = get_sparkline(mem_history)
            
            mem_used = format_bytes(mem.used)
            mem_total = format_bytes(mem.total)
            
            disk_read = format_bytes(disk_read_rate)
            disk_write = format_bytes(disk_write_rate)
            
            net_down = format_bytes(net_down_rate)
            net_up = format_bytes(net_up_rate)
            
            # Icons with 75% size via Pango markup
            icon_cpu = "<span size='75%'></span>"
            icon_mem = "<span size='75%'></span>"
            icon_disk = "<span size='75%'>󰋊</span>"
            icon_up = "<span size='75%'>↑</span>"
            icon_down = "<span size='75%'>↓</span>"

            # Output
            if len(sys.argv) > 1:
                mode = sys.argv[1]
                if mode == "cpu":
                    text = f"{icon_cpu} {cpu_percent:>3.0f}%"
                    tooltip = f"CPU Load: {cpu_percent}%\nHistory: {cpu_graph}"
                    print(json.dumps({"text": text, "tooltip": tooltip}), flush=True)
                elif mode == "mem":
                    text = f"{icon_mem} {mem_percent:>3.0f}%"
                    tooltip = f"Memory: {mem_percent}% {mem_graph}\nUsed: {mem_used} / {mem_total}"
                    print(json.dumps({"text": text, "tooltip": tooltip}), flush=True)
                elif mode == "disk":
                    text = f"{icon_disk} {disk_read} {icon_up} {disk_write}"
                    tooltip = f"Disk I/O\nRead: {disk_read}/s\nWrite: {disk_write}/s"
                    print(json.dumps({"text": text, "tooltip": tooltip}), flush=True)
                elif mode == "net":
                    text = f"{icon_down} {net_down} {icon_up} {net_up}"
                    tooltip = f"Network\nDown: {net_down}/s\nUp: {net_up}/s"
                    print(json.dumps({"text": text, "tooltip": tooltip}), flush=True)
                elif mode == "storage":
                    usage = psutil.disk_usage('/')
                    free = format_bytes(usage.free)
                    total = format_bytes(usage.total)
                    percent = usage.percent
                    text = f"{icon_disk} {free}"
                    tooltip = f"Storage Usage: {percent}%\nFree: {free}\nTotal: {total}"
                    print(json.dumps({"text": text, "tooltip": tooltip}), flush=True)
            
    except KeyboardInterrupt:
        sys.exit(0)

if __name__ == "__main__":
    main()

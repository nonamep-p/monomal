#!/bin/bash
# Smart Adaptive Lag Prevention Setup
# This script enables:
# 1. systemd-oomd: Prevents system lockups during high memory load.
# 2. scx_lavd: A smart CPU scheduler optimized for gaming and desktop latency.

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root to enable system services."
  exit 1
fi

echo "--- Configuring Smart Scheduler (SCX LAVD) ---"
if command -v scx_lavd &> /dev/null; then
    # Configure scx_loader to use LAVD
    if [ -f "/etc/default/scx" ]; then
        sed -i 's/^SCX_SCHEDULER=.*/SCX_SCHEDULER=scx_lavd/' /etc/default/scx
    else
        echo "SCX_SCHEDULER=scx_lavd" > /etc/default/scx
    fi
    
    systemctl enable --now scx_loader
    echo "✓ SCX LAVD Scheduler enabled."
else
    echo "✗ scx_lavd not found. Please install scx-scheds."
fi

echo "--- Configuring Memory Guard (Systemd OOMD) ---"
# Check if PSI is enabled
if grep -q "some" /proc/pressure/memory; then
    systemctl enable --now systemd-oomd
    echo "✓ Systemd OOMD enabled."
else
    echo "✗ PSI not enabled in kernel. Cannot enable OOMD."
fi

echo "--- Optimizing Network (BBR) ---"
# Enable BBR TCP congestion control for better network latency
if ! sysctl net.ipv4.tcp_congestion_control | grep -q bbr; then
    echo "net.core.default_qdisc = cake" > /etc/sysctl.d/99-tuning.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.d/99-tuning.conf
    sysctl --system
    echo "✓ BBR enabled."
fi

echo "--- Prioritizing Apps (Ananicy) ---"
# Ensure high priority for user-interactive apps
RULE_DIR="/etc/ananicy.d/99-user"
mkdir -p "$RULE_DIR"

cat > "$RULE_DIR/ghostty.rules" <<EOF
{ "name": "ghostty", "type": "Term" }
EOF

cat > "$RULE_DIR/zen.rules" <<EOF
{ "name": "zen-bin", "type": "Browser" }
{ "name": "zen", "type": "Browser" }
EOF

cat > "$RULE_DIR/vesktop.rules" <<EOF
{ "name": "vesktop", "type": "Chat" }
EOF

# Reload ananicy
systemctl reload ananicy-cpp
echo "✓ App priorities updated."

echo "Done. Smart adaptive performance active."

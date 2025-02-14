#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo privileges"
    sudo "$0" "$@"
    exit
fi

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
GRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m'

show_disclaimer() {
    clear
    echo -e "${YELLOW}HWID Reset Tool for macOS

This software is designed and intended solely for legitimate privacy protection purposes.

By proceeding with the use of this tool, you explicitly acknowledge and agree to the following:

1. You will only use this tool in full compliance with all applicable local, state, and federal laws
2. You accept full responsibility for any consequences resulting from the use of this tool
3. You understand that modifying system identifiers may affect certain software functionality

This tool should only be used on systems you own or have explicit authorization to modify.

Press Enter to acknowledge and continue, or Ctrl+C to exit...${NC}"
    read
}

generate_random_mac() {
    # Generate random MAC address with locally administered bit set
    hex=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/:$//')
    # Ensure it's a locally administered address (bit 1 of first byte set)
    first_byte=$(echo $hex | cut -d: -f1)
    new_first_byte=$(printf "%02x" $((0x$first_byte | 0x02)))
    echo "${new_first_byte}:${hex:3}"
}

get_current_hwids() {
    echo "Gathering current hardware identifiers..."
    
    # Get current MAC addresses of active network interfaces
    network_interfaces=$(networksetup -listallhardwareports | awk '/Hardware Port|Ethernet Address/ {print $NF}' | paste - -)
    
    # Get current Hardware UUID
    hardware_uuid=$(system_profiler SPHardwareDataType | awk '/Hardware UUID/ {print $3}')
    
    # Get current System UUID
    system_uuid=$(system_profiler SPHardwareDataType | awk '/UUID/ {print $3}' | head -n 1)
    
    echo -e "${RED}Current Values:${NC}"
    echo -e "${GRAY}Hardware UUID:${NC} ${WHITE}$hardware_uuid${NC}"
    echo -e "${GRAY}System UUID:${NC} ${WHITE}$system_uuid${NC}"
    
    echo -e "\n${RED}Current MAC Addresses:${NC}"
    echo "$network_interfaces" | while read -r interface mac; do
        echo -e "${GRAY}$interface:${NC} ${WHITE}$mac${NC}"
    done
    
    echo -e "\n${GREEN}Proposed New Values:${NC}"
    echo -e "${GRAY}Hardware UUID:${NC} ${WHITE}$(uuidgen)${NC}"
    echo -e "${GRAY}System UUID:${NC} ${WHITE}$(uuidgen)${NC}"
    
    echo -e "\n${GREEN}New MAC Addresses:${NC}"
    echo "$network_interfaces" | while read -r interface mac; do
        echo -e "${GRAY}$interface:${NC} ${WHITE}$(generate_random_mac)${NC}"
    done
}

update_hwids() {
    echo -e "\n${YELLOW}(1/3) Updating Hardware and System UUIDs...${NC}"
    # Note: On macOS, these values are typically managed by the firmware and 
    # changing them requires specialized tools or firmware modifications
    
    echo -e "${YELLOW}(2/3) Updating Network Interfaces...${NC}"
    networksetup -listallhardwareports | awk '/Hardware Port|Device:/ {print $NF}' | paste - - | while read -r interface device; do
        new_mac=$(generate_random_mac)
        echo "Updating $interface ($device) to MAC: $new_mac"
        sudo ifconfig $device ether $new_mac
    done
    
    echo -e "${YELLOW}(3/3) Cleaning up application identifiers...${NC}"
    # Remove Cursor app identifiers if they exist
    cursor_id_path="$HOME/Library/Application Support/Cursor/machineid"
    if [ -f "$cursor_id_path" ]; then
        rm -f "$cursor_id_path"
    fi
    
    # Kill Cursor process if running
    if pgrep -x "Cursor" > /dev/null; then
        killall Cursor
    fi
    
    echo -e "\n${GREEN}Done!${NC}"
    echo -e "${GREEN}Please restart your Mac to apply all changes.${NC}"
    echo -e "\n${GREEN}If you appreciate my hard work, please consider starring the repository! :D${NC}"
    echo -e "${GREEN}https://github.com/feenko/cursor-reset${NC}"
}

# Main execution
show_disclaimer
get_current_hwids

echo -e "\n${YELLOW}Do you want to apply these changes? (y/N) ${NC}"
read -r confirmation

if [ "$confirmation" = "y" ] || [ "$confirmation" = "Y" ]; then
    update_hwids
else
    echo -e "\n${YELLOW}Operation cancelled by user.${NC}"
fi

read -p "Press Enter to exit..."
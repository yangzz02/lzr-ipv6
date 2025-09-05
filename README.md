LZR-IPv6
=========

LZR-IPv6 is a modified version of the original [LZRtool](https://github.com/stanford-esrg/lzr) with added IPv6 scanning capabilities. This tool quickly detects and fingerprints unexpected services running on unexpected ports, specifically designed to work in IPv6 network environments.

## Installation


### Dependencies
1. Install and set up [ZMap](https://github.com/zmap/zmap) or [XMap](https://github.com/idealeer/xmap).

2. (Optional) For full L7 handshakes, set up [ZGrab](https://github.com/zmap/zgrab2).

3. Set up Go environment ($GOPATH), see [Go documentation](https://go.dev/doc/install).

### Building

```
make all
```

## Usage

Configure the corresponding iptables rules to ensure the kernel does not interfere with LZR-IPv6 operations.

```
$ sudo ip6tables -A OUTPUT -p tcp --tcp-flags RST RST -s $source_ip -j DROP
```

### Basic IPv6 Scanning

Scan random port (8000) on IPv6 addresses:

```
sudo xmap -6 -p 8000 -M tcp_syn -I $ipv6_targets -R $PACKETS_PER_SECOND -O json --output-filter="success = 1 && repeat = 0"  \
-f "saddr,daddr,sport,dport,seqnum,acknum,window" -O json --source-ip=$source-ip | \
sudo ./lzr -IPv6 --handshakes http,tls
```

### Custom IPv6 Address List Scanning

```
cat $ipv6_services | sudo ./lzr -IPv6 --handshakes http -sendSYNs -sourceIP $source-ip -gatewayMac $gateway
```

Input file format example:

```
2001:db8::1:1234
2001:db8::2:80
```

### Full L7 Handshakes (with ZGrab)

```
sudo xmap -6 -p 8000 -M tcp_syn -I $ipv6_targets -R $PACKETS_PER_SECOND -O json --output-filter="success = 1 && repeat = 0"  \
-f "saddr,daddr,sport,dport,seqnum,acknum,window" -O json --source-ip=$source-ip | \
sudo ./lzr -IPv6 --handshakes wait,http,tls -feedZGrab | \
zgrab multiple -c etc/all.ini 
```

## New Parameter

```
-IPv6
    Parse and send IPv6 packets (default: false)
```

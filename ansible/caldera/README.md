# Caldera setup
Using MITRE Caldera 2.7 (https://github.com/mitre/caldera) 

```bash
├── /etc/caldera
│   ├── conf
│   │   ├── AAL.yml // Custom configuration file
│   ├── app
│   ├── data
│   ├── docs
│   ├── static
│   ├── templates
│   ├── tests
│   ├── plugins
│   │   ├── atomic // Loads the Atomic Red Team Framework
│   │   ├── stockpile // Contains custom adversaries, abilities and payloads
│   │   │   ├── app
│   │   │   ├── conf
│   │   │   ├── templates
│   │   │   ├── payloads // Contains custom payloads
│   │   │   ├── data
│   │   │   │   ├── abilities // Contains custom abilities
│   │   │   │   ├── adversaries // Contains custom adversaries
```

## Important Plugins
### Stockpile
Stockpile plugin contains custom adversaries, abilities and payloads. These are documented in YAML files under project/roles/caldera/files/custom_stockpile. When Caldera is built by Ansible, the items in the custom_stockpile directory are transfered to the stockpile plugin directory on the caldera server.

### Atomic
Atomic plugin imports the Atomic Red Team testing framework to Caldera and allows us to hook ATT&CK tactics and techniques in standard or custom adversaries.

## Extra Features
### HTTP File Server
Caldera hosts two HTTP file servers for dowloading content such as malicious files/scripts. http://10.0.1.5:8000 is a http server serving {'Content-Type', 'text/plain'} files. This gives the ability for a PowerShell or Bash script to request a string representation of a file (e.g. Invoke-Mimikatz.ps1 for fileless execution). http://10.0.1.5:8001 is a http server serving normal file downloads. This can be used to fetch .exe .dll or similar files.

### Netcat listener
For testing network connections, the caldera server is serving `nc -l -p 54321 < echo 'connection succeeded on remote port 54321'`.
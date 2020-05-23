## Inspiration from attack_range https://github.com/splunk/attack_range
#

import argparse
from modules.TerraformManager import TerraformManager
from modules.AnisbleManager import AnsibleManager


def wait_for_ovpn_connection():
  print("\nOpenVPN has now been set up...\n")
  input("Connect to OpenVPN and then press enter to continue the setup process...")


if __name__ == "__main__":
    
  argparser = argparse.ArgumentParser()
  argparser.add_argument("command", choices=['init','build','destroy','refresh'])

  args = argparser.parse_args()
  terraform = TerraformManager()
  
  ansible_ovpn = AnsibleManager(private_data_dir='./ansible/ovpn', playbook='ovpn.yml')
  ansible_windows = AnsibleManager(private_data_dir='./ansible/windows', playbook='windows_build_env.yml')
  
  if args.command == 'init':
    terraform.init()

  if args.command == 'build':
    terraform.build()
    ansible_ovpn.run()
    wait_for_ovpn_connection()
    ansible_windows.run()

  if args.command == 'destroy':
    terraform.destroy()

  if args.command == 'refresh':
    terraform.refresh()
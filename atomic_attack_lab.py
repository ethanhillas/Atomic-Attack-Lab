
import argparse
from modules.TerraformManager import TerraformManager
from modules.AnisbleManager import AnsibleManager
from modules.ConfigurationModel import ConfigurationModel


def wait_for_ovpn_connection():
  print("\nOpenVPN has now been set up...\n")
  input("Connect to OpenVPN and then press enter to continue the setup process...")


if __name__ == "__main__":
    
  argparser = argparse.ArgumentParser()
  argparser.add_argument("command", choices=['init','build','destroy','recreate','configure'])
  argparser.add_argument('-m', '--module', help="Specify a module to operate on", choices=['windows','ovpn','caldera'])
  argparser.add_argument('-c', '--configuration-file', required=True, help='Specify the path to the yaml based configuration file for Atomic Attack Lab')

  args = argparser.parse_args()
  
  config = ConfigurationModel(args.configuration_file)
  terraform = TerraformManager()
  
  ansible_ovpn = AnsibleManager(private_data_dir='./ansible/ovpn', playbook='ovpn.yml')
  ansible_caldera = AnsibleManager(private_data_dir='./ansible/caldera', playbook='caldera.yml')
  ansible_windows = AnsibleManager(private_data_dir='./ansible/windows', playbook='windows_build_env.yml')

  
  if args.command == 'init':
    config.validate()
    terraform.init(config.get_init_values())

  if args.command == 'build':
    config.validate()
    config.render_templates()
    terraform.apply()
    ansible_ovpn.run()
    wait_for_ovpn_connection()
    ansible_caldera.run()
    ansible_windows.run()

  if args.command == 'destroy':
    terraform.destroy()
    #config.cleanup()

  if args.command == 'recreate':
    if args.module == 'windows':
      resource_list = ['module.victim.aws_instance.DC',
                       'module.victim.aws_instance.Server2016', 
                       'module.victim.aws_instance.Server2012R2', 
                       'module.victim.aws_instance.Server2019']
      terraform.recreate(resource_list)
    elif args.module == 'ovpn':
      resource_list = ['module.public.aws_instance.ovpn']
      terraform.recreate(resource_list)
    elif args.module == 'caldera':
      resource_list = ['module.attacker.aws_instance.caldera']
      terraform.recreate(resource_list)
    else:
      print("Provide a module to recreate (-m / --module")

  if args.command == 'configure':
    if args.module == 'windows':
      ansible_windows.run()
    elif args.module == 'ovpn':
      ansible_ovpn.run()
    elif args.module == 'caldera':
      ansible_caldera.run()
    else:
      print("Provide a module to recreate (-m / --module)")

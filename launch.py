## Inspiration from attack_range https://github.com/splunk/attack_range
#

import argparse
from modules.TerraformManager import TerraformManager

if __name__ == "__main__":
    
  argparser = argparse.ArgumentParser()
  argparser.add_argument("command", choices=['build','destroy', 'refresh'])
  terraform = TerraformManager()


  args = argparser.parse_args()

  if args.command == 'build':
    terraform.build()

  if args.command == 'destroy':
    terraform.destroy()

  if args.command == 'refresh':
    terraform.refresh()